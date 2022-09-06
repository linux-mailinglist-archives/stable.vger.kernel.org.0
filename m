Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2341F5AEA79
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbiIFNor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238506AbiIFNnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:43:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9929F7EFCB;
        Tue,  6 Sep 2022 06:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C54261548;
        Tue,  6 Sep 2022 13:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4B0C433D6;
        Tue,  6 Sep 2022 13:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471363;
        bh=3UcOXbWyeA5C56jtAvIiTnIveZqbtE8vO+hT19Hbj7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hz9vafWgl03zghHclU12JY4HR1eBhGN50bwHNsmvB/4gtCyxOhg+VOiNaN/9DHyZy
         sgi+C7igfa+QOphAIYcZzD6pEPtiYKi+Hh8+0Psdgor6jHd3MayHhkOR2EEoGje3eV
         IeQyHdvWu35fJtE95Nf6jTDADcBsdpuQccMx8JNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minas Harutyunyan <hminas@synopsys.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 5.10 57/80] usb: dwc2: fix wrong order of phy_power_on and phy_init
Date:   Tue,  6 Sep 2022 15:30:54 +0200
Message-Id: <20220906132819.443987276@linuxfoundation.org>
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
@@ -154,9 +154,9 @@ static int __dwc2_lowlevel_hw_enable(str
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
@@ -188,9 +188,9 @@ static int __dwc2_lowlevel_hw_disable(st
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


