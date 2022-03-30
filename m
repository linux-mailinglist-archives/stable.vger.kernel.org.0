Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F43C4EC29D
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243601AbiC3MA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345800AbiC3LzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2357B263663;
        Wed, 30 Mar 2022 04:51:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7DEEB81C48;
        Wed, 30 Mar 2022 11:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5865AC340F2;
        Wed, 30 Mar 2022 11:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641104;
        bh=3eNm8dG5hwrOYRfNxaPoVEjbdCJXfSIDk1mmCHp/p8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ej6icyrs21MQXiXTpXL1XYQm3RdP/m1Z3wx0diSD+U1IafrG9hR8JaiZMmexQVikI
         EasnOG7lw6UP2jn1gvxPh+EVg1jqiszuL+0r9J4ib5CDlETj4wwFRrUJDgN19L4EKS
         3fTnu9lbFuhHw7p7/OQlFcMg+FKREuliC5PK4w7n1felvS4ODrZIsV1+Xacc8pY8iI
         yHzSVFyy/FBc0I0P+y2Er9jJEnjXxD51zMTKSIQmlxNmpjKSPSSF2oOkEY6YeIg8tr
         RQOv8gd9wVOHwGLmMlcKmx/ugK4T3MqBRhGmmN66nfjNsXvVVhiYRikWYSoDFC9jG3
         gdsgFAko4YgjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 12/37] ASoC: madera: Add dependencies on MFD
Date:   Wed, 30 Mar 2022 07:50:57 -0400
Message-Id: <20220330115122.1671763-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115122.1671763-1-sashal@kernel.org>
References: <20220330115122.1671763-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit ec29170c724ca30305fc3a19ba2ee73ecac65509 ]

The Madera CODECs use regmap_irq functions but nothing ensures that
regmap_irq is built into the kernel. Add dependencies on the ASoC
symbols for the relevant MFD component. There is no point in building
the ASoC driver if the MFD doesn't support it and the MFD part contains
the necessary dependencies to ensure everything is built into the
kernel.

Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220203115025.16464-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 34c6dd04b85a..52c89a6f54e9 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -659,6 +659,7 @@ config SND_SOC_CS4349
 
 config SND_SOC_CS47L15
 	tristate
+	depends on MFD_CS47L15
 
 config SND_SOC_CS47L24
 	tristate
@@ -666,15 +667,19 @@ config SND_SOC_CS47L24
 
 config SND_SOC_CS47L35
 	tristate
+	depends on MFD_CS47L35
 
 config SND_SOC_CS47L85
 	tristate
+	depends on MFD_CS47L85
 
 config SND_SOC_CS47L90
 	tristate
+	depends on MFD_CS47L90
 
 config SND_SOC_CS47L92
 	tristate
+	depends on MFD_CS47L92
 
 # Cirrus Logic Quad-Channel ADC
 config SND_SOC_CS53L30
-- 
2.34.1

