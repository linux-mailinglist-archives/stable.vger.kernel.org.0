Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2423B490DBE
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241891AbiAQRFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:05:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50818 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241338AbiAQRDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:03:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A0A0B81161;
        Mon, 17 Jan 2022 17:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7E6C36AF2;
        Mon, 17 Jan 2022 17:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438979;
        bh=vqm+l+et8fHmf+ZDrFYxAyjLbW9sX4AdX0B4LSjo1aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgvvEl/SJ7qAVQQNbiah6dLtl3gBWqsbBgWd3eXW4tvY4dUcd6aQNKHuySqmb9qpz
         BCopNtxgTgsSScBlg/3hX2GLGb8XmbQdUJP/t1dWPyf5Sn9UEn7mArVOtomnu6y6Ak
         UoVssy9HB6rxfb6LqgarfPBF2es7+vUy/jP1SpjIL/X6TxxsOT6iAR+U8W8bgPVZJP
         zJzIK7zKIkA5KhV72b6zODyHZxizzbL7DuJVRqVplj9DoLBsht1+r6dacFo9Nw8r8Y
         rEC9CdvuyMJo8dR+uK65zuXE0f2EuJ27uXxwNs9XULhD50IaZjPul3YzZQW8UIeqJJ
         IKGHYZ+5ReCXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, matthias.bgg@gmail.com,
        jiaxin.yu@mediatek.com, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 37/44] ASoC: mediatek: mt8192-mt6359: fix device_node leak
Date:   Mon, 17 Jan 2022 12:01:20 -0500
Message-Id: <20220117170127.1471115-37-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117170127.1471115-1-sashal@kernel.org>
References: <20220117170127.1471115-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit 4e28491a7a198c668437f2be8a91a76aa52f20eb ]

The of_parse_phandle() document:
    >>> Use of_node_put() on it when done.

The driver didn't call of_node_put().  Fixes the leak.

Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20211214040028.2992627-1-tzungbi@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
index a606133951b70..24a5d0adec1ba 100644
--- a/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
+++ b/sound/soc/mediatek/mt8192/mt8192-mt6359-rt1015-rt5682.c
@@ -1172,7 +1172,11 @@ static int mt8192_mt6359_dev_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	return devm_snd_soc_register_card(&pdev->dev, card);
+	ret = devm_snd_soc_register_card(&pdev->dev, card);
+
+	of_node_put(platform_node);
+	of_node_put(hdmi_codec);
+	return ret;
 }
 
 #ifdef CONFIG_OF
-- 
2.34.1

