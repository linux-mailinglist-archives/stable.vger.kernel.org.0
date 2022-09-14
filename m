Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9075B8410
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiINJHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiINJGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:06:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDE9754A3;
        Wed, 14 Sep 2022 02:03:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E31BA6190D;
        Wed, 14 Sep 2022 09:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD70C43470;
        Wed, 14 Sep 2022 09:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663146174;
        bh=w8J7WeZoAmtAVa2bitCJ9ueRJcsRqLvy4sotjojZBno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJyojNLIXrXCdLruTMLXRzmQUNW+8zTnnDFK6QV2B4AwqAab9VC9ZzMyLI/q461bv
         Bdb56xr+YmJAaKIP1wNRCyE8ySu4RpudwGEVEMMwJ86NFsiwkO5IYMQuqjL7/1W4Cp
         o1CdtBho7cH1v4Z1pVHHhGRmr9Kho1Zt+Zlqlc8+iivReS0uhWEuNa7U2KJI48fIVt
         ieog4F0Z5duiuFGcg5CleXHLN7hDwgKBZ3u4k3O08/diYynnN7Upkr/wBpeIaQwSAv
         VU53Zd//A7NRYL8I+5YZbjdW4qJSOi4DAxM6q6qL1ECvTI2zbyJNAwA0BZYNhk2rLB
         JO4ZWXIJ+8GfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mohan Kumar <mkumard@nvidia.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, thierry.reding@gmail.com, jonathanh@nvidia.com,
        digetx@gmail.com, spujar@nvidia.com, alsa-devel@alsa-project.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/16] ALSA: hda/tegra: Align BDL entry to 4KB boundary
Date:   Wed, 14 Sep 2022 05:02:17 -0400
Message-Id: <20220914090224.470913-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220914090224.470913-1-sashal@kernel.org>
References: <20220914090224.470913-1-sashal@kernel.org>
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
index 773f4903550a0..f0e556f2ccf69 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -451,7 +451,8 @@ MODULE_DEVICE_TABLE(of, hda_tegra_match);
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

