Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B849AD16C9
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731976AbfJIRXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:23:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730490AbfJIRXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:23:54 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 119A121920;
        Wed,  9 Oct 2019 17:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641834;
        bh=/4mMuhJyPwKfQfkFTTqyLam8OguJfnlyat4cAdt/7VI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6GS984hK9CM5ZnARTBXIjvK6o0cJl8roJSSmMXGxyPdViHpTRvz4T82OrdPDfOhL
         cr+hLkjOHi8RyQFbbrFg5583BmCCDUZ08U7j40MZY/BGD2nphT4vXN9zD76Oru/vS/
         owwuI5j8DQRv1Gtdx6VllZzfqo8jHOTd33YRCXFI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Lowry Li (Arm Technology China)" <Lowry.Li@arm.com>,
        Lowry Li <lowry.li@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        James Qian Wang <james.qian.wang@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 03/68] drm: Clear the fence pointer when writeback job signaled
Date:   Wed,  9 Oct 2019 13:04:42 -0400
Message-Id: <20191009170547.32204-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170547.32204-1-sashal@kernel.org>
References: <20191009170547.32204-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Lowry Li (Arm Technology China)" <Lowry.Li@arm.com>

[ Upstream commit b1066a123538044117f0a78ba8c6a50cf5a04c86 ]

During it signals the completion of a writeback job, after releasing
the out_fence, we'd clear the pointer.

Check if fence left over in drm_writeback_cleanup_job(), release it.

Signed-off-by: Lowry Li (Arm Technology China) <lowry.li@arm.com>
Reviewed-by: Brian Starkey <brian.starkey@arm.com>
Reviewed-by: James Qian Wang (Arm Technology China) <james.qian.wang@arm.com>
Signed-off-by: james qian wang (Arm Technology China) <james.qian.wang@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1564571048-15029-3-git-send-email-lowry.li@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_writeback.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/drm_writeback.c b/drivers/gpu/drm/drm_writeback.c
index ff138b6ec48ba..43d9e3bb3a943 100644
--- a/drivers/gpu/drm/drm_writeback.c
+++ b/drivers/gpu/drm/drm_writeback.c
@@ -324,6 +324,9 @@ void drm_writeback_cleanup_job(struct drm_writeback_job *job)
 	if (job->fb)
 		drm_framebuffer_put(job->fb);
 
+	if (job->out_fence)
+		dma_fence_put(job->out_fence);
+
 	kfree(job);
 }
 EXPORT_SYMBOL(drm_writeback_cleanup_job);
@@ -366,25 +369,29 @@ drm_writeback_signal_completion(struct drm_writeback_connector *wb_connector,
 {
 	unsigned long flags;
 	struct drm_writeback_job *job;
+	struct dma_fence *out_fence;
 
 	spin_lock_irqsave(&wb_connector->job_lock, flags);
 	job = list_first_entry_or_null(&wb_connector->job_queue,
 				       struct drm_writeback_job,
 				       list_entry);
-	if (job) {
+	if (job)
 		list_del(&job->list_entry);
-		if (job->out_fence) {
-			if (status)
-				dma_fence_set_error(job->out_fence, status);
-			dma_fence_signal(job->out_fence);
-			dma_fence_put(job->out_fence);
-		}
-	}
+
 	spin_unlock_irqrestore(&wb_connector->job_lock, flags);
 
 	if (WARN_ON(!job))
 		return;
 
+	out_fence = job->out_fence;
+	if (out_fence) {
+		if (status)
+			dma_fence_set_error(out_fence, status);
+		dma_fence_signal(out_fence);
+		dma_fence_put(out_fence);
+		job->out_fence = NULL;
+	}
+
 	INIT_WORK(&job->cleanup_work, cleanup_work);
 	queue_work(system_long_wq, &job->cleanup_work);
 }
-- 
2.20.1

