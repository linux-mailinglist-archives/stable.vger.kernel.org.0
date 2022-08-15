Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BD259496A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243994AbiHOXne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354327AbiHOXlx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3AD2C661;
        Mon, 15 Aug 2022 13:12:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D33D5B80EA9;
        Mon, 15 Aug 2022 20:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEE5C433D6;
        Mon, 15 Aug 2022 20:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594353;
        bh=PvyEqTet1YutiyM68uLV8/0zJlbK9ycyLKrxuXea/54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVEhrbyhcol+KpKpjgmSuJyWLyFvzAMY8KhxnvNtJnsLW0e2UoHC/kJytmAlMfNBR
         cKb7OwewUnhADZfkUC/nPNfOdjLCNZXe59UVYge+TB9+ITsbWFYQFnaik+awre8c+v
         i4jkMXcIT7Y6X7D2yD/4RmvNoMpcA4qzFfxk4t4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0420/1157] drm/vc4: hdmi: Move HDMI reset to pm_resume
Date:   Mon, 15 Aug 2022 19:56:16 +0200
Message-Id: <20220815180456.476020431@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 467e30171b5b483922b1c24c573fa50787207cb6 ]

The BCM2835-37 found in the RaspberryPi 0 to 3 have a power domain
attached to the HDMI block, handled in Linux through runtime_pm.

That power domain is shared with the VEC block, so even if we put our
runtime_pm reference in the HDMI driver it would keep being on. If the
VEC is disabled though, the power domain would be disabled and we would
lose any initialization done in our bind implementation.

That initialization involves calling the reset function and initializing
the CEC registers.

Let's move the initialization to our runtime_resume implementation so
that we initialize everything properly if we ever need to.

Fixes: c86b41214362 ("drm/vc4: hdmi: Move the HSM clock enable to runtime_pm")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://lore.kernel.org/r/20220613144800.326124-24-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 41 ++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index b73f64f0ba09..f3e0de6515e0 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2544,8 +2544,6 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
 	struct cec_connector_info conn_info;
 	struct platform_device *pdev = vc4_hdmi->pdev;
 	struct device *dev = &pdev->dev;
-	unsigned long flags;
-	u32 value;
 	int ret;
 
 	if (!of_find_property(dev->of_node, "interrupts", NULL)) {
@@ -2564,15 +2562,6 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
 	cec_fill_conn_info_from_drm(&conn_info, &vc4_hdmi->connector);
 	cec_s_conn_info(vc4_hdmi->cec_adap, &conn_info);
 
-	spin_lock_irqsave(&vc4_hdmi->hw_lock, flags);
-	value = HDMI_READ(HDMI_CEC_CNTRL_1);
-	/* Set the logical address to Unregistered */
-	value |= VC4_HDMI_CEC_ADDR_MASK;
-	HDMI_WRITE(HDMI_CEC_CNTRL_1, value);
-	spin_unlock_irqrestore(&vc4_hdmi->hw_lock, flags);
-
-	vc4_hdmi_cec_update_clk_div(vc4_hdmi);
-
 	if (vc4_hdmi->variant->external_irq_controller) {
 		ret = request_threaded_irq(platform_get_irq_byname(pdev, "cec-rx"),
 					   vc4_cec_irq_handler_rx_bare,
@@ -2588,10 +2577,6 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
 		if (ret)
 			goto err_remove_cec_rx_handler;
 	} else {
-		spin_lock_irqsave(&vc4_hdmi->hw_lock, flags);
-		HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, 0xffffffff);
-		spin_unlock_irqrestore(&vc4_hdmi->hw_lock, flags);
-
 		ret = request_threaded_irq(platform_get_irq(pdev, 0),
 					   vc4_cec_irq_handler,
 					   vc4_cec_irq_handler_thread, 0,
@@ -2642,7 +2627,6 @@ static int vc4_hdmi_cec_init(struct vc4_hdmi *vc4_hdmi)
 }
 
 static void vc4_hdmi_cec_exit(struct vc4_hdmi *vc4_hdmi) {};
-
 #endif
 
 static int vc4_hdmi_build_regset(struct vc4_hdmi *vc4_hdmi,
@@ -2871,12 +2855,34 @@ static int __maybe_unused vc4_hdmi_runtime_suspend(struct device *dev)
 static int vc4_hdmi_runtime_resume(struct device *dev)
 {
 	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
+	unsigned long __maybe_unused flags;
+	u32 __maybe_unused value;
 	int ret;
 
 	ret = clk_prepare_enable(vc4_hdmi->hsm_clock);
 	if (ret)
 		return ret;
 
+	if (vc4_hdmi->variant->reset)
+		vc4_hdmi->variant->reset(vc4_hdmi);
+
+#ifdef CONFIG_DRM_VC4_HDMI_CEC
+	spin_lock_irqsave(&vc4_hdmi->hw_lock, flags);
+	value = HDMI_READ(HDMI_CEC_CNTRL_1);
+	/* Set the logical address to Unregistered */
+	value |= VC4_HDMI_CEC_ADDR_MASK;
+	HDMI_WRITE(HDMI_CEC_CNTRL_1, value);
+	spin_unlock_irqrestore(&vc4_hdmi->hw_lock, flags);
+
+	vc4_hdmi_cec_update_clk_div(vc4_hdmi);
+
+	if (!vc4_hdmi->variant->external_irq_controller) {
+		spin_lock_irqsave(&vc4_hdmi->hw_lock, flags);
+		HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, 0xffffffff);
+		spin_unlock_irqrestore(&vc4_hdmi->hw_lock, flags);
+	}
+#endif
+
 	return 0;
 }
 
@@ -2966,9 +2972,6 @@ static int vc4_hdmi_bind(struct device *dev, struct device *master, void *data)
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
-	if (vc4_hdmi->variant->reset)
-		vc4_hdmi->variant->reset(vc4_hdmi);
-
 	if ((of_device_is_compatible(dev->of_node, "brcm,bcm2711-hdmi0") ||
 	     of_device_is_compatible(dev->of_node, "brcm,bcm2711-hdmi1")) &&
 	    HDMI_READ(HDMI_VID_CTL) & VC4_HD_VID_CTL_ENABLE) {
-- 
2.35.1



