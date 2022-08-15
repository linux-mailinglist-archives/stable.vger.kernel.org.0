Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD77594559
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348982AbiHOWiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350877AbiHOWhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:37:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01DD5F12B;
        Mon, 15 Aug 2022 12:50:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37A5160FB5;
        Mon, 15 Aug 2022 19:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E40C433C1;
        Mon, 15 Aug 2022 19:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592987;
        bh=u3MJlF94TEUlwGT6XhEOyGzd+wXV3YqFsvsnUO3j5f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ld0sjg0NMsfMteaAwSPQyGG3+WPVE50Om7/lZ2o6voLHzC03sTa3qLHY0sNXkqACp
         U+7GQv/qszIxZaAm1x8JndbF/cXivX6ew4nqYZI8w8SxvVFw4OSyWjdC/7+ZOCceuo
         KvTC6CLZVH3L05GmApBVCRRuEerotYy788IXqv0M=
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
Subject: [PATCH 5.18 0876/1095] ASoC: SOF: mediatek: fix mt8195 StatvectorSel wrong setting
Date:   Mon, 15 Aug 2022 20:04:35 +0200
Message-Id: <20220815180505.597440635@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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



