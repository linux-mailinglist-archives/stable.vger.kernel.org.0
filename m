Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA77F60886B
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbiJVIQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbiJVIP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:15:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C210F2DB796;
        Sat, 22 Oct 2022 00:56:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B893460AE6;
        Sat, 22 Oct 2022 07:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69B5C433D6;
        Sat, 22 Oct 2022 07:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425271;
        bh=UIhXXYdwIpBrrDXc+TJvtBLDWPr6Ak8cvZrM8faBrUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Srx8d79VdB31oyNr+goEWWA7w7yS4X9M22bDvetjmL8nFTeEcULAEF3qw1dhZ6Oz9
         8puIMnLAfZwuheTg9up+BwEd7sL97rc2MudOK9Dxt/LxRF6Zg/PKVRXLyBCy30W261
         smSoI9kvm5QvGLYO64AaxyLoS+LL2DHc202ZpmQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 446/717] usb: dwc3: core: fix some leaks in probe
Date:   Sat, 22 Oct 2022 09:25:25 +0200
Message-Id: <20221022072518.008482544@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 2a735e4b5580a2a6bbd6572109b4c4f163c57462 ]

The dwc3_get_properties() function calls:

	dwc->usb_psy = power_supply_get_by_name(usb_psy_name);

so there is some additional clean up required on these error paths.

Fixes: 6f0764b5adea ("usb: dwc3: add a power supply for current control")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YyxFYFnP53j9sCg+@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 58 +++++++++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index ebf3afad378b..2419ef828f9b 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1678,8 +1678,10 @@ static int dwc3_probe(struct platform_device *pdev)
 	dwc3_get_properties(dwc);
 
 	dwc->reset = devm_reset_control_array_get_optional_shared(dev);
-	if (IS_ERR(dwc->reset))
-		return PTR_ERR(dwc->reset);
+	if (IS_ERR(dwc->reset)) {
+		ret = PTR_ERR(dwc->reset);
+		goto put_usb_psy;
+	}
 
 	if (dev->of_node) {
 		/*
@@ -1689,45 +1691,57 @@ static int dwc3_probe(struct platform_device *pdev)
 		 * check for them to retain backwards compatibility.
 		 */
 		dwc->bus_clk = devm_clk_get_optional(dev, "bus_early");
-		if (IS_ERR(dwc->bus_clk))
-			return dev_err_probe(dev, PTR_ERR(dwc->bus_clk),
-					     "could not get bus clock\n");
+		if (IS_ERR(dwc->bus_clk)) {
+			ret = dev_err_probe(dev, PTR_ERR(dwc->bus_clk),
+					    "could not get bus clock\n");
+			goto put_usb_psy;
+		}
 
 		if (dwc->bus_clk == NULL) {
 			dwc->bus_clk = devm_clk_get_optional(dev, "bus_clk");
-			if (IS_ERR(dwc->bus_clk))
-				return dev_err_probe(dev, PTR_ERR(dwc->bus_clk),
-						     "could not get bus clock\n");
+			if (IS_ERR(dwc->bus_clk)) {
+				ret = dev_err_probe(dev, PTR_ERR(dwc->bus_clk),
+						    "could not get bus clock\n");
+				goto put_usb_psy;
+			}
 		}
 
 		dwc->ref_clk = devm_clk_get_optional(dev, "ref");
-		if (IS_ERR(dwc->ref_clk))
-			return dev_err_probe(dev, PTR_ERR(dwc->ref_clk),
-					     "could not get ref clock\n");
+		if (IS_ERR(dwc->ref_clk)) {
+			ret = dev_err_probe(dev, PTR_ERR(dwc->ref_clk),
+					    "could not get ref clock\n");
+			goto put_usb_psy;
+		}
 
 		if (dwc->ref_clk == NULL) {
 			dwc->ref_clk = devm_clk_get_optional(dev, "ref_clk");
-			if (IS_ERR(dwc->ref_clk))
-				return dev_err_probe(dev, PTR_ERR(dwc->ref_clk),
-						     "could not get ref clock\n");
+			if (IS_ERR(dwc->ref_clk)) {
+				ret = dev_err_probe(dev, PTR_ERR(dwc->ref_clk),
+						    "could not get ref clock\n");
+				goto put_usb_psy;
+			}
 		}
 
 		dwc->susp_clk = devm_clk_get_optional(dev, "suspend");
-		if (IS_ERR(dwc->susp_clk))
-			return dev_err_probe(dev, PTR_ERR(dwc->susp_clk),
-					     "could not get suspend clock\n");
+		if (IS_ERR(dwc->susp_clk)) {
+			ret = dev_err_probe(dev, PTR_ERR(dwc->susp_clk),
+					    "could not get suspend clock\n");
+			goto put_usb_psy;
+		}
 
 		if (dwc->susp_clk == NULL) {
 			dwc->susp_clk = devm_clk_get_optional(dev, "suspend_clk");
-			if (IS_ERR(dwc->susp_clk))
-				return dev_err_probe(dev, PTR_ERR(dwc->susp_clk),
-						     "could not get suspend clock\n");
+			if (IS_ERR(dwc->susp_clk)) {
+				ret = dev_err_probe(dev, PTR_ERR(dwc->susp_clk),
+						    "could not get suspend clock\n");
+				goto put_usb_psy;
+			}
 		}
 	}
 
 	ret = reset_control_deassert(dwc->reset);
 	if (ret)
-		return ret;
+		goto put_usb_psy;
 
 	ret = dwc3_clk_enable(dwc);
 	if (ret)
@@ -1827,7 +1841,7 @@ static int dwc3_probe(struct platform_device *pdev)
 	dwc3_clk_disable(dwc);
 assert_reset:
 	reset_control_assert(dwc->reset);
-
+put_usb_psy:
 	if (dwc->usb_psy)
 		power_supply_put(dwc->usb_psy);
 
-- 
2.35.1



