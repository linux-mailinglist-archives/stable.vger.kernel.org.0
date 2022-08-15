Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD091594D9B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243464AbiHPApB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346198AbiHPAnP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:43:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B2FD419E;
        Mon, 15 Aug 2022 13:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EED2B61233;
        Mon, 15 Aug 2022 20:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9291C433C1;
        Mon, 15 Aug 2022 20:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596018;
        bh=u3MJlF94TEUlwGT6XhEOyGzd+wXV3YqFsvsnUO3j5f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNYkyUF7BIFQ4owC5p+PtLJM7Cz6YbpaONacuHrfGa2D2J878a0L6qnVZHAF3ZoZy
         cZZBAH5ln0AYdZPXZ6F1H/Tzdsa+cHJhqK4ZbrllPJtID4FKZULAn8ps0V6fUFCTA8
         uHKeOU9DROwP3q0VnSEpGTPu5xn880xkd3yWFbkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        YC Hung <yc.hung@mediatek.com>, Li-Yu Yu <afg984@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        KuanHsun Cheng <Allen-KH.Cheng@mediatek.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0948/1157] ASoC: SOF: mediatek: fix mt8195 StatvectorSel wrong setting
Date:   Mon, 15 Aug 2022 20:05:04 +0200
Message-Id: <20220815180517.485029372@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YC Hung <yc.hung@mediatek.com>

[ Upstream commit 99bad468846f7a255dcfc95454401c83ae02e89b ]

Fix StatVectorSel wrong setting.

Fixes: b7f6503830 ("ASoC: SOF: mediatek: Add fw loader and mt8195 dsp ops to load firmware")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: YC Hung <yc.hung@mediatek.com>
Reviewed-by: Li-Yu Yu <afg984@gmail.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: KuanHsun Cheng <Allen-KH.Cheng@mediatek.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220708203904.29214-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/mediatek/mt8195/mt8195-loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/mediatek/mt8195/mt8195-loader.c b/sound/soc/sof/mediatek/mt8195/mt8195-loader.c
index ed18d6379e92..ef2664c3cd47 100644
--- a/sound/soc/sof/mediatek/mt8195/mt8195-loader.c
+++ b/sound/soc/sof/mediatek/mt8195/mt8195-loader.c
@@ -21,7 +21,7 @@ void sof_hifixdsp_boot_sequence(struct snd_sof_dev *sdev, u32 boot_addr)
 
 	/* pull high StatVectorSel to use AltResetVec (set bit4 to 1) */
 	snd_sof_dsp_update_bits(sdev, DSP_REG_BAR, DSP_RESET_SW,
-				DSP_RESET_SW, DSP_RESET_SW);
+				STATVECTOR_SEL, STATVECTOR_SEL);
 
 	/* toggle  DReset & BReset */
 	/* pull high DReset & BReset */
-- 
2.35.1



