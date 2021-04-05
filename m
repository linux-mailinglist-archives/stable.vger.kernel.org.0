Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FAC354012
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239104AbhDEJPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240594AbhDEJPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:15:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B30E6611C1;
        Mon,  5 Apr 2021 09:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614119;
        bh=Cr7LoF8rbRdzE4lwIK+f6hJsM/trJ+hJTygPu2SWwmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcXuV9lR6hkPDPgbFk9yxWMDyrz8C/fPjjwU4CQBHqpgKao7z1+CKDh998R7fmZF0
         ZyObTXR5m60bjhpRzsMYlguRC6blieGcf3wmaZE8ITRZAKMLddof2GU8Ag5xAmAx/g
         if34dfEfVOSGRCP4xWtDE94mXcpJO7ulbyiBykeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhan Liu <zhan.liu@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 090/152] drm/amdgpu/vangogh: dont check for dpm in is_dpm_running when in suspend
Date:   Mon,  5 Apr 2021 10:53:59 +0200
Message-Id: <20210405085037.173931236@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 6951c3e4a260f65a16433833d2511e8796dc8625 upstream.

Do the same thing we do for Renoir.  We can check, but since
the sbios has started DPM, it will always return true which
causes the driver to skip some of the SMU init when it shouldn't.

Reviewed-by: Zhan Liu <zhan.liu@amd.com>
Acked-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
@@ -388,10 +388,15 @@ static int vangogh_get_allowed_feature_m
 
 static bool vangogh_is_dpm_running(struct smu_context *smu)
 {
+	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
 	uint32_t feature_mask[2];
 	uint64_t feature_enabled;
 
+	/* we need to re-init after suspend so return false */
+	if (adev->in_suspend)
+		return false;
+
 	ret = smu_cmn_get_enabled_32_bits_mask(smu, feature_mask, 2);
 
 	if (ret)


