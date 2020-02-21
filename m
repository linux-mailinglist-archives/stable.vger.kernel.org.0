Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04DDE167134
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgBUHwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:52:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:49696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729856AbgBUHwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:52:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 459E420578;
        Fri, 21 Feb 2020 07:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271522;
        bh=0HeExuz9QPcw+aWERqJaIZJiSb77L69c+dK4wEu8aeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1A2FIVuhB/u/ZGzvdDIeC9Q6Xzpvrpc4wyNTO4ehd365p4mha3LJfLznqrN5GRXiW
         WDGfMQd3JoSFIXEw3N4D96JEnA+a9/1ZOOEr7rTMyCKNy5a54QjXwNH39JV4PJ6n6k
         xNwWTLV3Lm3CQY2SVXxccmy7Ezj6T34wsBh6mTw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Monk Liu <Monk.Liu@amd.com>,
        Emily Deng <Emily.Deng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 161/399] drm/amdgpu: fix double gpu_recovery for NV of SRIOV
Date:   Fri, 21 Feb 2020 08:38:06 +0100
Message-Id: <20200221072418.221316122@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Monk Liu <Monk.Liu@amd.com>

[ Upstream commit 1512d064f55bace6a8e32d65009c7ea112e76a31 ]

issues:
gpu_recover() is re-entered by the mailbox interrupt
handler mxgpu_nv.c

fix:
we need to bypass the gpu_recover() invoke in mailbox
interrupt as long as the timeout is not infinite (thus the TDR
will be triggered automatically after time out, no need to invoke
gpu_recover() through mailbox interrupt.

Signed-off-by: Monk Liu <Monk.Liu@amd.com>
Reviewed-by: Emily Deng <Emily.Deng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
index 0d8767eb7a709..1c3a7d4bb65d2 100644
--- a/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/mxgpu_nv.c
@@ -269,7 +269,11 @@ flr_done:
 	}
 
 	/* Trigger recovery for world switch failure if no TDR */
-	if (amdgpu_device_should_recover_gpu(adev))
+	if (amdgpu_device_should_recover_gpu(adev)
+		&& (adev->sdma_timeout == MAX_SCHEDULE_TIMEOUT ||
+		adev->gfx_timeout == MAX_SCHEDULE_TIMEOUT ||
+		adev->compute_timeout == MAX_SCHEDULE_TIMEOUT ||
+		adev->video_timeout == MAX_SCHEDULE_TIMEOUT))
 		amdgpu_device_gpu_recover(adev, NULL);
 }
 
-- 
2.20.1



