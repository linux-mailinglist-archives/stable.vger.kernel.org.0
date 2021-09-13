Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C651C40948C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345580AbhIMObz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347121AbhIMOaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:30:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A2961B5D;
        Mon, 13 Sep 2021 13:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541072;
        bh=0x6AMwLtktK0p++DEgX0mX/VHgOCE3g17gLFp+HbpAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJycALvSWLRyT47FrhE+MfKDwvReWXC5F7gSuDnICs21IPKWJcdFFtL5PXraCGirR
         pbJTZaXWwB41HsqAB9X/biNl8R3kTY6JLF1yxczxyOnv5Pmfl3NptNTB4p2H02ua43
         8vW9D0IER6CkxV/LWcMtkSX74KVLc7/UDULkERcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Robert Foss <robert.foss@linaro.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 151/334] drm/bridge: ti-sn65dsi86: Add some 100 us delays
Date:   Mon, 13 Sep 2021 15:13:25 +0200
Message-Id: <20210913131118.465891522@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit e183bf31cf0d3a05162e633e428350ed176ce926 ]

The manual has always said that we need 100 us delays in a few
places. Though it hasn't seemed to be a big deal to skip these, let's
add them in case it makes something happier.

NOTE: this fixes no known issues but it seems good to make it right.

Fixes: a095f15c00e2 ("drm/bridge: add support for sn65dsi86 bridge driver")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Robert Foss <robert.foss@linaro.org>
Reviewed-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210730084534.v2.3.I842d483139531aa4651da8338512fdf0171ff23c@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index ecd4fa3a9a1d..c9cddf317c72 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -304,6 +304,9 @@ static int __maybe_unused ti_sn65dsi86_resume(struct device *dev)
 		return ret;
 	}
 
+	/* td2: min 100 us after regulators before enabling the GPIO */
+	usleep_range(100, 110);
+
 	gpiod_set_value(pdata->enable_gpio, 1);
 
 	/*
@@ -886,6 +889,9 @@ static void ti_sn_bridge_pre_enable(struct drm_bridge *bridge)
 
 	if (!pdata->refclk)
 		ti_sn65dsi86_enable_comms(pdata);
+
+	/* td7: min 100 us after enable before DSI data */
+	usleep_range(100, 110);
 }
 
 static void ti_sn_bridge_post_disable(struct drm_bridge *bridge)
-- 
2.30.2



