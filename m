Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D07C2C9D38
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389413AbgLAJU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:20:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389439AbgLAJJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:09:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FDE62224A;
        Tue,  1 Dec 2020 09:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813724;
        bh=pU4+iLvfEPqb4ShgmgqBEAl5Mh4SYEhmO3+yTyncc/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvnID7FTi8uUCZOvvqwTGttqvtfyiW4wCFmgaA3m75IpO0Woao57J2hQhdkRqyi2S
         FGQdX/AUzhPH3y+/IqZcHvnfsi6AGDMNXR523VEAD9WwpH+UGIuXDL3lmJ4pEEcmW/
         5gFi0umLhXX5MV2K5ndtOaAjJNLEnOR7QPbmrBQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 037/152] drm/amd/amdgpu: fix null pointer in runtime pm
Date:   Tue,  1 Dec 2020 09:52:32 +0100
Message-Id: <20201201084716.744009594@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Feng <kenneth.feng@amd.com>

commit 7acc79eb5f78d3d1aa5dd21fc0a0329f1b7f2be5 upstream.

fix the null pointer issue when runtime pm is triggered.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4593,7 +4593,7 @@ int amdgpu_device_baco_enter(struct drm_
 	if (!amdgpu_device_supports_baco(adev->ddev))
 		return -ENOTSUPP;
 
-	if (ras && ras->supported)
+	if (ras && ras->supported && adev->nbio.funcs->enable_doorbell_interrupt)
 		adev->nbio.funcs->enable_doorbell_interrupt(adev, false);
 
 	return amdgpu_dpm_baco_enter(adev);
@@ -4612,7 +4612,7 @@ int amdgpu_device_baco_exit(struct drm_d
 	if (ret)
 		return ret;
 
-	if (ras && ras->supported)
+	if (ras && ras->supported && adev->nbio.funcs->enable_doorbell_interrupt)
 		adev->nbio.funcs->enable_doorbell_interrupt(adev, true);
 
 	return 0;


