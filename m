Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1358C521F4D
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346213AbiEJPsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346187AbiEJPsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:48:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4783527D01B;
        Tue, 10 May 2022 08:43:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAB26614E1;
        Tue, 10 May 2022 15:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E858C385D6;
        Tue, 10 May 2022 15:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197436;
        bh=B5Qp5P8UuaKwEKNG8kBzepvyoMKD3BUNxBcVLn2VzAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sonuPilV5zBYyf5Id2t5iHRjgeFdSKUMBpxCabkyEHCayu3YhUbb98/ruu5/KxRvU
         fXXk/rW+i8qOiRx86ZsA4141+zxLJ9cimblELGS7kCSktmNvVAkINzWRQHVWq1Oo65
         vlX+qpzBFTt7Eb6tJh3voqOAoU3QaSaLnghmiviN6gg+vzzE8U462SO54H5t66ewnr
         cGlY+v2/LOKzrGsaXBHtWy+a5J6ugnr1YGNQ9upFxRCw2h6j+Nbn2+mT+zCha04c/F
         DKlZjlRp41brsbIoejzxfM25bNEjxzr3fgD7A50WByObh8t5eKlAOvyjqWeuzm+0RD
         /YH++V5zI/cMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        pierre-louis.bossart@linux.intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 06/21] ASoC: max98090: Generate notifications on changes for custom control
Date:   Tue, 10 May 2022 11:43:25 -0400
Message-Id: <20220510154340.153400-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154340.153400-1-sashal@kernel.org>
References: <20220510154340.153400-1-sashal@kernel.org>
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

[ Upstream commit 13fcf676d9e102594effc686d98521ff5c90b925 ]

The max98090 driver has some custom controls which share a put() function
which returns 0 unconditionally, meaning that events are not generated
when the value changes. Fix that.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220420193454.2647908-2-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98090.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 6d9261346842..62b41ca050a2 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -430,7 +430,7 @@ static int max98090_put_enab_tlv(struct snd_kcontrol *kcontrol,
 		mask << mc->shift,
 		sel << mc->shift);
 
-	return 0;
+	return *select != val;
 }
 
 static const char *max98090_perf_pwr_text[] =
-- 
2.35.1

