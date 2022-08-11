Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E5359023C
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbiHKQHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbiHKQGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:06:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1DAB9FB4;
        Thu, 11 Aug 2022 08:53:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1979960F3D;
        Thu, 11 Aug 2022 15:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06948C433D6;
        Thu, 11 Aug 2022 15:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233209;
        bh=4FXxmeamZE/+Ek8SymR31JLl1PEr4R8InY2NDrVuePw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rS7Ea1eDOyg5Bt8svTq/kkofZdAIa6syM7FbiD93IytzU/j23nXmq9MkB24m0jTp7
         aqSiyV5GRIQkUdGl0XfFJRiwmF8AEJgOTPEaJO8I1avIabsdsMGiMoLETiCAZmPHgf
         88w3AeZ4ehci30B6pmfp5q3Garg1ATst0UncmQqtx8VBdiZB5X44/jEsT9rIRMm+rR
         bNHvUaHGbG/ty4e8IT28ii1IAH3xeJgETtsaZfL5JCG+t5B4XE+6Ztvr2cEpMHJmoj
         xjnAKe1B5WrJqXz79IPUgUMs6XvRB4JWIMGbbNsuyBFXabXE2AofXmGKNTNDfllgMn
         B1AqvsrUC4hEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     lin cao <lin.cao@amd.com>, Jingwen Chen <Jingwen.Chen2@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, evan.quan@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, lijo.lazar@amd.com, guchun.chen@amd.com,
        luben.tuikov@amd.com, sathishkumar.sundararaju@amd.com,
        danijel.slivka@amd.com, Mohammadzafar.ziya@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 67/93] drm/amdgpu: Call trace info was found in dmesg when loading amdgpu
Date:   Thu, 11 Aug 2022 11:42:01 -0400
Message-Id: <20220811154237.1531313-67-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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

From: lin cao <lin.cao@amd.com>

[ Upstream commit 748262eb400e809aa13e3485f4983c3db3d0ebb3 ]

In the case of SRIOV, the register smnMp1_PMI_3_FIFO will get an invalid
value which will cause the "shift out of bound". In Ubuntu22.04, this
issue will be checked an related call trace will be reported in dmesg.

Signed-off-by: lin cao <lin.cao@amd.com>
Reviewed-by: Jingwen Chen <Jingwen.Chen2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 7a1e225fb823..971a9712fa63 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -758,6 +758,7 @@ static void sienna_cichlid_stb_init(struct smu_context *smu);
 
 static int sienna_cichlid_init_smc_tables(struct smu_context *smu)
 {
+	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
 
 	ret = sienna_cichlid_tables_init(smu);
@@ -768,7 +769,8 @@ static int sienna_cichlid_init_smc_tables(struct smu_context *smu)
 	if (ret)
 		return ret;
 
-	sienna_cichlid_stb_init(smu);
+	if (!amdgpu_sriov_vf(adev))
+		sienna_cichlid_stb_init(smu);
 
 	return smu_v11_0_init_smc_tables(smu);
 }
-- 
2.35.1

