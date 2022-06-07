Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76B05414D3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358927AbiFGUWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359203AbiFGUWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:22:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091AD1451FD;
        Tue,  7 Jun 2022 11:31:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97FC461295;
        Tue,  7 Jun 2022 18:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4232C385A5;
        Tue,  7 Jun 2022 18:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626685;
        bh=dJUCVa4nIa8YINdSoor1J/gc2l6XzUX9TFZT4NQvPgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGBcaAcT52IwaiFpdplmUD7TZPpWKAk3cG7lQtl4qcJ4NkqQq3bqaB5W3r8rvoPzv
         MHQRNqMwz3jmCNISdT8scqtrRNj6XB6hq1u9+p//p6MUyxrU8eQxEV21iGZ/EjUcA4
         r5U667Xv3skpMKnWKoraK855RWJLijqkn+181UGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 430/772] ASoC: max98090: Move check for invalid values before casting in max98090_put_enab_tlv()
Date:   Tue,  7 Jun 2022 19:00:22 +0200
Message-Id: <20220607165001.673831982@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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



