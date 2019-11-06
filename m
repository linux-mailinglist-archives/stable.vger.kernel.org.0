Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38AD3F0E26
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 06:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfKFFQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 00:16:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:43114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbfKFFQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 00:16:58 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEB86206A3;
        Wed,  6 Nov 2019 05:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573017418;
        bh=6SoXQmpFL1pLJ30tuGrZg1GHHjTEWHo92t9q3pvJXso=;
        h=Date:From:To:Subject:From;
        b=qFyuIomsckNtmr2V/sFtUsF2WgW8/6DJAnwvA7qMTvar9GKsrLHaXBo1ifEDMnYWa
         CB16Y8WUsxV3shC3g0JDuhy5ZXb+tA7EmZ/CJvJ/u8Fu9fRzpnq47CZ/ZLJ0KwJPej
         gmD8/cjcCyY3uZjHAJ3z8jvCbMlemBbM/rlPEL1I=
Date:   Tue, 05 Nov 2019 21:16:57 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, haokexin@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 12/17] dump_stack: avoid the livelock of the
 dump_lock
Message-ID: <20191106051657.fRGxFzH1B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>
Subject: dump_stack: avoid the livelock of the dump_lock

In the current code, we use the atomic_cmpxchg() to serialize the output
of the dump_stack(), but this implementation suffers the thundering herd
problem.  We have observed such kind of livelock on a Marvell cn96xx
board(24 cpus) when heavily using the dump_stack() in a kprobe handler. 
Actually we can let the competitors to wait for the releasing of the lock
before jumping to atomic_cmpxchg().  This will definitely mitigate the
thundering herd problem.  Thanks Linus for the suggestion.

[akpm@linux-foundation.org: fix comment]
Link: http://lkml.kernel.org/r/20191030031637.6025-1-haokexin@gmail.com
Fixes: b58d977432c8 ("dump_stack: serialize the output from dump_stack()")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dump_stack.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/lib/dump_stack.c~dump_stack-avoid-the-livelock-of-the-dump_lock
+++ a/lib/dump_stack.c
@@ -106,7 +106,12 @@ retry:
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
 
_
