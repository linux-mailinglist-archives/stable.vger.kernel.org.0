Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63EF515913
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfEGFdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:33:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726947AbfEGFda (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:33:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15D8720C01;
        Tue,  7 May 2019 05:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207209;
        bh=bTMDjl5OERlZhmnbj15r+fyRb5JYDrqCCHTDy+GWvlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWeB0TFRZhc/wNfPlgDfKsQBdQB0YsrXHFlinlS6ULAQmUIX40r3ZK9hizZhpWIW7
         22RMZLxEQgJcCysUIMfz0T4qoEhDsla3J9GRNPUImlZH2PFKzCEiUuHuTRvYpkXTxV
         Wn43PmqkmDgzUxa+E2auwaZN7oG8RxEto2cmCw4w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wentalou <Wentao.Lou@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.0 27/99] drm/amdgpu: shadow in shadow_list without tbo.mem.start cause page fault in sriov TDR
Date:   Tue,  7 May 2019 01:31:21 -0400
Message-Id: <20190507053235.29900-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wentalou <Wentao.Lou@amd.com>

[ Upstream commit b575f10dbd6f84c2c8744ff1f486bfae1e4f6f38 ]

shadow was added into shadow_list by amdgpu_bo_create_shadow.
meanwhile, shadow->tbo.mem was not fully configured.
tbo.mem would be fully configured by amdgpu_vm_sdma_map_table until calling amdgpu_vm_clear_bo.
If sriov TDR occurred between amdgpu_bo_create_shadow and amdgpu_vm_sdma_map_table,
amdgpu_device_recover_vram would deal with shadow without tbo.mem.start.

Signed-off-by: Wentao Lou <Wentao.Lou@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 7ff3a28fc903..5336b2c9b615 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3150,6 +3150,7 @@ static int amdgpu_device_recover_vram(struct amdgpu_device *adev)
 
 		/* No need to recover an evicted BO */
 		if (shadow->tbo.mem.mem_type != TTM_PL_TT ||
+		    shadow->tbo.mem.start == AMDGPU_BO_INVALID_OFFSET ||
 		    shadow->parent->tbo.mem.mem_type != TTM_PL_VRAM)
 			continue;
 
-- 
2.20.1

