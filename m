Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2C75BAA90
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiIPKTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiIPKSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:18:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDAFAFACC;
        Fri, 16 Sep 2022 03:12:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5048EB82521;
        Fri, 16 Sep 2022 10:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B47C433B5;
        Fri, 16 Sep 2022 10:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323123;
        bh=d3RriZ1gtEVgmpI5vEczQFM4evlZwypu38PWRi8Uqfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6gPW7uKFZTXl+sGYKk6iXqgXRoZPo2bZFro5jzd06lEUfhS9Czlp9p9MKcciRyqv
         aR/QjZrZubYkkpFc5wnu6FQOy6SeIb6ybqM5ui2zdN9l+W1R4zBm1aXP81xqQEK1Ht
         6x9R7/PCV5quvbPnYFVV8jB5xykEid+iyLckfOus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/35] ARM: dts: at91: fix low limit for CPU regulator
Date:   Fri, 16 Sep 2022 12:08:28 +0200
Message-Id: <20220916100447.162758761@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100446.916515275@linuxfoundation.org>
References: <20220916100446.916515275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 279d626d737486363233b9b99c30b5696c389b41 ]

Fix low limit for CPU regulator. Otherwise setting voltages lower than
1.125V will not be allowed (CPUFreq will not be allowed to set proper
voltages on proper frequencies).

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20220113144900.906370-7-claudiu.beznea@microchip.com
Stable-dep-of: 7f41d52ced9e ("ARM: dts: at91: sama7g5ek: specify proper regulator output ranges")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama7g5ek.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91-sama7g5ek.dts b/arch/arm/boot/dts/at91-sama7g5ek.dts
index bac0e49cc5770..be51c1dbb4595 100644
--- a/arch/arm/boot/dts/at91-sama7g5ek.dts
+++ b/arch/arm/boot/dts/at91-sama7g5ek.dts
@@ -228,7 +228,7 @@
 
 				vddcpu: VDD_OTHER {
 					regulator-name = "VDD_OTHER";
-					regulator-min-microvolt = <1125000>;
+					regulator-min-microvolt = <1050000>;
 					regulator-max-microvolt = <1850000>;
 					regulator-initial-mode = <2>;
 					regulator-allowed-modes = <2>, <4>;
-- 
2.35.1



