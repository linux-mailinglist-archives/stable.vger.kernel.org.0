Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D17D5C0377
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiIUQFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiIUQET (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:04:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4D0175A9;
        Wed, 21 Sep 2022 08:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4B41B83096;
        Wed, 21 Sep 2022 15:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A66C433D7;
        Wed, 21 Sep 2022 15:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663775619;
        bh=HQt0Dir2v/OKPiuSGmulQLZyU2gBxDWR9oKGbTv2oXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7W0LYQrq9i9Eepr3my4AuGabEw4HpLT3Ps9ZWDylKt94pEMqEpKVm79V4zrMt/xF
         YA10fRBOEF3CmE24nwNwiAtNvHBDaWFS7BrPKa/1JAJPb1MQo64tGW8hTOdilGB86R
         6VlyYoOyraf0Rll5ejhdxOBETi9I7gUZa1iqKclVcn+5T4Y43Zfj2T2Rik+3TdmpYC
         NteF3TzHPXkAO33nYwaWYRi9IRsnzcSG/wbGSrf/5CFEenZsxu3VKnWw6phVP5jXUI
         lvVlvmhLUuOCPXbbdi11Eo7Kn0gWdojN8svp9ZIEDa5LWmRt2wW8Qh4SmZbGQkm4tN
         WSQB9TeTx4j/w==
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
Subject: [PATCH AUTOSEL 5.19 06/16] drm/amd/pm: disable BACO entry/exit completely on several sienna cichlid cards
Date:   Wed, 21 Sep 2022 11:53:22 -0400
Message-Id: <20220921155332.234913-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921155332.234913-1-sashal@kernel.org>
References: <20220921155332.234913-1-sashal@kernel.org>
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
index 32bb6b1d9526..d13e455c8827 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -368,6 +368,17 @@ static void sienna_cichlid_check_bxco_support(struct smu_context *smu)
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

