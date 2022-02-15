Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66484B6D03
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 14:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238097AbiBONH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 08:07:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbiBONH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 08:07:27 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B46AFF78
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 05:07:16 -0800 (PST)
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 13E8383886;
        Tue, 15 Feb 2022 14:07:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1644930434;
        bh=+5XeOXiBdY2HU+UPOtxSSMLjN9PVOQsjLd31SIQQPRY=;
        h=From:To:Cc:Subject:Date:From;
        b=wuy6q9KEzXzN+3V0tBAFURaiIRYty2mr9O3ATEWd0ACAEIlr/8mLwf4cloXftAni9
         eJrBFJDLCFmxIlllZQojiI+yTSYnCA9jx2LYZrTMD9FAav10LRkkxTcoh8mJGBhMWl
         ryXncxykBHtMho+d30d5kDIDfK0sgYCxbZ7fPQbIeRSVgdAh7vuvmSUsKu6uaz0kFU
         ABZu0nGGhEsTqH2lsbo6Mg4IyTOfHEGwSfSlLC9yM+Em2l+4S6Bc4TnmME74Fbd2o1
         PG1ykbOQ/yKtR7yu6gcgZFtu8rdzvRky/9y3zsx5kx3Bo/V7X3vJ/JQvmZ17v/TtrK
         m4EGdLsjCRMHw==
From:   Marek Vasut <marex@denx.de>
To:     alsa-devel@alsa-project.org
Cc:     Marek Vasut <marex@denx.de>, Mark Brown <broonie@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min
Date:   Tue, 15 Feb 2022 14:06:45 +0100
Message-Id: <20220215130645.164025-1-marex@denx.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While the $val/$val2 values passed in from userspace are always >= 0
integers, the limits of the control can be signed integers and the $min
can be non-zero and less than zero. To correctly validate $val/$val2
against platform_max, add the $min offset to val first.

Fixes: 817f7c9335ec0 ("ASoC: ops: Reject out of bounds values in snd_soc_put_volsw()")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
 sound/soc/soc-ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index f24f7354f46fe..6389a512c4dc6 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -317,7 +317,7 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 		mask = BIT(sign_bit + 1) - 1;
 
 	val = ucontrol->value.integer.value[0];
-	if (mc->platform_max && val > mc->platform_max)
+	if (mc->platform_max && ((int)val + min) > mc->platform_max)
 		return -EINVAL;
 	if (val > max - min)
 		return -EINVAL;
@@ -330,7 +330,7 @@ int snd_soc_put_volsw(struct snd_kcontrol *kcontrol,
 	val = val << shift;
 	if (snd_soc_volsw_is_stereo(mc)) {
 		val2 = ucontrol->value.integer.value[1];
-		if (mc->platform_max && val2 > mc->platform_max)
+		if (mc->platform_max && ((int)val2 + min) > mc->platform_max)
 			return -EINVAL;
 		if (val2 > max - min)
 			return -EINVAL;
-- 
2.34.1

