Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72AEC644076
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 10:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbiLFJwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 04:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235319AbiLFJvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 04:51:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402002315F;
        Tue,  6 Dec 2022 01:51:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3C24B818ED;
        Tue,  6 Dec 2022 09:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2C7C433D7;
        Tue,  6 Dec 2022 09:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320259;
        bh=7hHdQtpeJgUhhlVrjaF3QqUWI/qXbxg2b5hWeRvhBPo=;
        h=From:To:Cc:Subject:Date:From;
        b=EPGu40n3As8TBxrYOJSOPyZ9fIXVNpqVvBNIQGxVsJpmuK4qMD2cPQjEojUaoUU34
         wugXU6ZF0rJhVN+Xv6yvWqVe2tXok7QqLuceZQYAWvDlM1RL6LlzEernFi/LEgvoAA
         JB6KPvoQfl9Pq4ePM/pO/lOtzC4OnGfDhK8BAjqBvulEVt5mzw966Bjs1i+8tGt8Xd
         la0owBHy92M+h9DDELv++ZNnS2v7p2T3X26gNerwKZnZZLDoA2+EcRGVW2LOAEp5aI
         OAMw0x55R9yR8oWiVeQqKJHtFV5G2xmoyRflw8zUapVv//2x6wWy46ie3HolxNJ+NI
         u/0I75DCWY86g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 1/5] ASoC: ops: Check bounds for second channel in snd_soc_put_volsw_sx()
Date:   Tue,  6 Dec 2022 04:50:51 -0500
Message-Id: <20221206095055.987728-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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
index 453b61b42dd9..00e6a6e46fe5 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -460,6 +460,12 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	if (snd_soc_volsw_is_stereo(mc)) {
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

