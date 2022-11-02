Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C569C61582F
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiKBCqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiKBCqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:46:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8BD21268
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:46:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A878DB81FF9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC48C433D6;
        Wed,  2 Nov 2022 02:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357205;
        bh=SyE6fIy7aCerQfNQdRBRdYruB0g1oabtivglLKKX90E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bvvh5YWEDui66evCONS6PDLh7uWpYhrfMrGwlcbMY2Tq3h1SpkCUejH7S0bxeXN86
         0lD02Mimbp+hjIXyGt8L6XvuVEf26v94Hx3219rqPQ4ATFOui8KhB0U0//nH1XncHa
         JEOlhtM+VbQUpA0BEwNepriC7R3++BLA5MDjBRU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 131/240] ASoC: qcom: lpass-cpu: mark HDMI TX registers as volatile
Date:   Wed,  2 Nov 2022 03:31:46 +0100
Message-Id: <20221102022114.343835409@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
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
index 8a56f38dc7e8..99a3b4428591 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -782,10 +782,18 @@ static bool lpass_hdmi_regmap_volatile(struct device *dev, unsigned int reg)
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



