Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90DEA540BC9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350938AbiFGSby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351516AbiFGS3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:29:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B748179971;
        Tue,  7 Jun 2022 10:55:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1779B617C4;
        Tue,  7 Jun 2022 17:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C78C34115;
        Tue,  7 Jun 2022 17:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624523;
        bh=CzrLO3e2CgEOzWZRssCzwztDRtE5eWvfjtuaGMykLwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvTlpGPsk48ttU5PCCrH52HtHuHZslxb18fH9MNcrSSDu9hE63jZtzELVPpruAfVM
         Z9oG3EQU7yK/sxAVfnteODwPo3wKnIqqzXesgu1fyZv5IXjyPANRMoXTKjOiKi/rKB
         ohbhguG/MUkBrEegixNYRehyxF1B8jus1ktuNPHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/667] ASoC: wm2000: fix missing clk_disable_unprepare() on error in wm2000_anc_transition()
Date:   Tue,  7 Jun 2022 19:00:24 +0200
Message-Id: <20220607164945.521939333@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit be2af740e2a9c7134f2d8ab4f104006e110b13de ]

Fix the missing clk_disable_unprepare() before return
from wm2000_anc_transition() in the error handling case.

Fixes: 514cfd6dd725 ("ASoC: wm2000: Integrate with clock API")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220514091053.686416-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm2000.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm2000.c b/sound/soc/codecs/wm2000.c
index 72e165cc6443..97ece3114b3d 100644
--- a/sound/soc/codecs/wm2000.c
+++ b/sound/soc/codecs/wm2000.c
@@ -536,7 +536,7 @@ static int wm2000_anc_transition(struct wm2000_priv *wm2000,
 {
 	struct i2c_client *i2c = wm2000->i2c;
 	int i, j;
-	int ret;
+	int ret = 0;
 
 	if (wm2000->anc_mode == mode)
 		return 0;
@@ -566,13 +566,13 @@ static int wm2000_anc_transition(struct wm2000_priv *wm2000,
 		ret = anc_transitions[i].step[j](i2c,
 						 anc_transitions[i].analogue);
 		if (ret != 0)
-			return ret;
+			break;
 	}
 
 	if (anc_transitions[i].dest == ANC_OFF)
 		clk_disable_unprepare(wm2000->mclk);
 
-	return 0;
+	return ret;
 }
 
 static int wm2000_anc_set_mode(struct wm2000_priv *wm2000)
-- 
2.35.1



