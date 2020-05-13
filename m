Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C9A1D0EDD
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733219AbgEMJtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:49:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733215AbgEMJtU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:49:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECCCD2492D;
        Wed, 13 May 2020 09:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363360;
        bh=Akg9xLHTZHHWY/epxL7GMjYFLSg63eUOf9Ut5sYs75s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kpl1pzDvcAQnbeMURLT2g3A5d4VBf6zyIEC13eRKXZp7r8OtLy9CRJFYnLoY+NUC6
         bVtdBLG5W5FhLtnoEvGKuDNAM0byhd23ZDuFZ15tO6lwoXty/5iWQyAFaIovzGHEVq
         ukfZmOqdiYgBa0b4B0zygNknOVyHG3lzSOKNTi4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/90] drm/amdgpu: drop redundant cg/pg ungate on runpm enter
Date:   Wed, 13 May 2020 11:44:03 +0200
Message-Id: <20200513094409.822993461@linuxfoundation.org>
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

[ Upstream commit f7b52890daba570bc8162d43c96b5583bbdd4edd ]

CG/PG ungate is already performed in ip_suspend_phase1. Otherwise,
the CG/PG ungate will be performed twice. That will cause gfxoff
disablement is performed twice also on runpm enter while gfxoff
enablemnt once on rump exit. That will put gfxoff into disabled
state.

Fixes: b2a7e9735ab286 ("drm/amdgpu: fix the hw hang during perform system reboot and reset")
Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index ca2a0770aad2e..5e1dce4241547 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3070,9 +3070,6 @@ int amdgpu_device_suspend(struct drm_device *dev, bool suspend, bool fbcon)
 		}
 	}
 
-	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
-	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
-
 	amdgpu_ras_suspend(adev);
 
 	r = amdgpu_device_ip_suspend_phase1(adev);
-- 
2.20.1



