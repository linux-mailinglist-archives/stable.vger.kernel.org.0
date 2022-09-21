Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1105C0381
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiIUQGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiIUQFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:05:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9656E2A439;
        Wed, 21 Sep 2022 08:54:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58E71B830EB;
        Wed, 21 Sep 2022 15:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2213C43470;
        Wed, 21 Sep 2022 15:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663775691;
        bh=mZEjU9sKh4ZHqsW67cldg1I7i6KLgb+SX4bzxU6CYwQ=;
        h=From:To:Cc:Subject:Date:From;
        b=SkhF4lr4feLhxqcH8ZCpum+XDsyrDBWZWWdT3eBtsjoqrvZZ8Jf69kwOOq6svklDi
         wTYSQhQpigMj/xJOXU6GFXA38QbOnDoqk7AKbc23qNxVCQ0j76pXg88z/QAVHXZIqJ
         CuYb2b7jalnP4J63yBEGdMAS0TYiFprEChFfShiGAq1NIscwaOOkoxx/2QaFj7O7/a
         rkPUOSNux9bcBaj1BPH2dj7XyZr+crDoY05qfi2gr3qlWzX48gMwqfNsJMdG9WH2/d
         wEzUNMa9lFr66XEA/V3ybUvLm06ZpchtpG0rqDc7P+GsF59D9mNQtW38O+wzzJs7w+
         l7w7sS330moxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9] Drivers: hv: Never allocate anything besides framebuffer from framebuffer memory region
Date:   Wed, 21 Sep 2022 11:54:49 -0400
Message-Id: <20220921155449.235520-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit f0880e2cb7e1f8039a048fdd01ce45ab77247221 ]

Passed through PCI device sometimes misbehave on Gen1 VMs when Hyper-V
DRM driver is also loaded. Looking at IOMEM assignment, we can see e.g.

$ cat /proc/iomem
...
f8000000-fffbffff : PCI Bus 0000:00
  f8000000-fbffffff : 0000:00:08.0
    f8000000-f8001fff : bb8c4f33-2ba2-4808-9f7f-02f3b4da22fe
...
fe0000000-fffffffff : PCI Bus 0000:00
  fe0000000-fe07fffff : bb8c4f33-2ba2-4808-9f7f-02f3b4da22fe
    fe0000000-fe07fffff : 2ba2:00:02.0
      fe0000000-fe07fffff : mlx4_core

the interesting part is the 'f8000000' region as it is actually the
VM's framebuffer:

$ lspci -v
...
0000:00:08.0 VGA compatible controller: Microsoft Corporation Hyper-V virtual VGA (prog-if 00 [VGA controller])
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at f8000000 (32-bit, non-prefetchable) [size=64M]
...

 hv_vmbus: registering driver hyperv_drm
 hyperv_drm 5620e0c7-8062-4dce-aeb7-520c7ef76171: [drm] Synthvid Version major 3, minor 5
 hyperv_drm 0000:00:08.0: vgaarb: deactivate vga console
 hyperv_drm 0000:00:08.0: BAR 0: can't reserve [mem 0xf8000000-0xfbffffff]
 hyperv_drm 5620e0c7-8062-4dce-aeb7-520c7ef76171: [drm] Cannot request framebuffer, boot fb still active?

Note: "Cannot request framebuffer" is not a fatal error in
hyperv_setup_gen1() as the code assumes there's some other framebuffer
device there but we actually have some other PCI device (mlx4 in this
case) config space there!

The problem appears to be that vmbus_allocate_mmio() can use dedicated
framebuffer region to serve any MMIO request from any device. The
semantics one might assume of a parameter named "fb_overlap_ok"
aren't implemented because !fb_overlap_ok essentially has no effect.
The existing semantics are really "prefer_fb_overlap". This patch
implements the expected and needed semantics, which is to not allocate
from the frame buffer space when !fb_overlap_ok.

Note, Gen2 VMs are usually unaffected by the issue because
framebuffer region is already taken by EFI fb (in case kernel supports
it) but Gen1 VMs may have this region unclaimed by the time Hyper-V PCI
pass-through driver tries allocating MMIO space if Hyper-V DRM/FB drivers
load after it. Devices can be brought up in any sequence so let's
resolve the issue by always ignoring 'fb_mmio' region for non-FB
requests, even if the region is unclaimed.

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/20220827130345.1320254-4-vkuznets@redhat.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 3248aa7a35b3..cb3e22f10d68 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1186,7 +1186,7 @@ int vmbus_allocate_mmio(struct resource **new, struct hv_device *device_obj,
 			bool fb_overlap_ok)
 {
 	struct resource *iter, *shadow;
-	resource_size_t range_min, range_max, start;
+	resource_size_t range_min, range_max, start, end;
 	const char *dev_n = dev_name(&device_obj->device);
 	int retval;
 
@@ -1221,6 +1221,14 @@ int vmbus_allocate_mmio(struct resource **new, struct hv_device *device_obj,
 		range_max = iter->end;
 		start = (range_min + align - 1) & ~(align - 1);
 		for (; start + size - 1 <= range_max; start += align) {
+			end = start + size - 1;
+
+			/* Skip the whole fb_mmio region if not fb_overlap_ok */
+			if (!fb_overlap_ok && fb_mmio &&
+			    (((start >= fb_mmio->start) && (start <= fb_mmio->end)) ||
+			     ((end >= fb_mmio->start) && (end <= fb_mmio->end))))
+				continue;
+
 			shadow = __request_region(iter, start, size, NULL,
 						  IORESOURCE_BUSY);
 			if (!shadow)
-- 
2.35.1

