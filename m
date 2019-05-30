Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A122F491
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbfE3Ejo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:39:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728239AbfE3DMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:37 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADFE923C5A;
        Thu, 30 May 2019 03:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185956;
        bh=r4n9B0Nzlwy+WTd/3TjJMZizJyy4JvP92WwFbRE+sXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQBYa2peTvOp9qBk8W78Kcsa1yb42wxDhMVtBlhavxTQrC6rM/7haJsrfKJ3+/PMj
         b4pqZyV4ARYIO8sWkip4Wd+hMp3p2o2WAA9GUVUZXrPmpNXQCpWhlFGv4wbFyS9ta5
         XKSU7r2Mm4PEZ1hK2TvfQFvtynAr03ynPq+JS4eA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 373/405] drm: writeback: Fix leak of writeback job
Date:   Wed, 29 May 2019 20:06:11 -0700
Message-Id: <20190530030559.595289366@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e482ae9b5fdc01a343f22f52930e85a6cfdf85eb ]

Writeback jobs are allocated when the WRITEBACK_FB_ID is set, and
deleted when the jobs complete. This results in both a memory leak of
the job and a leak of the framebuffer if the atomic commit returns
before the job is queued for processing, for instance if the atomic
check fails or if the commit runs in test-only mode.

Fix this by implementing the drm_writeback_cleanup_job() function and
calling it from __drm_atomic_helper_connector_destroy_state(). As
writeback jobs are removed from the state when they're queued for
processing, any job left in the state when the state gets destroyed
needs to be cleaned up.

The existing declaration of the drm_writeback_cleanup_job() function
without an implementation hints that this problem was considered, but
never addressed.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Brian Starkey <brian.starkey@arm.com>
Acked-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_atomic_state_helper.c |  4 ++++
 drivers/gpu/drm/drm_writeback.c           | 14 +++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_atomic_state_helper.c b/drivers/gpu/drm/drm_atomic_state_helper.c
index 4985384e51f6e..59ffb6b9c7453 100644
--- a/drivers/gpu/drm/drm_atomic_state_helper.c
+++ b/drivers/gpu/drm/drm_atomic_state_helper.c
@@ -30,6 +30,7 @@
 #include <drm/drm_connector.h>
 #include <drm/drm_atomic.h>
 #include <drm/drm_device.h>
+#include <drm/drm_writeback.h>
 
 #include <linux/slab.h>
 #include <linux/dma-fence.h>
@@ -412,6 +413,9 @@ __drm_atomic_helper_connector_destroy_state(struct drm_connector_state *state)
 
 	if (state->commit)
 		drm_crtc_commit_put(state->commit);
+
+	if (state->writeback_job)
+		drm_writeback_cleanup_job(state->writeback_job);
 }
 EXPORT_SYMBOL(__drm_atomic_helper_connector_destroy_state);
 
diff --git a/drivers/gpu/drm/drm_writeback.c b/drivers/gpu/drm/drm_writeback.c
index c20e6fe00cb38..2d75032f81591 100644
--- a/drivers/gpu/drm/drm_writeback.c
+++ b/drivers/gpu/drm/drm_writeback.c
@@ -268,6 +268,15 @@ void drm_writeback_queue_job(struct drm_writeback_connector *wb_connector,
 }
 EXPORT_SYMBOL(drm_writeback_queue_job);
 
+void drm_writeback_cleanup_job(struct drm_writeback_job *job)
+{
+	if (job->fb)
+		drm_framebuffer_put(job->fb);
+
+	kfree(job);
+}
+EXPORT_SYMBOL(drm_writeback_cleanup_job);
+
 /*
  * @cleanup_work: deferred cleanup of a writeback job
  *
@@ -280,10 +289,9 @@ static void cleanup_work(struct work_struct *work)
 	struct drm_writeback_job *job = container_of(work,
 						     struct drm_writeback_job,
 						     cleanup_work);
-	drm_framebuffer_put(job->fb);
-	kfree(job);
-}
 
+	drm_writeback_cleanup_job(job);
+}
 
 /**
  * drm_writeback_signal_completion - Signal the completion of a writeback job
-- 
2.20.1



