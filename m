Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5FE1A9C5E
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408861AbgDOLem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:34:42 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59239 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408856AbgDOLej (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:34:39 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D2F15C015B;
        Wed, 15 Apr 2020 07:34:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:34:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=AtqWIO
        2WbJdpkSFOapVeuFgLlusdj6KopsOoqBF8pS0=; b=TEKoOU5n547rVlgawkbyCC
        Iyip7ZeALrvGzAaqbWB1ffDsTIHWSDJLRasP5ZUIHWtR071m8lJ8ML8V/mi91mrW
        dMxkwp6kzhWGSsfQfcS/1obJmkoIZA2rjRYaHjBTJiDeOpX1U8mGBTyelggxSVjI
        bQUrg0aEsUzhNPSGExY0i2zgGXnrH16pZNKQlBIm2JSHscZ5rVGk4U434+XHKXP5
        k06bgFLusc4h0NPCMaphFkxTPD+A8zUIEenqK2gA1LydZtKto2Lv4i6+jiI99qN2
        1FLdvbcIxUgGyArq5ajxgmN3mSU7K9GhkxxEncB+6KHSP1oWYQGuP0gj16SlZC8g
        ==
X-ME-Sender: <xms:TfGWXurtoQntv0e5RB6STnSmRyfJl4ba9E-ZSgvTzP6jx_VAqHmvnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:TfGWXsGs0fA1eMJbkwVrR4AZuoYQJY6BZRIT9GQ_Gw37CStmhvjUWw>
    <xmx:TfGWXkT5kh7AAc1tYiiRvszI2F5GjgWXu2n2g7LIfHqD22YAZiC84A>
    <xmx:TfGWXiOt4QZDyQb1MPR7Mlr37KFQzGplDI6UiGuirhhOYGx4Nk5bPg>
    <xmx:TvGWXornDpK24KTkj0qDRcu_jWbBkcShiNwIXa7qyKuPgZVhJsxMOg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9C7773280064;
        Wed, 15 Apr 2020 07:34:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu: fix gfx hang during suspend with video playback" failed to apply to 5.5-stable tree
To:     Prike.Liang@amd.com, Mengbing.Wang@amd.com,
        alexander.deucher@amd.com, ray.huang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:34:28 +0200
Message-ID: <1586950468112129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
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

