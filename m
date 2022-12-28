Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6EA657970
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiL1PBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbiL1PA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:00:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663161263D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:00:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 067826153B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AA3C433EF;
        Wed, 28 Dec 2022 15:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239656;
        bh=YZHBE/QsmYJTIOgxlNvDplpzhbgG3WKEoKETH6NkGUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHKMIYvcRd4bjw5OkL6Vi/A8CJtl6jfnNkitw9YYOSvFZw2xBKftXEOjhe4Aztwiw
         bxTKgEZeyfaotkg8lv3MjMrZH6+us3tuL06ErfVzF2VfrU5TuEr80K4m7eSEWnfD10
         5S1yk7TIPHY/hnPp9focWj2jifI8xib6tFS5xPNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lijo Lazar <lijo.lazar@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 254/731] drm/amd/pm/smu11: BACO is supported when its in BACO state
Date:   Wed, 28 Dec 2022 15:36:01 +0100
Message-Id: <20221228144303.925084741@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 614c3d049514..83fa3d20a1d5 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1595,6 +1595,10 @@ bool smu_v11_0_baco_is_support(struct smu_context *smu)
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



