Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59216A36CD
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjB0CE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjB0CEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:04:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D010139;
        Sun, 26 Feb 2023 18:04:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ED0660D17;
        Mon, 27 Feb 2023 02:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FF4C433D2;
        Mon, 27 Feb 2023 02:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463380;
        bh=l+h1m6l15Q0H3wMw3p063iUD+9lEE8RxFhgso/B/Gys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJ1Cods6576p2rR+A2PMcZnN9x5UVpm854vsldpv82Ftl3TCGvz17feOCwJIINGpK
         dZoE9Xrr9kXT2OMYt0Ry4aqcDqmOaWiajkGFJqx9+DN/wG4JXf67SE/pRfeogqIrpQ
         PwXXRW8T/JIGjecH9xryftTbNo451uWCthgVZaSo5Ok3wRplRqWrqhdSCRdQnwpoDf
         tE4parZ2pAijc2l474x918DAtb4oyUtQ5uYiKcUTpcQcvkitrSnfNK1rUZ3e2Sh7QD
         3J2GQk4rkXSG0T3MxcxTc+CTQ3WSP1OCMN+NuVIfE8hgs8aQVjv9i8uB7yre3GCcmF
         Yx2BkjFm1kLCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.2 35/60] ASoC: kirkwood: Iterate over array indexes instead of using pointer math
Date:   Sun, 26 Feb 2023 21:00:20 -0500
Message-Id: <20230227020045.1045105-35-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit b3bcedc0402fcdc5c8624c433562d9d1882749d8 ]

Walking the dram->cs array was seen as accesses beyond the first array
item by the compiler. Instead, use the array index directly. This allows
for run-time bounds checking under CONFIG_UBSAN_BOUNDS as well. Seen
with GCC 13 with -fstrict-flex-arrays:

../sound/soc/kirkwood/kirkwood-dma.c: In function
'kirkwood_dma_conf_mbus_windows.constprop':
../sound/soc/kirkwood/kirkwood-dma.c:90:24: warning: array subscript 0 is outside array bounds of 'const struct mbus_dram_window[0]' [-Warray-bounds=]
   90 |                 if ((cs->base & 0xffff0000) < (dma & 0xffff0000)) {
      |                      ~~^~~~~~

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: alsa-devel@alsa-project.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230127224128.never.410-kees@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/kirkwood/kirkwood-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index 700a18561a940..640cebd2983e2 100644
--- a/sound/soc/kirkwood/kirkwood-dma.c
+++ b/sound/soc/kirkwood/kirkwood-dma.c
@@ -86,7 +86,7 @@ kirkwood_dma_conf_mbus_windows(void __iomem *base, int win,
 
 	/* try to find matching cs for current dma address */
 	for (i = 0; i < dram->num_cs; i++) {
-		const struct mbus_dram_window *cs = dram->cs + i;
+		const struct mbus_dram_window *cs = &dram->cs[i];
 		if ((cs->base & 0xffff0000) < (dma & 0xffff0000)) {
 			writel(cs->base & 0xffff0000,
 				base + KIRKWOOD_AUDIO_WIN_BASE_REG(win));
-- 
2.39.0

