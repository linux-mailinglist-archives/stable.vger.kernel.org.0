Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCAA2A43B2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 12:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgKCLDb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 3 Nov 2020 06:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbgKCLDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 06:03:30 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF69C0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 03:03:30 -0800 (PST)
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 211651F4561E;
        Tue,  3 Nov 2020 11:03:29 +0000 (GMT)
Date:   Tue, 3 Nov 2020 12:03:26 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>,
        Robin Murphy <robin.murphy@arm.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v3] drm/panfrost: Move the GPU reset bits outside the
 timeout handler
Message-ID: <20201103120326.10037005@collabora.com>
In-Reply-To: <20201103102540.GB401619@phenom.ffwll.local>
References: <20201103081347.1000139-1-boris.brezillon@collabora.com>
        <20201103102540.GB401619@phenom.ffwll.local>
Organization: Collabora
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 3 Nov 2020 11:25:40 +0100
Daniel Vetter <daniel@ffwll.ch> wrote:

> On Tue, Nov 03, 2020 at 09:13:47AM +0100, Boris Brezillon wrote:
> > We've fixed many races in panfrost_job_timedout() but some remain.
> > Instead of trying to fix it again, let's simplify the logic and move
> > the reset bits to a separate work scheduled when one of the queue
> > reports a timeout.
> > 
> > v3:
> > - Replace the atomic_cmpxchg() by an atomic_xchg() (Robin Murphy)
> > - Add Steven's R-b
> > 
> > v2:
> > - Use atomic_cmpxchg() to conditionally schedule the reset work (Steven Price)
> > 
> > Fixes: 1a11a88cfd9a ("drm/panfrost: Fix job timeout handling")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> > Reviewed-by: Steven Price <steven.price@arm.com>  
> 
> Sprinkling the dma_fence annotations over this would be really nice ...

You mean something like that?

--->8---
From 4f90ee2972eaec0332833ff6f9ea078acbfa899a Mon Sep 17 00:00:00 2001
From: Boris Brezillon <boris.brezillon@collabora.com>
Date: Tue, 3 Nov 2020 12:01:09 +0100
Subject: [PATCH] drm/panfrost: Annotate dma_fence signalling

Annotate dma_fence signalling to help lockdep catch deadlocks.

Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panfrost/panfrost_job.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
index 569a099dc10e..046cb3677332 100644
--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -482,7 +482,9 @@ static irqreturn_t panfrost_job_irq_handler(int irq, void *data)
 
 		if (status & JOB_INT_MASK_DONE(j)) {
 			struct panfrost_job *job;
+			bool cookie;
 
+			cookie = dma_fence_begin_signalling();
 			spin_lock(&pfdev->js->job_lock);
 			job = pfdev->jobs[j];
 			/* Only NULL if job timeout occurred */
@@ -496,6 +498,7 @@ static irqreturn_t panfrost_job_irq_handler(int irq, void *data)
 				pm_runtime_put_autosuspend(pfdev->dev);
 			}
 			spin_unlock(&pfdev->js->job_lock);
+			dma_fence_end_signalling(cookie);
 		}
 
 		status &= ~mask;
