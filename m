Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AA938A8FB
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238417AbhETK4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:56:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237332AbhETKx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:53:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92F4861CD8;
        Thu, 20 May 2021 10:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504851;
        bh=tL1WG2HabN56/tkOGg5mdffeNgPB6ImRJFOAt+HNIac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMPLKn/WBOKmtUkav8iyNOHeK06+xB/VcHytwwWLml9x8kZHNQHOssSG2wn6fF8P6
         YK4OhllNQgDn8BEkxoTh1KwgXGSkEeVe7UpfDkg10lqlgsya0Tkayogi8TvPAb4JmU
         0XaHGhlVqdYCj2coglZBl0Z10apTYHuqZp5XDjcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 4.9 074/240] misc: vmw_vmci: explicitly initialize vmci_notify_bm_set_msg struct
Date:   Thu, 20 May 2021 11:21:06 +0200
Message-Id: <20210520092111.169604392@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 376565b9717c30cd58ad33860fa42697615fa2e4 upstream.

KMSAN complains that the vmci_use_ppn64() == false path in
vmci_dbell_register_notification_bitmap() left upper 32bits of
bitmap_set_msg.bitmap_ppn64 member uninitialized.

  =====================================================
  BUG: KMSAN: uninit-value in kmsan_check_memory+0xd/0x10
  CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.11.0-rc7+ #4
  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 02/27/2020
  Call Trace:
   dump_stack+0x21c/0x280
   kmsan_report+0xfb/0x1e0
   kmsan_internal_check_memory+0x484/0x520
   kmsan_check_memory+0xd/0x10
   iowrite8_rep+0x86/0x380
   vmci_send_datagram+0x150/0x280
   vmci_dbell_register_notification_bitmap+0x133/0x1e0
   vmci_guest_probe_device+0xcab/0x1e70
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

  Local variable ----bitmap_set_msg@vmci_dbell_register_notification_bitmap created at:
   vmci_dbell_register_notification_bitmap+0x50/0x1e0
   vmci_dbell_register_notification_bitmap+0x50/0x1e0

  Bytes 28-31 of 32 are uninitialized
  Memory access of size 32 starts at ffff88810098f570
  =====================================================

Fixes: 83e2ec765be03e8a ("VMCI: doorbell implementation.")
Cc: <stable@vger.kernel.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://lore.kernel.org/r/20210402121742.3917-1-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/vmw_vmci/vmci_doorbell.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/vmw_vmci/vmci_doorbell.c
+++ b/drivers/misc/vmw_vmci/vmci_doorbell.c
@@ -334,7 +334,7 @@ int vmci_dbell_host_context_notify(u32 s
 bool vmci_dbell_register_notification_bitmap(u32 bitmap_ppn)
 {
 	int result;
-	struct vmci_notify_bm_set_msg bitmap_set_msg;
+	struct vmci_notify_bm_set_msg bitmap_set_msg = { };
 
 	bitmap_set_msg.hdr.dst = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
 						  VMCI_SET_NOTIFY_BITMAP);


