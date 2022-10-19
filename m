Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F1760422C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbiJSK4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbiJSK4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:56:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8CA165514;
        Wed, 19 Oct 2022 03:27:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE27EB824BC;
        Wed, 19 Oct 2022 09:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28622C4314A;
        Wed, 19 Oct 2022 09:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170663;
        bh=wn1Qa7aWt3WxTNBuzagICTdOlbP3jJqAjckgAsaRIkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ucGnItiV9XBNeWRw23GvDVcw94mrF1o/70LYqGmr1kyXkBartZ6ZEbyy5USoT6aB
         gIJ9+Ldgu5YE5jm9cSZqPcujaye57pWYdavQ6r+93erT1JQvxDl9sWtOol++BX4Rx4
         8rB8rBnVIDee7Yl5WkWsgf3rw4Cyv+lBTui4Gfag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH 6.0 739/862] drm: bridge: dw_hdmi: only trigger hotplug event on link change
Date:   Wed, 19 Oct 2022 10:33:46 +0200
Message-Id: <20221019083322.612345116@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 25a60eb4d67c..40d8ca37f5bc 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -3096,6 +3096,7 @@ static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 {
 	struct dw_hdmi *hdmi = dev_id;
 	u8 intr_stat, phy_int_pol, phy_pol_mask, phy_stat;
+	enum drm_connector_status status = connector_status_unknown;
 
 	intr_stat = hdmi_readb(hdmi, HDMI_IH_PHY_STAT0);
 	phy_int_pol = hdmi_readb(hdmi, HDMI_PHY_POL0);
@@ -3134,13 +3135,15 @@ static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
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



