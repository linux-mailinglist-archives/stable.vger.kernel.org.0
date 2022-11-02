Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDB06159C1
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiKBDRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiKBDRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:17:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBD32529F
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:17:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5827D61799
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E801BC433D6;
        Wed,  2 Nov 2022 03:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359037;
        bh=ecGe0/heA4x1GLBlCq441VKs30458MMVnntfAbfs4fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xp88gadrJ7Xg587dO/9bXpIVOIyuoDoa+z97di5a8cbFldTvb99w8DkJVd3eBOhQx
         Zh00TFf7b0taXsQ60u9eTAwCk/mzuhO1p17UDS8Af2/giV5rPLZlM7+I5VxMbNANWK
         FiXZVrUZdEKZC7wsd97Y+KvbR3uEsEYFlHV/upAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 39/91] ASoC: qcom: lpass-cpu: mark HDMI TX registers as volatile
Date:   Wed,  2 Nov 2022 03:33:22 +0100
Message-Id: <20221102022056.145020263@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>

[ Upstream commit c9a3545b1d771fb7b06a487796c40288c02c41c5 ]

Update HDMI volatile registers list as DMA, Channel Selection registers,
vbit control registers are being reflected by hardware DP port
disconnection.

This update is required to fix no display and no sound issue observed
after reconnecting TAMA/SANWA DP cables.
Once DP cable is unplugged, DMA control registers are being reset by
hardware, however at second plugin, new dma control values does not
updated to the dma hardware registers since new register value and
cached values at the time of first plugin are same.

Fixes: 7cb37b7bd0d3 ("ASoC: qcom: Add support for lpass hdmi driver")

Signed-off-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Reported-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Link: https://lore.kernel.org/r/1665637711-13300-1-git-send-email-quic_srivasam@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cpu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index 03abb3d719d0..9aa7c445b6b0 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -745,10 +745,18 @@ static bool lpass_hdmi_regmap_volatile(struct device *dev, unsigned int reg)
 		return true;
 	if (reg == LPASS_HDMI_TX_LEGACY_ADDR(v))
 		return true;
+	if (reg == LPASS_HDMI_TX_VBIT_CTL_ADDR(v))
+		return true;
 
 	for (i = 0; i < v->hdmi_rdma_channels; ++i) {
 		if (reg == LPAIF_HDMI_RDMACURR_REG(v, i))
 			return true;
+		if (reg == LPASS_HDMI_TX_DMA_ADDR(v, i))
+			return true;
+		if (reg == LPASS_HDMI_TX_CH_LSB_ADDR(v, i))
+			return true;
+		if (reg == LPASS_HDMI_TX_CH_MSB_ADDR(v, i))
+			return true;
 	}
 	return false;
 }
-- 
2.35.1



