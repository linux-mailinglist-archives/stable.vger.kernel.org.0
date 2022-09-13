Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC085B748F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbiIMPWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235783AbiIMPVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:21:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6687B286;
        Tue, 13 Sep 2022 07:36:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96067B80FF0;
        Tue, 13 Sep 2022 14:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01310C433D6;
        Tue, 13 Sep 2022 14:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079698;
        bh=M85DBPo+sC6ssrj+uPVSPX8PREwvyuTPkPj0UmY4iNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZWOiE4qsNEo6uuatiFBaMnwQCNDj1wpNTdJD97ujP/tm1Bln/Rpgoys/dSArkIAWx
         mohIaUyPbTWBCUsoxtnoKLKXmnP3MAwYUXkZDh9v1kp6DXJWtOUjhFTxrQ49Vkm8ES
         Olx9bEHUdDqJqXH5W/g5cX8MlBeDGurzyBvIeIhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minas Harutyunyan <hminas@synopsys.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 4.14 23/61] usb: dwc2: fix wrong order of phy_power_on and phy_init
Date:   Tue, 13 Sep 2022 16:07:25 +0200
Message-Id: <20220913140347.666168775@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

commit f9b995b49a07bd0d43b0e490f59be84415c745ae upstream.

Since 1599069a62c6 ("phy: core: Warn when phy_power_on is called before
phy_init") the driver complains. In my case (Amlogic SoC) the warning
is: phy phy-fe03e000.phy.2: phy_power_on was called before phy_init
So change the order of the two calls. The same change has to be done
to the order of phy_exit() and phy_power_off().

Fixes: 09a75e857790 ("usb: dwc2: refactor common low-level hw code to platform.c")
Cc: stable@vger.kernel.org
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/dfcc6b40-2274-4e86-e73c-5c5e6aa3e046@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/platform.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -141,9 +141,9 @@ static int __dwc2_lowlevel_hw_enable(str
 	} else if (hsotg->plat && hsotg->plat->phy_init) {
 		ret = hsotg->plat->phy_init(pdev, hsotg->plat->phy_type);
 	} else {
-		ret = phy_power_on(hsotg->phy);
+		ret = phy_init(hsotg->phy);
 		if (ret == 0)
-			ret = phy_init(hsotg->phy);
+			ret = phy_power_on(hsotg->phy);
 	}
 
 	return ret;
@@ -175,9 +175,9 @@ static int __dwc2_lowlevel_hw_disable(st
 	} else if (hsotg->plat && hsotg->plat->phy_exit) {
 		ret = hsotg->plat->phy_exit(pdev, hsotg->plat->phy_type);
 	} else {
-		ret = phy_exit(hsotg->phy);
+		ret = phy_power_off(hsotg->phy);
 		if (ret == 0)
-			ret = phy_power_off(hsotg->phy);
+			ret = phy_exit(hsotg->phy);
 	}
 	if (ret)
 		return ret;


