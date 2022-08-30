Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436165A6988
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiH3RUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiH3RTh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:19:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C02FD91C7;
        Tue, 30 Aug 2022 10:19:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFEEFB81D0D;
        Tue, 30 Aug 2022 17:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8108C433C1;
        Tue, 30 Aug 2022 17:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661879948;
        bh=QBsjK9oGm5O9r4YTpxdmvu68qWH0C2oAEG1TyScOEnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgvZvQn4290m3P/ibZRlay+67pEXm/8buecgrlSPFM8Q6fdHmNEavmBM1bnTuRt2h
         Z8LjpG4PbIRkL0bPLS+JPo/fGO+3jzvFjSymcrR67+ZZOwmPuKTxRBS/etgmjqQxT0
         UzJ23Ga5L/1nBD3V0JUTjdus7uJOJHzQmB8wlUSsIH4kacoFwZopMqEk0neDuoQ5wF
         BFfFSmtqJ0HUg9dTDxUEihQ5GvO2NmOIiiutg0Af8fKtjEP2OLQYUsx38FBr4cCewF
         ziMK//M5ZHy7oANgzXpSqOp8bjqbyKA0RMvq095Lufb0oxV4zC2LaBbfjr8zbS1mGi
         nVREjQCBN8YVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YiPeng Chai <YiPeng.Chai@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        andrey.grodzovsky@amd.com, guchun.chen@amd.com,
        shaoyun.liu@amd.com, Amaranath.Somalapuram@amd.com,
        lang.yu@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 10/33] drm/amdgpu: fix hive reference leak when adding xgmi device
Date:   Tue, 30 Aug 2022 13:18:01 -0400
Message-Id: <20220830171825.580603-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
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

[ Upstream commit f5994da72ba124a3d0463672fdfbec073e3bb72f ]

Only amdgpu_get_xgmi_hive but no amdgpu_put_xgmi_hive
which will leak the hive reference.

Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 3adebb63680e0..ea2b74c0fd229 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2482,12 +2482,14 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 			if (!hive->reset_domain ||
 			    !amdgpu_reset_get_reset_domain(hive->reset_domain)) {
 				r = -ENOENT;
+				amdgpu_put_xgmi_hive(hive);
 				goto init_failed;
 			}
 
 			/* Drop the early temporary reset domain we created for device */
 			amdgpu_reset_put_reset_domain(adev->reset_domain);
 			adev->reset_domain = hive->reset_domain;
+			amdgpu_put_xgmi_hive(hive);
 		}
 	}
 
-- 
2.35.1

