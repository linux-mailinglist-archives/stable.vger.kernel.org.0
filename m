Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24559594390
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343718AbiHOWMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244075AbiHOWKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:10:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005EB118DDC;
        Mon, 15 Aug 2022 12:38:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A185260BC2;
        Mon, 15 Aug 2022 19:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CFCC433C1;
        Mon, 15 Aug 2022 19:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592285;
        bh=BWdZqPLDXsnad35DrHwcE33hAm8J1xbYtk0RGyawOr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BThENeyXsNigqO2x4HQ7fWfRyukkcDN3hrM9lCZlASxQ62IV1Ylqohws9WV87M9Q2
         PxGZX3kN2TBG0DHPs8hEPl3YHdNZNPE1xavE2gxd8gbhEI3nfiNIZcrYipMDU+7eAv
         KVfJhfM11rloJnlSGcqg1gdAR+kRe9wrEu12RnFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0760/1095] phy: stm32: fix error return in stm32_usbphyc_phy_init
Date:   Mon, 15 Aug 2022 20:02:39 +0200
Message-Id: <20220815180500.716285659@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

[ Upstream commit 32b378a9179ae4db61cfc5d502717214e6cd1e1c ]

Error code is overridden, in case the PLL doesn't lock. So, the USB
initialization can continue. This leads to a platform freeze.
This can be avoided by returning proper error code to avoid USB probe
freezing the platform. It also displays proper errors in log.

Fixes: 5b1af71280ab ("phy: stm32: rework PLL Lock detection")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20220713133953.595134-1-fabrice.gasnier@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/st/phy-stm32-usbphyc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/st/phy-stm32-usbphyc.c b/drivers/phy/st/phy-stm32-usbphyc.c
index 007a23c78d56..a98c911cc37a 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -358,7 +358,9 @@ static int stm32_usbphyc_phy_init(struct phy *phy)
 	return 0;
 
 pll_disable:
-	return stm32_usbphyc_pll_disable(usbphyc);
+	stm32_usbphyc_pll_disable(usbphyc);
+
+	return ret;
 }
 
 static int stm32_usbphyc_phy_exit(struct phy *phy)
-- 
2.35.1



