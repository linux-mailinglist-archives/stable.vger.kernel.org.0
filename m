Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765055E9F5B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbiIZKZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbiIZKXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:23:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A584FDEA6;
        Mon, 26 Sep 2022 03:16:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62824CE10E3;
        Mon, 26 Sep 2022 10:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77068C433C1;
        Mon, 26 Sep 2022 10:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187404;
        bh=Oc1MWnQoNbV/pm3YZwsLXM5PtoU3drC/V01obMA+e88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AemJ0gz6pkZksts5GvfZ9XWgoQITCG+PJR6DSgDz+vmDc+XpQ7TpKZL2wtbpcxQQ7
         UpJZzTf3OIEdgYjZSjKwfIogY2tINs8rQDlxEKFNB5EPDlvjZVwQ6eDLRx2x7PxNc7
         J2ZAHuO1L9decgpmkaaGZ+lkrHH+QvHFosA2mM2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 38/40] Drivers: hv: Never allocate anything besides framebuffer from framebuffer memory region
Date:   Mon, 26 Sep 2022 12:12:06 +0200
Message-Id: <20220926100739.798016826@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100738.148626940@linuxfoundation.org>
References: <20220926100738.148626940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index cdf7d39362fd..1c09b1a787f6 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1426,7 +1426,7 @@ int vmbus_allocate_mmio(struct resource **new, struct hv_device *device_obj,
 			bool fb_overlap_ok)
 {
 	struct resource *iter, *shadow;
-	resource_size_t range_min, range_max, start;
+	resource_size_t range_min, range_max, start, end;
 	const char *dev_n = dev_name(&device_obj->device);
 	int retval;
 
@@ -1461,6 +1461,14 @@ int vmbus_allocate_mmio(struct resource **new, struct hv_device *device_obj,
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



