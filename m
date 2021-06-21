Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6A33AF0AD
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhFUQv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233240AbhFUQt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1709E6145D;
        Mon, 21 Jun 2021 16:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293272;
        bh=rThdMEtFDRM1YhoSDnD0/Y6nRSxmSvuUpsszqvht818=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIokVvL7ajGb2Xb+W7aZElZnF2FlLSk8TMpmKAZNnoJ35ND/ShMf24ULJV9hEQe0y
         lVlOJcGav6u89mpCUQ99sciBFGjUdJZYqfdDVTDKmmlT0cfs39U+Lmk9nsFqTrugUE
         E+viDqVkEdxHgGOwjL6xTt7kSAMfOS0RluIi3lwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifan Zhang <yifan1.zhang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 161/178] drm/amdgpu/gfx9: fix the doorbell missing when in CGPG issue.
Date:   Mon, 21 Jun 2021 18:16:15 +0200
Message-Id: <20210621154928.230954855@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

commit 4cbbe34807938e6e494e535a68d5ff64edac3f20 upstream.

If GC has entered CGPG, ringing doorbell > first page doesn't wakeup GC.
Enlarge CP_MEC_DOORBELL_RANGE_UPPER to workaround this issue.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -3623,8 +3623,12 @@ static int gfx_v9_0_kiq_init_register(st
 	if (ring->use_doorbell) {
 		WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_LOWER,
 					(adev->doorbell_index.kiq * 2) << 2);
+		/* If GC has entered CGPG, ringing doorbell > first page doesn't
+		 * wakeup GC. Enlarge CP_MEC_DOORBELL_RANGE_UPPER to workaround
+		 * this issue.
+		 */
 		WREG32_SOC15(GC, 0, mmCP_MEC_DOORBELL_RANGE_UPPER,
-					(adev->doorbell_index.userqueue_end * 2) << 2);
+					(adev->doorbell.size - 4));
 	}
 
 	WREG32_SOC15_RLC(GC, 0, mmCP_HQD_PQ_DOORBELL_CONTROL,


