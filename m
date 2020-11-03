Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623CB2A5677
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732587AbgKCU7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:59:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733148AbgKCU7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66BA522226;
        Tue,  3 Nov 2020 20:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437185;
        bh=VN2joP1QwjsTsFMr9W1EBaKAcBuzynY8faArlkwSbJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjwC6anBCamWjrl/E+fc2gRkXVEkS/1M4fhZmerbQANbwAbqaXKNtDdLCUWF/eMvc
         cvYgx01/EZQxOceWH8ptNd2I6PMXvrJecAh381k4vV/olQw0Ih44K9vHH1CgTMejIM
         mbv+0CGr8fWN2UMA3oBNrkBqEfWCFBoVkCM1h9wU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 183/214] drm/amd/display: Avoid MST manager resource leak.
Date:   Tue,  3 Nov 2020 21:37:11 +0100
Message-Id: <20201103203307.859116601@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
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
@@ -3956,6 +3956,13 @@ static void amdgpu_dm_connector_destroy(
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
 


