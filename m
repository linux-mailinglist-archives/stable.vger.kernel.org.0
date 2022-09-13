Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145995B6F28
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbiIMOJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbiIMOIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:08:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D18558E2;
        Tue, 13 Sep 2022 07:08:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86EA16149A;
        Tue, 13 Sep 2022 14:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98582C433D6;
        Tue, 13 Sep 2022 14:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078096;
        bh=Q+vMHRGkAwSDWOXbaXN+wZkgMIIyt/l7oOCUkocI/mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFjT/rjmvQFYdM3FnW1ZdqqyDMvh4L+8v13r5ZWf2CeiPAMept/+0ML3lDYSFxmde
         gNb4jLm/9NKGhHw5/GxCKFm+rpyaEShi2Rw8oP7T3qy/nWKMtsv/I20MwZBziBJOXd
         HGO/MU5cOGw6KOITWcT6hlf27eQtKkH5nR0bV3eE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YiPeng Chai <YiPeng.Chai@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 013/192] drm/amdgpu: Move psp_xgmi_terminate call from amdgpu_xgmi_remove_device to psp_hw_fini
Date:   Tue, 13 Sep 2022 16:01:59 +0200
Message-Id: <20220913140410.608880432@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e9411c28d88ba..2b00f8fe15a89 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -2612,6 +2612,9 @@ static int psp_hw_fini(void *handle)
 		psp_rap_terminate(psp);
 		psp_dtm_terminate(psp);
 		psp_hdcp_terminate(psp);
+
+		if (adev->gmc.xgmi.num_physical_nodes > 1)
+			psp_xgmi_terminate(psp);
 	}
 
 	psp_asd_terminate(psp);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
index 1b108d03e7859..f2aebbf3fbe38 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
@@ -742,7 +742,7 @@ int amdgpu_xgmi_remove_device(struct amdgpu_device *adev)
 		amdgpu_put_xgmi_hive(hive);
 	}
 
-	return psp_xgmi_terminate(&adev->psp);
+	return 0;
 }
 
 static int amdgpu_xgmi_ras_late_init(struct amdgpu_device *adev, struct ras_common_if *ras_block)
-- 
2.35.1



