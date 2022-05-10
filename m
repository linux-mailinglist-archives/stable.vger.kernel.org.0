Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0EB521FA8
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346223AbiEJPwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346540AbiEJPvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:51:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85F428B863;
        Tue, 10 May 2022 08:45:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 562E261426;
        Tue, 10 May 2022 15:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA43C385C2;
        Tue, 10 May 2022 15:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197517;
        bh=+m4xr2VstQvfmpmlbh/Hzx8ERJ0r2on0tJLdU5O4+6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+AYDTtGfc6NI6/rRcZetALBPs3cQsacGkCe8eQOFc3nNjzE3K1u1sR6Wf2r1eMSQ
         DOKiy51xa6N8fB6GnIGfpdepRuY6MNcQXeqhhhrCNGYHnJzVGjXIGUsAmYmoIAn24C
         hO9adxcLXRxL86B8cRV3Pbm9DEromxKJd+vdGvtUmyEELAed2Pu4CSGlpl0qVEfbmt
         LkFrBAKgccQwRwA9Sl8eYNlIPeWtEHv1joqXwkHk2X1dH+uXZ/yGcGqg/Rk2juSh8B
         id97JSjchfuAFQRAphq/bxFleM48YP+7Z689ufYAQ6BslRdHaKLChnx7eSVoW8tC6n
         48plY8Yb5RKwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        pierre-louis.bossart@linux.intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 2/9] ASoC: max98090: Reject invalid values in custom control put()
Date:   Tue, 10 May 2022 11:45:05 -0400
Message-Id: <20220510154512.153945-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510154512.153945-1-sashal@kernel.org>
References: <20220510154512.153945-1-sashal@kernel.org>
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

[ Upstream commit 2fbe467bcbfc760a08f08475eea6bbd4c2874319 ]

The max98090 driver has a custom put function for some controls which can
only be updated in certain circumstances which makes no effort to validate
that input is suitable for the control, allowing out of spec values to be
written to the hardware and presented to userspace. Fix this by returning
an error when invalid values are written.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220420193454.2647908-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98090.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 945a79e4f3eb..779845e3a9e3 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -413,6 +413,9 @@ static int max98090_put_enab_tlv(struct snd_kcontrol *kcontrol,
 
 	val = (val >> mc->shift) & mask;
 
+	if (sel < 0 || sel > mc->max)
+		return -EINVAL;
+
 	*select = sel;
 
 	/* Setting a volume is only valid if it is already On */
-- 
2.35.1

