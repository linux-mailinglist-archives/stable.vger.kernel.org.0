Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19ADA521FF6
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346656AbiEJPwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346772AbiEJPvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:51:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1C143AD8;
        Tue, 10 May 2022 08:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 066F7615F3;
        Tue, 10 May 2022 15:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82131C385A6;
        Tue, 10 May 2022 15:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197552;
        bh=FMJRUB1SG20TwFoKGF+M7aS86FGVewsJIqlGua4wN/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWTtX4TYUv13TJj6HbFDL/MoYQyBlQqwx5ke+yaWvOt+h4H9xVi8+DvctNYk8qQ3S
         KZKqC1UQ5hI2GJKavbFy3zSkRo7jVFaxQ9Hzo8T+TmaFCOSYH2zOCiN8UnBk5TzTFd
         yVEPirC4sQUe0CpEFMkWB/AZQ8wZm1pdFXBGx6k8OBXmCk8kGhGnfTN1pyTlhwClwz
         8aGHFLUW2FgcEsEZuGjj9na2IaDlpekVzh4cBbkwo9b9tr+6g0zWnBm88jazbxbCGk
         600mer3sp6oEbr8EAuVBdP4cDdSKOESB40TJ+zS4PGjnth7Nl8nPR3g0UOBtRl8xXp
         AowzIabkMN2CQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 4/8] ASoC: ops: Validate input values in snd_soc_put_volsw_range()
Date:   Tue, 10 May 2022 11:45:32 -0400
Message-Id: <20220510154536.154070-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154536.154070-1-sashal@kernel.org>
References: <20220510154536.154070-1-sashal@kernel.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit aa22125c57f9e577f0a667e4fa07fc3fa8ca1e60 ]

Check that values written via snd_soc_put_volsw_range() are
within the range advertised by the control, ensuring that we
don't write out of spec values to the hardware.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220423131239.3375261-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index c88bc6bb41cf..7a37312c8e0c 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -523,7 +523,15 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 	unsigned int mask = (1 << fls(max)) - 1;
 	unsigned int invert = mc->invert;
 	unsigned int val, val_mask;
-	int err, ret;
+	int err, ret, tmp;
+
+	tmp = ucontrol->value.integer.value[0];
+	if (tmp < 0)
+		return -EINVAL;
+	if (mc->platform_max && tmp > mc->platform_max)
+		return -EINVAL;
+	if (tmp > mc->max - mc->min + 1)
+		return -EINVAL;
 
 	if (invert)
 		val = (max - ucontrol->value.integer.value[0]) & mask;
@@ -538,6 +546,14 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 	ret = err;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
+		tmp = ucontrol->value.integer.value[1];
+		if (tmp < 0)
+			return -EINVAL;
+		if (mc->platform_max && tmp > mc->platform_max)
+			return -EINVAL;
+		if (tmp > mc->max - mc->min + 1)
+			return -EINVAL;
+
 		if (invert)
 			val = (max - ucontrol->value.integer.value[1]) & mask;
 		else
-- 
2.35.1

