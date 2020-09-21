Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A905272F6F
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgIUQ47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbgIUQob (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:44:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D0B2239A1;
        Mon, 21 Sep 2020 16:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706655;
        bh=kLkns3v2XOq+yM/cQ4Vfa+LOvdDLjxba94WJzGW4rHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+/+iBS9+/2QPdnu7Uh81ClyhnFW9arh3CMuBEj+evoiU13de/g45+tDQ7xDEZU7g
         qy4fk9Pnjo3IqIC/LAgsNdd2qf2pgOnnCZJCPHiel33eck5B2qIj99Rf0W1myQhgGp
         9S0Kq2XicnxaIbAQSSkZVDDxpSmQMbHikeay8Qko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vkoul@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 041/118] ASoC: rt711: Fix return check for devm_regmap_init_sdw()
Date:   Mon, 21 Sep 2020 18:27:33 +0200
Message-Id: <20200921162038.217062952@linuxfoundation.org>
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

[ Upstream commit be1a4b2c56db860a220c6f74d461188e5733264a ]

devm_regmap_init_sdw() returns a valid pointer on success or ERR_PTR on
failure which should be checked with IS_ERR. Also use PTR_ERR for
returning error codes.

Reported-by: Takashi Iwai <tiwai@suse.de>
Fixes: 320b8b0d13b8 ("ASoC: rt711: add rt711 codec driver")
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200826163340.3249608-4-vkoul@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt711-sdw.c b/sound/soc/codecs/rt711-sdw.c
index 45b928954b580..7efff130a638c 100644
--- a/sound/soc/codecs/rt711-sdw.c
+++ b/sound/soc/codecs/rt711-sdw.c
@@ -452,8 +452,8 @@ static int rt711_sdw_probe(struct sdw_slave *slave,
 
 	/* Regmap Initialization */
 	sdw_regmap = devm_regmap_init_sdw(slave, &rt711_sdw_regmap);
-	if (!sdw_regmap)
-		return -EINVAL;
+	if (IS_ERR(sdw_regmap))
+		return PTR_ERR(sdw_regmap);
 
 	regmap = devm_regmap_init(&slave->dev, NULL,
 		&slave->dev, &rt711_regmap);
-- 
2.25.1



