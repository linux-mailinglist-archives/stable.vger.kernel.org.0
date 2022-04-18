Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E835550574E
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243248AbiDRNuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244207AbiDRNtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:49:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DADD42ED8;
        Mon, 18 Apr 2022 06:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F33E660B35;
        Mon, 18 Apr 2022 13:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE84AC385A1;
        Mon, 18 Apr 2022 13:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286895;
        bh=jc/F14J1Q5blMfhfcsVcA4oJiPqFkisi/RXSOeFA/4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guy6q5UNtrChp2cVCFVCvyWeBntbrJjsXYBbxzwUWoBJoxgVIK/DJnKZMswwAmB+g
         WjlGcO6zI/E+EQAYvufc7KATc2gu3otCtYpRSF+izK4mTarDVAsEcoyXEnuIwXPILF
         5Ppn04LbvhvszMnrJE2tOLY36ZctS7X1cVzOSPhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Wang <patrick.wang.shcn@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 279/284] mm: kmemleak: take a full lowmem check in kmemleak_*_phys()
Date:   Mon, 18 Apr 2022 14:14:20 +0200
Message-Id: <20220418121221.059720168@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
 mm/kmemleak.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1192,7 +1192,7 @@ EXPORT_SYMBOL(kmemleak_no_scan);
 void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, int min_count,
 			       gfp_t gfp)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_alloc(__va(phys), size, min_count, gfp);
 }
 EXPORT_SYMBOL(kmemleak_alloc_phys);
@@ -1203,7 +1203,7 @@ EXPORT_SYMBOL(kmemleak_alloc_phys);
  */
 void __ref kmemleak_free_part_phys(phys_addr_t phys, size_t size)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_free_part(__va(phys), size);
 }
 EXPORT_SYMBOL(kmemleak_free_part_phys);
@@ -1214,7 +1214,7 @@ EXPORT_SYMBOL(kmemleak_free_part_phys);
  */
 void __ref kmemleak_not_leak_phys(phys_addr_t phys)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_not_leak(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_not_leak_phys);
@@ -1225,7 +1225,7 @@ EXPORT_SYMBOL(kmemleak_not_leak_phys);
  */
 void __ref kmemleak_ignore_phys(phys_addr_t phys)
 {
-	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_ignore(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_ignore_phys);


