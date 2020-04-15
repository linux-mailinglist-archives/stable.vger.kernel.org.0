Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0DB1A9C58
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408859AbgDOLee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:34:34 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52739 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408856AbgDOLeb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:34:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 053B05C01F5;
        Wed, 15 Apr 2020 07:34:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:34:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rxKfCS
        XUBQ8hX/FjMtaM/GkHN5Pfa8mPxXZbqHVfOFw=; b=d6ljXyps1N1a7IC9LD6qLL
        /85xUyGBI5LLUnU7cLSldyGaT7cvkY2MXuFn+eMZJgP78bfs8UDS576w9tvZznNT
        6wTI8XnS0g1RTby/ULArMe8yHhlAqm5PU8ZoIM9L585v8xlPz2lPU+ByWILSh8K8
        1UA6UFb1HPPr/pefYoF3Q+XepJqhwIsQ1BaaP5vXW2sAmwg4YHwEQqVF+T8os5KD
        3LFQMrChBJLJEK2T0LF3AO4SO3eXQs0sarxFZxRneZhT4dyFYi1XuTHAvkgoxkbP
        SBGqLFM/yP+ODiUL2NbPc75sSryxz3+rfopj6eQNSD6fsCB6pdc5tEGesl8T2QWw
        ==
X-ME-Sender: <xms:RfGWXpkBXn7haoIJlWMLJQvC3DyEa1iBww55DzO6GtiOGs2-Dc-kDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:RfGWXs7JDNpM_r457T9Hfiq4ZNAGPJM8YVXEGlXLdwd783wRHUNA4w>
    <xmx:RfGWXky2B0gpMGDxaMqSrP9VqAoE3J61xLeYTee908vA6lchqWUODQ>
    <xmx:RfGWXlJ4RziegSga8RrjxnG-u869y5s007CDhjDPfI-dtjF58pwkOg>
    <xmx:RvGWXjmCgNls03atD8_GmOpDd1mAEHsHqa8PbhzZKbZOhH2AQOB9NQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5456C306005C;
        Wed, 15 Apr 2020 07:34:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu: fix gfx hang during suspend with video playback" failed to apply to 5.6-stable tree
To:     Prike.Liang@amd.com, Mengbing.Wang@amd.com,
        alexander.deucher@amd.com, ray.huang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:34:28 +0200
Message-ID: <15869504681998@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 487eca11a321ef33bcf4ca5adb3c0c4954db1b58 Mon Sep 17 00:00:00 2001
From: Prike Liang <Prike.Liang@amd.com>
Date: Tue, 7 Apr 2020 20:21:26 +0800
Subject: [PATCH] drm/amdgpu: fix gfx hang during suspend with video playback
 (v2)

The system will be hang up during S3 suspend because of SMU is pending
for GC not respose the register CP_HQD_ACTIVE access request.This issue
root cause of accessing the GC register under enter GFX CGGPG and can
be fixed by disable GFX CGPG before perform suspend.

v2: Use disable the GFX CGPG instead of RLC safe mode guard.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Tested-by: Mengbing Wang <Mengbing.Wang@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index faa3e7102156..559dc24ef436 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2340,8 +2340,6 @@ static int amdgpu_device_ip_suspend_phase1(struct amdgpu_device *adev)
 {
 	int i, r;
 
-	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
-	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
 
 	for (i = adev->num_ip_blocks - 1; i >= 0; i--) {
 		if (!adev->ip_blocks[i].status.valid)
@@ -3356,6 +3354,9 @@ int amdgpu_device_suspend(struct drm_device *dev, bool fbcon)
 		}
 	}
 
+	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
+	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
+
 	amdgpu_amdkfd_suspend(adev, !fbcon);
 
 	amdgpu_ras_suspend(adev);

