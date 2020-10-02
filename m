Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE722811FE
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 14:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387815AbgJBMGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 08:06:34 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49024 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgJBMGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Oct 2020 08:06:33 -0400
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 1D954291181;
        Fri,  2 Oct 2020 13:06:32 +0100 (BST)
Date:   Fri, 2 Oct 2020 14:06:29 +0200
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Steven Price <steven.price@arm.com>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] drm/panfrost: Fix job timeout handling
Message-ID: <20201002140629.79174b26@collabora.com>
In-Reply-To: <20201002071032.1225267-1-boris.brezillon@collabora.com>
References: <20201002071032.1225267-1-boris.brezillon@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri,  2 Oct 2020 09:10:32 +0200
Boris Brezillon <boris.brezillon@collabora.com> wrote:

> @@ -392,19 +411,41 @@ static void panfrost_job_timedout(struct drm_sched_job *sched_job)
>  		job_read(pfdev, JS_TAIL_LO(js)),
>  		sched_job);
>  
> +	/* Scheduler is already stopped, nothing to do. */
> +	if (!panfrost_scheduler_stop(&pfdev->js->queue[js], sched_job))
> +		return;
> +
>  	if (!mutex_trylock(&pfdev->reset_lock))
>  		return;
>  
> +	mutex_lock(&pfdev->sched_lock);

Oops, sched_lock shouldn't be acquired here, I switched to a per-queue
lock instead.
