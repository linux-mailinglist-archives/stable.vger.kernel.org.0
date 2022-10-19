Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E68604500
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbiJSMTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbiJSMTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:19:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FEF1D679;
        Wed, 19 Oct 2022 04:54:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 982D6B82468;
        Wed, 19 Oct 2022 09:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D41C433D6;
        Wed, 19 Oct 2022 09:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170180;
        bh=vsC+cg4HPLsC+F2/XwsJv30mCC9+RhZxAHJVrJ++TDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7MRcJF+juIjn5mdz4wynuoyeFa90P8fuAvzDnx1ybFlWwmNEDL2h8O8k+93xPGXP
         V1Hl+eZU40ludm//Ep3SRmM9hlaAziFTneaZpf9KwT3dkQS1T/JYgyQQhRKHuj3U29
         blIsxGtedqam7KoomDBlgoFBvvb83VM5NnOvRRwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 556/862] usb: dwc3: core: fix some leaks in probe
Date:   Wed, 19 Oct 2022 10:30:43 +0200
Message-Id: <20221019083314.546151210@linuxfoundation.org>
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
index 219d797e2230..919d36fd0298 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1712,8 +1712,10 @@ static int dwc3_probe(struct platform_device *pdev)
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
@@ -1723,45 +1725,57 @@ static int dwc3_probe(struct platform_device *pdev)
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
@@ -1861,7 +1875,7 @@ static int dwc3_probe(struct platform_device *pdev)
 	dwc3_clk_disable(dwc);
 assert_reset:
 	reset_control_assert(dwc->reset);
-
+put_usb_psy:
 	if (dwc->usb_psy)
 		power_supply_put(dwc->usb_psy);
 
-- 
2.35.1



