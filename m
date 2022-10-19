Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99A560487C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbiJSN4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234401AbiJSNzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:55:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA34819E938;
        Wed, 19 Oct 2022 06:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BFACB8241B;
        Wed, 19 Oct 2022 08:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E2BC433C1;
        Wed, 19 Oct 2022 08:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169789;
        bh=G8xADkDPYcWBWUslQAaiMJUF6p8+GO7B2dJtWPf4nTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFcB1uTeve38IFckh1KxMeEfYwJKccu2+s1hUmV6k9AYEGV0saVzcieGeEf48KnPn
         yIM17KzX2HRXAseqF9Sx2rBglMiuwTueUefBLlLUVYRJyl/sAyJ16GAWp2s1TuZGOv
         DC//5rV3wKxtCx4YLrnUccn2xqB+LxdzeU4djDkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 408/862] ASoC: wcd-mbhc-v2: Revert "ASoC: wcd-mbhc-v2: use pm_runtime_resume_and_get()"
Date:   Wed, 19 Oct 2022 10:28:15 +0200
Message-Id: <20221019083307.983393057@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit e18f6bcf8e864ea0e9690691d0d749c662b6a2c7 ]

This reverts commit ddea4bbf287b6028eaa15a185d0693856956ecf2 ("ASoC:
wcd-mbhc-v2: use pm_runtime_resume_and_get()"), because it introduced
double runtime PM put if pm_runtime_get_sync() returns -EACCES:

  wcd934x-codec wcd934x-codec.3.auto: WCD934X Minor:0x1 Version:0x401
  wcd934x-codec wcd934x-codec.3.auto: Runtime PM usage count underflow!

The commit claimed no changes in functionality except dropping the
reference on -EACCESS.  This is exactly the change introducing bug
because function calls unconditionally pm_runtime_put_autosuspend() at
the end.

Fixes: ddea4bbf287b ("ASoC: wcd-mbhc-v2: use pm_runtime_resume_and_get()")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220929131528.217502-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd-mbhc-v2.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wcd-mbhc-v2.c b/sound/soc/codecs/wcd-mbhc-v2.c
index 98baef594bf3..31009283e7d4 100644
--- a/sound/soc/codecs/wcd-mbhc-v2.c
+++ b/sound/soc/codecs/wcd-mbhc-v2.c
@@ -714,11 +714,12 @@ static int wcd_mbhc_initialise(struct wcd_mbhc *mbhc)
 	struct snd_soc_component *component = mbhc->component;
 	int ret;
 
-	ret = pm_runtime_resume_and_get(component->dev);
+	ret = pm_runtime_get_sync(component->dev);
 	if (ret < 0 && ret != -EACCES) {
 		dev_err_ratelimited(component->dev,
-				    "pm_runtime_resume_and_get failed in %s, ret %d\n",
+				    "pm_runtime_get_sync failed in %s, ret %d\n",
 				    __func__, ret);
+		pm_runtime_put_noidle(component->dev);
 		return ret;
 	}
 
@@ -1096,11 +1097,12 @@ static void wcd_correct_swch_plug(struct work_struct *work)
 	mbhc = container_of(work, struct wcd_mbhc, correct_plug_swch);
 	component = mbhc->component;
 
-	ret = pm_runtime_resume_and_get(component->dev);
+	ret = pm_runtime_get_sync(component->dev);
 	if (ret < 0 && ret != -EACCES) {
 		dev_err_ratelimited(component->dev,
-				    "pm_runtime_resume_and_get failed in %s, ret %d\n",
+				    "pm_runtime_get_sync failed in %s, ret %d\n",
 				    __func__, ret);
+		pm_runtime_put_noidle(component->dev);
 		return;
 	}
 	micbias_mv = wcd_mbhc_get_micbias(mbhc);
-- 
2.35.1



