Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5895A6A69
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiH3R3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiH3R2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:28:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D064D31FD;
        Tue, 30 Aug 2022 10:25:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13E48B81C55;
        Tue, 30 Aug 2022 17:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88337C43470;
        Tue, 30 Aug 2022 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880218;
        bh=4KRIZt60OYvPDJXSjhi2ESW3KUFxGrgOB5pvP03ikz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQuxwDZuIsup9GQpBY99nuLwCokXhxAfs5a2K/aCwIUkG5mefc3XFT5pImIJg65YI
         c7NXAf19OH9o3HEixlG0YL/DmVYrSWQYVyDpVxk0fXOUghxBySf5ZZZA7+M6sT84QZ
         B7PPhgE2Oz1kSxC0RXjJNNuFY109hRd/Cb35aO7U2I4TLhVI8oldGoAA0JM1lc+D93
         pfM7gM/Dda8SBR5RUSYvivPHAGFHNo6xEFnucWu0mjLOtqaCrQMff0syAdnfJeVd64
         b0gBq3mPac1NoP5w74vs5lO2rzI2oMYuorgMRWIUoSkzrzcsKoEakWNOvuTfhww+E8
         9f8Vq+bggwOjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YiPeng Chai <YiPeng.Chai@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        john.clements@amd.com, Likun.Gao@amd.com, candice.li@amd.com,
        tao.zhou1@amd.com, guchun.chen@amd.com, Bokun.Zhang@amd.com,
        andrey.grodzovsky@amd.com, bernard@vivo.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 05/16] drm/amdgpu: Move psp_xgmi_terminate call from amdgpu_xgmi_remove_device to psp_hw_fini
Date:   Tue, 30 Aug 2022 13:23:06 -0400
Message-Id: <20220830172317.581397-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830172317.581397-1-sashal@kernel.org>
References: <20220830172317.581397-1-sashal@kernel.org>
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

From: YiPeng Chai <YiPeng.Chai@amd.com>

[ Upstream commit 9d705d7741ae70764f3d6d87e67fad3b5c30ffd0 ]

V1:
The amdgpu_xgmi_remove_device function will send unload command
to psp through psp ring to terminate xgmi, but psp ring has been
destroyed in psp_hw_fini.

V2:
1. Change the commit title.
2. Restore amdgpu_xgmi_remove_device to its original calling location.
   Move psp_xgmi_terminate call from amdgpu_xgmi_remove_device to
   psp_hw_fini.

Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c  | 3 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 2f47f81a74a57..ae84d3b582aa5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -2146,6 +2146,9 @@ static int psp_hw_fini(void *handle)
 		psp_rap_terminate(psp);
 		psp_dtm_terminate(psp);
 		psp_hdcp_terminate(psp);
+
+		if (adev->gmc.xgmi.num_physical_nodes > 1)
+			psp_xgmi_terminate(psp);
 	}
 
 	psp_asd_unload(psp);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
index 042c85fc528bb..def0b7092438f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
@@ -622,7 +622,7 @@ int amdgpu_xgmi_remove_device(struct amdgpu_device *adev)
 		amdgpu_put_xgmi_hive(hive);
 	}
 
-	return psp_xgmi_terminate(&adev->psp);
+	return 0;
 }
 
 int amdgpu_xgmi_ras_late_init(struct amdgpu_device *adev)
-- 
2.35.1

