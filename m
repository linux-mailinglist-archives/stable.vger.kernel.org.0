Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0DD66C4B3
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjAPP5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbjAPP5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6190A234CD
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:57:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D57396102D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB472C433D2;
        Mon, 16 Jan 2023 15:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884631;
        bh=9S49RvK0Myy6KGTNRM2Bz2WXdLcMqxKuDPtAr1jYYAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaYWXwwi8GyDcjfOXxJMEEs2J8jfjHvn60Hedx7M6zaznKPRmzt9rFDPrxJZys9jN
         h744CC4WPg05f0JBI30GqOTugCDKUS/HxCMHPhmcx/wgun52JR7zx8HFgy0dUdf5KN
         b1lKFQyra2nJ5X9LpCh4hbiYdiAFraztPtwkEr6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>,
        Leo Liu <leo.liu@amd.com>, Yifan Zhang <yifan1.zhang@amd.com>,
        Aaron Liu <aaron.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/183] drm/amdgpu: Enable pg/cg flags on GC11_0_4 for VCN
Date:   Mon, 16 Jan 2023 16:50:03 +0100
Message-Id: <20230116154806.812464496@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>

[ Upstream commit 2a0fe2ca6e9c9bf9c47a9f9f0d67c13281a13f8c ]

This enable VCN PG, CG and JPEG PG, CG

Signed-off-by: Saleemkhan Jamadar <saleemkhan.jamadar@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e1d900df63ad ("drm/amdgpu: enable VCN DPG for GC IP v11.0.4")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index 26f1e4edb4d5..599ddc28d8e1 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -654,8 +654,11 @@ static int soc21_common_early_init(void *handle)
 		adev->external_rev_id = adev->rev_id + 0x20;
 		break;
 	case IP_VERSION(11, 0, 4):
-		adev->cg_flags = 0;
-		adev->pg_flags = 0;
+		adev->cg_flags = AMD_CG_SUPPORT_VCN_MGCG |
+			AMD_CG_SUPPORT_JPEG_MGCG;
+		adev->pg_flags = AMD_PG_SUPPORT_VCN |
+			AMD_PG_SUPPORT_GFX_PG |
+			AMD_PG_SUPPORT_JPEG;
 		adev->external_rev_id = adev->rev_id + 0x1;
 		break;
 
-- 
2.35.1



