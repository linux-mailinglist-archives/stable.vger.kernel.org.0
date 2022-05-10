Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91622521FF5
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346649AbiEJPww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347090AbiEJPv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:51:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F6A24F0D8;
        Tue, 10 May 2022 08:46:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3781614A6;
        Tue, 10 May 2022 15:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70068C385A6;
        Tue, 10 May 2022 15:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197613;
        bh=AvMJv2jCQvxUqPnjz3GXZ5jMdU/1LfpW54CJT3n+Cy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkXt8M4bak9KBaeq/Kn+TY31fJM51Vz1+qfEdkTRW23L+FFBqpW/W35LG8npGatNf
         aDNjhWz3XN+SVUOY4scS8POx7e9imkT1RIVNtpIbIF+faRvqcU927U9UrB+VW8njfJ
         QKwK2aRgSY4ojDcQtGFFGhAbGEb/rC8fq3DxlKzJRgNZoUFi5GueansVCRnKDUtR+O
         UgdRU8U7CvD7xQXVYtpY5jjwwCjgTX0d9Bz1AeO6so7Kv0p79axwq97d7z2GzXuvrE
         4UWphDjMKqNnKy2Ah0mpk6l5955Rtpt76PjvSrtTw7HSSc4q6FO9qFyn/1eSgbB1OI
         LOFZLMHmvkWGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        pierre-louis.bossart@linux.intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 3/5] ASoC: max98090: Generate notifications on changes for custom control
Date:   Tue, 10 May 2022 11:46:35 -0400
Message-Id: <20220510154637.154283-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154637.154283-1-sashal@kernel.org>
References: <20220510154637.154283-1-sashal@kernel.org>
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
index a25183f6fba6..362d1fb2aae9 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -436,7 +436,7 @@ static int max98090_put_enab_tlv(struct snd_kcontrol *kcontrol,
 		mask << mc->shift,
 		sel << mc->shift);
 
-	return 0;
+	return *select != val;
 }
 
 static const char *max98090_perf_pwr_text[] =
-- 
2.35.1

