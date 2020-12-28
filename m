Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31F12E41F2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438166AbgL1PPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:15:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438163AbgL1OGd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 769F0205CB;
        Mon, 28 Dec 2020 14:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164353;
        bh=rffE+0RGjNumsaZb1eL5EEpMbEV4x5ZuJ9d0nAdmnmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6NR5VUiBsmPS6GWNL8uKB5jjo/fSeQvLiP14Je/VARvD3v9qLsqCcv/l+bkhUOaA
         bhQS1wDHP7qJGTI96UB/15IwUUodAFQkLkf3B2JgCdKHe186BuFPaO20hfWTGhPJCX
         qaW02oHfs4EBnr503n0nsjaR3JAKm3BmfR59JKvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/717] drm/meson: dw-hdmi: Register a callback to disable the regulator
Date:   Mon, 28 Dec 2020 13:42:21 +0100
Message-Id: <20201228125027.812906195@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 0405f94a1ae0586ca237aec0e859f1b796d6325d ]

Removing the meson-dw-hdmi module results in the following splat:

i[   43.340509] WARNING: CPU: 0 PID: 572 at drivers/regulator/core.c:2125 _regulator_put.part.0+0x16c/0x174
[...]
[   43.454870] CPU: 0 PID: 572 Comm: modprobe Tainted: G        W   E     5.10.0-rc4-00049-gd274813a4de3-dirty #2147
[   43.465042] Hardware name:  , BIOS 2021.01-rc2-00012-gde865f7ee1 11/16/2020
[   43.471945] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO BTYPE=--)
[   43.477896] pc : _regulator_put.part.0+0x16c/0x174
[   43.482638] lr : regulator_put+0x44/0x60
[...]
[   43.568715] Call trace:
[   43.571132]  _regulator_put.part.0+0x16c/0x174
[   43.575529]  regulator_put+0x44/0x60
[   43.579067]  devm_regulator_release+0x20/0x2c
[   43.583380]  release_nodes+0x1c8/0x2b4
[   43.587087]  devres_release_all+0x44/0x6c
[   43.591056]  __device_release_driver+0x1a0/0x23c
[   43.595626]  driver_detach+0xcc/0x160
[   43.599249]  bus_remove_driver+0x68/0xe0
[   43.603130]  driver_unregister+0x3c/0x6c
[   43.607011]  platform_driver_unregister+0x20/0x2c
[   43.611678]  meson_dw_hdmi_platform_driver_exit+0x18/0x4a8 [meson_dw_hdmi]
[   43.618485]  __arm64_sys_delete_module+0x1bc/0x294

as the HDMI regulator is still enabled on release.

In order to address this, register a callback that will deal with
the disabling when the driver is unbound, solving the problem.

Fixes: 161a803fe32d ("drm/meson: dw_hdmi: Add support for an optional external 5V regulator")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201116200744.495826-4-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_dw_hdmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/meson/meson_dw_hdmi.c b/drivers/gpu/drm/meson/meson_dw_hdmi.c
index 29a8ff41595d2..68826cf9993fc 100644
--- a/drivers/gpu/drm/meson/meson_dw_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_dw_hdmi.c
@@ -941,6 +941,11 @@ static void meson_dw_hdmi_init(struct meson_dw_hdmi *meson_dw_hdmi)
 
 }
 
+static void meson_disable_regulator(void *data)
+{
+	regulator_disable(data);
+}
+
 static int meson_dw_hdmi_bind(struct device *dev, struct device *master,
 				void *data)
 {
@@ -989,6 +994,10 @@ static int meson_dw_hdmi_bind(struct device *dev, struct device *master,
 		ret = regulator_enable(meson_dw_hdmi->hdmi_supply);
 		if (ret)
 			return ret;
+		ret = devm_add_action_or_reset(dev, meson_disable_regulator,
+					       meson_dw_hdmi->hdmi_supply);
+		if (ret)
+			return ret;
 	}
 
 	meson_dw_hdmi->hdmitx_apb = devm_reset_control_get_exclusive(dev,
-- 
2.27.0



