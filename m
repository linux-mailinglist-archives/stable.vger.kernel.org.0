Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E032A64405A
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbiLFJv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiLFJuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:50:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959B91B9CB;
        Tue,  6 Dec 2022 01:50:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35644615FA;
        Tue,  6 Dec 2022 09:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52117C433C1;
        Tue,  6 Dec 2022 09:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320203;
        bh=jVKkcmQg3xhs+2+IEpH/E10NCA5+mVsH+Xu57wyAYaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHwEqQbUsPUOBiQkUyzFLwCSw4pHoFe7uX94xektFKy3/ssoL3jugBH+j1hjhxi1E
         1yc9ONHUolpEGwPunv9KZ9zlol2kl9jtBobb4uD4N2FR1IqaPp/EezB232BIPmh9yj
         vXR0bl5Xpq4FvNR0+t5bE3zlEn/FqsIHty65tYilAibmnNjejUkZkgCQ/N8Q30tu+e
         HhZEpur1+TrRr1cJxpCJCTSD2Y/rPCLdrGV5UzWjG2uzvdAi97amiYvTpHATBArgW3
         IuKUKTIPmUE/pA1sLABk6CKHcqjNs9+46vGZzsu8B07jzRtY9+g2ml/6nFIkVIcSpW
         C5Ew7q1KtcdFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 03/12] ASoC: ops: Check bounds for second channel in snd_soc_put_volsw_sx()
Date:   Tue,  6 Dec 2022 04:49:45 -0500
Message-Id: <20221206094955.987437-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206094955.987437-1-sashal@kernel.org>
References: <20221206094955.987437-1-sashal@kernel.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 97eea946b93961fffd29448dcda7398d0d51c4b2 ]

The bounds checks in snd_soc_put_volsw_sx() are only being applied to the
first channel, meaning it is possible to write out of bounds values to the
second channel in stereo controls. Add appropriate checks.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220511134137.169575-2-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index e73360e9de8f..c18808477819 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -451,6 +451,12 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 
 		val_mask = mask << rshift;
 		val2 = (ucontrol->value.integer.value[1] + min) & mask;
+
+		if (mc->platform_max && val2 > mc->platform_max)
+			return -EINVAL;
+		if (val2 > max)
+			return -EINVAL;
+
 		val2 = val2 << rshift;
 
 		err = snd_soc_component_update_bits(component, reg2, val_mask,
-- 
2.35.1

