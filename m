Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7824439613F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhEaOhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:37:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232772AbhEaOfh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:35:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E56C561C4D;
        Mon, 31 May 2021 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469065;
        bh=yP4dU9bSFrV/tkHbP2aZDXyhX7JxxtdOIJffJXrV/Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbUFxbkpjBMDy4mFcC3RxCYNZBHSgJ0P/BLAJuiaYrtXCSUtlTczhmYJtzePHvH0z
         pvzH7jUc/UUlVZHNELV3O4RhoalTPCWQAQimJsJFDyszw3tRM8NfjvQCdrTC2FpjIm
         kLO8RFDjVmzvF49fT06wZP0yxKwJt3LrIZQQJWHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 055/296] drm/amd/pm: correct MGpuFanBoost setting
Date:   Mon, 31 May 2021 15:11:50 +0200
Message-Id: <20210531130705.684165457@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit 1a0b713c73688c6bafbe6faf8c90390b11b26fc6 upstream.

No MGpuFanBoost setting for those ASICs which do not support it.
Otherwise, it may breaks their fan control feature.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1580

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c         |    9 +++++++++
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c |   10 ++++++++++
 2 files changed, 19 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -2366,6 +2366,8 @@ static ssize_t navi10_get_gpu_metrics(st
 
 static int navi10_enable_mgpu_fan_boost(struct smu_context *smu)
 {
+	struct smu_table_context *table_context = &smu->smu_table;
+	PPTable_t *smc_pptable = table_context->driver_pptable;
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t param = 0;
 
@@ -2373,6 +2375,13 @@ static int navi10_enable_mgpu_fan_boost(
 	if (adev->asic_type == CHIP_NAVI12)
 		return 0;
 
+	/*
+	 * Skip the MGpuFanBoost setting for those ASICs
+	 * which do not support it
+	 */
+	if (!smc_pptable->MGpuFanBoostLimitRpm)
+		return 0;
+
 	/* Workaround for WS SKU */
 	if (adev->pdev->device == 0x7312 &&
 	    adev->pdev->revision == 0)
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -3015,6 +3015,16 @@ static ssize_t sienna_cichlid_get_gpu_me
 
 static int sienna_cichlid_enable_mgpu_fan_boost(struct smu_context *smu)
 {
+	struct smu_table_context *table_context = &smu->smu_table;
+	PPTable_t *smc_pptable = table_context->driver_pptable;
+
+	/*
+	 * Skip the MGpuFanBoost setting for those ASICs
+	 * which do not support it
+	 */
+	if (!smc_pptable->MGpuFanBoostLimitRpm)
+		return 0;
+
 	return smu_cmn_send_smc_msg_with_param(smu,
 					       SMU_MSG_SetMGpuFanBoostLimitRpm,
 					       0,


