Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90C354A449
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351420AbiFNCGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351362AbiFNCFx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:05:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B092533EB5;
        Mon, 13 Jun 2022 19:05:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58352B80AC1;
        Tue, 14 Jun 2022 02:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8228C385A9;
        Tue, 14 Jun 2022 02:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172317;
        bh=QyA7bmOpgTHe++ypbwOYleAT8DYMiXUQDDhCe7vK3cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtLFDX+7HPbbntLl7n7Nolgzj8J78AggbWT3EyOccgFeen7/CgJpJ+hrw8xeltb/g
         b+iIChgVEryGbtPjMxPsz0ochFdgs2M9GscFq2xXi/izabq9iVRSLn8gUmDC97R6Xb
         piRQywPuvvx4ZpN7fRw8srPOtHrnE+s3/ahoEcTw2+9ye9RoNtycwirRH99IFw5+Q4
         M0NHEz7qAgRlgOqaTKIYFHA5bf6O0WRb+o71nDnn0gTPmtkglLU9YN/hVHc7JMvh25
         Zy4Zo7xH0cjDrwpBCm3z6JEdA60gAMXXC8RpApL0HWAwmBGougq3f3ZfCy+KNp/oYU
         F35Pup5JmyqCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 20/47] ASoC: wm_adsp: Fix event generation for wm_adsp_fw_put()
Date:   Mon, 13 Jun 2022 22:04:13 -0400
Message-Id: <20220614020441.1098348-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020441.1098348-1-sashal@kernel.org>
References: <20220614020441.1098348-1-sashal@kernel.org>
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
index e32c8ded181d..9cfd4f18493f 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -333,7 +333,7 @@ int wm_adsp_fw_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	struct wm_adsp *dsp = snd_soc_component_get_drvdata(component);
-	int ret = 0;
+	int ret = 1;
 
 	if (ucontrol->value.enumerated.item[0] == dsp[e->shift_l].fw)
 		return 0;
-- 
2.35.1

