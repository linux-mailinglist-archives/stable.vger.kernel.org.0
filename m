Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECE85902B5
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236741AbiHKQMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236312AbiHKQMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:12:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D397C19E;
        Thu, 11 Aug 2022 08:57:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F067B82160;
        Thu, 11 Aug 2022 15:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC65C433D6;
        Thu, 11 Aug 2022 15:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233426;
        bh=uAXzZINES3nmOB+mBHuxi0LFvyWjuvJOJe20ERFCLNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WqXYhJnzGluuFljGK08TIF5+gnNLob2VjzBV45AEmVDGBXvXu7HG77ZbxGNQEQVRX
         BynvU/a5L4DqSvcYSXM+MWBad1UV/vd/wbyW/oOdZ398PDjmyRe9Cnjx7pz1uB6lWJ
         RIbsaGHPfpKZkPzzQPd1QgzbtR5WUricgDJ6rqvtjOTjiaMG2BhXdjl9jZ9nJrY5NW
         HxtdAc8ftnFm4I8Mag5Wt7qATq06ShiMzMG0W47cboM+C3lEXNwkuy6doQh9fbyX7o
         8AoVzQadFssJuS9rj7UAD7rP7zuHBy7fJHBx9b8NJuzDTjLd2CBjywq7HYPYsKwr9R
         ENd5czbPGdRZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>, robh@kernel.org,
        tomeu.vizoso@collabora.com, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 06/69] drm/panfrost: Handle HW_ISSUE_TTRX_2968_TTRX_3162
Date:   Thu, 11 Aug 2022 11:55:15 -0400
Message-Id: <20220811155632.1536867-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
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

From: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>

[ Upstream commit 382435709516c1a7dc3843872792abf95e786c83 ]

Add handling for the HW_ISSUE_TTRX_2968_TTRX_3162 quirk. Logic ported
from kbase. kbase lists this workaround as used on Mali-G57.

Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220525145754.25866-3-alyssa.rosenzweig@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_gpu.c    | 3 +++
 drivers/gpu/drm/panfrost/panfrost_issues.h | 3 +++
 drivers/gpu/drm/panfrost/panfrost_regs.h   | 1 +
 3 files changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.c b/drivers/gpu/drm/panfrost/panfrost_gpu.c
index f8355de6e335..a3cdf3e86ef3 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -108,6 +108,9 @@ static void panfrost_gpu_init_quirks(struct panfrost_device *pfdev)
 			quirks |= SC_LS_ALLOW_ATTR_TYPES;
 	}
 
+	if (panfrost_has_hw_issue(pfdev, HW_ISSUE_TTRX_2968_TTRX_3162))
+		quirks |= SC_VAR_ALGORITHM;
+
 	if (panfrost_has_hw_feature(pfdev, HW_FEATURE_TLS_HASHING))
 		quirks |= SC_TLS_HASH_ENABLE;
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_issues.h b/drivers/gpu/drm/panfrost/panfrost_issues.h
index 8e59d765bf19..3af7d723377e 100644
--- a/drivers/gpu/drm/panfrost/panfrost_issues.h
+++ b/drivers/gpu/drm/panfrost/panfrost_issues.h
@@ -125,6 +125,9 @@ enum panfrost_hw_issue {
 	 * kernel must fiddle with L2 caches to prevent data leakage */
 	HW_ISSUE_TGOX_R1_1234,
 
+	/* Must set SC_VAR_ALGORITHM */
+	HW_ISSUE_TTRX_2968_TTRX_3162,
+
 	HW_ISSUE_END
 };
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_regs.h b/drivers/gpu/drm/panfrost/panfrost_regs.h
index 6c5a11ef1ee8..28f5aae58d9c 100644
--- a/drivers/gpu/drm/panfrost/panfrost_regs.h
+++ b/drivers/gpu/drm/panfrost/panfrost_regs.h
@@ -195,6 +195,7 @@
 #define SC_TLS_HASH_ENABLE		BIT(17)
 #define SC_LS_ATTR_CHECK_DISABLE	BIT(18)
 #define SC_ENABLE_TEXGRD_FLAGS		BIT(25)
+#define SC_VAR_ALGORITHM		BIT(29)
 /* End SHADER_CONFIG register */
 
 /* TILER_CONFIG register */
-- 
2.35.1

