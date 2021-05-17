Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E5E3836D3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243966AbhEQPgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:36:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243963AbhEQPeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A06561CD9;
        Mon, 17 May 2021 14:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262359;
        bh=AiU/BgLvW2ctw3w72amgEsbBuG1O1PL/JwBVyj4teM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aVuT0uXvsnNK9UHBTEgAxBAJN40wZtQnI09Xf5J6irdSD44GHmUA5EK2eIMbdxs6c
         RgHsPeUlc6zLwN6vlhKyWOOE//tNiHl1MYdkix9ZH8sPSDInGsf8cewORrFqPjFLr5
         VyOxmLUrDqlgzGbZoDCBLSqHr7g11hprgtdv1Knc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        David Ward <david.ward@gatech.edu>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 247/329] drm/amd/display: Initialize attribute for hdcp_srm sysfs file
Date:   Mon, 17 May 2021 16:02:38 +0200
Message-Id: <20210517140310.459347024@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ward <david.ward@gatech.edu>

commit fe1c97d008f86f672f0e9265f180c22451ca3b9f upstream.

It is stored in dynamically allocated memory, so sysfs_bin_attr_init() must
be called to initialize it. (Note: "initialization" only sets the .attr.key
member in this struct; it does not change the value of any other members.)

Otherwise, when CONFIG_DEBUG_LOCK_ALLOC=y this message appears during boot:

    BUG: key ffff9248900cd148 has not been registered!

Fixes: 9037246bb2da ("drm/amd/display: Add sysfs interface for set/get srm")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1586
Reported-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: David Ward <david.ward@gatech.edu>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -643,6 +643,7 @@ struct hdcp_workqueue *hdcp_create_workq
 
 	/* File created at /sys/class/drm/card0/device/hdcp_srm*/
 	hdcp_work[0].attr = data_attr;
+	sysfs_bin_attr_init(&hdcp_work[0].attr);
 
 	if (sysfs_create_bin_file(&adev->dev->kobj, &hdcp_work[0].attr))
 		DRM_WARN("Failed to create device file hdcp_srm");


