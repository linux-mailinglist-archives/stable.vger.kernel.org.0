Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27598272F71
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgIUQ5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729249AbgIUQob (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C9C1239ED;
        Mon, 21 Sep 2020 16:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706662;
        bh=5X/DYBT5/gSjOuqlaOrhJ+FYCXkn6QRmAdRhqOafT9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=habN3al+QnmIHkznoHjMvdQRotIFaxbJgoBN9PZOYj0fCflmUFNX/TCce3pGorCdC
         oqaYa5BGU4Dtkh2ccvP+xkVoqGjP90zi6VpWtZPf0P2JM7T7ZVb8zhgqctqPS87IGb
         Xdz80+8ANmvRBTvDTTkRv47pRtzLtFoZ/1+iCz0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vkoul@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 043/118] ASoC: rt700: Fix return check for devm_regmap_init_sdw()
Date:   Mon, 21 Sep 2020 18:27:35 +0200
Message-Id: <20200921162038.317894283@linuxfoundation.org>
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

[ Upstream commit db1a4250aef53775ec0094b81454213319cc8c74 ]

devm_regmap_init_sdw() returns a valid pointer on success or ERR_PTR on
failure which should be checked with IS_ERR. Also use PTR_ERR for
returning error codes.

Reported-by: Takashi Iwai <tiwai@suse.de>
Fixes: 7d2a5f9ae41e ("ASoC: rt700: add rt700 codec driver")
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200826163340.3249608-6-vkoul@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt700-sdw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt700-sdw.c b/sound/soc/codecs/rt700-sdw.c
index 4d14048d11976..1d24bf0407182 100644
--- a/sound/soc/codecs/rt700-sdw.c
+++ b/sound/soc/codecs/rt700-sdw.c
@@ -452,8 +452,8 @@ static int rt700_sdw_probe(struct sdw_slave *slave,
 
 	/* Regmap Initialization */
 	sdw_regmap = devm_regmap_init_sdw(slave, &rt700_sdw_regmap);
-	if (!sdw_regmap)
-		return -EINVAL;
+	if (IS_ERR(sdw_regmap))
+		return PTR_ERR(sdw_regmap);
 
 	regmap = devm_regmap_init(&slave->dev, NULL,
 		&slave->dev, &rt700_regmap);
-- 
2.25.1



