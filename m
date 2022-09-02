Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043A55AAF03
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236789AbiIBMco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236526AbiIBMbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:31:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B42DD772;
        Fri,  2 Sep 2022 05:26:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0402CB82AA3;
        Fri,  2 Sep 2022 12:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C88C433C1;
        Fri,  2 Sep 2022 12:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121598;
        bh=F4vlN0+PCazpWuJH/8PKmMSCu5OzBSkiLxykRptJRxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbmezwLC0JDyxhC8ZCGqPxg+vo0vgw8LxMQRMqR5/W9yqWyCY56H2OX7/PB1Ukniz
         bmZAW1wo92KD9QsgqyJI3OG8G8+j3zqklreWCBuekEhy63UAYF8l3QzCCF60P64QjW
         T/EeFbCxKSXo9Od80W/tingVBDEoorl+THWK/6u8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Thierry Reding <treding@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 32/56] asm-generic: sections: refactor memory_intersects
Date:   Fri,  2 Sep 2022 14:18:52 +0200
Message-Id: <20220902121401.383778713@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
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

From: Quanyang Wang <quanyang.wang@windriver.com>

commit 0c7d7cc2b4fe2e74ef8728f030f0f1674f9f6aee upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/sections.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -100,7 +100,7 @@ static inline bool memory_contains(void
 /**
  * memory_intersects - checks if the region occupied by an object intersects
  *                     with another memory region
- * @begin: virtual address of the beginning of the memory regien
+ * @begin: virtual address of the beginning of the memory region
  * @end: virtual address of the end of the memory region
  * @virt: virtual address of the memory object
  * @size: size of the memory object
@@ -113,7 +113,10 @@ static inline bool memory_intersects(voi
 {
 	void *vend = virt + size;
 
-	return (virt >= begin && virt < end) || (vend >= begin && vend < end);
+	if (virt < end && vend > begin)
+		return true;
+
+	return false;
 }
 
 /**


