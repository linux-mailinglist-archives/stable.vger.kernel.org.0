Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801E62A5818
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbgKCVsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:48:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731755AbgKCUuG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DE0720719;
        Tue,  3 Nov 2020 20:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436605;
        bh=NpASS000Ip1rXIuNT99G/rbIO+PVGDUeTdGfBOxoxNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LeD36dLMcBEg++2gHinNebJBS59LenhPa0AU4NZbfOSZ64SeVn0gyc7q/qf/jXxOk
         Z2CKwGw3+NEpjUG2kgmpKBOTMyTO0FF0Hc7Xtf+RISBAc4BvHij2f4c1QgycQ4u2mG
         VQF2dhaHHASDWTsdT83n3bi32m76b0yPqepPOcf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 323/391] drm/amd/display: Avoid MST manager resource leak.
Date:   Tue,  3 Nov 2020 21:36:14 +0100
Message-Id: <20201103203408.922157208@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

commit 5dff80bdce9e385af5716ed083f9e33e814484ab upstream.

On connector destruction call drm_dp_mst_topology_mgr_destroy
to release resources allocated in drm_dp_mst_topology_mgr_init.
Do it only if MST manager was initilized before otherwsie a crash
is seen on driver unload/device unplug.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4882,6 +4882,13 @@ static void amdgpu_dm_connector_destroy(
 	struct amdgpu_device *adev = connector->dev->dev_private;
 	struct amdgpu_display_manager *dm = &adev->dm;
 
+	/*
+	 * Call only if mst_mgr was iniitalized before since it's not done
+	 * for all connector types.
+	 */
+	if (aconnector->mst_mgr.dev)
+		drm_dp_mst_topology_mgr_destroy(&aconnector->mst_mgr);
+
 #if defined(CONFIG_BACKLIGHT_CLASS_DEVICE) ||\
 	defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE)
 


