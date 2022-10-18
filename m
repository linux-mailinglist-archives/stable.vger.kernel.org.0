Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A33602027
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 03:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiJRBH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 21:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiJRBHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 21:07:54 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D5EBAF
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 18:07:53 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id e15so10616637iof.2
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 18:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xvNB9WiNIPXKm+fKuntZlQJdCyk9M5Uyh12KK7FhNsk=;
        b=NT/7KcVoO5PZgXcuH8ykllbEFgzjvh/ZNHuB/JnIoib0REN917mC2yZ3goyv6y2DBX
         RUDs+3juAcJSYZ0utC1fOtkSAdlQwXpuhx07brqFkmMylMRvyGknwf/S6s2WcBcJLU3e
         XxEzXiPpeaBHJXa+hUxdRpP51YjyZAxPFks6g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xvNB9WiNIPXKm+fKuntZlQJdCyk9M5Uyh12KK7FhNsk=;
        b=XttElwxlMxhe3rnVEdQDJJxw7aS8ghiymVK1pzQL9dztie76WYxE3SunhDMh68mATd
         nKe9Ec9bbfQZwNpCU88jO0ThNQhGpKxqOK+dzP0oFSIltaXrBtZuu1hMCEJnk9p2259P
         AA1LAIA+VzHt+OU1PdOPirwYow4HcgNwNXC3ZQhcF3wmxTUcFODt7xgPyoYhAC/XDhNV
         UrIQHqN3fYydY1c8z1nWlpxlb0VjCThhopm6FEzK/LNthYfTpyUB/EqRQjOqucasExVk
         il+pdofEiR8tbU0ts5RuUqiD9z7XFLmp94/YU8dSIccAvybW6IhtHRIAruHaMcTtljXj
         O8gQ==
X-Gm-Message-State: ACrzQf04RUEkO+s9AUIzo/befYEhsqaywwL/oQQAjoU3oPKnHijpXtaa
        4sHwbRarsimYCBSuDiK2tsLRaS7Dm3f2OA==
X-Google-Smtp-Source: AMsMyM4GPmsilh/d3IUpGo7EM4I5H7QWbMvVzbAVtF8gnhpUk+MFubkgmkUKk+joPxGUkzJq+2dV1w==
X-Received: by 2002:a05:6638:19c4:b0:363:afc3:b403 with SMTP id bi4-20020a05663819c400b00363afc3b403mr654868jab.144.1666055272626;
        Mon, 17 Oct 2022 18:07:52 -0700 (PDT)
Received: from localhost.localdomain ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id e6-20020a022106000000b0036377aa5a35sm529499jaa.100.2022.10.17.18.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 18:07:52 -0700 (PDT)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     sashal@kernel.org, gregkh@linuxfoundation.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, alexander.deucher@amd.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] Revert "drm/amdgpu: move nbio sdma_doorbell_range() into sdma code for vega"
Date:   Mon, 17 Oct 2022 19:07:45 -0600
Message-Id: <20221018010746.603662-1-skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 9f55f36f749a7608eeef57d7d72991a9bd557341.

This commit causes repeated WARN_ONs from

drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amd
gpu_dm.c:7391 amdgpu_dm_atomic_commit_tail+0x23b9/0x2430 [amdgpu]

dmesg fills up with the following messages and drm initialization takes
a very long time.

Cc: <stable@vger.kernel.org>    # 5.10
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |  5 -----
 drivers/gpu/drm/amd/amdgpu/soc15.c     | 25 +++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index a1a8e026b9fa..1f2e2460e121 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -1475,11 +1475,6 @@ static int sdma_v4_0_start(struct amdgpu_device *adev)
 		WREG32_SDMA(i, mmSDMA0_CNTL, temp);
 
 		if (!amdgpu_sriov_vf(adev)) {
-			ring = &adev->sdma.instance[i].ring;
-			adev->nbio.funcs->sdma_doorbell_range(adev, i,
-				ring->use_doorbell, ring->doorbell_index,
-				adev->doorbell_index.sdma_doorbell_range);
-
 			/* unhalt engine */
 			temp = RREG32_SDMA(i, mmSDMA0_F32_CNTL);
 			temp = REG_SET_FIELD(temp, SDMA0_F32_CNTL, HALT, 0);
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index abd649285a22..7212b9900e0a 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1332,6 +1332,25 @@ static int soc15_common_sw_fini(void *handle)
 	return 0;
 }
 
+static void soc15_doorbell_range_init(struct amdgpu_device *adev)
+{
+	int i;
+	struct amdgpu_ring *ring;
+
+	/* sdma/ih doorbell range are programed by hypervisor */
+	if (!amdgpu_sriov_vf(adev)) {
+		for (i = 0; i < adev->sdma.num_instances; i++) {
+			ring = &adev->sdma.instance[i].ring;
+			adev->nbio.funcs->sdma_doorbell_range(adev, i,
+				ring->use_doorbell, ring->doorbell_index,
+				adev->doorbell_index.sdma_doorbell_range);
+		}
+
+		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
+						adev->irq.ih.doorbell_index);
+	}
+}
+
 static int soc15_common_hw_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
@@ -1351,6 +1370,12 @@ static int soc15_common_hw_init(void *handle)
 
 	/* enable the doorbell aperture */
 	soc15_enable_doorbell_aperture(adev, true);
+	/* HW doorbell routing policy: doorbell writing not
+	 * in SDMA/IH/MM/ACV range will be routed to CP. So
+	 * we need to init SDMA/IH/MM/ACV doorbell range prior
+	 * to CP ip block init and ring test.
+	 */
+	soc15_doorbell_range_init(adev);
 
 	return 0;
 }
-- 
2.34.1

