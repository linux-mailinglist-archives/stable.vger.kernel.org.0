Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F075F9550
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiJJASZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbiJJARs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:17:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4735E562;
        Sun,  9 Oct 2022 16:53:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69FB4B80DE4;
        Sun,  9 Oct 2022 23:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B999C433C1;
        Sun,  9 Oct 2022 23:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359585;
        bh=GE2YQiTOCkVprWu/xnAquC2VU2jYU3qYnrea42lOiBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2CGffiE8bBdtxPzgltaKnYtW0P7VWBu7Zv/yu+w4a4O3nf0DzlKXUmHLfnk7Qcyl
         EM+4WPaquQZKZ4Hoy/5LOgsGQxyid2AAE88cB0e2PN7oqSH2UsBuuaRweS68FbiN5A
         tuQnZ9iO/pF54L9wlK9v8iaMHGFj25D/jzZWyRqMRd8oZqFZ1b7yx2bN8xgw3Yf5wQ
         boJPIl6XKayUzMKbo030ki1IaULZGq7SE+oR0SaLKy89OhAYmLENkZAMCllRVi2AoE
         UTICglAcu0AVSfF3qqmu+HQLuSatmVttK2mXplzJDwzZsJ3oAf9uhDRtWFECZRp0uj
         ltwuphZdX76VA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifan Zha <Yifan.Zha@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@gmail.com, daniel@ffwll.ch, sonny.jiang@amd.com,
        evan.quan@amd.com, James.Zhu@amd.com, tim.huang@amd.com,
        Likun.Gao@amd.com, Stanley.Yang@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 12/36] drm/admgpu: Skip CG/PG on SOC21 under SRIOV VF
Date:   Sun,  9 Oct 2022 19:51:58 -0400
Message-Id: <20221009235222.1230786-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235222.1230786-1-sashal@kernel.org>
References: <20221009235222.1230786-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Yifan Zha <Yifan.Zha@amd.com>

[ Upstream commit 828418259254863e0af5805bd712284e2bd88e3b ]

[Why]
There is no CG(Clock Gating)/PG(Power Gating) requirement on SRIOV VF.
For multi VF, VF should not enable any CG/PG features.
For one VF, PF will program CG/PG related registers.

[How]
Do not set any cg/pg flag bit at early init under sriov.

Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Yifan Zha <Yifan.Zha@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index 8d5c452a9100..6d3bfb0f0346 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -551,6 +551,10 @@ static int soc21_common_early_init(void *handle)
 			AMD_PG_SUPPORT_JPEG |
 			AMD_PG_SUPPORT_ATHUB |
 			AMD_PG_SUPPORT_MMHUB;
+		if (amdgpu_sriov_vf(adev)) {
+			adev->cg_flags = 0;
+			adev->pg_flags = 0;
+		}
 		adev->external_rev_id = adev->rev_id + 0x1; // TODO: need update
 		break;
 	case IP_VERSION(11, 0, 2):
-- 
2.35.1

