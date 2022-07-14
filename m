Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B13857433F
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbiGNEb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236925AbiGNEaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:30:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427E53244B;
        Wed, 13 Jul 2022 21:25:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D83ACB82377;
        Thu, 14 Jul 2022 04:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A189C385A5;
        Thu, 14 Jul 2022 04:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772710;
        bh=O8tlw0dNGRaykhtvOszk9r/8Y1NGnYjj0OZ9LrffeaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFfon5oDgtBx5x2XTWX6KVMSYc4QNvsDsmNmRCV3PJehTdvS6URi0N6DXYVM1/HEz
         axXL0YazCmKLQ0xvaUm5k3oi2tRJzigs5juWaDMr6Yi5S5XxmKNvFMUDITpnxdLP4m
         mZtR1d6XJNlF4fF4ZUw5XFIAA19V4+Z4mYZPlYpfJQZFyyw6RM6HdW/vZeJjeHwC4l
         U6673bEZp+CrqdZ6tpcw5UClkVzkfCR/o0tL3dAGM+ux9Fa7MWMWy2oVnHmSAWjFYK
         RKjSWhTbQiE8aLFZKV3SmyiTTLmdMKDSXGV0jztdPt7/SEktWZuOITc8zzm6r+ywT1
         EmVDJVwH7KfzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rf@opensource.cirrus.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org, patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 5.15 17/28] ASoC: madera: Fix event generation for OUT1 demux
Date:   Thu, 14 Jul 2022 00:24:18 -0400
Message-Id: <20220714042429.281816-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042429.281816-1-sashal@kernel.org>
References: <20220714042429.281816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit e3cabbef3db8269207a6b8808f510137669f8deb ]

madera_out1_demux_put returns the value of
snd_soc_dapm_mux_update_power, which returns a 1 if a path was found for
the kcontrol. This is obviously different to the expected return a 1 if
the control was updated value. This results in spurious notifications to
user-space. Update the handling to only return a 1 when the value is
changed.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220623105120.1981154-4-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/madera.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/madera.c b/sound/soc/codecs/madera.c
index f4ed7e04673f..d3e7a591b5a8 100644
--- a/sound/soc/codecs/madera.c
+++ b/sound/soc/codecs/madera.c
@@ -618,7 +618,13 @@ int madera_out1_demux_put(struct snd_kcontrol *kcontrol,
 end:
 	snd_soc_dapm_mutex_unlock(dapm);
 
-	return snd_soc_dapm_mux_update_power(dapm, kcontrol, mux, e, NULL);
+	ret = snd_soc_dapm_mux_update_power(dapm, kcontrol, mux, e, NULL);
+	if (ret < 0) {
+		dev_err(madera->dev, "Failed to update demux power state: %d\n", ret);
+		return ret;
+	}
+
+	return change;
 }
 EXPORT_SYMBOL_GPL(madera_out1_demux_put);
 
-- 
2.35.1

