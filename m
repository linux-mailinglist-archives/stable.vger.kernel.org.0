Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9061C272F63
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgIUQ4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729682AbgIUQoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01F6B239D0;
        Mon, 21 Sep 2020 16:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706653;
        bh=A+/EOSHJaXLjM6V0dnwVJ52JZI+Vj+l6h0uzHaaqO2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BsyPIk1/SFFvbu5QHPWn0mssuZuLGVfPQMbbFb21wSfDO1Q2V/SnSgjYe0Hhx+pqA
         djWnOEWaZrfp9yHZnoUkeATiwJcc45vtlTLCHFFrfuIuWg5J1ZE28ZDlAniGosdKGO
         8xY2lP29ZcMbIulR7/lCi4WmAlTJ9FUEG7+RWOXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vkoul@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 040/118] ASoC: rt1308-sdw: Fix return check for devm_regmap_init_sdw()
Date:   Mon, 21 Sep 2020 18:27:32 +0200
Message-Id: <20200921162038.166669705@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 344850d93c098e1b17e6f89d5e436893e9762ef3 ]

devm_regmap_init_sdw() returns a valid pointer on success or ERR_PTR on
failure which should be checked with IS_ERR. Also use PTR_ERR for
returning error codes.

Reported-by: Takashi Iwai <tiwai@suse.de>
Fixes: a87a6653a28c ("ASoC: rt1308-sdw: add rt1308 SdW amplifier driver")
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200826163340.3249608-3-vkoul@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1308-sdw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt1308-sdw.c b/sound/soc/codecs/rt1308-sdw.c
index b0ba0d2acbdd6..56e952a904a39 100644
--- a/sound/soc/codecs/rt1308-sdw.c
+++ b/sound/soc/codecs/rt1308-sdw.c
@@ -684,8 +684,8 @@ static int rt1308_sdw_probe(struct sdw_slave *slave,
 
 	/* Regmap Initialization */
 	regmap = devm_regmap_init_sdw(slave, &rt1308_sdw_regmap);
-	if (!regmap)
-		return -EINVAL;
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
 
 	rt1308_sdw_init(&slave->dev, regmap, slave);
 
-- 
2.25.1



