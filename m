Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F8D5EA53D
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239001AbiIZL7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239254AbiIZL6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:58:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E587B7B286;
        Mon, 26 Sep 2022 03:52:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E084B80185;
        Mon, 26 Sep 2022 10:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC71C433D6;
        Mon, 26 Sep 2022 10:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189410;
        bh=OJR+Kvk3y51iZ6Yjl4qfoMm5F58M8vlAqHec4fKuqLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqFQlgzWbdv/AIYtolb0yAr8OafU+29c7LC4g0JUyYFRky1gku9GtK9mT4KaYA0nf
         voM8Yh+V8VQ3asvp92yxIittY9Z9FDTfxUhGsRtI3wbJ94EHIGp1h6dmmdS+e6c4V/
         3OoJQyb2xFsdFQIFgqfnFrebddWpZkNVeSpLeLwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 179/207] drm/amdgpu: add HDP remap functionality to nbio 7.7
Date:   Mon, 26 Sep 2022 12:12:48 +0200
Message-Id: <20220926100814.634068640@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



