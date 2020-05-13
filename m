Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B0C1D0EDC
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733214AbgEMJtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732596AbgEMJtS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:49:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9253520769;
        Wed, 13 May 2020 09:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363358;
        bh=7h3ilf4yRUxzBh/TqzooOJcpzlutNJdFmVpnoQVo1lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DuS5vARycaSlMWkYXUmbjxG/Jz7GgwXAw+uteXzV4CCKJH6ygQhOE/kqxkZlGWtQV
         wUGS3uAo9nVO2H0V8vUUsX1mUVZo9sNQ45FrXx4uPk/TIvR3w6SlyT70ZeXlJwFfJc
         /V4RoC3ldWKedq3kNNaRycJroeJBiXrHN5fJV/1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/90] drm/amdgpu: move kfd suspend after ip_suspend_phase1
Date:   Wed, 13 May 2020 11:44:02 +0200
Message-Id: <20200513094409.731798624@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit c457a273e118bb96e1db8d1825f313e6cafe4258 ]

This sequence change should be safe as what did in ip_suspend_phase1
is to suspend DCE only. And this is a prerequisite for coming
redundant cg/pg ungate dropping.

Fixes: 487eca11a321ef ("drm/amdgpu: fix gfx hang during suspend with video playback (v2)")
Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 630e8342d1625..ca2a0770aad2e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3073,12 +3073,12 @@ int amdgpu_device_suspend(struct drm_device *dev, bool suspend, bool fbcon)
 	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
 	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
 
-	amdgpu_amdkfd_suspend(adev);
-
 	amdgpu_ras_suspend(adev);
 
 	r = amdgpu_device_ip_suspend_phase1(adev);
 
+	amdgpu_amdkfd_suspend(adev);
+
 	/* evict vram memory */
 	amdgpu_bo_evict_vram(adev);
 
-- 
2.20.1



