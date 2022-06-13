Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2A45491C9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379090AbiFMNrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379762AbiFMNpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:45:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAABF25;
        Mon, 13 Jun 2022 04:32:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F3C2B80E93;
        Mon, 13 Jun 2022 11:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BE1C36B0A;
        Mon, 13 Jun 2022 11:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119953;
        bh=OFNj5xmXGxE4mdg0R2KYtiLRMIxzRi9bXGMK1v6AV0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7a/7oq0jypROSDCsf3AacsqV7z5C0NJPpbUQKprBFYhVRKrG0scvrDQN1utRhjCZ
         Ui6VrCRfURFgOSZEuTeQCWNb/1b2Y3Wshy1MEOS/ETjHhQVoGlluOdHF3akcHpnHeX
         wd7G+14QeZH9qFFh8APGKRcho2n/Xffc5iF0umR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 178/339] drm/panfrost: Job should reference MMU not file_priv
Date:   Mon, 13 Jun 2022 12:10:03 +0200
Message-Id: <20220613094932.073544035@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

[ Upstream commit 6e516faf04317db2c46cbec4e3b78b4653a5b109 ]

For a while now it's been allowed for a MMU context to outlive it's
corresponding panfrost_priv, however the job structure still references
panfrost_priv to get hold of the MMU context. If panfrost_priv has been
freed this is a use-after-free which I've been able to trigger resulting
in a splat.

To fix this, drop the reference to panfrost_priv in the job structure
and add a direct reference to the MMU structure which is what's actually
needed.

Fixes: 7fdc48cc63a3 ("drm/panfrost: Make sure MMU context lifetime is not bound to panfrost_priv")
Signed-off-by: Steven Price <steven.price@arm.com>
Acked-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220519152003.81081-1-steven.price@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 5 +++--
 drivers/gpu/drm/panfrost/panfrost_job.c | 6 +++---
 drivers/gpu/drm/panfrost/panfrost_job.h | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 94b6f0a19c83..47780fe597f2 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -233,6 +233,7 @@ static int panfrost_ioctl_submit(struct drm_device *dev, void *data,
 		struct drm_file *file)
 {
 	struct panfrost_device *pfdev = dev->dev_private;
+	struct panfrost_file_priv *file_priv = file->driver_priv;
 	struct drm_panfrost_submit *args = data;
 	struct drm_syncobj *sync_out = NULL;
 	struct panfrost_job *job;
@@ -262,12 +263,12 @@ static int panfrost_ioctl_submit(struct drm_device *dev, void *data,
 	job->jc = args->jc;
 	job->requirements = args->requirements;
 	job->flush_id = panfrost_gpu_get_latest_flush_id(pfdev);
-	job->file_priv = file->driver_priv;
+	job->mmu = file_priv->mmu;
 
 	slot = panfrost_job_get_slot(job);
 
 	ret = drm_sched_job_init(&job->base,
-				 &job->file_priv->sched_entity[slot],
+				 &file_priv->sched_entity[slot],
 				 NULL);
 	if (ret)
 		goto out_put_job;
diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
index a6925dbb6224..22c2af1a4627 100644
--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -201,7 +201,7 @@ static void panfrost_job_hw_submit(struct panfrost_job *job, int js)
 		return;
 	}
 
-	cfg = panfrost_mmu_as_get(pfdev, job->file_priv->mmu);
+	cfg = panfrost_mmu_as_get(pfdev, job->mmu);
 
 	job_write(pfdev, JS_HEAD_NEXT_LO(js), lower_32_bits(jc_head));
 	job_write(pfdev, JS_HEAD_NEXT_HI(js), upper_32_bits(jc_head));
@@ -431,7 +431,7 @@ static void panfrost_job_handle_err(struct panfrost_device *pfdev,
 		job->jc = 0;
 	}
 
-	panfrost_mmu_as_put(pfdev, job->file_priv->mmu);
+	panfrost_mmu_as_put(pfdev, job->mmu);
 	panfrost_devfreq_record_idle(&pfdev->pfdevfreq);
 
 	if (signal_fence)
@@ -452,7 +452,7 @@ static void panfrost_job_handle_done(struct panfrost_device *pfdev,
 	 * happen when we receive the DONE interrupt while doing a GPU reset).
 	 */
 	job->jc = 0;
-	panfrost_mmu_as_put(pfdev, job->file_priv->mmu);
+	panfrost_mmu_as_put(pfdev, job->mmu);
 	panfrost_devfreq_record_idle(&pfdev->pfdevfreq);
 
 	dma_fence_signal_locked(job->done_fence);
diff --git a/drivers/gpu/drm/panfrost/panfrost_job.h b/drivers/gpu/drm/panfrost/panfrost_job.h
index 77e6d0e6f612..8becc1ba0eb9 100644
--- a/drivers/gpu/drm/panfrost/panfrost_job.h
+++ b/drivers/gpu/drm/panfrost/panfrost_job.h
@@ -17,7 +17,7 @@ struct panfrost_job {
 	struct kref refcount;
 
 	struct panfrost_device *pfdev;
-	struct panfrost_file_priv *file_priv;
+	struct panfrost_mmu *mmu;
 
 	/* Fence to be signaled by IRQ handler when the job is complete. */
 	struct dma_fence *done_fence;
-- 
2.35.1



