Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A896B45D8
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbjCJOiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbjCJOhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:37:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23448119F8C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:37:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E34FB822BF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124B9C4339B;
        Fri, 10 Mar 2023 14:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459046;
        bh=bkH/MSHh1vG3qxFVj3SFFzY6BLBc2XZzTikb04xmBFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Pa7slcMimq0ZdNgmserumNs6jWNRJwQ6x7QQEG1vLvzM6LY1Pz/7uKv8ytFILEu/
         6JcwUO/rzoxZAa1nKnRGF+N3r1kroNclqxbOnp4gKsV4ZEjTUjFECxbu/pEs8KMOsY
         Vknq7s2j5mDJTyE3OOZkb5ZyiDHhuGQfzqQ3aYTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?=E6=9F=B3=E8=8F=81=E5=B3=B0?= <liujingfeng@qianxin.com>,
        Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.4 231/357] KVM: Destroy target device if coalesced MMIO unregistration fails
Date:   Fri, 10 Mar 2023 14:38:40 +0100
Message-Id: <20230310133744.958874705@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit b1cb1fac22abf102ffeb29dd3eeca208a3869d54 upstream.

Destroy and free the target coalesced MMIO device if unregistering said
device fails.  As clearly noted in the code, kvm_io_bus_unregister_dev()
does not destroy the target device.

  BUG: memory leak
  unreferenced object 0xffff888112a54880 (size 64):
    comm "syz-executor.2", pid 5258, jiffies 4297861402 (age 14.129s)
    hex dump (first 32 bytes):
      38 c7 67 15 00 c9 ff ff 38 c7 67 15 00 c9 ff ff  8.g.....8.g.....
      e0 c7 e1 83 ff ff ff ff 00 30 67 15 00 c9 ff ff  .........0g.....
    backtrace:
      [<0000000006995a8a>] kmalloc include/linux/slab.h:556 [inline]
      [<0000000006995a8a>] kzalloc include/linux/slab.h:690 [inline]
      [<0000000006995a8a>] kvm_vm_ioctl_register_coalesced_mmio+0x8e/0x3d0 arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:150
      [<00000000022550c2>] kvm_vm_ioctl+0x47d/0x1600 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3323
      [<000000008a75102f>] vfs_ioctl fs/ioctl.c:46 [inline]
      [<000000008a75102f>] file_ioctl fs/ioctl.c:509 [inline]
      [<000000008a75102f>] do_vfs_ioctl+0xbab/0x1160 fs/ioctl.c:696
      [<0000000080e3f669>] ksys_ioctl+0x76/0xa0 fs/ioctl.c:713
      [<0000000059ef4888>] __do_sys_ioctl fs/ioctl.c:720 [inline]
      [<0000000059ef4888>] __se_sys_ioctl fs/ioctl.c:718 [inline]
      [<0000000059ef4888>] __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:718
      [<000000006444fa05>] do_syscall_64+0x9f/0x4e0 arch/x86/entry/common.c:290
      [<000000009a4ed50b>] entry_SYSCALL_64_after_hwframe+0x49/0xbe

  BUG: leak checking failed

Fixes: 5d3c4c79384a ("KVM: Stop looking for coalesced MMIO zones if the bus is destroyed")
Cc: stable@vger.kernel.org
Reported-by: 柳菁峰 <liujingfeng@qianxin.com>
Reported-by: Michal Luczaj <mhal@rbox.co>
Link: https://lore.kernel.org/r/20221219171924.67989-1-seanjc@google.com
Link: https://lore.kernel.org/all/20230118220003.1239032-1-mhal@rbox.co
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/coalesced_mmio.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -191,15 +191,17 @@ int kvm_vm_ioctl_unregister_coalesced_mm
 			r = kvm_io_bus_unregister_dev(kvm,
 				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS, &dev->dev);
 
+			kvm_iodevice_destructor(&dev->dev);
+
 			/*
 			 * On failure, unregister destroys all devices on the
 			 * bus _except_ the target device, i.e. coalesced_zones
-			 * has been modified.  No need to restart the walk as
-			 * there aren't any zones left.
+			 * has been modified.  Bail after destroying the target
+			 * device, there's no need to restart the walk as there
+			 * aren't any zones left.
 			 */
 			if (r)
 				break;
-			kvm_iodevice_destructor(&dev->dev);
 		}
 	}
 


