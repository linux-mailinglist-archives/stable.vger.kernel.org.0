Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D16EF7F15
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbfKKSfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:35:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728542AbfKKSfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:35:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B4B3214E0;
        Mon, 11 Nov 2019 18:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497332;
        bh=g3lezv9ivSNQxWayz9OZ2GCeVKzhDQnCPwLJ9jDGNos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqvzMRNSmlJ4+XFIeVGbXlATRHGez5V2chHrZmmgD2gQ/MFS5OwgNvz7KnpVuoMJa
         pQCuvb+7WPvhX8J0v24ZK/b9HlXf9N3dM58SU6fXCWXeIakRz6DRXxJ5LycrcyqCfZ
         4tIxNrTadYp0UEjl1hcQp8w1xIU5orLFBRUFsHT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 018/105] dump_stack: avoid the livelock of the dump_lock
Date:   Mon, 11 Nov 2019 19:27:48 +0100
Message-Id: <20191111181433.177415479@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

commit 5cbf2fff3bba8d3c6a4d47c1754de1cf57e2b01f upstream.

In the current code, we use the atomic_cmpxchg() to serialize the output
of the dump_stack(), but this implementation suffers the thundering herd
problem.  We have observed such kind of livelock on a Marvell cn96xx
board(24 cpus) when heavily using the dump_stack() in a kprobe handler.
Actually we can let the competitors to wait for the releasing of the
lock before jumping to atomic_cmpxchg().  This will definitely mitigate
the thundering herd problem.  Thanks Linus for the suggestion.

[akpm@linux-foundation.org: fix comment]
Link: http://lkml.kernel.org/r/20191030031637.6025-1-haokexin@gmail.com
Fixes: b58d977432c8 ("dump_stack: serialize the output from dump_stack()")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/dump_stack.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/lib/dump_stack.c
+++ b/lib/dump_stack.c
@@ -46,7 +46,12 @@ retry:
 		was_locked = 1;
 	} else {
 		local_irq_restore(flags);
-		cpu_relax();
+		/*
+		 * Wait for the lock to release before jumping to
+		 * atomic_cmpxchg() in order to mitigate the thundering herd
+		 * problem.
+		 */
+		do { cpu_relax(); } while (atomic_read(&dump_lock) != -1);
 		goto retry;
 	}
 


