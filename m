Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E46171E49
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388262AbgB0O0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:26:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388407AbgB0OJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:09:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6EFD20714;
        Thu, 27 Feb 2020 14:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812575;
        bh=v8NZMWe0K1US6EgKHTCHrO3rHbGQOm1PoYWoohtuGQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fmhbj28hiMwSFZA3WRxYWrd0cUFnpp3AUs1PWLo5RFZhUTt+Yx6lXyVogV8F1U+d2
         b54jGtFHmHUBvPyR2wqX9/rL1ziU/Qb6vwV/58cWznmJYq9j2ttkpdPZmW+KPNVQel
         89oQgxH8BSNUPi/2KrUrl+pJYzFkD0HZCgKT3ckY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaojie Yuan <xiaojie.yuan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 071/135] drm/amdgpu/gfx9: disable gfxoff when reading rlc clock
Date:   Thu, 27 Feb 2020 14:36:51 +0100
Message-Id: <20200227132240.032106175@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 120cf959308e1bda984e40a9edd25ee2d6262efd upstream.

Otherwise we readback all ones.  Fixes rlc counter
readback while gfxoff is active.

Reviewed-by: Xiaojie Yuan <xiaojie.yuan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -4080,11 +4080,13 @@ static uint64_t gfx_v9_0_get_gpu_clock_c
 {
 	uint64_t clock;
 
+	amdgpu_gfx_off_ctrl(adev, false);
 	mutex_lock(&adev->gfx.gpu_clock_mutex);
 	WREG32_SOC15(GC, 0, mmRLC_CAPTURE_GPU_CLOCK_COUNT, 1);
 	clock = (uint64_t)RREG32_SOC15(GC, 0, mmRLC_GPU_CLOCK_COUNT_LSB) |
 		((uint64_t)RREG32_SOC15(GC, 0, mmRLC_GPU_CLOCK_COUNT_MSB) << 32ULL);
 	mutex_unlock(&adev->gfx.gpu_clock_mutex);
+	amdgpu_gfx_off_ctrl(adev, true);
 	return clock;
 }
 


