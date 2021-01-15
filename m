Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBCA2F7A3C
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388002AbhAOMhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:37:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:44784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387997AbhAOMhb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F410522473;
        Fri, 15 Jan 2021 12:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714211;
        bh=zFgr4LD4Ax9y75P2OZd4JJTP0ouxnGyFBHYxHhyn9v8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KsvRO9cpD1Qoi/UozCyxXAIiN5DD2BuduJv6vnrJh5qA7jo7zrWFv7ARhpq+MrsfJ
         hZqmPwy40Ivk6Pfq78zGj9tOfWdoLZ3+ccHkljla00UgSC/cpjjk10ElsnETCB6jfn
         fftMD0FLNEF+Ymn6LUvvoy9eWeeJ8c/OtYH7p4Vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/103] drm/panfrost: Dont corrupt the queue mutex on open/close
Date:   Fri, 15 Jan 2021 13:27:00 +0100
Message-Id: <20210115122006.408206973@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

[ Upstream commit a17d609e3e216c406f7c0cec2a94086a4401ac06 ]

The mutex within the panfrost_queue_state should have the lifetime of
the queue, however it was erroneously initialised/destroyed during
panfrost_job_{open,close} which is called every time a client
opens/closes the drm node.

Move the initialisation/destruction to panfrost_job_{init,fini} where it
belongs.

Fixes: 1a11a88cfd9a ("drm/panfrost: Fix job timeout handling")
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201029170047.30564-1-steven.price@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_job.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
index 1ce2001106e56..517dfb247a801 100644
--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -617,6 +617,8 @@ int panfrost_job_init(struct panfrost_device *pfdev)
 	}
 
 	for (j = 0; j < NUM_JOB_SLOTS; j++) {
+		mutex_init(&js->queue[j].lock);
+
 		js->queue[j].fence_context = dma_fence_context_alloc(1);
 
 		ret = drm_sched_init(&js->queue[j].sched,
@@ -647,8 +649,10 @@ void panfrost_job_fini(struct panfrost_device *pfdev)
 
 	job_write(pfdev, JOB_INT_MASK, 0);
 
-	for (j = 0; j < NUM_JOB_SLOTS; j++)
+	for (j = 0; j < NUM_JOB_SLOTS; j++) {
 		drm_sched_fini(&js->queue[j].sched);
+		mutex_destroy(&js->queue[j].lock);
+	}
 
 }
 
@@ -660,7 +664,6 @@ int panfrost_job_open(struct panfrost_file_priv *panfrost_priv)
 	int ret, i;
 
 	for (i = 0; i < NUM_JOB_SLOTS; i++) {
-		mutex_init(&js->queue[i].lock);
 		sched = &js->queue[i].sched;
 		ret = drm_sched_entity_init(&panfrost_priv->sched_entity[i],
 					    DRM_SCHED_PRIORITY_NORMAL, &sched,
@@ -677,10 +680,8 @@ void panfrost_job_close(struct panfrost_file_priv *panfrost_priv)
 	struct panfrost_job_slot *js = pfdev->js;
 	int i;
 
-	for (i = 0; i < NUM_JOB_SLOTS; i++) {
+	for (i = 0; i < NUM_JOB_SLOTS; i++)
 		drm_sched_entity_destroy(&panfrost_priv->sched_entity[i]);
-		mutex_destroy(&js->queue[i].lock);
-	}
 }
 
 int panfrost_job_is_idle(struct panfrost_device *pfdev)
-- 
2.27.0



