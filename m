Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221F2658479
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbiL1Q5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbiL1Q4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:56:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6941F10C2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:52:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AF0CB81707
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D088C433EF;
        Wed, 28 Dec 2022 16:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246373;
        bh=KuoKBNcyqTfYCus5XqiP+5s9OwApLwtBqGwy//0dO0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFDKg+t/Z9jmMeFAbh7EU6lCrnYKV/b64ZhPpT8DALhksNWy/8FkJB3UDDlFHD6yz
         dIH1q0KbNBCBLi+hvmxo33eRa7l+aIpx5O4ZskgOnJzNo0eI+2TYrznLZMO3RgoIwX
         +B4M1VmsqZLR8Abcw7dsaaQpmkGlQmZRRnxr8+G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang He <windhl@126.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1028/1146] drm/amdgpu: Fix potential double free and null pointer dereference
Date:   Wed, 28 Dec 2022 15:42:47 +0100
Message-Id: <20221228144358.283271665@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit dfd0287bd3920e132a8dae2a0ec3d92eaff5f2dd ]

In amdgpu_get_xgmi_hive(), we should not call kfree() after
kobject_put() as the PUT will call kfree().

In amdgpu_device_ip_init(), we need to check the returned *hive*
which can be NULL before we dereference it.

Signed-off-by: Liang He <windhl@126.com>
Reviewed-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 5 +++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c   | 2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 2cf72cfa2e60..913f22d41673 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2462,6 +2462,11 @@ static int amdgpu_device_ip_init(struct amdgpu_device *adev)
 			if (!amdgpu_sriov_vf(adev)) {
 				struct amdgpu_hive_info *hive = amdgpu_get_xgmi_hive(adev);
 
+				if (WARN_ON(!hive)) {
+					r = -ENOENT;
+					goto init_failed;
+				}
+
 				if (!hive->reset_domain ||
 				    !amdgpu_reset_get_reset_domain(hive->reset_domain)) {
 					r = -ENOENT;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
index 47159e9a0884..4b9e7b050ccd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c
@@ -386,7 +386,6 @@ struct amdgpu_hive_info *amdgpu_get_xgmi_hive(struct amdgpu_device *adev)
 	if (ret) {
 		dev_err(adev->dev, "XGMI: failed initializing kobject for xgmi hive\n");
 		kobject_put(&hive->kobj);
-		kfree(hive);
 		hive = NULL;
 		goto pro_end;
 	}
@@ -410,7 +409,6 @@ struct amdgpu_hive_info *amdgpu_get_xgmi_hive(struct amdgpu_device *adev)
 				dev_err(adev->dev, "XGMI: failed initializing reset domain for xgmi hive\n");
 				ret = -ENOMEM;
 				kobject_put(&hive->kobj);
-				kfree(hive);
 				hive = NULL;
 				goto pro_end;
 			}
-- 
2.35.1



