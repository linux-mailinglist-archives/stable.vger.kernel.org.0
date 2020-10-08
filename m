Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BEB287230
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 12:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgJHKEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 06:04:21 -0400
Received: from foss.arm.com ([217.140.110.172]:47998 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725849AbgJHKEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Oct 2020 06:04:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 297E331B;
        Thu,  8 Oct 2020 03:04:21 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 31DC43F70D;
        Thu,  8 Oct 2020 03:04:20 -0700 (PDT)
Subject: Re: [PATCH v3] drm/panfrost: Fix job timeout handling
To:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20201002122506.1374183-1-boris.brezillon@collabora.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <ddd62ed0-d659-b57e-38de-247bac9a0430@arm.com>
Date:   Thu, 8 Oct 2020 11:04:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201002122506.1374183-1-boris.brezillon@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/10/2020 13:25, Boris Brezillon wrote:
> If more than two jobs end up timeout-ing concurrently, only one of them
> (the one attached to the scheduler acquiring the lock) is fully handled.
> The other one remains in a dangling state where it's no longer part of
> the scheduling queue, but still blocks something in scheduler, leading
> to repetitive timeouts when new jobs are queued.
> 
> Let's make sure all bad jobs are properly handled by the thread
> acquiring the lock.
> 
> v3:
> - Add Steven's R-b
> - Don't take the sched_lock when stopping the schedulers
> 
> v2:
> - Fix the subject prefix
> - Stop the scheduler before returning from panfrost_job_timedout()
> - Call cancel_delayed_work_sync() after drm_sched_stop() to make sure
>    no timeout handlers are in flight when we reset the GPU (Steven Price)
> - Make sure we release the reset lock before restarting the
>    schedulers (Steven Price)
> 
> Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> Reviewed-by: Steven Price <steven.price@arm.com>

Applied to drm-misc-next, thanks!

Steve
