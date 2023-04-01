Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4626D2CD1
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbjDABnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbjDABn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:43:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7DB20C0F;
        Fri, 31 Mar 2023 18:43:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06AEE62CFD;
        Sat,  1 Apr 2023 01:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E24C433D2;
        Sat,  1 Apr 2023 01:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313358;
        bh=/D4nHdOgubPpYjY6rrUOP3UQHzHPzlTIcnEkY36hxPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpZT1G6HiKo6+K3SuAd6J230jGEVl1vnrGQSj4wS3LWHCbLjVleQILfdXI2iExhOb
         NMqcoBDIJ2iu5hJq43+6QWTr6cpIFjGDh/rYDN6FaXwNUeJGm1aSWOzxdSiicpOQo3
         DXdwg59ivYSCkX5yOdUsJZdo6u3SeOG7IaqwUGE752tA37HAV5f/QtVlb4QGPBq3OT
         0iVukbnBGhhD+uizgPzk3RINWve4QJhHjCoYwBeHKudw2YGRqaRe/X6+a1k5ILTPN1
         rrON3EtEzAXlvoJNAP8XaHmRkGFdADid6wCwbggjt0g8P31bvMzW8bcpv4d8bhvawP
         etpgaXkXuebcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jane Jian <Jane.Jian@amd.com>, Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, tim.huang@amd.com, yifan1.zhang@amd.com,
        Likun.Gao@amd.com, kenneth.feng@amd.com, evan.quan@amd.com,
        mario.limonciello@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 24/25] drm/amdgpu/gfx: set cg flags to enter/exit safe mode
Date:   Fri, 31 Mar 2023 21:41:22 -0400
Message-Id: <20230401014126.3356410-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014126.3356410-1-sashal@kernel.org>
References: <20230401014126.3356410-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jane Jian <Jane.Jian@amd.com>

[ Upstream commit e06bfcc1a1c41bcb8c31470d437e147ce9f0acfd ]

sriov needs to enter/exit safe mode in update umd p state
add the cg flag to let it enter or exit while needed

Signed-off-by: Jane Jian <Jane.Jian@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index c748d92cec8e7..ddb7b8651ab4c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1315,6 +1315,11 @@ static int gfx_v11_0_sw_init(void *handle)
 		break;
 	}
 
+	/* Enable CG flag in one VF mode for enabling RLC safe mode enter/exit */
+	if (adev->ip_versions[GC_HWIP][0] == IP_VERSION(11, 0, 3) &&
+		amdgpu_sriov_is_pp_one_vf(adev))
+		adev->cg_flags = AMD_CG_SUPPORT_GFX_CGCG;
+
 	/* EOP Event */
 	r = amdgpu_irq_add_id(adev, SOC21_IH_CLIENTID_GRBM_CP,
 			      GFX_11_0_0__SRCID__CP_EOP_INTERRUPT,
-- 
2.39.2

