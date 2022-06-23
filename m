Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A975586A2
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbiFWSPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236662AbiFWSPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:15:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA1D82881;
        Thu, 23 Jun 2022 10:21:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2170661EA7;
        Thu, 23 Jun 2022 17:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA69C3411B;
        Thu, 23 Jun 2022 17:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004906;
        bh=Fw48xkHyH8/DLVrsed+YMJXLK35lFF9hd1liV4MKg1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2umwWv1Vff+d37bxWSpsYEz/kls2ijEKK67VNrutXOJdUTkKxHZOALwnPO3DpZfNW
         DVA9AiBog3GdMcmTQQk2zNKsvLy6qL0HrljMCiums+zScef5+oZ/NL+jCwZqD1w0z7
         JNbHThI4K4Tz8I1VQ85LR2tNjOLXYzYr2o9iu41Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 188/234] ASoC: es8328: Fix event generation for deemphasis control
Date:   Thu, 23 Jun 2022 18:44:15 +0200
Message-Id: <20220623164348.369141110@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit 8259610c2ec01c5cbfb61882ae176aabacac9c19 ]

Currently the put() method for the deemphasis control returns 0 when a new
value is written to the control even if the value changed, meaning events
are not generated. Fix this, skip the work of updating the value when it is
unchanged and then return 1 after having done so.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220603123937.4013603-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8328.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/es8328.c b/sound/soc/codecs/es8328.c
index 3afa163f7652..dcb01889e177 100644
--- a/sound/soc/codecs/es8328.c
+++ b/sound/soc/codecs/es8328.c
@@ -165,13 +165,16 @@ static int es8328_put_deemph(struct snd_kcontrol *kcontrol,
 	if (deemph > 1)
 		return -EINVAL;
 
+	if (es8328->deemph == deemph)
+		return 0;
+
 	ret = es8328_set_deemph(component);
 	if (ret < 0)
 		return ret;
 
 	es8328->deemph = deemph;
 
-	return 0;
+	return 1;
 }
 
 
-- 
2.35.1



