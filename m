Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B952ABB6E
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgKIN2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:28:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733061AbgKINOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:14:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E68A92083B;
        Mon,  9 Nov 2020 13:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927641;
        bh=d0gPJV5WWEH+NZIHVHiJKGf1pstT/LiJ6O/8EHYy+7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RqMe0i98sxQhslLCo4ACnhjn9kUZN6lD3Cb+q7C0ZWiSAzL3ID5Vwl1iMII4ZoaUt
         ji9E1zRlwnA6vD1t4Y2iwPdz+FZZgZJEP9o3nbYWVAKlOg/oGKNELLz1yKgjIHtjc+
         7TVwsyNa5MspaXv2hsHzayP5MVi50ayFLrM3tpzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 30/85] lib/crc32test: remove extra local_irq_disable/enable
Date:   Mon,  9 Nov 2020 13:55:27 +0100
Message-Id: <20201109125024.034824347@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit aa4e460f0976351fddd2f5ac6e08b74320c277a1 upstream.

Commit 4d004099a668 ("lockdep: Fix lockdep recursion") uncovered the
following issue in lib/crc32test reported on s390:

  BUG: using __this_cpu_read() in preemptible [00000000] code: swapper/0/1
  caller is lockdep_hardirqs_on_prepare+0x48/0x270
  CPU: 6 PID: 1 Comm: swapper/0 Not tainted 5.9.0-next-20201015-15164-g03d992bd2de6 #19
  Hardware name: IBM 3906 M04 704 (LPAR)
  Call Trace:
    lockdep_hardirqs_on_prepare+0x48/0x270
    trace_hardirqs_on+0x9c/0x1b8
    crc32_test.isra.0+0x170/0x1c0
    crc32test_init+0x1c/0x40
    do_one_initcall+0x40/0x130
    do_initcalls+0x126/0x150
    kernel_init_freeable+0x1f6/0x230
    kernel_init+0x22/0x150
    ret_from_fork+0x24/0x2c
  no locks held by swapper/0/1.

Remove extra local_irq_disable/local_irq_enable helpers calls.

Fixes: 5fb7f87408f1 ("lib: add module support to crc32 tests")
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lkml.kernel.org/r/patch.git-4369da00c06e.your-ad-here.call-01602859837-ext-1679@work.hours
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/crc32test.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/lib/crc32test.c
+++ b/lib/crc32test.c
@@ -683,7 +683,6 @@ static int __init crc32c_test(void)
 
 	/* reduce OS noise */
 	local_irq_save(flags);
-	local_irq_disable();
 
 	nsec = ktime_get_ns();
 	for (i = 0; i < 100; i++) {
@@ -694,7 +693,6 @@ static int __init crc32c_test(void)
 	nsec = ktime_get_ns() - nsec;
 
 	local_irq_restore(flags);
-	local_irq_enable();
 
 	pr_info("crc32c: CRC_LE_BITS = %d\n", CRC_LE_BITS);
 
@@ -768,7 +766,6 @@ static int __init crc32_test(void)
 
 	/* reduce OS noise */
 	local_irq_save(flags);
-	local_irq_disable();
 
 	nsec = ktime_get_ns();
 	for (i = 0; i < 100; i++) {
@@ -783,7 +780,6 @@ static int __init crc32_test(void)
 	nsec = ktime_get_ns() - nsec;
 
 	local_irq_restore(flags);
-	local_irq_enable();
 
 	pr_info("crc32: CRC_LE_BITS = %d, CRC_BE BITS = %d\n",
 		 CRC_LE_BITS, CRC_BE_BITS);


