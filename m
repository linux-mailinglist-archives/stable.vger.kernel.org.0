Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29752644057
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbiLFJv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiLFJuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:50:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E97D1E3EE;
        Tue,  6 Dec 2022 01:50:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F01CDB818E7;
        Tue,  6 Dec 2022 09:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0310FC433D6;
        Tue,  6 Dec 2022 09:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320201;
        bh=T5BoWa1YCB2Nbpvv0gLOacJKwctZLb/HoHqezvyRhvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZlsyk8nktRyEOBWilZwzIx309ExjrEejSimyGbpmUMcowYimzzxycRPHp6wR2caX
         +lChu4d56HVzx0qLlDN8hRwIGfv3DWmkhzSKD50J+agMIVYrItYjbOoCxk6bHwecq3
         Vca2cYnDWs+dlS8JrGVLTuUvTDOu1JhWnwFVilwTj4lMcEWvOZM4q/XG5iA9vSYNo+
         tr2kop64UGtvCbPq7BybXDV2gYtMH+cvN2KWcL1Y3wbOYPLLXiuL2AAdOBtujnoyZ8
         TFAPsxiBLhemahjJwaWglefz/c5ud7dRWBfbiScQjcNptMc3ce2uqonvPZZ5/u6LaU
         fY6llq3Mxq3UQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shengjiu Wang <shengjiu.wang@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, shengjiu.wang@gmail.com,
        Xiubo.Lee@gmail.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 02/12] ASoC: fsl_micfil: explicitly clear CHnF flags
Date:   Tue,  6 Dec 2022 04:49:44 -0500
Message-Id: <20221206094955.987437-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206094955.987437-1-sashal@kernel.org>
References: <20221206094955.987437-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit b776c4a4618ec1b5219d494c423dc142f23c4e8f ]

There may be failure when start 1 channel recording after
8 channels recording. The reason is that the CHnF
flags are not cleared successfully by software reset.

This issue is triggerred by the change of clearing
software reset bit.

CHnF flags are write 1 clear bits. Clear them by force
write.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://lore.kernel.org/r/1651925654-32060-2-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index cb84d95c3aac..d1cd104f8584 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -202,6 +202,14 @@ static int fsl_micfil_reset(struct device *dev)
 	if (ret)
 		return ret;
 
+	/*
+	 * Set SRES should clear CHnF flags, But even add delay here
+	 * the CHnF may not be cleared sometimes, so clear CHnF explicitly.
+	 */
+	ret = regmap_write_bits(micfil->regmap, REG_MICFIL_STAT, 0xFF, 0xFF);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.35.1

