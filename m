Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9E55AEE32
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242005AbiIFOy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242426AbiIFOyF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:54:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FA366A5D;
        Tue,  6 Sep 2022 07:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B753F61558;
        Tue,  6 Sep 2022 14:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211B5C433D6;
        Tue,  6 Sep 2022 14:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662473361;
        bh=ppcGylTDM9z0q0cLK0IXVsWH6c6XivW11+riR1eUWkI=;
        h=From:To:Cc:Subject:Date:From;
        b=r007kpoCYy3l1op/1eX3gpQePk4Kyy7h5+mX/s8Y9x+ggH+ZfNTiRi7le17gPRew2
         hP0dOco2VR3JlL3l/gOXhZK/cI2PCE7lxjKR5UcbXMlwknDwpiq6x8YOHdJq/s0mKp
         HcRh10+zntQeOU5ai9Lj9GGMgDuEJVu8oluuRJC36JQX0lEpSgrUuFth/RKCjXkggS
         eMa+84Zpo25Ei4sCcRrpQL9hIEVhsKYBg85apjX8bdbf/txfunauVSp7VfjYqyRtn9
         zuMe5uSYLV+6iEnRU4Yc8Da8KMIOtWxSSY2DEzp//tWMSxc6TS610mBnm33UoAjH5h
         y3TwwxorOSufA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVZGX-0000Er-A9; Tue, 06 Sep 2022 16:09:25 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH stable 4.9] usb: dwc3: fix PHY disable sequence
Date:   Tue,  6 Sep 2022 16:09:17 +0200
Message-Id: <20220906140917.908-1-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
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
[ johan: adjust context to 4.9 ]
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---

Never again... ;)

Johan


 drivers/usb/dwc3/core.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index b6d6fe4565fd..fb00dccfc373 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -602,15 +602,15 @@ static void dwc3_core_exit(struct dwc3 *dwc)
 {
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
+
+	usb_phy_shutdown(dwc->usb2_phy);
+	usb_phy_shutdown(dwc->usb3_phy);
+	phy_exit(dwc->usb2_generic_phy);
+	phy_exit(dwc->usb3_generic_phy);
 }
 
 /**
@@ -1149,16 +1149,16 @@ static int dwc3_probe(struct platform_device *pdev)
 err5:
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

