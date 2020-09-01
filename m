Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0BE0259479
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731222AbgIAPkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728847AbgIAPkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:40:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CE7B2176B;
        Tue,  1 Sep 2020 15:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974808;
        bh=zkZMGY/CYIoNUZbkh72y2HEDhe9M8knRpG2npOH/GiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UT/13ai5wEMarVDFd3gABLJEae4Ck1VIsSYQswqd8zTjLYL7fzwr95IjBxh/wKqEr
         kTvFDDGmbSuowsWyledrdj5ERPmlu8DQ4jr8m0RQYBSAKZbT8l8UFhf6RCoSFXJHQo
         7Cmyc3OHIsD7vV872hvvcM8BHLgwHCF4Ewi2mppw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 099/255] drm/etnaviv: always start/stop scheduler in timeout processing
Date:   Tue,  1 Sep 2020 17:09:15 +0200
Message-Id: <20200901151005.467213257@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 50248a3ec0f5e5debd18033eb2a29f0b793a7000 ]

The drm scheduler currently expects that the stop/start sequence is always
executed in the timeout handling, as the job at the head of the hardware
execution list is always removed from the ring mirror before the driver
function is called and only inserted back into the list when starting the
scheduler.

This adds some unnecessary overhead if the timeout handler determines
that the GPU is still executing jobs normally and just wished to extend
the timeout, but a better solution requires a major rearchitecture of the
scheduler, which is not applicable as a fix.

Fixes: 135517d3565b ("drm/scheduler: Avoid accessing freed bad job.")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_sched.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_sched.c b/drivers/gpu/drm/etnaviv/etnaviv_sched.c
index 4e3e95dce6d87..cd46c882269cc 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_sched.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_sched.c
@@ -89,12 +89,15 @@ static void etnaviv_sched_timedout_job(struct drm_sched_job *sched_job)
 	u32 dma_addr;
 	int change;
 
+	/* block scheduler */
+	drm_sched_stop(&gpu->sched, sched_job);
+
 	/*
 	 * If the GPU managed to complete this jobs fence, the timout is
 	 * spurious. Bail out.
 	 */
 	if (dma_fence_is_signaled(submit->out_fence))
-		return;
+		goto out_no_timeout;
 
 	/*
 	 * If the GPU is still making forward progress on the front-end (which
@@ -105,12 +108,9 @@ static void etnaviv_sched_timedout_job(struct drm_sched_job *sched_job)
 	change = dma_addr - gpu->hangcheck_dma_addr;
 	if (change < 0 || change > 16) {
 		gpu->hangcheck_dma_addr = dma_addr;
-		return;
+		goto out_no_timeout;
 	}
 
-	/* block scheduler */
-	drm_sched_stop(&gpu->sched, sched_job);
-
 	if(sched_job)
 		drm_sched_increase_karma(sched_job);
 
@@ -120,6 +120,7 @@ static void etnaviv_sched_timedout_job(struct drm_sched_job *sched_job)
 
 	drm_sched_resubmit_jobs(&gpu->sched);
 
+out_no_timeout:
 	/* restart scheduler after GPU is usable again */
 	drm_sched_start(&gpu->sched, true);
 }
-- 
2.25.1



