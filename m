Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95E35A3FCA
	for <lists+stable@lfdr.de>; Sun, 28 Aug 2022 23:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiH1VEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Aug 2022 17:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiH1VDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Aug 2022 17:03:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804313122D;
        Sun, 28 Aug 2022 14:03:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43D14B80B6E;
        Sun, 28 Aug 2022 21:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004C9C433D6;
        Sun, 28 Aug 2022 21:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661720614;
        bh=ZkqBwUQYn3LLZPxRpQrgs9g8Hl9Zs9dLLdmzg3ivhoQ=;
        h=Date:To:From:Subject:From;
        b=Ipd6Mn+DvaT90xxohZL11IBKMvUxCobVrc2hkrABjHK1cO4FQhbdBr2eVDX/cWB6M
         2KWBLp62GPBvYVJaSFbJCeSjOLU90j/Sd+/RQFMyA0HcWYWy/FSZsIx7Vqp7EaV0v2
         tn7OIwFrIsyDaNwX4A1ioiQcmU9Ixb1mEk1Vr2ow=
Date:   Sun, 28 Aug 2022 14:03:33 -0700
To:     mm-commits@vger.kernel.org, treding@nvidia.com,
        stable@vger.kernel.org, arnd@arndb.de, ardb@kernel.org,
        quanyang.wang@windriver.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] asm-generic-sections-refactor-memory_intersects.patch removed from -mm tree
Message-Id: <20220828210334.004C9C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: asm-generic: sections: refactor memory_intersects
has been removed from the -mm tree.  Its filename was
     asm-generic-sections-refactor-memory_intersects.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Quanyang Wang <quanyang.wang@windriver.com>
Subject: asm-generic: sections: refactor memory_intersects
Date: Fri, 19 Aug 2022 16:11:45 +0800

There are two problems with the current code of memory_intersects:

First, it doesn't check whether the region (begin, end) falls inside the
region (virt, vend), that is (virt < begin && vend > end).

The second problem is if vend is equal to begin, it will return true but
this is wrong since vend (virt + size) is not the last address of the
memory region but (virt + size -1) is.  The wrong determination will
trigger the misreporting when the function check_for_illegal_area calls
memory_intersects to check if the dma region intersects with stext region.

The misreporting is as below (stext is at 0x80100000):
 WARNING: CPU: 0 PID: 77 at kernel/dma/debug.c:1073 check_for_illegal_area+0x130/0x168
 DMA-API: chipidea-usb2 e0002000.usb: device driver maps memory from kernel text or rodata [addr=800f0000] [len=65536]
 Modules linked in:
 CPU: 1 PID: 77 Comm: usb-storage Not tainted 5.19.0-yocto-standard #5
 Hardware name: Xilinx Zynq Platform
  unwind_backtrace from show_stack+0x18/0x1c
  show_stack from dump_stack_lvl+0x58/0x70
  dump_stack_lvl from __warn+0xb0/0x198
  __warn from warn_slowpath_fmt+0x80/0xb4
  warn_slowpath_fmt from check_for_illegal_area+0x130/0x168
  check_for_illegal_area from debug_dma_map_sg+0x94/0x368
  debug_dma_map_sg from __dma_map_sg_attrs+0x114/0x128
  __dma_map_sg_attrs from dma_map_sg_attrs+0x18/0x24
  dma_map_sg_attrs from usb_hcd_map_urb_for_dma+0x250/0x3b4
  usb_hcd_map_urb_for_dma from usb_hcd_submit_urb+0x194/0x214
  usb_hcd_submit_urb from usb_sg_wait+0xa4/0x118
  usb_sg_wait from usb_stor_bulk_transfer_sglist+0xa0/0xec
  usb_stor_bulk_transfer_sglist from usb_stor_bulk_srb+0x38/0x70
  usb_stor_bulk_srb from usb_stor_Bulk_transport+0x150/0x360
  usb_stor_Bulk_transport from usb_stor_invoke_transport+0x38/0x440
  usb_stor_invoke_transport from usb_stor_control_thread+0x1e0/0x238
  usb_stor_control_thread from kthread+0xf8/0x104
  kthread from ret_from_fork+0x14/0x2c

Refactor memory_intersects to fix the two problems above.

Before the 1d7db834a027e ("dma-debug: use memory_intersects()
directly"), memory_intersects is called only by printk_late_init:

printk_late_init -> init_section_intersects ->memory_intersects.

There were few places where memory_intersects was called.

When commit 1d7db834a027e ("dma-debug: use memory_intersects()
directly") was merged and CONFIG_DMA_API_DEBUG is enabled, the DMA
subsystem uses it to check for an illegal area and the calltrace above
is triggered.

[akpm@linux-foundation.org: fix nearby comment typo]
Link: https://lkml.kernel.org/r/20220819081145.948016-1-quanyang.wang@windriver.com
Fixes: 979559362516 ("asm/sections: add helpers to check for section data")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thierry Reding <treding@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/sections.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/include/asm-generic/sections.h~asm-generic-sections-refactor-memory_intersects
+++ a/include/asm-generic/sections.h
@@ -97,7 +97,7 @@ static inline bool memory_contains(void
 /**
  * memory_intersects - checks if the region occupied by an object intersects
  *                     with another memory region
- * @begin: virtual address of the beginning of the memory regien
+ * @begin: virtual address of the beginning of the memory region
  * @end: virtual address of the end of the memory region
  * @virt: virtual address of the memory object
  * @size: size of the memory object
@@ -110,7 +110,10 @@ static inline bool memory_intersects(voi
 {
 	void *vend = virt + size;
 
-	return (virt >= begin && virt < end) || (vend >= begin && vend < end);
+	if (virt < end && vend > begin)
+		return true;
+
+	return false;
 }
 
 /**
_

Patches currently in -mm which might be from quanyang.wang@windriver.com are


