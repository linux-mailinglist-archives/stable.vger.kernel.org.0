Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2F0167104
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgBUHu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:50:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729037AbgBUHu0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:50:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70351208C4;
        Fri, 21 Feb 2020 07:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271425;
        bh=YPGPEDMa2swDKgTCQRDKlLnyvqjdbgcYK9BNY5SuAws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLIOSXR1ZCNXN6qkDU/g7dmMWUFYbHy0Yzo3/2Iy9/fTp1gZMVKkv0PFgEmtT2QC6
         nJaLCQspLiqWNS9OkWmNZ84RLWKiIq4nTQAFHX2Shmce1bJ8NwFCPVo6YMrjr3FAgB
         0BBTBCLPorYSQaOcXP4Wa9OdOFcNoLasG+1ZRdRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Monk Liu <Monk.Liu@amd.com>,
        Emily Deng <Emily.Deng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 162/399] drm/amdgpu: fix KIQ ring test fail in TDR of SRIOV
Date:   Fri, 21 Feb 2020 08:38:07 +0100
Message-Id: <20200221072418.319253235@linuxfoundation.org>
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

[ Upstream commit 5a7489a7e189ee2be889485f90c8cf24ea4b9a40 ]

issues:
MEC is ruined by the amdkfd_pre_reset after VF FLR done

fix:
amdkfd_pre_reset() would ruin MEC after hypervisor finished the VF FLR,
the correct sequence is do amdkfd_pre_reset before VF FLR but there is
a limitation to block this sequence:
if we do pre_reset() before VF FLR, it would go KIQ way to do register
access and stuck there, because KIQ probably won't work by that time
(e.g. you already made GFX hang)

so the best way right now is to simply remove it.

Signed-off-by: Monk Liu <Monk.Liu@amd.com>
Reviewed-by: Emily Deng <Emily.Deng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index c17505fba9884..332b9c24a2cd0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3639,8 +3639,6 @@ static int amdgpu_device_reset_sriov(struct amdgpu_device *adev,
 	if (r)
 		return r;
 
-	amdgpu_amdkfd_pre_reset(adev);
-
 	/* Resume IP prior to SMC */
 	r = amdgpu_device_ip_reinit_early_sriov(adev);
 	if (r)
-- 
2.20.1



