Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D85F657EAC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbiL1P43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbiL1P4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:56:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E92216597
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:56:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6E24B817B0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34962C433D2;
        Wed, 28 Dec 2022 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242965;
        bh=TysLWZxsnVb8erUgU7pXb3w5UkFrysFkGEmLXlYnk4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FM9CVDQEDoWeH7w/GrkvMIRETPjXvBh0q044+mo8UqXPT6ISqOLnbnxE/i/u9NStn
         grFUOVLbIrbwEDSB5JLS5l7zECf+Ejs4pP+6BZ6SKoZOAG4LoFQoitPchUc1pGrjon
         Wd4SNCvP845QCg3YqEX0L5yGjFOoW0oK4xZFQD9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lijo Lazar <lijo.lazar@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0435/1146] drm/amd/pm/smu11: BACO is supported when its in BACO state
Date:   Wed, 28 Dec 2022 15:32:54 +0100
Message-Id: <20221228144341.996457193@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit 6dca7efe6e522bf213c7dab691fa580d82f48f74 ]

Return true early if ASIC is in BACO state already, no need
to talk to SMU. It can fix the issue that driver was not
calling BACO exit at all in runtime pm resume, and a timing
issue leading to a PCI AER error happened eventually.

Fixes: 8795e182b02d ("PCI/portdrv: Don't disable AER reporting in get_port_device_capability()")
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
index 70b560737687..ad5f6a15a1d7 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1588,6 +1588,10 @@ bool smu_v11_0_baco_is_support(struct smu_context *smu)
 	if (amdgpu_sriov_vf(smu->adev) || !smu_baco->platform_support)
 		return false;
 
+	/* return true if ASIC is in BACO state already */
+	if (smu_v11_0_baco_get_state(smu) == SMU_BACO_STATE_ENTER)
+		return true;
+
 	/* Arcturus does not support this bit mask */
 	if (smu_cmn_feature_is_supported(smu, SMU_FEATURE_BACO_BIT) &&
 	   !smu_cmn_feature_is_enabled(smu, SMU_FEATURE_BACO_BIT))
-- 
2.35.1



