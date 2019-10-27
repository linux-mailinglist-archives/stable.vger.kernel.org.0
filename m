Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF801E68B5
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731115AbfJ0VRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731108AbfJ0VRo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:17:44 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5CFE2070B;
        Sun, 27 Oct 2019 21:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211063;
        bh=oGHknJ1O/6LAjrtCeIttoLqZwSAoc1U8qXk1HVnDHX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLy0X3hZMa2r6kFjeoSPyUOAhHFW6cg9uyuUxDv+zjAV1GFlxjXkFnSvoW9jJq5ni
         HfVq/abp5Zih5TWHMoiw4hp6+bPMbWC9c53fW7RlDAY2TvUX2hD8VkA2kFJiEDnW0w
         TX9agL3kpeHixVyqDA8c9TB1Cz2EtVBZ60zdNHuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Lowry Li (Arm Technology China)" <lowry.li@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        "James Qian Wang (Arm Technology China)" <james.qian.wang@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 002/197] drm: Clear the fence pointer when writeback job signaled
Date:   Sun, 27 Oct 2019 21:58:40 +0100
Message-Id: <20191027203351.823794615@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lowry Li (Arm Technology China) <Lowry.Li@arm.com>

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



