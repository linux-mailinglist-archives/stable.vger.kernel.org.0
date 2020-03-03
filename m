Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16447177DF7
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 18:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730909AbgCCRpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:45:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730905AbgCCRpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:45:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2569C208C3;
        Tue,  3 Mar 2020 17:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257519;
        bh=jgup64UFrKiSacTUai/nnQoGjwFMsP91KXVuOUvxR9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNW0FFpEoy1jcRdw8pgrNy6nbJW8hTydlTHHwFn9YfDSXp+mRN1GAau2EQ7sASpbg
         sQCOTk94WefolwHHOTTbsih5WpTgNcEs1GAFOKdAb5XIMDrzuWC9OWjvhTeDGmw5y7
         3J0bkjT2MIKEaV7dP+JTVwozaOQBCv7JjKJu5IPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Rob Clark <robdclark@gmail.com>,
        Sean Paul <seanpaul@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 026/176] drm/msm: Set dma maximum segment size for mdss
Date:   Tue,  3 Mar 2020 18:41:30 +0100
Message-Id: <20200303174307.548385277@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Paul <seanpaul@chromium.org>

[ Upstream commit db735fc4036bbe1fbe606819b5f0ff26cc76cdff ]

Turning on CONFIG_DMA_API_DEBUG_SG results in the following error:

[   12.078665] msm ae00000.mdss: DMA-API: mapping sg segment longer than device claims to support [len=3526656] [max=65536]
[   12.089870] WARNING: CPU: 6 PID: 334 at /mnt/host/source/src/third_party/kernel/v4.19/kernel/dma/debug.c:1301 debug_dma_map_sg+0x1dc/0x318
[   12.102655] Modules linked in: joydev
[   12.106442] CPU: 6 PID: 334 Comm: frecon Not tainted 4.19.0 #2
[   12.112450] Hardware name: Google Cheza (rev3+) (DT)
[   12.117566] pstate: 60400009 (nZCv daif +PAN -UAO)
[   12.122506] pc : debug_dma_map_sg+0x1dc/0x318
[   12.126995] lr : debug_dma_map_sg+0x1dc/0x318
[   12.131487] sp : ffffff800cc3ba80
[   12.134913] x29: ffffff800cc3ba80 x28: 0000000000000000
[   12.140395] x27: 0000000000000004 x26: 0000000000000004
[   12.145868] x25: ffffff8008e55b18 x24: 0000000000000000
[   12.151337] x23: 00000000ffffffff x22: ffffff800921c000
[   12.156809] x21: ffffffc0fa75b080 x20: ffffffc0f7195090
[   12.162280] x19: ffffffc0f1c53280 x18: 0000000000000000
[   12.167749] x17: 0000000000000000 x16: 0000000000000000
[   12.173218] x15: 0000000000000000 x14: 0720072007200720
[   12.178689] x13: 0720072007200720 x12: 0720072007200720
[   12.184161] x11: 0720072007200720 x10: 0720072007200720
[   12.189641] x9 : ffffffc0f1fc6b60 x8 : 0000000000000000
[   12.195110] x7 : ffffff8008132ce0 x6 : 0000000000000000
[   12.200585] x5 : 0000000000000000 x4 : ffffff8008134734
[   12.206058] x3 : ffffff800cc3b830 x2 : ffffffc0f1fc6240
[   12.211532] x1 : 25045a74f48a7400 x0 : 25045a74f48a7400
[   12.217006] Call trace:
[   12.219535]  debug_dma_map_sg+0x1dc/0x318
[   12.223671]  get_pages+0x19c/0x20c
[   12.227177]  msm_gem_fault+0x64/0xfc
[   12.230874]  __do_fault+0x3c/0x140
[   12.234383]  __handle_mm_fault+0x70c/0xdb8
[   12.238603]  handle_mm_fault+0xac/0xc4
[   12.242473]  do_page_fault+0x1bc/0x3d4
[   12.246342]  do_translation_fault+0x54/0x88
[   12.250652]  do_mem_abort+0x60/0xf0
[   12.254250]  el0_da+0x20/0x24
[   12.257317] irq event stamp: 67260
[   12.260828] hardirqs last  enabled at (67259): [<ffffff8008132d0c>] console_unlock+0x214/0x608
[   12.269693] hardirqs last disabled at (67260): [<ffffff8008080e0c>] do_debug_exception+0x5c/0x178
[   12.278820] softirqs last  enabled at (67256): [<ffffff8008081664>] __do_softirq+0x4d4/0x520
[   12.287510] softirqs last disabled at (67249): [<ffffff80080be574>] irq_exit+0xa8/0x100
[   12.295742] ---[ end trace e63cfc40c313ffab ]---

The root of the problem is that the default segment size for sgt is
(UINT_MAX & PAGE_MASK), and the default segment size for device dma is
64K. As such, if you compare the 2, you would deduce that the sg segment
will overflow the device's capacity. In reality, the hardware can
accommodate the larger sg segments, it's just not initializing its max
segment properly. This patch initializes the max segment size for the
mdss device, which gets rid of that pesky warning.

Reported-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200121111813.REPOST.1.I92c66a35fb13f368095b05287bdabdbe88ca6922@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index c84f0a8b3f2ce..b73fbb65e14b2 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -441,6 +441,14 @@ static int msm_drm_init(struct device *dev, struct drm_driver *drv)
 	if (ret)
 		goto err_msm_uninit;
 
+	if (!dev->dma_parms) {
+		dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
+					      GFP_KERNEL);
+		if (!dev->dma_parms)
+			return -ENOMEM;
+	}
+	dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
+
 	msm_gem_shrinker_init(ddev);
 
 	switch (get_mdp_ver(pdev)) {
-- 
2.20.1



