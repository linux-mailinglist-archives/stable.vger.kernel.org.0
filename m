Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA96E2A39A0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgKCBTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:19:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727666AbgKCBTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:19:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78D1422264;
        Tue,  3 Nov 2020 01:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366359;
        bh=K/SXxsNkThrwbE4r+ibPrqWEftAgxZ6uEO6Io1rGk3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0rXoHlSI62in4qQrdlxPc4O6OOslfSJM+743B9r5wjeXQYrCDZvXDcY6GNdb1PqW
         oeOKPTBIcEEk5/G1Ea2JaYrbxPxYpaKTYuyz6rkl6nMyfotcemnvQL4EaGMwALFL40
         vPJJs671MO4iWGmjgL1CukN86o8U42S+Loabib1s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Seung-Woo Kim <sw0312.kim@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.9 29/35] staging: mmal-vchiq: Fix memory leak for vchiq_instance
Date:   Mon,  2 Nov 2020 20:18:34 -0500
Message-Id: <20201103011840.182814-29-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011840.182814-1-sashal@kernel.org>
References: <20201103011840.182814-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seung-Woo Kim <sw0312.kim@samsung.com>

[ Upstream commit b6ae84d648954fae096d94faea1ddb6518b27841 ]

The vchiq_instance is allocated with vchiq_initialise() but never
freed properly. Fix memory leak for the vchiq_instance.

Reported-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Link: https://lore.kernel.org/r/1603706150-10806-1-git-send-email-sw0312.kim@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../vc04_services/vchiq-mmal/mmal-vchiq.c     | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c b/drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c
index e798d494f00ff..bbf033ca47362 100644
--- a/drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c
@@ -179,6 +179,9 @@ struct vchiq_mmal_instance {
 
 	/* ordered workqueue to process all bulk operations */
 	struct workqueue_struct *bulk_wq;
+
+	/* handle for a vchiq instance */
+	struct vchiq_instance *vchiq_instance;
 };
 
 static struct mmal_msg_context *
@@ -1840,6 +1843,7 @@ int vchiq_mmal_finalise(struct vchiq_mmal_instance *instance)
 
 	mutex_unlock(&instance->vchiq_mutex);
 
+	vchiq_shutdown(instance->vchiq_instance);
 	flush_workqueue(instance->bulk_wq);
 	destroy_workqueue(instance->bulk_wq);
 
@@ -1856,6 +1860,7 @@ EXPORT_SYMBOL_GPL(vchiq_mmal_finalise);
 int vchiq_mmal_init(struct vchiq_mmal_instance **out_instance)
 {
 	int status;
+	int err = -ENODEV;
 	struct vchiq_mmal_instance *instance;
 	static struct vchiq_instance *vchiq_instance;
 	struct vchiq_service_params params = {
@@ -1890,17 +1895,21 @@ int vchiq_mmal_init(struct vchiq_mmal_instance **out_instance)
 	status = vchiq_connect(vchiq_instance);
 	if (status) {
 		pr_err("Failed to connect VCHI instance (status=%d)\n", status);
-		return -EIO;
+		err = -EIO;
+		goto err_shutdown_vchiq;
 	}
 
 	instance = kzalloc(sizeof(*instance), GFP_KERNEL);
 
-	if (!instance)
-		return -ENOMEM;
+	if (!instance) {
+		err = -ENOMEM;
+		goto err_shutdown_vchiq;
+	}
 
 	mutex_init(&instance->vchiq_mutex);
 
 	instance->bulk_scratch = vmalloc(PAGE_SIZE);
+	instance->vchiq_instance = vchiq_instance;
 
 	mutex_init(&instance->context_map_lock);
 	idr_init_base(&instance->context_map, 1);
@@ -1932,7 +1941,9 @@ int vchiq_mmal_init(struct vchiq_mmal_instance **out_instance)
 err_free:
 	vfree(instance->bulk_scratch);
 	kfree(instance);
-	return -ENODEV;
+err_shutdown_vchiq:
+	vchiq_shutdown(vchiq_instance);
+	return err;
 }
 EXPORT_SYMBOL_GPL(vchiq_mmal_init);
 
-- 
2.27.0

