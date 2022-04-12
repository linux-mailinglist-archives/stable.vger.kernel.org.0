Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195854FD5E1
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbiDLIA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357686AbiDLHki (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:40:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40E61005;
        Tue, 12 Apr 2022 00:16:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60F1261708;
        Tue, 12 Apr 2022 07:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76605C385A1;
        Tue, 12 Apr 2022 07:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747802;
        bh=uyftIm97GOa/nPfrZIJfhPY3oen1ZSdn3fuNNPh3DfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnByObOy6iCWsCIdDckhld9DEvUZMKKgi9MpkbrOCxV8OkCBxoEFfdWknOzmwULkD
         86RggxdyLik7XaUMeQJm0vrm8zTJbO6DZEKkZtwcSMNerC1B/B8Xhl/N1FEZ4y6E6K
         8GewlxTtftJOlrkb/44L6TjznT5myvv+9SEpcIHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 194/343] Drivers: hv: vmbus: Fix initialization of device object in vmbus_device_register()
Date:   Tue, 12 Apr 2022 08:30:12 +0200
Message-Id: <20220412062956.958068021@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com>

[ Upstream commit 3a5469582c241abca22500f36a9cb8e9331969cf ]

Initialize the device's dma_{mask,parms} pointers and the device's
dma_mask value before invoking device_register().  Address the
following trace with 5.17-rc7:

[   49.646839] WARNING: CPU: 0 PID: 189 at include/linux/dma-mapping.h:543
	netvsc_probe+0x37a/0x3a0 [hv_netvsc]
[   49.646928] Call Trace:
[   49.646930]  <TASK>
[   49.646935]  vmbus_probe+0x40/0x60 [hv_vmbus]
[   49.646942]  really_probe+0x1ce/0x3b0
[   49.646948]  __driver_probe_device+0x109/0x180
[   49.646952]  driver_probe_device+0x23/0xa0
[   49.646955]  __device_attach_driver+0x76/0xe0
[   49.646958]  ? driver_allows_async_probing+0x50/0x50
[   49.646961]  bus_for_each_drv+0x84/0xd0
[   49.646964]  __device_attach+0xed/0x170
[   49.646967]  device_initial_probe+0x13/0x20
[   49.646970]  bus_probe_device+0x8f/0xa0
[   49.646973]  device_add+0x41a/0x8e0
[   49.646975]  ? hrtimer_init+0x28/0x80
[   49.646981]  device_register+0x1b/0x20
[   49.646983]  vmbus_device_register+0x5e/0xf0 [hv_vmbus]
[   49.646991]  vmbus_add_channel_work+0x12d/0x190 [hv_vmbus]
[   49.646999]  process_one_work+0x21d/0x3f0
[   49.647002]  worker_thread+0x4a/0x3b0
[   49.647005]  ? process_one_work+0x3f0/0x3f0
[   49.647007]  kthread+0xff/0x130
[   49.647011]  ? kthread_complete_and_exit+0x20/0x20
[   49.647015]  ret_from_fork+0x22/0x30
[   49.647020]  </TASK>
[   49.647021] ---[ end trace 0000000000000000 ]---

Fixes: 743b237c3a7b0 ("scsi: storvsc: Add Isolation VM support for storvsc driver")
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20220315141053.3223-1-parri.andrea@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 12a2b37e87f3..0a05e10ab36c 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2097,6 +2097,10 @@ int vmbus_device_register(struct hv_device *child_device_obj)
 	child_device_obj->device.parent = &hv_acpi_dev->dev;
 	child_device_obj->device.release = vmbus_device_release;
 
+	child_device_obj->device.dma_parms = &child_device_obj->dma_parms;
+	child_device_obj->device.dma_mask = &child_device_obj->dma_mask;
+	dma_set_mask(&child_device_obj->device, DMA_BIT_MASK(64));
+
 	/*
 	 * Register with the LDM. This will kick off the driver/device
 	 * binding...which will eventually call vmbus_match() and vmbus_probe()
@@ -2122,9 +2126,6 @@ int vmbus_device_register(struct hv_device *child_device_obj)
 	}
 	hv_debug_add_dev_dir(child_device_obj);
 
-	child_device_obj->device.dma_parms = &child_device_obj->dma_parms;
-	child_device_obj->device.dma_mask = &child_device_obj->dma_mask;
-	dma_set_mask(&child_device_obj->device, DMA_BIT_MASK(64));
 	return 0;
 
 err_kset_unregister:
-- 
2.35.1



