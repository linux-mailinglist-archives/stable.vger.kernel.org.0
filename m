Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B903A2A7FC2
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 14:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgKENkF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 5 Nov 2020 08:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgKENkE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 08:40:04 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C5FC0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 05:40:00 -0800 (PST)
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 74A731F4646B;
        Thu,  5 Nov 2020 13:39:56 +0000 (GMT)
Date:   Thu, 5 Nov 2020 14:39:53 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] drm/panfrost: Move the GPU reset bits outside the
 timeout handler
Message-ID: <20201105143953.516e75b2@collabora.com>
In-Reply-To: <d59e4750-ad1a-5573-16db-ad9b57b6eec5@arm.com>
References: <20201104170729.1828212-1-boris.brezillon@collabora.com>
        <d59e4750-ad1a-5573-16db-ad9b57b6eec5@arm.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 5 Nov 2020 13:27:04 +0000
Steven Price <steven.price@arm.com> wrote:

> > +	old_status = atomic_xchg(&queue->status,
> > +				 PANFROST_QUEUE_STATUS_STOPPED);
> > +	WARN_ON(old_status != PANFROST_QUEUE_STATUS_ACTIVE &&
> > +		old_status != PANFROST_QUEUE_STATUS_STOPPED);
> > +	if (old_status == PANFROST_QUEUE_STATUS_STOPPED)
> > +		goto out;  
> 
> NIT: It's slightly cleaner if you swap the above lines, i.e.:
> 
> 	if (old_status == PANFROST_QUEUE_STATUS_STOPPED)
> 		goto out;
> 	WARN_ON(old_status != PANFROST_QUEUE_STATUS_ACTIVE);

I agree.

> 
> > +
> > +	drm_sched_stop(&queue->sched, bad);
> > +	if (bad)
> > +		drm_sched_increase_karma(bad);
> > +
> > +	stopped = true;
> > +
> > +	/*
> > +	 * Set the timeout to max so the timer doesn't get started
> > +	 * when we return from the timeout handler (restored in
> > +	 * panfrost_scheduler_start()).
> > +	 */
> > +	queue->sched.timeout = MAX_SCHEDULE_TIMEOUT;
> > +
> > +out:
> >   	mutex_unlock(&queue->lock);
> >   
> >   	return stopped;
> >   }
> >   
> > +static void panfrost_scheduler_start(struct panfrost_queue_state *queue)
> > +{
> > +	enum panfrost_queue_status old_status;
> > +
> > +	mutex_lock(&queue->lock);
> > +	old_status = atomic_xchg(&queue->status,
> > +				 PANFROST_QUEUE_STATUS_STARTING);
> > +	if (WARN_ON(old_status != PANFROST_QUEUE_STATUS_STOPPED))
> > +		goto out;  
> 
> The error handling isn't great here - in this case the queue status is 
> left in _STATUS_STARTING, which at best would lead to another WARN_ON 
> being hit, but also has the effect of ignoring job faults. Probably the 
> timeout would eventually get things back to normal.
> 
> Obviously this situation will never occur™, but we can do better either 
> by continuing with the normal logic below, or even better replacing 
> atomic_xchg() with an atomic_cmpxchg() (so leave the status alone if not 
> _STOPPED). Both seem like better error recovery options to me. But keep 
> the WARN_ON because something has clearly gone wrong if this happens.

The second approach doesn't unblock things if we end up with
old_status != STOPPED and the queue is really stopped (which shouldn't
happen, unless we have a problem in our state machine). I think I'll
go for the first option and restart the queue unconditionally (I'm
keeping the WARN_ON(), of course).
