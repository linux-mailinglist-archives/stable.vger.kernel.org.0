Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0320395FD9
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhEaOQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233626AbhEaOOc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:14:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7ED026199C;
        Mon, 31 May 2021 13:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468547;
        bh=68svN8qALJMVamZXMkW6w5NBf89LKW/Z7/CfJcreCr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRbZmuRx+YrcJt16g9jnvKdcgPdPGMNkuXFMXKMs+U1VF6pGlXdJM0tDcgnCtUEep
         8PzrOUvsgBxQBG0Con1bJhWWVJ3W2Bjst5BoQPTYq6jcmWFxXTKUoTOEQOsFiEC6VP
         7DnDMw0xQqdpePrJXhncwKtrYuxeqd50UdL7FmBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Leo Liu <leo.liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 031/177] drm/amdgpu/vcn1: add cancel_delayed_work_sync before power gate
Date:   Mon, 31 May 2021 15:13:08 +0200
Message-Id: <20210531130649.002914653@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Zhu <James.Zhu@amd.com>

commit b95f045ea35673572ef46d6483ad8bd6d353d63c upstream.

Add cancel_delayed_work_sync before set power gating state
to avoid race condition issue when power gating.

Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c
@@ -233,9 +233,13 @@ static int vcn_v1_0_hw_fini(void *handle
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 	struct amdgpu_ring *ring = &adev->vcn.inst->ring_dec;
 
+	cancel_delayed_work_sync(&adev->vcn.idle_work);
+
 	if ((adev->pg_flags & AMD_PG_SUPPORT_VCN_DPG) ||
-		RREG32_SOC15(VCN, 0, mmUVD_STATUS))
+		(adev->vcn.cur_state != AMD_PG_STATE_GATE &&
+		 RREG32_SOC15(VCN, 0, mmUVD_STATUS))) {
 		vcn_v1_0_set_powergating_state(adev, AMD_PG_STATE_GATE);
+	}
 
 	ring->sched.ready = false;
 


