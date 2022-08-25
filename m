Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEBA5A0600
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbiHYBhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiHYBhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:37:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4969A97A;
        Wed, 24 Aug 2022 18:36:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 322A6CE1927;
        Thu, 25 Aug 2022 01:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A256C43150;
        Thu, 25 Aug 2022 01:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391370;
        bh=RByfm/GMgOtnq7bK11xgHjpmVsDWy7v99buNjhiYVIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRO5elntl/ZcRCH9abaHcYG2dB+KIRYzdJ7EVU9SNlT3mUUHUF6K9ySkiyScDe/Fx
         sD4jAJUU9/N+zeTf+mMEnc/Xpqx/Fh5ClNJXbrAk3e4Qx9cgJpR5NCgTu1FXKcDVRt
         qjtFTWFL/F8oKsH8N7G3+H0I6XpG32Q8heUTV+9dZnbvfkhdms+SWmge0JwtPiVGAn
         5u3YZSO2KuQBN1HuoE0uW8uUsf4jyRHwFdmKqauu5aWgqzZWG/R2ZmQau3z8p6ESos
         dtShWRpDiFCwJPl9qT5i8VAda+70zg6/pFrMzn4hP/e37ufOFI8DK3Y52If184FLPX
         5dGU6yJRk3joA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, Likun.Gao@amd.com, lijo.lazar@amd.com,
        KevinYang.Wang@amd.com, YiPeng.Chai@amd.com, kenneth.feng@amd.com,
        Jack.Gui@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 23/38] drm/amd/pm: add missing ->fini_xxxx interfaces for some SMU13 asics
Date:   Wed, 24 Aug 2022 21:33:46 -0400
Message-Id: <20220825013401.22096-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
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

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 4bac1c846eff8042dd59ddecd0a43f3b9de5fd23 ]

Without these, potential memory leak may be induced.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c | 2 ++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index 7432b3e76d3d..201546c36994 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -1583,7 +1583,9 @@ static const struct pptable_funcs smu_v13_0_0_ppt_funcs = {
 	.dump_pptable = smu_v13_0_0_dump_pptable,
 	.init_microcode = smu_v13_0_init_microcode,
 	.load_microcode = smu_v13_0_load_microcode,
+	.fini_microcode = smu_v13_0_fini_microcode,
 	.init_smc_tables = smu_v13_0_0_init_smc_tables,
+	.fini_smc_tables = smu_v13_0_fini_smc_tables,
 	.init_power = smu_v13_0_init_power,
 	.fini_power = smu_v13_0_fini_power,
 	.check_fw_status = smu_v13_0_check_fw_status,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index 4e1861fb2c6a..9cde13b07dd2 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -1539,7 +1539,9 @@ static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.dump_pptable = smu_v13_0_7_dump_pptable,
 	.init_microcode = smu_v13_0_init_microcode,
 	.load_microcode = smu_v13_0_load_microcode,
+	.fini_microcode = smu_v13_0_fini_microcode,
 	.init_smc_tables = smu_v13_0_7_init_smc_tables,
+	.fini_smc_tables = smu_v13_0_fini_smc_tables,
 	.init_power = smu_v13_0_init_power,
 	.check_fw_status = smu_v13_0_7_check_fw_status,
 	.setup_pptable = smu_v13_0_7_setup_pptable,
-- 
2.35.1

