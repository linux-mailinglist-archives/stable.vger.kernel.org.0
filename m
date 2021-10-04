Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F61420F70
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbhJDNex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:34:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236803AbhJDNdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:33:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9101B63224;
        Mon,  4 Oct 2021 13:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353289;
        bh=G3j+9ax/3/NZ+Nih8oq2Uf9WUNcgQZUq9EjiImao3Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmSotVol930Sr/bPIicmwlpm+ahApUxYzviSUdOUp4qjLT8nKhxnE0r0w8K5eJxrc
         +bf7FBw6aMS0kqnXdkds+/9TWQEcm2FoeWh8Ey33E/6rvYq3utMR6akvK8z/Qd3VD5
         qiagI2w9QR9jOZU9hZ5JePFDhhlKGHy+6BkZB9U8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prike Liang <Prike.Liang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 070/172] drm/amdgpu: force exit gfxoff on sdma resume for rmb s0ix
Date:   Mon,  4 Oct 2021 14:52:00 +0200
Message-Id: <20211004125047.249040654@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prike Liang <Prike.Liang@amd.com>

commit 26db706a6d77b9e184feb11725e97e53b7a89519 upstream.

In the s2idle stress test sdma resume fail occasionally,in the
failed case GPU is in the gfxoff state.This issue may introduce
by firmware miss handle doorbell S/R and now temporary fix the issue
by forcing exit gfxoff for sdma resume.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -883,6 +883,12 @@ static int sdma_v5_2_start(struct amdgpu
 			msleep(1000);
 	}
 
+	/* TODO: check whether can submit a doorbell request to raise
+	 * a doorbell fence to exit gfxoff.
+	 */
+	if (adev->in_s0ix)
+		amdgpu_gfx_off_ctrl(adev, false);
+
 	sdma_v5_2_soft_reset(adev);
 	/* unhalt the MEs */
 	sdma_v5_2_enable(adev, true);
@@ -891,6 +897,8 @@ static int sdma_v5_2_start(struct amdgpu
 
 	/* start the gfx rings and rlc compute queues */
 	r = sdma_v5_2_gfx_resume(adev);
+	if (adev->in_s0ix)
+		amdgpu_gfx_off_ctrl(adev, true);
 	if (r)
 		return r;
 	r = sdma_v5_2_rlc_resume(adev);


