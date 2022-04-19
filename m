Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2015060F2
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240755AbiDSA31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240574AbiDSA3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:29:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E22C252AD;
        Mon, 18 Apr 2022 17:26:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11CA061358;
        Tue, 19 Apr 2022 00:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2E4C385A1;
        Tue, 19 Apr 2022 00:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650327972;
        bh=SX8vYiTfcK6YNPW5i5/fqXKLA3KAkWdwFjwI0+tZfDo=;
        h=Date:To:From:Subject:From;
        b=VgcNG99nHBzh+alJlNexPRU+XG0rK05yeQ2BGJVL2VZB6IrRpailopHjpBZL7isCE
         AN6w1rN4jIepXHI14o2zUWKnoq43346Htsv5wdtGASxN9yRVMMTmbX0b8mf0YKmSb0
         mWLMQFmEt3GwnmYnj1JJ2lSSKwd7EB6mB5tTBPu8=
Date:   Mon, 18 Apr 2022 17:26:11 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        catalin.marinas@arm.com, patrick.wang.shcn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-kmemleak-take-a-full-lowmem-check-in-kmemleak__phys.patch removed from -mm tree
Message-Id: <20220419002612.6A2E4C385A1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: take a full lowmem check in kmemleak_*_phys()
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-take-a-full-lowmem-check-in-kmemleak__phys.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Patrick Wang <patrick.wang.shcn@gmail.com>
Subject: mm: kmemleak: take a full lowmem check in kmemleak_*_phys()

The kmemleak_*_phys() apis do not check the address for lowmem's min
boundary, while the caller may pass an address below lowmem, which will
trigger an oops:

# echo scan > /sys/kernel/debug/kmemleak
[   54.888353] Unable to handle kernel paging request at virtual address ff5fffffffe00000
[   54.888932] Oops [#1]
[   54.889102] Modules linked in:
[   54.889326] CPU: 2 PID: 134 Comm: bash Not tainted 5.18.0-rc1-next-20220407 #33
[   54.889620] Hardware name: riscv-virtio,qemu (DT)
[   54.889901] epc : scan_block+0x74/0x15c
[   54.890215]  ra : scan_block+0x72/0x15c
[   54.890390] epc : ffffffff801e5806 ra : ffffffff801e5804 sp : ff200000104abc30
[   54.890607]  gp : ffffffff815cd4e8 tp : ff60000004cfa340 t0 : 0000000000000200
[   54.890835]  t1 : 00aaaaaac23954cc t2 : 00000000000003ff s0 : ff200000104abc90
[   54.891024]  s1 : ffffffff81b0ff28 a0 : 0000000000000000 a1 : ff5fffffffe01000
[   54.891201]  a2 : ffffffff81b0ff28 a3 : 0000000000000002 a4 : 0000000000000001
[   54.891377]  a5 : 0000000000000000 a6 : ff200000104abd7c a7 : 0000000000000005
[   54.891552]  s2 : ff5fffffffe00ff9 s3 : ffffffff815cd998 s4 : ffffffff815d0e90
[   54.891727]  s5 : ffffffff81b0ff28 s6 : 0000000000000020 s7 : ffffffff815d0eb0
[   54.891903]  s8 : ffffffffffffffff s9 : ff5fffffffe00000 s10: ff5fffffffe01000
[   54.892078]  s11: 0000000000000022 t3 : 00ffffffaa17db4c t4 : 000000000000000f
[   54.892271]  t5 : 0000000000000001 t6 : 0000000000000000
[   54.892408] status: 0000000000000100 badaddr: ff5fffffffe00000 cause: 000000000000000d
[   54.892643] [<ffffffff801e5a1c>] scan_gray_list+0x12e/0x1a6
[   54.892824] [<ffffffff801e5d3e>] kmemleak_scan+0x2aa/0x57e
[   54.892961] [<ffffffff801e633c>] kmemleak_write+0x32a/0x40c
[   54.893096] [<ffffffff803915ac>] full_proxy_write+0x56/0x82
[   54.893235] [<ffffffff801ef456>] vfs_write+0xa6/0x2a6
[   54.893362] [<ffffffff801ef880>] ksys_write+0x6c/0xe2
[   54.893487] [<ffffffff801ef918>] sys_write+0x22/0x2a
[   54.893609] [<ffffffff8000397c>] ret_from_syscall+0x0/0x2
[   54.894183] ---[ end trace 0000000000000000 ]---

The callers may not quite know the actual address they pass(e.g.  from
devicetree).  So the kmemleak_*_phys() apis should guarantee the
address they finally use is in lowmem range, so check the address for
lowmem's min boundary.

Link: https://lkml.kernel.org/r/20220413122925.33856-1-patrick.wang.shcn@gmail.com
Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-take-a-full-lowmem-check-in-kmemleak__phys
+++ a/mm/kmemleak.c
@@ -1132,7 +1132,7 @@ EXPORT_SYMBOL(kmemleak_no_scan);
 void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, int min_count,
 			       gfp_t gfp)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_alloc(__va(phys), size, min_count, gfp);
 }
 EXPORT_SYMBOL(kmemleak_alloc_phys);
@@ -1146,7 +1146,7 @@ EXPORT_SYMBOL(kmemleak_alloc_phys);
  */
 void __ref kmemleak_free_part_phys(phys_addr_t phys, size_t size)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_free_part(__va(phys), size);
 }
 EXPORT_SYMBOL(kmemleak_free_part_phys);
@@ -1158,7 +1158,7 @@ EXPORT_SYMBOL(kmemleak_free_part_phys);
  */
 void __ref kmemleak_not_leak_phys(phys_addr_t phys)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_not_leak(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_not_leak_phys);
@@ -1170,7 +1170,7 @@ EXPORT_SYMBOL(kmemleak_not_leak_phys);
  */
 void __ref kmemleak_ignore_phys(phys_addr_t phys)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_ignore(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_ignore_phys);
_

Patches currently in -mm which might be from patrick.wang.shcn@gmail.com are


