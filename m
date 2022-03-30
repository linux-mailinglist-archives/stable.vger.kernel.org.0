Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324044EC23F
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbiC3L66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345251AbiC3LyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:54:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEE7281827;
        Wed, 30 Mar 2022 04:50:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18E25CE1D3F;
        Wed, 30 Mar 2022 11:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C25BC36AE5;
        Wed, 30 Mar 2022 11:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641036;
        bh=I6aGqWjrqvnZkEehH1G0+jL/Sh2jVVvHMXxT5JjDfXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKvjqnYHg5/V95XG7llIBj9tdf7G/en/yIUUC9ddTUeSpp7EFK1YkHRiGnc4DadG/
         7SyBS0XCB5gXOsL0NHg7jA3xvdSjl1Z8ebvNfbVA1YBt7rWuy/T0SwZ2HRksO6bsF8
         9gItuWot3d9lLjU2SaCgSqVx03lMDvX60wA20gw0Sm0/CJ0KXf8XHxw5kj2VLA2KaX
         DrjtJp0CryBbUXAuPMfICYhQp0ww/wtK1ysn39nstHXCLJL9OB9M3JOqAgiFcDQ7aB
         e5P+GG3Qt1Bn7gYSVnBWaMrpgCGW+dStfb7gA8PB8z8xWojKkZtslvu4qaX9No6WsQ
         sAQwuY70Wzvrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 19/50] ASoC: madera: Add dependencies on MFD
Date:   Wed, 30 Mar 2022 07:49:33 -0400
Message-Id: <20220330115005.1671090-19-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115005.1671090-1-sashal@kernel.org>
References: <20220330115005.1671090-1-sashal@kernel.org>
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
index f12c9b942678..47e675e8bd00 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -690,6 +690,7 @@ config SND_SOC_CS4349
 
 config SND_SOC_CS47L15
 	tristate
+	depends on MFD_CS47L15
 
 config SND_SOC_CS47L24
 	tristate
@@ -697,15 +698,19 @@ config SND_SOC_CS47L24
 
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

