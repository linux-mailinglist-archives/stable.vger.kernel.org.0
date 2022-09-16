Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787ED5BAA89
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbiIPK1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiIPK0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:26:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5A3B2CCA;
        Fri, 16 Sep 2022 03:16:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6570EB824B2;
        Fri, 16 Sep 2022 10:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08FEC433D6;
        Fri, 16 Sep 2022 10:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323305;
        bh=XzJqPGh8ad7ZjLoasVaoLcyVIViWOGhH2VlHRi/F3rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acyjlkmG7QKCVM0tUOX6jpPC5p40ZS+6jLUX+p/apZYgj7WziBzImnJJK/B5M5uGC
         li9Zs/1ciJm2Bv1LrUjESuRd4+gZhzFZoxCpG2QXadshIQTOME3jVxHPiFNpDeh+zT
         gD2eO7AiWvtlzLiKU7XTOIOEVhrQEwDDqYdKcnrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 24/38] drm/amd/pm: use vbios carried pptable for all SMU13.0.7 SKUs
Date:   Fri, 16 Sep 2022 12:08:58 +0200
Message-Id: <20220916100449.481667755@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit b023053592646b1da9477b0b598f2cdd5d3f89d8 ]

For those SMU13.0.7 unsecure SKUs, the vbios carried pptable is ready to go.
Use that one instead of hardcoded softpptable.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 35 ++++++++++++-------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index 9cde13b07dd26..d9a5209aa8433 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -382,11 +382,27 @@ static int smu_v13_0_7_append_powerplay_table(struct smu_context *smu)
 	return 0;
 }
 
+static int smu_v13_0_7_get_pptable_from_pmfw(struct smu_context *smu,
+					     void **table,
+					     uint32_t *size)
+{
+	struct smu_table_context *smu_table = &smu->smu_table;
+	void *combo_pptable = smu_table->combo_pptable;
+	int ret = 0;
+
+	ret = smu_cmn_get_combo_pptable(smu);
+	if (ret)
+		return ret;
+
+	*table = combo_pptable;
+	*size = sizeof(struct smu_13_0_7_powerplay_table);
+
+	return 0;
+}
 
 static int smu_v13_0_7_setup_pptable(struct smu_context *smu)
 {
 	struct smu_table_context *smu_table = &smu->smu_table;
-	void *combo_pptable = smu_table->combo_pptable;
 	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
 
@@ -395,18 +411,11 @@ static int smu_v13_0_7_setup_pptable(struct smu_context *smu)
 	 * be used directly by driver. To get the raw pptable, we need to
 	 * rely on the combo pptable(and its revelant SMU message).
 	 */
-	if (adev->scpm_enabled) {
-		ret = smu_cmn_get_combo_pptable(smu);
-		if (ret)
-			return ret;
-
-		smu->smu_table.power_play_table = combo_pptable;
-		smu->smu_table.power_play_table_size = sizeof(struct smu_13_0_7_powerplay_table);
-	} else {
-		ret = smu_v13_0_setup_pptable(smu);
-		if (ret)
-			return ret;
-	}
+	ret = smu_v13_0_7_get_pptable_from_pmfw(smu,
+						&smu_table->power_play_table,
+						&smu_table->power_play_table_size);
+	if (ret)
+		return ret;
 
 	ret = smu_v13_0_7_store_powerplay_table(smu);
 	if (ret)
-- 
2.35.1



