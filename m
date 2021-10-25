Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284C843A044
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbhJYT3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235352AbhJYT2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:28:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDA1D6113B;
        Mon, 25 Oct 2021 19:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189884;
        bh=KCAGzqHHbF0daqZGWKDTxoMRoQg6+sBe85+/4TbKvHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LlEOPl3TmYtp78eGlE7mZDDQDGzw5hyrkfLTMZ7BrscvtsYSEWH536STFaCsOCsie
         89Kn4QiFuy3KZB5LHaM3RAPSRaUPAJKHgJ4sTr2uAkufH8pMhmGtPcEZZscnyvHebc
         I/sYs2qH4eUySnakLtNlwcpVGCAh79bi9DniI7Fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 06/37] ASoC: wm8960: Fix clock configuration on slave mode
Date:   Mon, 25 Oct 2021 21:14:31 +0200
Message-Id: <20211025190929.547841507@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 6b9b546dc00797c74bef491668ce5431ff54e1e2 ]

There is a noise issue for 8kHz sample rate on slave mode.
Compared with master mode, the difference is the DACDIV
setting, after correcting the DACDIV, the noise is gone.

There is no noise issue for 48kHz sample rate, because
the default value of DACDIV is correct for 48kHz.

So wm8960_configure_clocking() should be functional for
ADC and DAC function even if it is slave mode.

In order to be compatible for old use case, just add
condition for checking that sysclk is zero with
slave mode.

Fixes: 0e50b51aa22f ("ASoC: wm8960: Let wm8960 driver configure its bit clock and frame clock")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/1634102224-3922-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8960.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 88e869d16714..abd5c12764f0 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -755,9 +755,16 @@ static int wm8960_configure_clocking(struct snd_soc_component *component)
 	int i, j, k;
 	int ret;
 
-	if (!(iface1 & (1<<6))) {
-		dev_dbg(component->dev,
-			"Codec is slave mode, no need to configure clock\n");
+	/*
+	 * For Slave mode clocking should still be configured,
+	 * so this if statement should be removed, but some platform
+	 * may not work if the sysclk is not configured, to avoid such
+	 * compatible issue, just add '!wm8960->sysclk' condition in
+	 * this if statement.
+	 */
+	if (!(iface1 & (1 << 6)) && !wm8960->sysclk) {
+		dev_warn(component->dev,
+			 "slave mode, but proceeding with no clock configuration\n");
 		return 0;
 	}
 
-- 
2.33.0



