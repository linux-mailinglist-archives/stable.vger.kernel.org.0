Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4462E3C4F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388142AbgL1OBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:01:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407993AbgL1OAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:00:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF710206D4;
        Mon, 28 Dec 2020 14:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164015;
        bh=AJpwapILn+fBr2s2XAzdACyoOVzWiBbyzW+HqMm0wxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7lX2Tg7s2I0seFDx4NE1kdwsrLoB6jdb0Jp2kph0BnjZI6wc2G5zR5sUGPsZ+MDv
         ZrE3AIBSLtPmNOttKaGv56YxMdUY+9Lm+Dmb0DUReJWaWM1T8sutNPXusDDM6fMtlr
         f8qinzphXLuMXhgjTp8DInGDRpLdj0QQEj5vQz6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/717] ASoC: qcom: fix unsigned int bitwidth compared to less than zero
Date:   Mon, 28 Dec 2020 13:40:28 +0100
Message-Id: <20201228125022.431229801@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit bcc96dc3cf8048c80af7c487af17e19be27ac57d ]

The check for an error return from the call to snd_pcm_format_width
is never true as the unsigned int bitwidth can never be less than
zero. Fix this by making bitwidth an int.

Fixes: 7cb37b7bd0d3 ("ASoC: qcom: Add support for lpass hdmi driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20201028115112.109017-1-colin.king@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/qcom/lpass-hdmi.c b/sound/soc/qcom/lpass-hdmi.c
index 172952d3a5d66..abfb8737a89f4 100644
--- a/sound/soc/qcom/lpass-hdmi.c
+++ b/sound/soc/qcom/lpass-hdmi.c
@@ -24,7 +24,7 @@ static int lpass_hdmi_daiops_hw_params(struct snd_pcm_substream *substream,
 	unsigned int rate = params_rate(params);
 	unsigned int channels = params_channels(params);
 	unsigned int ret;
-	unsigned int bitwidth;
+	int bitwidth;
 	unsigned int word_length;
 	unsigned int ch_sts_buf0;
 	unsigned int ch_sts_buf1;
-- 
2.27.0



