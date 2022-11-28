Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BBC63AF36
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiK1Rj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbiK1Rj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:39:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D56128E18;
        Mon, 28 Nov 2022 09:38:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 854A0612F5;
        Mon, 28 Nov 2022 17:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09140C43154;
        Mon, 28 Nov 2022 17:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657117;
        bh=PAxi6eeJkAJBPTiO6t6sK57HyXc9bdfpzD8eQdRXDQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XLMjF2UjaenvdhCBrYuv0ecKju5kyfRXRYzqbbxY03txyy4IsyFZrxtUWghJVRxjS
         ItDct9cBnACbB8mqXi4w/rM/WvjPAsfqMjYJUXyNLYatTu4yPa4uGoKRCe8OtE8TI/
         h91LNWV/iUyvBfViPQbI+jfBwdglxVJuQQ2ptL5DgReEv9LUDN3st77k4Ocq2FQ1eC
         xA34HYF7ESUSiMHR4oOU5GSXsp5GPCg5+vcNSyklhV5D9hKtkDWxKb+m9ozFU+IvSi
         iTc4cUg5idZ36DpF/FCeBJFHCLFlOJknjvEyyqmsEmidI4V+uD0ZeMWUzuaSYcqcYL
         YTKq97LgfNzig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 19/39] ASoC: rt711-sdca: fix the latency time of clock stop prepare state machine transitions
Date:   Mon, 28 Nov 2022 12:35:59 -0500
Message-Id: <20221128173642.1441232-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
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

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit c7d7d4e7bb1290cc473610b0bb96d9fa606d00e7 ]

Due to the hardware behavior, it takes some time for CBJ detection/impedance sensing/de-bounce.
The ClockStop_NotFinished flag will be raised until these functions are completed.
In ClockStopMode0 mode case, the SdW controller might check this flag from D3 to D0 when the
jack detection interrupt happened.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://lore.kernel.org/r/20221116090318.5017-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt711-sdca-sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt711-sdca-sdw.c b/sound/soc/codecs/rt711-sdca-sdw.c
index a085b2f530aa..31e77d462ef3 100644
--- a/sound/soc/codecs/rt711-sdca-sdw.c
+++ b/sound/soc/codecs/rt711-sdca-sdw.c
@@ -230,7 +230,7 @@ static int rt711_sdca_read_prop(struct sdw_slave *slave)
 	}
 
 	/* set the timeout values */
-	prop->clk_stop_timeout = 20;
+	prop->clk_stop_timeout = 700;
 
 	/* wake-up event */
 	prop->wake_capable = 1;
-- 
2.35.1

