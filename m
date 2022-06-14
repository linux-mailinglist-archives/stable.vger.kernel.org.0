Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F6C54A5FF
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353799AbiFNCQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353493AbiFNCPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:15:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502F03DA77;
        Mon, 13 Jun 2022 19:09:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31A5D60B65;
        Tue, 14 Jun 2022 02:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68903C36B01;
        Tue, 14 Jun 2022 02:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172562;
        bh=RLHSQVtkqrazy0mBeNjXkqecGr67GUWi+zQRgtJ/3Bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPnuuAfAUd492Mu0fgNSQDJ1yL7UfT/r5NHrxH12Rb9tsUBhSVxH9mwruk+WaX5JY
         dJRluPM7nKVeI1ITiJjG/gzk3DmxZ1pNdXIm3b/boL8mji3VGCRJVLlrKIaWRN5ieV
         SCFRrIfkbzrP5clk/uWQmRrzwiTFpPPV1tbRCcO1iGByuOx1z83ph6Jwp4RCbzlC/N
         zd8LKXSZz7DpkfW35xhY5FGHpCPL3MJW48gyDqpOFtV59Tf8x2mPcAX7t0C2izp/d5
         uUslaMF0H9JifK5trQtV94ljmCK4g2ZEfZaQL+EVMtchgZ43X1sFrppq5C6RFsL3oK
         g37Fb1q9nl4fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 12/23] ASoC: wm_adsp: Fix event generation for wm_adsp_fw_put()
Date:   Mon, 13 Jun 2022 22:08:48 -0400
Message-Id: <20220614020900.1100401-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020900.1100401-1-sashal@kernel.org>
References: <20220614020900.1100401-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 2abdf9f80019e8244d3806ed0e1c9f725e50b452 ]

Currently wm_adsp_fw_put() returns 0 rather than 1 when updating the value
of the control, meaning that no event is generated to userspace. Fix this
by setting the default return value to 1, the code already exits early with
a return value of 0 if the value is unchanged.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220603115003.3865834-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index 13672928da99..aedfa6b2895b 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -791,7 +791,7 @@ int wm_adsp_fw_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	struct wm_adsp *dsp = snd_soc_component_get_drvdata(component);
-	int ret = 0;
+	int ret = 1;
 
 	if (ucontrol->value.enumerated.item[0] == dsp[e->shift_l].fw)
 		return 0;
-- 
2.35.1

