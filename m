Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC6D540BF7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345952AbiFGScf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351772AbiFGSaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D3C34B8C;
        Tue,  7 Jun 2022 10:55:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A10BA617A6;
        Tue,  7 Jun 2022 17:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1471C34119;
        Tue,  7 Jun 2022 17:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624547;
        bh=NXa1J+I2sAkxDWNmDYdzt2EPtQnTfLbT30iET12VL7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBWLVvRs8aL1NYIgUlBsNw22dHkznxEEvNus5xohNSOhBVggaVQuVOVjKPPCntxBp
         DwThHQmXJbOT5hcLNUJoDM5SCWPV2lL9M/g1oszb/08cTHwZQoGZojtFHQ9UTm2Spx
         kmsK6cHsjDcxv8xGeu80Scn1U8vAl4EzQlWacAhjNjKkIMynknPuoIhEAU4X13FM7a
         ffYJXTip9scG6mJZB322aure0XtNWjDG8/vhBruuLKpT2jfQmmgsM6I5bdeepLT4Vc
         rzUJwgbZh/6+3yi0dxvUDOfnf+7yLdt8pyJwt33+v1l7E0JL5TFevEOmEueVPA94+N
         K4yhFOq9N0wuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, evan.quan@amd.com,
        alexander.deucher@amd.com, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        lijo.lazar@amd.com, guchun.chen@amd.com, Jack.Gui@amd.com,
        darren.powell@amd.com, Hawking.Zhang@amd.com,
        mario.limonciello@amd.com, kenneth.feng@amd.com, tim.huang@amd.com,
        kevin1.wang@amd.com, Xiaomeng.Hou@amd.com, tao.zhou1@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 59/60] drm/amd/pm: use bitmap_{from,to}_arr32 where appropriate
Date:   Tue,  7 Jun 2022 13:52:56 -0400
Message-Id: <20220607175259.478835-59-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yury Norov <yury.norov@gmail.com>

[ Upstream commit 525d6515604eb1373ce5e6372a6b6640953b2d6a ]

The smu_v1X_0_set_allowed_mask() uses bitmap_copy() to convert
bitmap to 32-bit array. This may be wrong due to endiannes issues.
Fix it by switching to bitmap_{from,to}_arr32.

CC: Alexander Gordeev <agordeev@linux.ibm.com>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Christian Borntraeger <borntraeger@linux.ibm.com>
CC: Claudio Imbrenda <imbrenda@linux.ibm.com>
CC: David Hildenbrand <david@redhat.com>
CC: Heiko Carstens <hca@linux.ibm.com>
CC: Janosch Frank <frankja@linux.ibm.com>
CC: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: Sven Schnelle <svens@linux.ibm.com>
CC: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c | 2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
index 4e9e2cf39859..5fcbec9dd45d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -777,7 +777,7 @@ int smu_v11_0_set_allowed_mask(struct smu_context *smu)
 		goto failed;
 	}
 
-	bitmap_copy((unsigned long *)feature_mask, feature->allowed, 64);
+	bitmap_to_arr32(feature_mask, feature->allowed, 64);
 
 	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetAllowedFeaturesMaskHigh,
 					  feature_mask[1], NULL);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index b54790d3483e..4a5e91b59f0c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -726,7 +726,7 @@ int smu_v13_0_set_allowed_mask(struct smu_context *smu)
 	if (bitmap_empty(feature->allowed, SMU_FEATURE_MAX) || feature->feature_num < 64)
 		goto failed;
 
-	bitmap_copy((unsigned long *)feature_mask, feature->allowed, 64);
+	bitmap_to_arr32(feature_mask, feature->allowed, 64);
 
 	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetAllowedFeaturesMaskHigh,
 					      feature_mask[1], NULL);
-- 
2.35.1

