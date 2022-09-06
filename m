Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C545AE691
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiIFL0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiIFL0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:26:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AD842AE2
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8F2B4CE16FD
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C01C433D6;
        Tue,  6 Sep 2022 11:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662463605;
        bh=nMun95hlLXM1yX9B+WdM2bB2jUZ0baHYml81nu5htvE=;
        h=Subject:To:Cc:From:Date:From;
        b=Q2AoYr/yyPTIXuD836YLubUHjc4Y2RiwivHtakcV13aNmDHZlv5vCbMyDwU2OdjiV
         xhpZzX2kK2dih9dsQ10jePuCvwk8US5E2ygEzXaaDlF+TWJtdq5oILDzo+qNk7M6Te
         k0JTEjrOass0kccAEAP/X3bUmETaUwPkumPK7QXk=
Subject: FAILED: patch "[PATCH] usb: dwc2: fix wrong order of phy_power_on and phy_init" failed to apply to 4.9-stable tree
To:     hkallweit1@gmail.com, gregkh@linuxfoundation.org,
        hminas@synopsys.com, m.szyprowski@samsung.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:26:43 +0200
Message-ID: <166246360357133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f9b995b49a07bd0d43b0e490f59be84415c745ae Mon Sep 17 00:00:00 2001
From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 23 Aug 2022 19:58:42 +0200
Subject: [PATCH] usb: dwc2: fix wrong order of phy_power_on and phy_init

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

diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index c8ba87df7abe..fd0ccf6f3ec5 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -154,9 +154,9 @@ static int __dwc2_lowlevel_hw_enable(struct dwc2_hsotg *hsotg)
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
@@ -188,9 +188,9 @@ static int __dwc2_lowlevel_hw_disable(struct dwc2_hsotg *hsotg)
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

