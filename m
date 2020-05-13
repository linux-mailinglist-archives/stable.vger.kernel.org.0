Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4C31D0D5B
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732727AbgEMJwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732840AbgEMJwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:52:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6590220740;
        Wed, 13 May 2020 09:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363540;
        bh=BzKH8StmHV6/JIwreyqHM9gQEKpaQpdBcq80m+A7K+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R25uVRiPLkmvfCsblK+M/7a+Vgn4ZSn+F5HoiQtVGZhi6SkQV0nqar3b3j27lDocS
         G5R6so3HSjhVUW39HONVYlVhtsWwcjsfZE/5yqTKSQVNYOOt8EexXt/icFYBtu3ZHF
         W/XAa3Dnv4i+jPKp3vXPJcNwceu07+68HnmOkYWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 004/118] drm/amdgpu: drop redundant cg/pg ungate on runpm enter
Date:   Wed, 13 May 2020 11:43:43 +0200
Message-Id: <20200513094418.009604063@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
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
index 1ddf2460cf834..5fcbacddb9b0e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3325,9 +3325,6 @@ int amdgpu_device_suspend(struct drm_device *dev, bool fbcon)
 		}
 	}
 
-	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
-	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
-
 	amdgpu_ras_suspend(adev);
 
 	r = amdgpu_device_ip_suspend_phase1(adev);
-- 
2.20.1



