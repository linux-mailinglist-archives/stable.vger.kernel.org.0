Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE8AE9716
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 08:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfJ3HQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 03:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbfJ3HQb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 03:16:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3EA3205C9;
        Wed, 30 Oct 2019 07:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572419791;
        bh=EhXSMhIQw1JQQRMH+PqtZz7vHfx8X1v+krmMz8QXJJA=;
        h=Date:From:To:Subject:From;
        b=mjRzhlcN2U/1GZi9j1d9yxeTv73NyAhtQ4tuiHNFQvXZjakEMssNGYS6ns5jzz4f9
         HaTeuMcSCtajpq+jla7Ca9avLwBtVss/6VrgZRE4wzBQztLQ9ayY0E18m0cRv9XUQE
         RIZdVLWYtorH4Aj4TV+C00Z4cgfwCPEzwY0CLDEM=
Date:   Wed, 30 Oct 2019 00:16:30 -0700
From:   akpm@linux-foundation.org
To:     haokexin@gmail.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  + dump_stack-avoid-the-livelock-of-the-dump_lock.patch
 added to -mm tree
Message-ID: <20191030071630.NUNB72Rra%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: dump_stack: avoid the livelock of the dump_lock
has been added to the -mm tree.  Its filename is
     dump_stack-avoid-the-livelock-of-the-dump_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dump_stack-avoid-the-livelock-of-the-dump_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dump_stack-avoid-the-livelock-of-the-dump_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kevin Hao <haokexin@gmail.com>
Subject: dump_stack: avoid the livelock of the dump_lock

In the current code, we use the atomic_cmpxchg() to serialize the output
of the dump_stack(), but this implementation suffers the thundering herd
problem.  We have observed such kind of livelock on a Marvell cn96xx
board(24 cpus) when heavily using the dump_stack() in a kprobe handler. 
Actually we can let the competitors to wait for the releasing of the lock
before jumping to atomic_cmpxchg().  This will definitely mitigate the
thundering herd problem.  Thanks Linus for the suggestion.

Link: http://lkml.kernel.org/r/20191030031637.6025-1-haokexin@gmail.com
Fixes: b58d977432c8 ("dump_stack: serialize the output from dump_stack()")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dump_stack.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/dump_stack.c~dump_stack-avoid-the-livelock-of-the-dump_lock
+++ a/lib/dump_stack.c
@@ -106,7 +106,11 @@ retry:
 		was_locked = 1;
 	} else {
 		local_irq_restore(flags);
-		cpu_relax();
+		/*
+		 * Wait the lock to release before jumping to atomic_cmpxchg()
+		 * in order to mitigate the thundering herd problem.
+		 */
+		do { cpu_relax(); } while (atomic_read(&dump_lock) != -1);
 		goto retry;
 	}
 
_

Patches currently in -mm which might be from haokexin@gmail.com are

dump_stack-avoid-the-livelock-of-the-dump_lock.patch

