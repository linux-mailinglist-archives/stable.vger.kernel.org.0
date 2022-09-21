Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1BC5C03A5
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbiIUQIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbiIUQHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:07:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007E9A3D66;
        Wed, 21 Sep 2022 08:55:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E399B830CA;
        Wed, 21 Sep 2022 15:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F15FC433C1;
        Wed, 21 Sep 2022 15:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663775651;
        bh=Gl9io5BLtE9CCwEPd3iswAcZ+PjuZKqsZXFtnvw+MfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntjpyL4/iDL2Zndu2V1kyZ4g18XN3AkYLOqIZkInx80P8qHcv0rOajUaxNyHGULm2
         09wLyj/l2ULGoRHbIbviOIQEvAYvOMGx7rTjHQCa0pnUgtPm5ZRW3wGxiSyiHx69ob
         ydMMy2g7LvzYgvBcpPOJ4/nldZiXle9MNNeE/f7jnOJX6BicDyFjpCpoG6fZaPhKMy
         DamdVxNeP3E6eyB6j9SU500bQTqdJhgYSh1s0rqNUNqPVJsBn1ybHIwVam/e1piJYa
         EDHD4+BV0lkP2XMwywoo+7g06znXnWKlxAU+oB+twsv3DHUKE+FcQoqabvSBgmJLwz
         W2Jjhc3HZWWBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guchun Chen <guchun.chen@amd.com>, Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, evan.quan@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, luben.tuikov@amd.com,
        sathishkumar.sundararaju@amd.com, danijel.slivka@amd.com,
        Mohammadzafar.ziya@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 04/10] drm/amd/pm: disable BACO entry/exit completely on several sienna cichlid cards
Date:   Wed, 21 Sep 2022 11:54:01 -0400
Message-Id: <20220921155407.235132-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921155407.235132-1-sashal@kernel.org>
References: <20220921155407.235132-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 7c6fb61a400bf3218c6504cb2d48858f98822c9d ]

To avoid hardware intermittent failures.

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 79976921dc46..c71d50e82168 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -358,6 +358,17 @@ static void sienna_cichlid_check_bxco_support(struct smu_context *smu)
 		smu_baco->platform_support =
 			(val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true :
 									false;
+
+		/*
+		 * Disable BACO entry/exit completely on below SKUs to
+		 * avoid hardware intermittent failures.
+		 */
+		if (((adev->pdev->device == 0x73A1) &&
+		    (adev->pdev->revision == 0x00)) ||
+		    ((adev->pdev->device == 0x73BF) &&
+		    (adev->pdev->revision == 0xCF)))
+			smu_baco->platform_support = false;
+
 	}
 }
 
-- 
2.35.1

