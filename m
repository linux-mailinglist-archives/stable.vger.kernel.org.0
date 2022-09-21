Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38645C034E
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiIUQCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbiIUQA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 12:00:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D9C95AD2;
        Wed, 21 Sep 2022 08:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FF006315F;
        Wed, 21 Sep 2022 15:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A204DC433B5;
        Wed, 21 Sep 2022 15:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663775632;
        bh=OJR+Kvk3y51iZ6Yjl4qfoMm5F58M8vlAqHec4fKuqLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yga/v0E7FpThEg9jukqWjHbKGVIavYieDDltMRy+aFKXN6io+RwdxIoUUzETFf9iV
         Vp8pzoAIBavPsuf74iPQ8caD4UaJ3usQBhQu/1L6521TW2USRSBYdVoG82db7A7qtd
         7WZA7rzj9YZwyCPoBLei1n2DA2xqZK8+S8xoSJTTXfbSEIyXLqK0iQCMvZ+1D7shzP
         /hBM8ybhaH58qD85xi3W30Hlt4r5W51r89EXwKuG0dyAaM7ZbkT7rDHeON5OAlmnCJ
         LsYen5VFxmaOV9PHn77B9mjctNZ8iib8F95Fxovm8YAMCy+wiZyOsOjcxbRmr5Ykj0
         aUNooyTKgognA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Xiaojian.Du@amd.com, tim.huang@amd.com, yifan1.zhang@amd.com,
        ray.huang@amd.com, jiapeng.chong@linux.alibaba.com,
        sonny.jiang@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 09/16] drm/amdgpu: add HDP remap functionality to nbio 7.7
Date:   Wed, 21 Sep 2022 11:53:25 -0400
Message-Id: <20220921155332.234913-9-sashal@kernel.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 8c5708d3da37b8c7c3c22c7e945b9a76a7c9539b ]

Was missing before and would have resulted in a write to
a non-existant register. Normally APUs don't use HDP, but
other asics could use this code and APUs do use the HDP
when used in passthrough.

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c
index cdc0c9779848..6c1fd471a4c7 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_7.c
@@ -28,6 +28,14 @@
 #include "nbio/nbio_7_7_0_sh_mask.h"
 #include <uapi/linux/kfd_ioctl.h>
 
+static void nbio_v7_7_remap_hdp_registers(struct amdgpu_device *adev)
+{
+	WREG32_SOC15(NBIO, 0, regBIF_BX0_REMAP_HDP_MEM_FLUSH_CNTL,
+		     adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_MEM_FLUSH_CNTL);
+	WREG32_SOC15(NBIO, 0, regBIF_BX0_REMAP_HDP_REG_FLUSH_CNTL,
+		     adev->rmmio_remap.reg_offset + KFD_MMIO_REMAP_HDP_REG_FLUSH_CNTL);
+}
+
 static u32 nbio_v7_7_get_rev_id(struct amdgpu_device *adev)
 {
 	u32 tmp;
@@ -237,4 +245,5 @@ const struct amdgpu_nbio_funcs nbio_v7_7_funcs = {
 	.ih_doorbell_range = nbio_v7_7_ih_doorbell_range,
 	.ih_control = nbio_v7_7_ih_control,
 	.init_registers = nbio_v7_7_init_registers,
+	.remap_hdp_registers = nbio_v7_7_remap_hdp_registers,
 };
-- 
2.35.1

