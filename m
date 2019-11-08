Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D976F3CF9
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 01:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfKHAjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 19:39:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727952AbfKHAjF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 19:39:05 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71A7D222C4;
        Fri,  8 Nov 2019 00:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573173544;
        bh=bBQ+xW5u4/Kotm5XikxpsjXe6eUJ+Vh/cDTe1YgBUgw=;
        h=Date:From:To:Subject:From;
        b=Z25lStDe+/tfnCBfN/uzsyN7D0m4T6ZTBaXlqJws3AU8KvXxka2jbcjnsfzCN/9MG
         5Jen7cF92y5jBryHhsGSWwOm9pQCRV9rHwAelI9BDSU6AZ2tVkKjeXUCwf13P/fk+P
         VIiOk2nUT+GbZGKLJ6MQcRFyYmoKA8maZ2TprGuI=
Date:   Thu, 07 Nov 2019 16:39:04 -0800
From:   akpm@linux-foundation.org
To:     haokexin@gmail.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [merged]
 dump_stack-avoid-the-livelock-of-the-dump_lock.patch removed from -mm tree
Message-ID: <20191108003904.HxSawhcRv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: dump_stack: avoid the livelock of the dump_lock
has been removed from the -mm tree.  Its filename was
     dump_stack-avoid-the-livelock-of-the-dump_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from haokexin@gmail.com are


