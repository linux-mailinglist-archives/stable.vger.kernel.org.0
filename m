Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53BA3D760A
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236696AbhG0NWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236885AbhG0NUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37E68601FD;
        Tue, 27 Jul 2021 13:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391993;
        bh=u1luN1sMFI7o5STBnQbpqlrcozJB2enfmjp0qualJQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FpEv5SWoQR0yY/0UOu82OFKaeLY/RiGzBp/8avXYzeVEZsmDUlSYBqO5tGAcSa7/h
         4y2aVKS83K45UHATAKsu6sTEWcAlLkMPF++UW3n1EnOuS1tvouFpDXHvsU3iXveDuB
         xOgv5kLRefu7MJImKfhLX4eEwYiV+aDC3eIOMZThb/OZonWA1+qobaQkEXKDQAV+gX
         IaemdnUbCHUgSbbD7tkxcYsTGD1Upf2c0abm8RAgrFJygfomQ/bck/HToeSS1oIoNb
         YoIs/uyEsuniL2bN0796KmRKKxFuqo4TVpVNELJWNt5ghXzdFrUO/8iFDGSrLc5ftW
         hID4EwQ7fALXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 12/17] ASoC: ti: j721e-evm: Check for not initialized parent_clk_id
Date:   Tue, 27 Jul 2021 09:19:33 -0400
Message-Id: <20210727131938.834920-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131938.834920-1-sashal@kernel.org>
References: <20210727131938.834920-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@gmail.com>

[ Upstream commit 82d28b67f780910f816fe1cfb0f676fc38c4cbb3 ]

During probe the parent_clk_id is set to -1 which should not be used to
array index within hsdiv_rates[].

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20210717122820.1467-3-peter.ujfalusi@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/j721e-evm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/ti/j721e-evm.c b/sound/soc/ti/j721e-evm.c
index 017c4ad11ca6..265bbc5a2f96 100644
--- a/sound/soc/ti/j721e-evm.c
+++ b/sound/soc/ti/j721e-evm.c
@@ -197,7 +197,7 @@ static int j721e_configure_refclk(struct j721e_priv *priv,
 		return ret;
 	}
 
-	if (priv->hsdiv_rates[domain->parent_clk_id] != scki) {
+	if (domain->parent_clk_id == -1 || priv->hsdiv_rates[domain->parent_clk_id] != scki) {
 		dev_dbg(priv->dev,
 			"%s configuration for %u Hz: %s, %dxFS (SCKI: %u Hz)\n",
 			audio_domain == J721E_AUDIO_DOMAIN_CPB ? "CPB" : "IVI",
-- 
2.30.2

