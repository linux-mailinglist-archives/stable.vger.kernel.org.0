Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E576656FC04
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbiGKJhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiGKJhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:37:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041AD4E63E;
        Mon, 11 Jul 2022 02:19:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0324B80E76;
        Mon, 11 Jul 2022 09:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26579C34115;
        Mon, 11 Jul 2022 09:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531166;
        bh=KCG/poZQs1m2qcMF8m1bdRnnCDWxrbakgTIoSY55yeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0gJP3LgHyX4OlS2bAUYbOyrXe+1vBAi91brCTAvq9+ucOQs+QoMepCZczhxl5NU//
         /ef7I8DufqTxrQmDSYVYmT1NdyLDtzA2twODVDpJWG18viQshKTkURbJKTBafrp1z2
         9s/+FL0140nBX71WGmdh2oaM1qhf/NFugHo8JaVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mihai Sain <mihai.sain@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 075/112] ARM: at91: fix soc detection for SAM9X60 SiPs
Date:   Mon, 11 Jul 2022 11:07:15 +0200
Message-Id: <20220711090551.700795977@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mihai Sain <mihai.sain@microchip.com>

[ Upstream commit 35074df65a8d8c5328a83e2eea948f7bbc8e6e08 ]

Fix SoC detection for SAM9X60 SiPs:
SAM9X60D5M
SAM9X60D1G
SAM9X60D6K

Fixes: af3a10513cd6 ("drivers: soc: atmel: add per soc id and version match masks")
Signed-off-by: Mihai Sain <mihai.sain@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220616081344.1978664-1-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/atmel/soc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/soc/atmel/soc.c b/drivers/soc/atmel/soc.c
index b2d365ae0282..dae8a2e0f745 100644
--- a/drivers/soc/atmel/soc.c
+++ b/drivers/soc/atmel/soc.c
@@ -91,14 +91,14 @@ static const struct at91_soc socs[] __initconst = {
 	AT91_SOC(SAM9X60_CIDR_MATCH, AT91_CIDR_MATCH_MASK,
 		 AT91_CIDR_VERSION_MASK, SAM9X60_EXID_MATCH,
 		 "sam9x60", "sam9x60"),
-	AT91_SOC(SAM9X60_CIDR_MATCH, SAM9X60_D5M_EXID_MATCH,
-		 AT91_CIDR_VERSION_MASK, SAM9X60_EXID_MATCH,
+	AT91_SOC(SAM9X60_CIDR_MATCH, AT91_CIDR_MATCH_MASK,
+		 AT91_CIDR_VERSION_MASK, SAM9X60_D5M_EXID_MATCH,
 		 "sam9x60 64MiB DDR2 SiP", "sam9x60"),
-	AT91_SOC(SAM9X60_CIDR_MATCH, SAM9X60_D1G_EXID_MATCH,
-		 AT91_CIDR_VERSION_MASK, SAM9X60_EXID_MATCH,
+	AT91_SOC(SAM9X60_CIDR_MATCH, AT91_CIDR_MATCH_MASK,
+		 AT91_CIDR_VERSION_MASK, SAM9X60_D1G_EXID_MATCH,
 		 "sam9x60 128MiB DDR2 SiP", "sam9x60"),
-	AT91_SOC(SAM9X60_CIDR_MATCH, SAM9X60_D6K_EXID_MATCH,
-		 AT91_CIDR_VERSION_MASK, SAM9X60_EXID_MATCH,
+	AT91_SOC(SAM9X60_CIDR_MATCH, AT91_CIDR_MATCH_MASK,
+		 AT91_CIDR_VERSION_MASK, SAM9X60_D6K_EXID_MATCH,
 		 "sam9x60 8MiB SDRAM SiP", "sam9x60"),
 #endif
 #ifdef CONFIG_SOC_SAMA5
-- 
2.35.1



