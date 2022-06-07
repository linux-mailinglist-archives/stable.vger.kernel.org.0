Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0725541C42
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382427AbiFGV6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383220AbiFGVwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39B32431A6;
        Tue,  7 Jun 2022 12:10:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A410617D0;
        Tue,  7 Jun 2022 19:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391A9C385A2;
        Tue,  7 Jun 2022 19:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629044;
        bh=dJUCVa4nIa8YINdSoor1J/gc2l6XzUX9TFZT4NQvPgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEZlM2ceI6LteJexpDSdLlLsOGVjeB3ihvjUlu+opqlWiCFPgUsXzbtRss2an3463
         +QcbTI5pgFTHkqctoH6nlwEKbzMTs+rffO//NQxMh+E8BuCSjzAt+65K9zVd19ucYB
         MTe3JTwCuGme+eKHGu8j2UF0kWL2+g75xUyX0igA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 508/879] ASoC: max98090: Move check for invalid values before casting in max98090_put_enab_tlv()
Date:   Tue,  7 Jun 2022 19:00:26 +0200
Message-Id: <20220607165017.620148269@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit f7a344468105ef8c54086dfdc800e6f5a8417d3e ]

Validation of signed input should be done before casting to unsigned int.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Suggested-by: Mark Brown <broonie@kernel.org>
Fixes: 2fbe467bcbfc ("ASoC: max98090: Reject invalid values in custom control put()")
Link: https://lore.kernel.org/r/1652999486-29653-1-git-send-email-khoroshilov@ispras.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98090.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 62b41ca050a2..5513acd360b8 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -393,7 +393,8 @@ static int max98090_put_enab_tlv(struct snd_kcontrol *kcontrol,
 	struct soc_mixer_control *mc =
 		(struct soc_mixer_control *)kcontrol->private_value;
 	unsigned int mask = (1 << fls(mc->max)) - 1;
-	unsigned int sel = ucontrol->value.integer.value[0];
+	int sel_unchecked = ucontrol->value.integer.value[0];
+	unsigned int sel;
 	unsigned int val = snd_soc_component_read(component, mc->reg);
 	unsigned int *select;
 
@@ -413,8 +414,9 @@ static int max98090_put_enab_tlv(struct snd_kcontrol *kcontrol,
 
 	val = (val >> mc->shift) & mask;
 
-	if (sel < 0 || sel > mc->max)
+	if (sel_unchecked < 0 || sel_unchecked > mc->max)
 		return -EINVAL;
+	sel = sel_unchecked;
 
 	*select = sel;
 
-- 
2.35.1



