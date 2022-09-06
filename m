Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECEA5AEB2A
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239280AbiIFNzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239892AbiIFNyQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:54:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF2980526;
        Tue,  6 Sep 2022 06:41:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95E5F61551;
        Tue,  6 Sep 2022 13:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934E3C433D6;
        Tue,  6 Sep 2022 13:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471342;
        bh=4wMBIiOVRFEUQgZUCLPvtOAlNnzfJHtYdPAydFACWFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7k7JYn5caGkg9xDIgW7rUhxiRNf5mjnYC4NvXcbEaKzsLMveUdSeR757OYyt+lY6
         TGy6jYBW5+j4p2wp9/EZr5gCc7uDDDLJQ2Y3wNUJeBOo6sS8/a3zSMvNJM5bmXNnnn
         g9Q0a4IKx7yRh3V8U4RPaSjG9a1++JF59E+G7Bl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Halaney <ahalaney@redhat.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 5.10 76/80] usb: dwc3: fix PHY disable sequence
Date:   Tue,  6 Sep 2022 15:31:13 +0200
Message-Id: <20220906132820.303080833@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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
[ johan: adjust context to 5.15 ]
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -728,15 +728,16 @@ static void dwc3_core_exit(struct dwc3 *
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
 	clk_bulk_disable_unprepare(dwc->num_clks, dwc->clks);
 	reset_control_assert(dwc->reset);
 }
@@ -1606,16 +1607,16 @@ err5:
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


