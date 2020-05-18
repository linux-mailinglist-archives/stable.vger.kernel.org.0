Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6201D8167
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730249AbgERRrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:47:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730261AbgERRrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:47:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3345F20835;
        Mon, 18 May 2020 17:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824065;
        bh=1YqJ8DeqJXMlgEc1ELrfj/EAODkaBVufJMnrx/jj3vU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TaXp/+JqAFrKYiB0DeALoYDZEgczNMxjyIfi/eYk8v9cJcQTU+GBadktGDVcqHmBF
         PwxgfYpqsrtx36UgEKA807VPrv1M/dX4vqE7aFeF8E1nRCx6IkKgurR9tA88aIPutU
         PGwlJcrzebcujYRxrKEYsdEIfYkVRcNm5OeJKQfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 040/114] blktrace: fix trace mutex deadlock
Date:   Mon, 18 May 2020 19:36:12 +0200
Message-Id: <20200518173510.751929221@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 2967acbb257a6a9bf912f4778b727e00972eac9b upstream.

A previous commit changed the locking around registration/cleanup,
but direct callers of blk_trace_remove() were missed. This means
that if we hit the error path in setup, we will deadlock on
attempting to re-acquire the queue trace mutex.

Fixes: 1f2cac107c59 ("blktrace: fix unlocked access to init/start-stop/teardown")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/blktrace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -591,7 +591,7 @@ static int __blk_trace_setup(struct requ
 		return ret;
 
 	if (copy_to_user(arg, &buts, sizeof(buts))) {
-		blk_trace_remove(q);
+		__blk_trace_remove(q);
 		return -EFAULT;
 	}
 	return 0;
@@ -637,7 +637,7 @@ static int compat_blk_trace_setup(struct
 		return ret;
 
 	if (copy_to_user(arg, &buts.name, ARRAY_SIZE(buts.name))) {
-		blk_trace_remove(q);
+		__blk_trace_remove(q);
 		return -EFAULT;
 	}
 


