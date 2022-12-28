Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9D3657DC5
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbiL1Pql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbiL1Pqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:46:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A306A164B0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:46:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 387BCB8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D547C433D2;
        Wed, 28 Dec 2022 15:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242386;
        bh=lOB/T60sWXx1He6Mrm1mXZncXUBjlFbZN3/xTZPaES8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XJ5+Su7ldJcsMIMaIJcylnWc9Eb8pgPww3f2MgQrYHHWU3dq50isO0UVVEiECPxi
         5YVNnnTLnXTzpFl8MN4XqKljo1K5Lwx/V8saWUGglNaOYDaA0Q84dczWLgeqv1X4kl
         A2kwmyl8BUo4kzD8Lm1NxcKPKfZxSNSTYZdhVD5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0404/1073] ASoC: mediatek: mtk-btcvsd: Add checks for write and read of mtk_btcvsd_snd
Date:   Wed, 28 Dec 2022 15:33:12 +0100
Message-Id: <20221228144338.990316536@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit d067b3378a78c9c3048ac535e31c171b6f5b5846 ]

As the mtk_btcvsd_snd_write and mtk_btcvsd_snd_read may return error,
it should be better to catch the exception.

Fixes: 4bd8597dc36c ("ASoC: mediatek: add btcvsd driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20221116030750.40500-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/common/mtk-btcvsd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/common/mtk-btcvsd.c b/sound/soc/mediatek/common/mtk-btcvsd.c
index d884bb7c0fc7..1c28b41e4311 100644
--- a/sound/soc/mediatek/common/mtk-btcvsd.c
+++ b/sound/soc/mediatek/common/mtk-btcvsd.c
@@ -1038,11 +1038,9 @@ static int mtk_pcm_btcvsd_copy(struct snd_soc_component *component,
 	struct mtk_btcvsd_snd *bt = snd_soc_component_get_drvdata(component);
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		mtk_btcvsd_snd_write(bt, buf, count);
+		return mtk_btcvsd_snd_write(bt, buf, count);
 	else
-		mtk_btcvsd_snd_read(bt, buf, count);
-
-	return 0;
+		return mtk_btcvsd_snd_read(bt, buf, count);
 }
 
 /* kcontrol */
-- 
2.35.1



