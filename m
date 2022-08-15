Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94A9594B78
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352211AbiHPASs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356568AbiHPARD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:17:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBE1A0337;
        Mon, 15 Aug 2022 13:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D910E60EE9;
        Mon, 15 Aug 2022 20:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1ED5C433D6;
        Mon, 15 Aug 2022 20:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595451;
        bh=Gi5fhKEQRLorlItAaeCoWCufFbIzNt8b6vIbaqCylvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPpqDS8D9OSBTsq16uWgPl49qbH34PQX0s58Xw3qhPYBQRzjqlNgEu8EDVvh1TmvX
         kvcvK+wPwW37/IbXNQJS1ly1Rrhkl4QCGdZlPiSGUMn9a4Zjj2pCbRRjUc3T/YLNOK
         KHVYhXLoXCwXIWTGU5634tDk1MmhvHY5ZSTJrjmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Ferry Toth <fntoth@gmail.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0769/1157] phy: ti: tusb1210: Dont check for write errors when powering on
Date:   Mon, 15 Aug 2022 20:02:05 +0200
Message-Id: <20220815180510.251133002@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit d4a0a189b72a7c98e4256292b18b67c69fbc9343 ]

On some platforms, like Intel Merrifield, the writing values during power on
may timeout:

   tusb1210 dwc3.0.auto.ulpi: error -110 writing val 0x41 to reg 0x80
   phy phy-dwc3.0.auto.ulpi.0: phy poweron failed --> -110
   dwc3 dwc3.0.auto: error -ETIMEDOUT: failed to initialize core
   dwc3: probe of dwc3.0.auto failed with error -110

which effectively fails the probe of the USB controller.
Drop the check as it was before the culprit commit (see Fixes tag).

Fixes: 09a3512681b3 ("phy: ti: tusb1210: Improve ulpi_read()/_write() error checking")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Ferry Toth <fntoth@gmail.com>
Link: https://lore.kernel.org/r/20220613160848.82746-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-tusb1210.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/ti/phy-tusb1210.c b/drivers/phy/ti/phy-tusb1210.c
index c3ab4b69ea68..669c13d6e402 100644
--- a/drivers/phy/ti/phy-tusb1210.c
+++ b/drivers/phy/ti/phy-tusb1210.c
@@ -105,8 +105,9 @@ static int tusb1210_power_on(struct phy *phy)
 	msleep(TUSB1210_RESET_TIME_MS);
 
 	/* Restore the optional eye diagram optimization value */
-	return tusb1210_ulpi_write(tusb, TUSB1210_VENDOR_SPECIFIC2,
-				   tusb->vendor_specific2);
+	tusb1210_ulpi_write(tusb, TUSB1210_VENDOR_SPECIFIC2, tusb->vendor_specific2);
+
+	return 0;
 }
 
 static int tusb1210_power_off(struct phy *phy)
-- 
2.35.1



