Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F885AED48
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbiIFOaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242253AbiIFO2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:28:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CC880F56;
        Tue,  6 Sep 2022 06:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 24A41CE1780;
        Tue,  6 Sep 2022 13:49:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0354DC433D6;
        Tue,  6 Sep 2022 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662472155;
        bh=dOI2IuuDRUSfQN5pm6dJWJDFV+lQ/T7EbbuVMHkHPLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPXwzh6RzP/UNIEttZNn+5ihz22M1H/HaUg7P7EVtDvD5qfyfxz+vEDKh1ddmsl+M
         peLhXdvrFC+V4qkup0rJFt1uGULqgydQpBbhQ24x+jbVn9nM/5ZpRQ0QEIOWIVDLTM
         gJreWl840lv+Mz/3MtkOToA5yTpaDiLHlivNNYggQG5JEo3YPetkiPYj5fn5rCkJVz
         XZ/2ULwOt2njkkBeNeJzPck38+8jrbYATIx9Lyv381GU7UdwL3CkcDwLXC950ZBPOn
         06/Y7wsxHKMa39XKJUcha3j30/VyMsyHw/3dB416u2by5d4FoK8+nbvcypiGCjBz1L
         GhGB0UUwlOuyw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVYx5-00050Q-D1; Tue, 06 Sep 2022 15:49:19 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH stable-4.19 1/4] usb: dwc3: fix PHY disable sequence
Date:   Tue,  6 Sep 2022 15:49:12 +0200
Message-Id: <20220906134915.19225-2-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906134915.19225-1-johan@kernel.org>
References: <20220906134915.19225-1-johan@kernel.org>
MIME-Version: 1.0
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

From: Johan Hovold <johan+linaro@kernel.org>

commit d2ac7bef95c9ead307801ccb6cb6dfbeb14247bf upstream.

Generic PHYs must be powered-off before they can be tore down.

Similarly, suspending legacy PHYs after having powered them off makes no
sense.

Fix the dwc3_core_exit() (e.g. called during suspend) and open-coded
dwc3_probe() error-path sequences that got this wrong.

Note that this makes dwc3_core_exit() match the dwc3_core_init() error
path with respect to powering off the PHYs.

Fixes: 03c1fd622f72 ("usb: dwc3: core: add phy cleanup for probe error handling")
Fixes: c499ff71ff2a ("usb: dwc3: core: re-factor init and exit paths")
Cc: stable@vger.kernel.org      # 4.8
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220804151001.23612-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ johan: adjust context to 4.19 ]
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/dwc3/core.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 984faecdd7ec..465aabb6e96c 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -673,15 +673,16 @@ static void dwc3_core_exit(struct dwc3 *dwc)
 {
 	dwc3_event_buffers_cleanup(dwc);
 
+	usb_phy_set_suspend(dwc->usb2_phy, 1);
+	usb_phy_set_suspend(dwc->usb3_phy, 1);
+	phy_power_off(dwc->usb2_generic_phy);
+	phy_power_off(dwc->usb3_generic_phy);
+
 	usb_phy_shutdown(dwc->usb2_phy);
 	usb_phy_shutdown(dwc->usb3_phy);
 	phy_exit(dwc->usb2_generic_phy);
 	phy_exit(dwc->usb3_generic_phy);
 
-	usb_phy_set_suspend(dwc->usb2_phy, 1);
-	usb_phy_set_suspend(dwc->usb3_phy, 1);
-	phy_power_off(dwc->usb2_generic_phy);
-	phy_power_off(dwc->usb3_generic_phy);
 	clk_bulk_disable(dwc->num_clks, dwc->clks);
 	clk_bulk_unprepare(dwc->num_clks, dwc->clks);
 	reset_control_assert(dwc->reset);
@@ -1509,16 +1510,16 @@ static int dwc3_probe(struct platform_device *pdev)
 	dwc3_debugfs_exit(dwc);
 	dwc3_event_buffers_cleanup(dwc);
 
-	usb_phy_shutdown(dwc->usb2_phy);
-	usb_phy_shutdown(dwc->usb3_phy);
-	phy_exit(dwc->usb2_generic_phy);
-	phy_exit(dwc->usb3_generic_phy);
-
 	usb_phy_set_suspend(dwc->usb2_phy, 1);
 	usb_phy_set_suspend(dwc->usb3_phy, 1);
 	phy_power_off(dwc->usb2_generic_phy);
 	phy_power_off(dwc->usb3_generic_phy);
 
+	usb_phy_shutdown(dwc->usb2_phy);
+	usb_phy_shutdown(dwc->usb3_phy);
+	phy_exit(dwc->usb2_generic_phy);
+	phy_exit(dwc->usb3_generic_phy);
+
 	dwc3_ulpi_exit(dwc);
 
 err4:
-- 
2.35.1

