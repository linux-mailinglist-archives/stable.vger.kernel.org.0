Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817485B83BD
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiINJDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiINJCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:02:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D23776457;
        Wed, 14 Sep 2022 02:01:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 597C2B8170C;
        Wed, 14 Sep 2022 09:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60702C43140;
        Wed, 14 Sep 2022 09:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146111;
        bh=RUselDYlOcAsICvqJ0Jg87IqgKRD31uJXYIX0ZCS6UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofFq37MMfbAwLMLRMlA7/KCRm3sycWVGj3qyvRzOprqX/jNWpOOh9aOTG4fJzBxW4
         jp6hUQ1sX3r9WGLZDMIAmaJ+Q3n7ksEFxMpvIpefzV8PAwygYSN2hw1EBBkBY1hUdo
         IFQjezoBUHbztvQ3F3YE3JVU7FazWFu7J05kqwBRCSes6NOHUiSBMxxjpR0gy3W2Pa
         j4VTEcglxL68l/UgZQH1Z2K9pRN7BbwjoMMErbTz78k3w43bsdugC1w/olPl0ntOp8
         n7QVQlWrU6VVtudTd4TLq1Op4je7JaFwAyiozftMq3Ayxl0w4zc2m4CmbY+kqlkore
         /uQhgfdp4Y9jg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mohan Kumar <mkumard@nvidia.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, thierry.reding@gmail.com, jonathanh@nvidia.com,
        spujar@nvidia.com, digetx@gmail.com, alsa-devel@alsa-project.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 13/22] ALSA: hda/tegra: Align BDL entry to 4KB boundary
Date:   Wed, 14 Sep 2022 05:00:54 -0400
Message-Id: <20220914090103.470630-13-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090103.470630-1-sashal@kernel.org>
References: <20220914090103.470630-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohan Kumar <mkumard@nvidia.com>

[ Upstream commit 8d44e6044a0e885acdd01813768a0b27906d64fd ]

AZA HW may send a burst read/write request crossing 4K memory boundary.
The 4KB boundary is not guaranteed by Tegra HDA HW. Make SW change to
include the flag AZX_DCAPS_4K_BDLE_BOUNDARY to align BDLE to 4K
boundary.

Signed-off-by: Mohan Kumar <mkumard@nvidia.com>
Link: https://lore.kernel.org/r/20220905172420.3801-1-mkumard@nvidia.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_tegra.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
index 7debb2c76aa62..976a112c7d006 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -474,7 +474,8 @@ MODULE_DEVICE_TABLE(of, hda_tegra_match);
 static int hda_tegra_probe(struct platform_device *pdev)
 {
 	const unsigned int driver_flags = AZX_DCAPS_CORBRP_SELF_CLEAR |
-					  AZX_DCAPS_PM_RUNTIME;
+					  AZX_DCAPS_PM_RUNTIME |
+					  AZX_DCAPS_4K_BDLE_BOUNDARY;
 	struct snd_card *card;
 	struct azx *chip;
 	struct hda_tegra *hda;
-- 
2.35.1

