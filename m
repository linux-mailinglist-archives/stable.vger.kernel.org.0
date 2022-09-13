Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDD15B7579
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiIMPpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235839AbiIMPog (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:44:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE042ACA;
        Tue, 13 Sep 2022 07:48:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5058B614A3;
        Tue, 13 Sep 2022 14:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69395C433C1;
        Tue, 13 Sep 2022 14:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079861;
        bh=3mnMXcJ1JR2zRL724pWgzy9GrDeUP+GY3DLcHW2IKn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQqp0QizyqjisFo01CiqSjHFZEIBFkZqSW/HFbmqUY+q/WTa9s6MLf+NnhN/0g8EM
         7bXbf3sLG/2xDKrBFjHEfhEA2NYbCmu6N7+phqdZyHPeFprY5FG5V+yjYc2C6dXW/I
         U5XSIxvGybZKxawkvrlKFlLCrGTFHjJmr8EBXDa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yee Lee <yee.lee@mediatek.com>
Subject: [PATCH 4.9 24/42] Revert "mm: kmemleak: take a full lowmem check in kmemleak_*_phys()"
Date:   Tue, 13 Sep 2022 16:07:55 +0200
Message-Id: <20220913140343.512632876@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140342.228397194@linuxfoundation.org>
References: <20220913140342.228397194@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yee Lee <yee.lee@mediatek.com>

This reverts commit 23c2d497de21f25898fbea70aeb292ab8acc8c94.

Commit 23c2d497de21 ("mm: kmemleak: take a full lowmem check in
kmemleak_*_phys()") brought false leak alarms on some archs like arm64
that does not init pfn boundary in early booting. The final solution
lands on linux-6.0: commit 0c24e061196c ("mm: kmemleak: add rbtree and
store physical address for objects allocated with PA").

Revert this commit before linux-6.0. The original issue of invalid PA
can be mitigated by additional check in devicetree.

The false alarm report is as following: Kmemleak output: (Qemu/arm64)
unreferenced object 0xffff0000c0170a00 (size 128):
  comm "swapper/0", pid 1, jiffies 4294892404 (age 126.208s)
  hex dump (first 32 bytes):
 62 61 73 65 00 00 00 00 00 00 00 00 00 00 00 00  base............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<(____ptrval____)>] __kmalloc_track_caller+0x1b0/0x2e4
    [<(____ptrval____)>] kstrdup_const+0x8c/0xc4
    [<(____ptrval____)>] kvasprintf_const+0xbc/0xec
    [<(____ptrval____)>] kobject_set_name_vargs+0x58/0xe4
    [<(____ptrval____)>] kobject_add+0x84/0x100
    [<(____ptrval____)>] __of_attach_node_sysfs+0x78/0xec
    [<(____ptrval____)>] of_core_init+0x68/0x104
    [<(____ptrval____)>] driver_init+0x28/0x48
    [<(____ptrval____)>] do_basic_setup+0x14/0x28
    [<(____ptrval____)>] kernel_init_freeable+0x110/0x178
    [<(____ptrval____)>] kernel_init+0x20/0x1a0
    [<(____ptrval____)>] ret_from_fork+0x10/0x20

This pacth is also applicable to linux-5.17.y/linux-5.18.y/linux-5.19.y

Cc: <stable@vger.kernel.org>
Signed-off-by: Yee Lee <yee.lee@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1130,7 +1130,7 @@ EXPORT_SYMBOL(kmemleak_no_scan);
 void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, int min_count,
 			       gfp_t gfp)
 {
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_alloc(__va(phys), size, min_count, gfp);
 }
 EXPORT_SYMBOL(kmemleak_alloc_phys);
@@ -1141,7 +1141,7 @@ EXPORT_SYMBOL(kmemleak_alloc_phys);
  */
 void __ref kmemleak_free_part_phys(phys_addr_t phys, size_t size)
 {
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_free_part(__va(phys), size);
 }
 EXPORT_SYMBOL(kmemleak_free_part_phys);
@@ -1152,7 +1152,7 @@ EXPORT_SYMBOL(kmemleak_free_part_phys);
  */
 void __ref kmemleak_not_leak_phys(phys_addr_t phys)
 {
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_not_leak(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_not_leak_phys);
@@ -1163,7 +1163,7 @@ EXPORT_SYMBOL(kmemleak_not_leak_phys);
  */
 void __ref kmemleak_ignore_phys(phys_addr_t phys)
 {
-	if (PHYS_PFN(phys) >= min_low_pfn && PHYS_PFN(phys) < max_low_pfn)
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
 		kmemleak_ignore(__va(phys));
 }
 EXPORT_SYMBOL(kmemleak_ignore_phys);


