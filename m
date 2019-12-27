Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C82F12BA25
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 19:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbfL0SQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 13:16:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728284AbfL0SQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 13:16:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B06C121775;
        Fri, 27 Dec 2019 18:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470570;
        bh=cmQ5bPpFTHGhZsTA/P2QxTSzK+X+Y59Kbf/bpK7LRh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gn/8FU576je5hT+wDWPRGNNrGgY0SK8eo+qWbVEKaniI9hpL0SLf2paZO/egPzP3Y
         7izquxNul0upPxNM62NNQ2eDDQL7wFysv/C4BA3EUaphVzSvrVMbgwpe1nrFp4cHUM
         nZshKnCDBIp0aS6p/HTSI1seXhwsaPip4afwO/Fk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shengjiu Wang <shengjiu.wang@nxp.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.4 17/25] ASoC: wm8962: fix lambda value
Date:   Fri, 27 Dec 2019 13:15:41 -0500
Message-Id: <20191227181549.8040-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181549.8040-1-sashal@kernel.org>
References: <20191227181549.8040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 556672d75ff486e0b6786056da624131679e0576 ]

According to user manual, it is required that FLL_LAMBDA > 0
in all cases (Integer and Franctional modes).

Fixes: 9a76f1ff6e29 ("ASoC: Add initial WM8962 CODEC driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/1576065442-19763-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8962.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index a7e79784fc16..4a3ce9b85253 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -2792,7 +2792,7 @@ static int fll_factors(struct _fll_div *fll_div, unsigned int Fref,
 
 	if (target % Fref == 0) {
 		fll_div->theta = 0;
-		fll_div->lambda = 0;
+		fll_div->lambda = 1;
 	} else {
 		gcd_fll = gcd(target, fratio * Fref);
 
@@ -2862,7 +2862,7 @@ static int wm8962_set_fll(struct snd_soc_codec *codec, int fll_id, int source,
 		return -EINVAL;
 	}
 
-	if (fll_div.theta || fll_div.lambda)
+	if (fll_div.theta)
 		fll1 |= WM8962_FLL_FRAC;
 
 	/* Stop the FLL while we reconfigure */
-- 
2.20.1

