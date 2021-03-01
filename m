Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA12328A48
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239143AbhCASOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:14:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:58186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239443AbhCASIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C86AB65104;
        Mon,  1 Mar 2021 17:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618897;
        bh=7jTk6X3nESlHt2daZxwA5T/oEbwBTmja9BtwEuC7MiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLkrgS+I6kpSb7tWf1XxSjHHkQaiOwHPL9bIxyTZXHykYraFQ1Pnf9DzYtlUIrPLj
         XKtuZFpd2WNu00qJj+3pY1t2wCvsK1NgnYyLVsUxZA/yjVkcMuH5F5bvTa3Zu3Reia
         zbkxH1Vytxc0LnBk+MRwLDwFi+vwszyTt80iW+8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 256/663] drm/amdgpu/display: remove hdcp_srm sysfs on device removal
Date:   Mon,  1 Mar 2021 17:08:24 +0100
Message-Id: <20210301161154.491191139@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

[ Upstream commit e96b1b2974989c6a25507b527843ede7594efc85 ]

Fixes: 9037246bb2da5 ("drm/amd/display: Add sysfs interface for set/get srm")

Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c      | 2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c | 3 ++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index fdca76fc598c0..bffaefaf5a292 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1096,7 +1096,7 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 
 #ifdef CONFIG_DRM_AMD_DC_HDCP
 	if (adev->dm.hdcp_workqueue) {
-		hdcp_destroy(adev->dm.hdcp_workqueue);
+		hdcp_destroy(&adev->dev->kobj, adev->dm.hdcp_workqueue);
 		adev->dm.hdcp_workqueue = NULL;
 	}
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
index c2cd184f0bbd4..79de68ac03f20 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -376,7 +376,7 @@ static void event_cpirq(struct work_struct *work)
 }
 
 
-void hdcp_destroy(struct hdcp_workqueue *hdcp_work)
+void hdcp_destroy(struct kobject *kobj, struct hdcp_workqueue *hdcp_work)
 {
 	int i = 0;
 
@@ -385,6 +385,7 @@ void hdcp_destroy(struct hdcp_workqueue *hdcp_work)
 		cancel_delayed_work_sync(&hdcp_work[i].watchdog_timer_dwork);
 	}
 
+	sysfs_remove_bin_file(kobj, &hdcp_work[0].attr);
 	kfree(hdcp_work->srm);
 	kfree(hdcp_work->srm_temp);
 	kfree(hdcp_work);
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h
index 5159b3a5e5b03..09294ff122fea 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.h
@@ -69,7 +69,7 @@ void hdcp_update_display(struct hdcp_workqueue *hdcp_work,
 
 void hdcp_reset_display(struct hdcp_workqueue *work, unsigned int link_index);
 void hdcp_handle_cpirq(struct hdcp_workqueue *work, unsigned int link_index);
-void hdcp_destroy(struct hdcp_workqueue *work);
+void hdcp_destroy(struct kobject *kobj, struct hdcp_workqueue *work);
 
 struct hdcp_workqueue *hdcp_create_workqueue(struct amdgpu_device *adev, struct cp_psp *cp_psp, struct dc *dc);
 
-- 
2.27.0



