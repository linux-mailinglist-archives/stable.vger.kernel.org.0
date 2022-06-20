Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A2F551C1E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244778AbiFTNLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244669AbiFTNKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:10:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039941D304;
        Mon, 20 Jun 2022 06:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B871861542;
        Mon, 20 Jun 2022 13:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0915C3411B;
        Mon, 20 Jun 2022 13:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730338;
        bh=Wb9zf+MdbLEL6269vRZQ5BnfGJNFA8u3ASZMRlx1A2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTQhq5uvtbFcOn6OqDsb5Rr6PnA3UhH4WSqCrLJAtdnTtD+REwcgM5Wax873b5bd+
         OwHEvwgJlUHp4Onc46zwx5iOO+OoRw2bjXgMFyJPZ0bgiw9JugezyS6nRFHFiDK+7U
         6xgrH5L8QJQSdeG+UjebOSvADZoMNO5jbjODHXEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/106] ASoC: wm_adsp: Fix event generation for wm_adsp_fw_put()
Date:   Mon, 20 Jun 2022 14:50:40 +0200
Message-Id: <20220620124725.010349246@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
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

[ Upstream commit 2abdf9f80019e8244d3806ed0e1c9f725e50b452 ]

Currently wm_adsp_fw_put() returns 0 rather than 1 when updating the value
of the control, meaning that no event is generated to userspace. Fix this
by setting the default return value to 1, the code already exits early with
a return value of 0 if the value is unchanged.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220603115003.3865834-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index f7c800927cb2..08fc1a025b1a 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -794,7 +794,7 @@ int wm_adsp_fw_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	struct wm_adsp *dsp = snd_soc_component_get_drvdata(component);
-	int ret = 0;
+	int ret = 1;
 
 	if (ucontrol->value.enumerated.item[0] == dsp[e->shift_l].fw)
 		return 0;
-- 
2.35.1



