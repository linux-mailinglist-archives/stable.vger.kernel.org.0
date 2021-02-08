Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BAC3132B3
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 13:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbhBHMqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 07:46:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232430AbhBHMp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 07:45:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A91364E75;
        Mon,  8 Feb 2021 12:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612788316;
        bh=ifobcqNo6vcc1rN286jX0rDurugavttR0zGgFnndxJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZabfLnCfWboDagFh79lmOMVM+OrOKo/UCF/y6QKsZ4+6j7wxciY+YxaHlKW/i107j
         rAAnOR3B6JIkry3ZkGEcrhEijpEg4UCtgpNn6Z7/+AEQaCQvx3Jh2fmSZQEoITz8ZO
         AuVrvNEltcrZSto+htnos71mPdfLSH6irIGjbt8I=
Date:   Mon, 8 Feb 2021 13:45:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Xiao Ni <xni@redhat.com>, David Jeffery <djeffery@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [stable-5.10] md: Set prev_flush_start and flush_bio in an
 atomic way
Message-ID: <YCEyWvFdF6PYkKD/@kroah.com>
References: <20210205141301.71682-1-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205141301.71682-1-jinpu.wang@cloud.ionos.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 03:13:01PM +0100, Jack Wang wrote:
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
> Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/md/md.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ea139d0c0bc3..2bd60bd9e2ca 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -639,8 +639,10 @@ static void md_submit_flush_data(struct work_struct *ws)
>  	 * could wait for this and below md_handle_request could wait for those
>  	 * bios because of suspend check
>  	 */
> +	spin_lock_irq(&mddev->lock);
>  	mddev->last_flush = mddev->start_flush;
>  	mddev->flush_bio = NULL;
> +	spin_unlock_irq(&mddev->lock);
>  	wake_up(&mddev->sb_wait);
>  
>  	if (bio->bi_iter.bi_size == 0) {
> -- 
> 2.25.1

Now queued up, thanks.

greg k-h
