Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633835700CA
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 13:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiGKLhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 07:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiGKLhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 07:37:02 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00FE2724
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 04:24:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1657537769; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=LQKUvb0gQQM8iDiGDL1LMlN5X/29sQALUCoynOqK3hQihwYDlVjBtmPoad6lCoKQNiwYyfq/a6N2mux3Q/NuqGXf3s8c/S+bNJ9/jgYkFpiFAxxTQBM+dd2ylnZDaJVHb1WtUp0xhrlVQMaNixsH74S9a7nFZT25TAAm2GMer6s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1657537769; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=Pk2nS9nnDYDLTlE8KCEn7MFzgcUdKiPq2TFM0PIC9Wo=; 
        b=cWrnfL9FVrLDQiwlSWi41ml4izYugEDfQIy/8k6mM6Uy1ASb86VXNSo+80Oeak8EuOpSYnrUN1eqMgVILl/CLMwHdEcKtcTIeBgO5AHL5hAwc5lak0HeArsu+62AUNtiTD/XgUJOOYPUvqfNLDnCdf4aC01KCwVW/iHWIG6ScWM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=linux.beauty;
        spf=pass  smtp.mailfrom=me@linux.beauty;
        dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1657537769;
        s=zmail; d=linux.beauty; i=me@linux.beauty;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
        bh=Pk2nS9nnDYDLTlE8KCEn7MFzgcUdKiPq2TFM0PIC9Wo=;
        b=U7ObJy27RpGQ0PljoJdIGcIx73adHeQPHGGMTw7k5K1NOS55y7H/D6EUsXL/mNcL
        aJ5gG4waH2sdp4KbsPSaK3MCtrVAtHgVntejxVnaGuQWOO4bf1oMZE0AEHPp/MNLbab
        R7L1AvRuYjpuIll2892T0LETvN8zlu2QmsIRv2Lo=
Received: from sh-lchen.ambarella.net (116.246.37.178 [116.246.37.178]) by mx.zohomail.com
        with SMTPS id 1657537768610480.07006514833813; Mon, 11 Jul 2022 04:09:28 -0700 (PDT)
From:   Li Chen <me@linux.beauty>
To:     lchen@ambarella.com
Cc:     Patrick Wang <patrick.wang.shcn@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] mm: kmemleak: take a full lowmem check in kmemleak_*_phys()
Date:   Mon, 11 Jul 2022 19:08:04 +0800
Message-Id: <20220711110804.11134-1-me@linux.beauty>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Wang <patrick.wang.shcn@gmail.com>

commit 23c2d497de21f25898fbea70aeb292ab8acc8c94 upstream.

The kmemleak_*_phys() apis do not check the address for lowmem's min
boundary, while the caller may pass an address below lowmem, which will
trigger an oops:

  # echo scan > /sys/kernel/debug/kmemleak
  Unable to handle kernel paging request at virtual address ff5fffffffe00000
  Oops [#1]
  Modules linked in:
  CPU: 2 PID: 134 Comm: bash Not tainted 5.18.0-rc1-next-20220407 #33
  Hardware name: riscv-virtio,qemu (DT)
  epc : scan_block+0x74/0x15c
   ra : scan_block+0x72/0x15c
  epc : ffffffff801e5806 ra : ffffffff801e5804 sp : ff200000104abc30
   gp : ffffffff815cd4e8 tp : ff60000004cfa340 t0 : 0000000000000200
   t1 : 00aaaaaac23954cc t2 : 00000000000003ff s0 : ff200000104abc90
   s1 : ffffffff81b0ff28 a0 : 0000000000000000 a1 : ff5fffffffe01000
   a2 : ffffffff81b0ff28 a3 : 0000000000000002 a4 : 0000000000000001
   a5 : 0000000000000000 a6 : ff200000104abd7c a7 : 0000000000000005
   s2 : ff5fffffffe00ff9 s3 : ffffffff815cd998 s4 : ffffffff815d0e90
   s5 : ffffffff81b0ff28 s6 : 0000000000000020 s7 : ffffffff815d0eb0
   s8 : ffffffffffffffff s9 : ff5fffffffe00000 s10: ff5fffffffe01000
   s11: 0000000000000022 t3 : 00ffffffaa17db4c t4 : 000000000000000f
   t5 : 0000000000000001 t6 : 0000000000000000
  status: 0000000000000100 badaddr: ff5fffffffe00000 cause: 000000000000000d
    scan_gray_list+0x12e/0x1a6
    kmemleak_scan+0x2aa/0x57e
    kmemleak_write+0x32a/0x40c
    full_proxy_write+0x56/0x82
    vfs_write+0xa6/0x2a6
    ksys_write+0x6c/0xe2
    sys_write+0x22/0x2a
    ret_from_syscall+0x0/0x2

The callers may not quite know the actual address they pass(e.g. from
devicetree).  So the kmemleak_*_phys() apis should guarantee the address
they finally use is in lowmem range, so check the address for lowmem's
min boundary.

Link: https://lkml.kernel.org/r/20220413122925.33856-1-patrick.wang.shcn@gmail.com
Signed-off-by: Patrick Wang <patrick.wang.shcn@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index b78861b8e013..859303aae180 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1125,7 +1125,7 @@ EXPORT_SYMBOL(kmemleak_no_scan);
 void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, int min_count,
 			       gfp_t gfp)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_alloc(__va(phys), size, min_count, gfp);
 }
 EXPORT_SYMBOL(kmemleak_alloc_phys);
@@ -1139,7 +1139,7 @@ EXPORT_SYMBOL(kmemleak_alloc_phys);
  */
 void __ref kmemleak_free_part_phys(phys_addr_t phys, size_t size)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_free_part(__va(phys), size);
 }
 EXPORT_SYMBOL(kmemleak_free_part_phys);
@@ -1151,7 +1151,7 @@ EXPORT_SYMBOL(kmemleak_free_part_phys);
  */
 void __ref kmemleak_not_leak_phys(phys_addr_t phys)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_not_leak(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_not_leak_phys);
@@ -1163,7 +1163,7 @@ EXPORT_SYMBOL(kmemleak_not_leak_phys);
  */
 void __ref kmemleak_ignore_phys(phys_addr_t phys)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_ignore(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_ignore_phys);
-- 
2.36.1

