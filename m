Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D82BAB2E
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439176AbfIVTfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390088AbfIVSqh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:46:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1103720830;
        Sun, 22 Sep 2019 18:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177996;
        bh=thp0v92/daGty3u6r809Bx87o5vEqDZeOIipXflwc3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uObstzXv4P9fqdcE2Es/yY8OVDb3MP4fTbgHtihjpPX6jt/DHIYhnjevnh4R8/qgU
         x6Z4Qw91OLzIgMcOYkKAFVU8F82wOVlPY/99Q5JyIxcJ4vZwq6bZWImMuXnOkyeZ3d
         Jl4pNMVb5VFiIiHkKa8tQj8r6ikD0z4uiwdh1538=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiaxin Yu <jiaxin.yu@mediatek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 087/203] ASoC: mediatek: mt6358: add delay after dmic clock on
Date:   Sun, 22 Sep 2019 14:41:53 -0400
Message-Id: <20190922184350.30563-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaxin Yu <jiaxin.yu@mediatek.com>

[ Upstream commit ccb1fa21ef58a2ac15519bb878470762e967e8b3 ]

Most dmics produce a high level when they receive clock. The difference
between power-on and memory record time is about 10ms, but the dmic
needs 50ms to output normal data.

This commit add 100ms delay after SoC output clock so that we can cut
off the pop noise at the beginning.

Signed-off-by: Jiaxin Yu <jiaxin.yu@mediatek.com>
Link: https://lore.kernel.org/r/1564980997-11359-1-git-send-email-jiaxin.yu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/mt6358.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/mt6358.c b/sound/soc/codecs/mt6358.c
index 50b3fc5457ea7..cab208aa22a77 100644
--- a/sound/soc/codecs/mt6358.c
+++ b/sound/soc/codecs/mt6358.c
@@ -1730,6 +1730,10 @@ static int mt6358_dmic_enable(struct mt6358_priv *priv)
 
 	/* UL turn on */
 	regmap_write(priv->regmap, MT6358_AFE_UL_SRC_CON0_L, 0x0003);
+
+	/* Prevent pop noise form dmic hw */
+	msleep(100);
+
 	return 0;
 }
 
-- 
2.20.1

