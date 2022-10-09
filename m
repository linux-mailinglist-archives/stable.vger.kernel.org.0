Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5095F9593
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbiJJAVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbiJJAUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:20:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9897B97;
        Sun,  9 Oct 2022 16:54:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28873B80DEA;
        Sun,  9 Oct 2022 23:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF91C4347C;
        Sun,  9 Oct 2022 23:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359689;
        bh=RY3cfM/ftCZjdDWwiDv/6mYDrpRONkhu8X8mieWXehg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZd3vKs68hg2qhtmhqm8l9TmD7lRpAvSNiItnjZnLkCOnEhyOdJHb6zLVcLmceptO
         0fvDIeWoGijVasxCrqnza2yHz83bIyVbXRpbqozgBX/ZHVLHnv7BChH+k1exj4xCyq
         0yTSnnUs9xhOcmvAArR+vvt4uE3rtnl46OLebFDJCZLxxGrt7mpUuaOj21pI1UQ1in
         7w4H6egUZm8XznS31B6AQ7MtJX7+kfURcpOFLcCjZ5Ha2bJ7/1QW60KmeYFBFYbaL7
         jPD5ZclR3Aj5H+AMDUBrCSPhLYbqDortW7pZswbewi6lb1pPcJaktgPXRM62ybSXQ8
         k5/R5lZA3h0DQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>, andrzej.hajda@intel.com,
        neil.armstrong@linaro.org, airlied@gmail.com, daniel@ffwll.ch,
        Sandor.yu@nxp.com, ville.syrjala@linux.intel.com,
        jernej.skrabec@gmail.com, tzimmermann@suse.de, maxime@cerno.tech,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 09/25] drm: bridge: dw_hdmi: only trigger hotplug event on link change
Date:   Sun,  9 Oct 2022 19:54:09 -0400
Message-Id: <20221009235426.1231313-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235426.1231313-1-sashal@kernel.org>
References: <20221009235426.1231313-1-sashal@kernel.org>
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

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit da09daf881082266e4075657fac53c7966de8e4d ]

There are two events that signal a real change of the link state: HPD going
high means the sink is newly connected or wants the source to re-read the
EDID, RX sense going low is a indication that the link has been disconnected.

Ignore the other two events that also trigger interrupts, but don't need
immediate attention: HPD going low does not necessarily mean the link has
been lost and should not trigger a immediate read of the status. RX sense
going high also does not require a detect cycle, as HPD going high is the
right point in time to read the EDID.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com> (v1)
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220826185733.3213248-1-l.stach@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index 25d58dcfc87e..d3129a3e6ab7 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -2970,6 +2970,7 @@ static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 {
 	struct dw_hdmi *hdmi = dev_id;
 	u8 intr_stat, phy_int_pol, phy_pol_mask, phy_stat;
+	enum drm_connector_status status = connector_status_unknown;
 
 	intr_stat = hdmi_readb(hdmi, HDMI_IH_PHY_STAT0);
 	phy_int_pol = hdmi_readb(hdmi, HDMI_PHY_POL0);
@@ -3008,13 +3009,15 @@ static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 			cec_notifier_phys_addr_invalidate(hdmi->cec_notifier);
 			mutex_unlock(&hdmi->cec_notifier_mutex);
 		}
-	}
 
-	if (intr_stat & HDMI_IH_PHY_STAT0_HPD) {
-		enum drm_connector_status status = phy_int_pol & HDMI_PHY_HPD
-						 ? connector_status_connected
-						 : connector_status_disconnected;
+		if (phy_stat & HDMI_PHY_HPD)
+			status = connector_status_connected;
+
+		if (!(phy_stat & (HDMI_PHY_HPD | HDMI_PHY_RX_SENSE)))
+			status = connector_status_disconnected;
+	}
 
+	if (status != connector_status_unknown) {
 		dev_dbg(hdmi->dev, "EVENT=%s\n",
 			status == connector_status_connected ?
 			"plugin" : "plugout");
-- 
2.35.1

