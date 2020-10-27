Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76ED929B4BB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762388AbgJ0PAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1787762AbgJ0PAR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:00:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C69E120714;
        Tue, 27 Oct 2020 15:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810816;
        bh=ZqL7zFQymRYCa2Cfx3gmpX6HBILpIoV9aEoS+biScPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9R52xQK9GI85c5UN6cu+w5cMldORw8XqtLsfrSK1NaUXo9hV4QtI3bYQ1tImOE8H
         AsL2MRj7Y/wacQJ9myJHDve6I2AyN5U0C9U6YHiEXwU3J8el5yrIWLvpbi47NjKxuc
         0HjUidKRikFmiYhJouvk10uM6vU2HnU5cZDxaLfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 246/633] ASoC: tas2770: Fix calling reset in probe
Date:   Tue, 27 Oct 2020 14:49:49 +0100
Message-Id: <20201027135534.216176789@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

[ Upstream commit b0bcbe615756d5923eec4e95996e4041627e5741 ]

tas2770_reset is called during i2c probe. The reset calls the
snd_soc_component_write which depends on the tas2770->component being
available. The component pointer is not set until codec_probe so move
the reset to the codec_probe after the pointer is set.

Fixes: 1a476abc723e6 ("tas2770: add tas2770 smart PA kernel driver")
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Link: https://lore.kernel.org/r/20200918190548.12598-1-dmurphy@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2770.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index cf071121c8398..9f759c51ca435 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -574,6 +574,8 @@ static int tas2770_codec_probe(struct snd_soc_component *component)
 
 	tas2770->component = component;
 
+	tas2770_reset(tas2770);
+
 	return 0;
 }
 
@@ -770,8 +772,6 @@ static int tas2770_i2c_probe(struct i2c_client *client,
 	tas2770->channel_size = 0;
 	tas2770->slot_width = 0;
 
-	tas2770_reset(tas2770);
-
 	result = tas2770_register_codec(tas2770);
 	if (result)
 		dev_err(tas2770->dev, "Register codec failed.\n");
-- 
2.25.1



