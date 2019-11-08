Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD753F555C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390363AbfKHTB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:01:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:59438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390369AbfKHTBz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:01:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 553132067B;
        Fri,  8 Nov 2019 19:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239714;
        bh=+7sjtycYthxBbTdXZOuBgjunJxe9qUow+unZqqYmg7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ljVWKfbCJ6rafJtp0JHii93f26gArYT/21wKgVASNXK3cz9cUCe+Z4871KdtqED2A
         VFcajzGHux6i4nXBJSG4JtJRvhnnJMQWB7CSOZFML4uJHOJ0tENmEZPVXFiNtDUDjl
         cDCo5McXu3lzIySD1xPk+ygA5BBjJg7Lnh0xqFzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaska Uimonen <jaska.uimonen@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/79] ASoC: rt5682: add NULL handler to set_jack function
Date:   Fri,  8 Nov 2019 19:49:48 +0100
Message-Id: <20191108174749.317380781@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaska Uimonen <jaska.uimonen@intel.com>

[ Upstream commit a315e76fc544f09daf619530a7b2f85865e6b25e ]

Implement NULL handler in set_jack function to disable
irq's.

Signed-off-by: Jaska Uimonen <jaska.uimonen@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190927201408.925-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 6f5dac09ceded..21e7c430baf7f 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -982,6 +982,16 @@ static int rt5682_set_jack_detect(struct snd_soc_component *component,
 {
 	struct rt5682_priv *rt5682 = snd_soc_component_get_drvdata(component);
 
+	rt5682->hs_jack = hs_jack;
+
+	if (!hs_jack) {
+		regmap_update_bits(rt5682->regmap, RT5682_IRQ_CTRL_2,
+				   RT5682_JD1_EN_MASK, RT5682_JD1_DIS);
+		regmap_update_bits(rt5682->regmap, RT5682_RC_CLK_CTRL,
+				   RT5682_POW_JDH | RT5682_POW_JDL, 0);
+		return 0;
+	}
+
 	switch (rt5682->pdata.jd_src) {
 	case RT5682_JD1:
 		snd_soc_component_update_bits(component, RT5682_CBJ_CTRL_2,
@@ -1019,8 +1029,6 @@ static int rt5682_set_jack_detect(struct snd_soc_component *component,
 		break;
 	}
 
-	rt5682->hs_jack = hs_jack;
-
 	return 0;
 }
 
-- 
2.20.1



