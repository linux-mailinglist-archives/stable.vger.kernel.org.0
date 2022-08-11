Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E9F58FF71
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbiHKP3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235770AbiHKP3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:29:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3908995687;
        Thu, 11 Aug 2022 08:29:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42518B82153;
        Thu, 11 Aug 2022 15:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D25C433C1;
        Thu, 11 Aug 2022 15:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231759;
        bh=uhGj3sXlMWLnhbKS7l+x7ghdxc5RdmKGvX75RnpZqJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jj2FAYkyBe8hSd6XKeFdwdE9YjE7ncIasbxTmoOQ36LXYLZLFz8G/vrzdF2giseTo
         tj92r1l09CrBJ+Idsbr7m+tytC82ECEdJzSPVrbWZ5DAA2/XQNGR1AlYs8IfFF74Hn
         +xUYE3f30PZ0TEEYI1OU/DDBnS/HpSEvvFDjD0M2G6PrF+7Iegn0bgcqPVJh07S1am
         0QxAAOLdx1WwGzuL+Rbd3sD/PuQue5AEU76WSQa2nfmEYnB4S5ntBCM6liKqnD5t+C
         z1xSsQhqwmfcIWHXpJ/zJlQMIEU3gEtcl4pUhPwMJoj3AWuXABfwi9kBEwWnP+6uS5
         qCsbcwa/u8OrQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>, robh@kernel.org,
        tomeu.vizoso@collabora.com, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 007/105] drm/panfrost: Don't set L2_MMU_CONFIG quirks
Date:   Thu, 11 Aug 2022 11:26:51 -0400
Message-Id: <20220811152851.1520029-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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

[ Upstream commit d8e53d8a4e0ae842ef5e83e0dfb0796980f710cf ]

L2_MMU_CONFIG is an implementation-defined register. Different Mali GPUs
define slightly different MAX_READS and MAX_WRITES fields, which
throttle outstanding reads and writes when set to non-zero values. When
left as zero, reads and writes are not throttled.

Both kbase and panfrost always zero these registers. Per discussion with
Steven Price, there are two reasons these quirks may be used:

1. Simulating slower memory subsystems. This use case is only of
   interest to system-on-chip designers; it is not relevant to mainline.

2. Working around broken memory subsystems. Hopefully we never see this
   case in mainline. If we do, we'll need to set this register based on
   an SoC-compatible, rather than generally matching on the GPU model.

To the best of our knowledge, these fields are zero at reset, so the
write is not necessary. Let's remove the write to aid porting to new
Mali GPUs, which have different layouts for the L2_MMU_CONFIG register.

Suggested-by: Steven Price <steven.price@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220525145754.25866-8-alyssa.rosenzweig@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_gpu.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gpu.c b/drivers/gpu/drm/panfrost/panfrost_gpu.c
index 295bef27fb55..e1a6e763d0dc 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gpu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gpu.c
@@ -127,18 +127,6 @@ static void panfrost_gpu_init_quirks(struct panfrost_device *pfdev)
 	gpu_write(pfdev, GPU_TILER_CONFIG, quirks);
 
 
-	quirks = gpu_read(pfdev, GPU_L2_MMU_CONFIG);
-
-	/* Limit read & write ID width for AXI */
-	if (panfrost_has_hw_feature(pfdev, HW_FEATURE_3BIT_EXT_RW_L2_MMU_CONFIG))
-		quirks &= ~(L2_MMU_CONFIG_3BIT_LIMIT_EXTERNAL_READS |
-			    L2_MMU_CONFIG_3BIT_LIMIT_EXTERNAL_WRITES);
-	else
-		quirks &= ~(L2_MMU_CONFIG_LIMIT_EXTERNAL_READS |
-			    L2_MMU_CONFIG_LIMIT_EXTERNAL_WRITES);
-
-	gpu_write(pfdev, GPU_L2_MMU_CONFIG, quirks);
-
 	quirks = 0;
 	if ((panfrost_model_eq(pfdev, 0x860) || panfrost_model_eq(pfdev, 0x880)) &&
 	    pfdev->features.revision >= 0x2000)
-- 
2.35.1

