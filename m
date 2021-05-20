Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C9D38AA88
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238991AbhETLPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:15:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239104AbhETLMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:12:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6202761D50;
        Thu, 20 May 2021 10:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505273;
        bh=8moV59Cohi3DoS4TU1+cHNWrTSf3MH8xlY9ZdeK9UGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/8GB6evcGx+4ozPiMrY4IJr2J7SEI+wSx4d1At+1da0c7RQHAlGN96n+rxY8iu1L
         dt6DZNe27DWaHKrsaUoj2F9zihI65Xzzs3n32iOvfBvHLdA80ZNvooa651CmKZmRs7
         1TqT7qE49ptpxhfc+ZcnlZUlDK/iqARGEKuHL9W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 4.4 060/190] misc: vmw_vmci: explicitly initialize vmci_datagram payload
Date:   Thu, 20 May 2021 11:22:04 +0200
Message-Id: <20210520092104.149478289@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit b2192cfeba8481224da0a4ec3b4a7ccd80b1623b upstream.

KMSAN complains that vmci_check_host_caps() left the payload part of
check_msg uninitialized.

  =====================================================
  BUG: KMSAN: uninit-value in kmsan_check_memory+0xd/0x10
  CPU: 1 PID: 1 Comm: swapper/0 Tainted: G    B             5.11.0-rc7+ #4
  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 02/27/2020
  Call Trace:
   dump_stack+0x21c/0x280
   kmsan_report+0xfb/0x1e0
   kmsan_internal_check_memory+0x202/0x520
   kmsan_check_memory+0xd/0x10
   iowrite8_rep+0x86/0x380
   vmci_guest_probe_device+0xf0b/0x1e70
   pci_device_probe+0xab3/0xe70
   really_probe+0xd16/0x24d0
   driver_probe_device+0x29d/0x3a0
   device_driver_attach+0x25a/0x490
   __driver_attach+0x78c/0x840
   bus_for_each_dev+0x210/0x340
   driver_attach+0x89/0xb0
   bus_add_driver+0x677/0xc40
   driver_register+0x485/0x8e0
   __pci_register_driver+0x1ff/0x350
   vmci_guest_init+0x3e/0x41
   vmci_drv_init+0x1d6/0x43f
   do_one_initcall+0x39c/0x9a0
   do_initcall_level+0x1d7/0x259
   do_initcalls+0x127/0x1cb
   do_basic_setup+0x33/0x36
   kernel_init_freeable+0x29a/0x3ed
   kernel_init+0x1f/0x840
   ret_from_fork+0x1f/0x30

  Uninit was created at:
   kmsan_internal_poison_shadow+0x5c/0xf0
   kmsan_slab_alloc+0x8d/0xe0
   kmem_cache_alloc+0x84f/0xe30
   vmci_guest_probe_device+0xd11/0x1e70
   pci_device_probe+0xab3/0xe70
   really_probe+0xd16/0x24d0
   driver_probe_device+0x29d/0x3a0
   device_driver_attach+0x25a/0x490
   __driver_attach+0x78c/0x840
   bus_for_each_dev+0x210/0x340
   driver_attach+0x89/0xb0
   bus_add_driver+0x677/0xc40
   driver_register+0x485/0x8e0
   __pci_register_driver+0x1ff/0x350
   vmci_guest_init+0x3e/0x41
   vmci_drv_init+0x1d6/0x43f
   do_one_initcall+0x39c/0x9a0
   do_initcall_level+0x1d7/0x259
   do_initcalls+0x127/0x1cb
   do_basic_setup+0x33/0x36
   kernel_init_freeable+0x29a/0x3ed
   kernel_init+0x1f/0x840
   ret_from_fork+0x1f/0x30

  Bytes 28-31 of 36 are uninitialized
  Memory access of size 36 starts at ffff8881675e5f00
  =====================================================

Fixes: 1f166439917b69d3 ("VMCI: guest side driver implementation.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://lore.kernel.org/r/20210402121742.3917-2-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/vmw_vmci/vmci_guest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -172,7 +172,7 @@ static int vmci_check_host_caps(struct p
 				VMCI_UTIL_NUM_RESOURCES * sizeof(u32);
 	struct vmci_datagram *check_msg;
 
-	check_msg = kmalloc(msg_size, GFP_KERNEL);
+	check_msg = kzalloc(msg_size, GFP_KERNEL);
 	if (!check_msg) {
 		dev_err(&pdev->dev, "%s: Insufficient memory\n", __func__);
 		return -ENOMEM;


