Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7C05F954B
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiJJASE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbiJJARH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:17:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94745D0DD;
        Sun,  9 Oct 2022 16:52:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3461B80DE1;
        Sun,  9 Oct 2022 23:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1675AC433C1;
        Sun,  9 Oct 2022 23:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359567;
        bh=VmgxIigWdW5PxGDKM9INkjR8myLbENkFTD+P5Yn5K18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjL4Gn7JCXPjvh5cZGr+XCaUxk2G8HvwkZza9NqJ4rgGGb4r91UqEY5/eAEOPRKfg
         3rzE5kKo8ntrFEXU2uSAT95auKIFUVAMY3BUDq7DvXty/p6x0zOYD7C6XoXyryXisc
         nhHyLiEIGv3wN9kRRU46Ydc1/4FwE77PDkLPGU6gD7+KOhMW091oEjy907y72A/YXe
         CmtdWmUUzealtxCRkjJMotyL4+nywhFp85b5XT7wYx9rpvh2jSQzHR56aeJvstz4AB
         Qo3N9RxMjPHzdqBDcS+G1UP6mzFycQijcuq7vzkNoP299Qy5IMl53M1PHZ24aRNOQj
         lVQvBGr4mgZ5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>, andrzej.hajda@intel.com,
        neil.armstrong@linaro.org, airlied@gmail.com, daniel@ffwll.ch,
        Sandor.yu@nxp.com, ville.syrjala@linux.intel.com,
        javierm@redhat.com, tzimmermann@suse.de, maxime@cerno.tech,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 10/36] drm: bridge: dw_hdmi: only trigger hotplug event on link change
Date:   Sun,  9 Oct 2022 19:51:56 -0400
Message-Id: <20221009235222.1230786-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235222.1230786-1-sashal@kernel.org>
References: <20221009235222.1230786-1-sashal@kernel.org>
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
index 3e1be9894ed1..0552e9a3c838 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -3095,6 +3095,7 @@ static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 {
 	struct dw_hdmi *hdmi = dev_id;
 	u8 intr_stat, phy_int_pol, phy_pol_mask, phy_stat;
+	enum drm_connector_status status = connector_status_unknown;
 
 	intr_stat = hdmi_readb(hdmi, HDMI_IH_PHY_STAT0);
 	phy_int_pol = hdmi_readb(hdmi, HDMI_PHY_POL0);
@@ -3133,13 +3134,15 @@ static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
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

