Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0C6521FF3
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346654AbiEJPwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346585AbiEJPvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:51:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8A228C9C1;
        Tue, 10 May 2022 08:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DEE8615AE;
        Tue, 10 May 2022 15:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E91BC385C2;
        Tue, 10 May 2022 15:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197522;
        bh=LPgWGFYVUKI8AXYB5cCTq9m4J4dr8kWxnRp48zoc8a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8wFL7sYDxLYFFm7fC08c3gYhDolGkZc6MiXCngpA2HNZV7CjWvFOvT+sJHhn+kVO
         N7LWtALQF/UWhOkDuYhi7QRQNM6iQGYf9XBaeElnHCIG62p8jbO8VtDmQjplSaJfqm
         tkLv6g0/PnXiyYFfHLTH6DQbWhkzVxwFPIwDk+dArdOUJo6YuT81A3oF/I97WMHAMX
         Ll8LHM9JZtQeYW2hEUA4XDk6+UG2HBC1NavkhjXx/LWW+YwzHxRXwxTQ6vxDGMxmMP
         0gbZV2rCcdLEYJEKg2uNd7wJIAeAgEe6pkSUQhgZo/xeMjFwsNpKvlyQtpaSGBl2QX
         yVc4p4zaZSy0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 4/9] ASoC: ops: Validate input values in snd_soc_put_volsw_range()
Date:   Tue, 10 May 2022 11:45:07 -0400
Message-Id: <20220510154512.153945-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154512.153945-1-sashal@kernel.org>
References: <20220510154512.153945-1-sashal@kernel.org>
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
index 2bc9fa6a34b8..15bfcdbdfaa4 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -510,7 +510,15 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
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
@@ -525,6 +533,14 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
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

