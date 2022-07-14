Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7EF574251
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbiGNEXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbiGNEWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:22:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F280627CFF;
        Wed, 13 Jul 2022 21:22:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B9D3B8236F;
        Thu, 14 Jul 2022 04:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FFDC34114;
        Thu, 14 Jul 2022 04:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772559;
        bh=SlrhLM8CiLrapZm3BcyHGoU9JGNSw8/TZ+SDGIgRx/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spNymYqVCh0VaMWmPYn/TkX9P2j5PXyuXnOCmp/AyAeeXffPbtrGqj++I7FD25LN9
         V+JwoJuhYWt8ApvcRCuPcJ7c8MNg+g4vW4okKGlgmSU8T5dfg+Y/pXcl0sYpR0Als1
         sA3O+SPwGsg7lwd7XpNO3KNwmN4S7JO3Ob3JQB038NsgYSmcYXsUD0k8TtQsqyNLgd
         EmaZsmdrb/aivrV1BjN8hwcxgxv2s7pR7BAdMy+OK3/yHcZb0Bq/rHzy9t4SredoWd
         +KrBtGjsSDuu/MeQbCen3QuAwHoMiHS5iLwDWOYVBGLhQ004UHxKXh8qYj+J+7Suqt
         mQBiNB/m45u0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, oder_chiou@realtek.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.18 07/41] ASoC: rt7*-sdw: harden jack_detect_handler
Date:   Thu, 14 Jul 2022 00:21:47 -0400
Message-Id: <20220714042221.281187-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 0484271ab0ce50649329fa9dc23c50853c5b26a4 ]

Realtek headset codec drivers typically check if the card is
instantiated before proceeding with the jack detection.

The rt700, rt711 and rt711-sdca are however missing a check on the
card pointer, which can lead to NULL dereferences encountered in
driver bind/unbind tests.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220606203752.144159-6-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt700.c      | 2 +-
 sound/soc/codecs/rt711-sdca.c | 2 +-
 sound/soc/codecs/rt711.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt700.c b/sound/soc/codecs/rt700.c
index e61a8257bf64..1f4da32639d4 100644
--- a/sound/soc/codecs/rt700.c
+++ b/sound/soc/codecs/rt700.c
@@ -162,7 +162,7 @@ static void rt700_jack_detect_handler(struct work_struct *work)
 	if (!rt700->hs_jack)
 		return;
 
-	if (!rt700->component->card->instantiated)
+	if (!rt700->component->card || !rt700->component->card->instantiated)
 		return;
 
 	reg = RT700_VERB_GET_PIN_SENSE | RT700_HP_OUT;
diff --git a/sound/soc/codecs/rt711-sdca.c b/sound/soc/codecs/rt711-sdca.c
index e5a0ec984bdd..9c88c92c0abc 100644
--- a/sound/soc/codecs/rt711-sdca.c
+++ b/sound/soc/codecs/rt711-sdca.c
@@ -294,7 +294,7 @@ static void rt711_sdca_jack_detect_handler(struct work_struct *work)
 	if (!rt711->hs_jack)
 		return;
 
-	if (!rt711->component->card->instantiated)
+	if (!rt711->component->card || !rt711->component->card->instantiated)
 		return;
 
 	/* SDW_SCP_SDCA_INT_SDCA_0 is used for jack detection */
diff --git a/sound/soc/codecs/rt711.c b/sound/soc/codecs/rt711.c
index 39f7ded1371e..3cb4bf76c021 100644
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -242,7 +242,7 @@ static void rt711_jack_detect_handler(struct work_struct *work)
 	if (!rt711->hs_jack)
 		return;
 
-	if (!rt711->component->card->instantiated)
+	if (!rt711->component->card || !rt711->component->card->instantiated)
 		return;
 
 	if (pm_runtime_status_suspended(rt711->slave->dev.parent)) {
-- 
2.35.1

