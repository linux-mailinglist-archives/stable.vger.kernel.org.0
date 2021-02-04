Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C6130F5EC
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 16:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbhBDPN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 10:13:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237179AbhBDPN1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 10:13:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B27264F43;
        Thu,  4 Feb 2021 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612451566;
        bh=5iy2Uj9SCM6fFG24PhhvTv+Yf5S6MNwLOof26JSOoio=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UT8fiwmfRys7roAwEOB/xMm/6MYeYZyFLq5vqX7/nQXIOqBLjFpS/Tlw+Slmkx5i2
         RoHex8KQtcJcAQe0w/J4ry3BrwwkhU3OXx5dbSGpnAgo3QcGKBJDhFvm2rDt7e46sc
         Sf78eofOfp/gcyPSztEVruL0myqdGCDznXYPUX/0=
Date:   Thu, 4 Feb 2021 16:12:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Xiao Ni <xni@redhat.com>, David Jeffery <djeffery@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [stable-4.19 8/8] md: Set prev_flush_start and flush_bio in an
 atomic way
Message-ID: <YBwO7EsBfljWNliY@kroah.com>
References: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
 <20210203132022.92406-9-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203132022.92406-9-jinpu.wang@cloud.ionos.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 03, 2021 at 02:20:22PM +0100, Jack Wang wrote:
> From: Xiao Ni <xni@redhat.com>
> 
> One customer reports a crash problem which causes by flush request. It
> triggers a warning before crash.
> 
>         /* new request after previous flush is completed */
>         if (ktime_after(req_start, mddev->prev_flush_start)) {
>                 WARN_ON(mddev->flush_bio);
>                 mddev->flush_bio = bio;
>                 bio = NULL;
>         }
> 
> The WARN_ON is triggered. We use spin lock to protect prev_flush_start and
> flush_bio in md_flush_request. But there is no lock protection in
> md_submit_flush_data. It can set flush_bio to NULL first because of
> compiler reordering write instructions.
> 
> For example, flush bio1 sets flush bio to NULL first in
> md_submit_flush_data. An interrupt or vmware causing an extended stall
> happen between updating flush_bio and prev_flush_start. Because flush_bio
> is NULL, flush bio2 can get the lock and submit to underlayer disks. Then
> flush bio1 updates prev_flush_start after the interrupt or extended stall.
> 
> Then flush bio3 enters in md_flush_request. The start time req_start is
> behind prev_flush_start. The flush_bio is not NULL(flush bio2 hasn't
> finished). So it can trigger the WARN_ON now. Then it calls INIT_WORK
> again. INIT_WORK() will re-initialize the list pointers in the
> work_struct, which then can result in a corrupted work list and the
> work_struct queued a second time. With the work list corrupted, it can
> lead in invalid work items being used and cause a crash in
> process_one_work.
> 
> We need to make sure only one flush bio can be handled at one same time.
> So add spin lock in md_submit_flush_data to protect prev_flush_start and
> flush_bio in an atomic way.
> 
> Reviewed-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> [jwang: backport dc5d17a3c39b06aef866afca19245a9cfb533a79 to 4.19]

I can not take patches backported to older kernels that "skip" kernel
releases.

For example, if I take this into 4.19.y, and then someone moves to 5.4
or 5.10, they will hit the same issue.

So please provide a backported series for all affected releases, back as
far as you want, but never skip releases.

I can't take this series, I'll drop it for now and wait for an updated
set of patches.

thanks,

greg k-h
