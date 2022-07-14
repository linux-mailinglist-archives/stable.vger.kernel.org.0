Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418E45743A0
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbiGNEhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237529AbiGNEgd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:36:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC0FA456;
        Wed, 13 Jul 2022 21:26:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5162961EBD;
        Thu, 14 Jul 2022 04:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFF5C34114;
        Thu, 14 Jul 2022 04:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772799;
        bh=XqlTd4nTiZWMDUpAlCHbBSebnj0dDtBFRM1zS2k8yng=;
        h=From:To:Cc:Subject:Date:From;
        b=Fn3+jHct+LX0xrawNMPbu6bEtJTeGXtwTlumoEIBwMhBdKQa480h14LxI06QdvPKk
         SHriekNS8J4Ggy5P7IyMqwfolwwWLGTyn14fNNdiuZFK9t/pA3CwnAd9rACeyF2mYd
         9utzOEwz7l7m2gvxYGKxSCszcpaAs/+MEHWws5wMQ+wqHosl2aHH0rte9jGjBgiUBc
         IvFyd3KgbE6F6Q1mI4+JkO4L2mHdlJRhZQYIczO65kh74NqivigWRbkTVs/b32skf2
         kH/DVa1TclN9AyfWV6Qa7169ZUL7SkUBQbS1z00LQ1oyZSybGN7AvyENB9Y7uA9OZe
         n4oXnsGm6QuWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 1/6] ASoC: ops: Fix off by one in range control validation
Date:   Thu, 14 Jul 2022 00:26:31 -0400
Message-Id: <20220714042637.282511-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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

[ Upstream commit 5871321fb4558c55bf9567052b618ff0be6b975e ]

We currently report that range controls accept a range of 0..(max-min) but
accept writes in the range 0..(max-min+1). Remove that extra +1.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220604105246.4055214-1-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 7a37312c8e0c..453b61b42dd9 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -530,7 +530,7 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 		return -EINVAL;
 	if (mc->platform_max && tmp > mc->platform_max)
 		return -EINVAL;
-	if (tmp > mc->max - mc->min + 1)
+	if (tmp > mc->max - mc->min)
 		return -EINVAL;
 
 	if (invert)
@@ -551,7 +551,7 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 			return -EINVAL;
 		if (mc->platform_max && tmp > mc->platform_max)
 			return -EINVAL;
-		if (tmp > mc->max - mc->min + 1)
+		if (tmp > mc->max - mc->min)
 			return -EINVAL;
 
 		if (invert)
-- 
2.35.1

