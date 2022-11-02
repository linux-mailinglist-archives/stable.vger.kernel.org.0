Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E239F61586B
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiKBCvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiKBCvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:51:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B55D21E35
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9672B617CE
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA2BC433D6;
        Wed,  2 Nov 2022 02:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357502;
        bh=UIZOseeQh6NqgYML67XjP+1RDlthbTNu22kafHd9u0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZY7ICqyRcLM4w3/1S51SejUMakGA7n5fB9vB73NblVkVomHjldXFeGpKnZg8On06
         0uBF59zhOv/Eg4+06RQ7JyQXFdICNoc7MKJsgdEGGIAdkYgx53dB0ztL/n+j21WjcH
         wYgumnwm5nozPdYVSoT2W5nYVr9rjmF1M7qnyiBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 153/240] ASoC: qcom: lpass-cpu: Mark HDMI TX parity register as volatile
Date:   Wed,  2 Nov 2022 03:32:08 +0100
Message-Id: <20221102022114.840510414@linuxfoundation.org>
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

[ Upstream commit 1dd5166102e7ca91e8c5d833110333835e147ddb ]

Update LPASS_HDMI_TX_PARITY_ADDR register as volatile, to fix
dp audio failures observed with some of external monitors.

Fixes: 7cb37b7bd0d3 ("ASoC: qcom: Add support for lpass hdmi driver")

Signed-off-by: Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1665825530-7593-1-git-send-email-quic_srivasam@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/qcom/lpass-cpu.c b/sound/soc/qcom/lpass-cpu.c
index 99a3b4428591..54353842dc07 100644
--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -784,6 +784,8 @@ static bool lpass_hdmi_regmap_volatile(struct device *dev, unsigned int reg)
 		return true;
 	if (reg == LPASS_HDMI_TX_VBIT_CTL_ADDR(v))
 		return true;
+	if (reg == LPASS_HDMI_TX_PARITY_ADDR(v))
+		return true;
 
 	for (i = 0; i < v->hdmi_rdma_channels; ++i) {
 		if (reg == LPAIF_HDMI_RDMACURR_REG(v, i))
-- 
2.35.1



