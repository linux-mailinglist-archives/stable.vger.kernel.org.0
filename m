Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77E93FEF64
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 16:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345402AbhIBOYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 10:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234283AbhIBOYD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 10:24:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1B78610A4;
        Thu,  2 Sep 2021 14:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630592585;
        bh=gLQagvTyM/uYTyJJBpw1JtLsPylt4qjtAxy+L1K9xM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eq3V3ly4Xlwvjc2Mh03GjlRHXLZFoRo/vteGkIYhg1vK7Vl/8D7OU5UP2Fzfq56sA
         6BLOxW3LNDhFgMI3/JxTczTTX5EAkIJN/lY3GpVHvMxO1ZA3NaMKcfKtULyX//3l+H
         xxF9Z36gNvdv1YyPP7Yudb6zYran9x9QcepLqAik=
Date:   Thu, 2 Sep 2021 16:23:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian =?iso-8859-1?Q?L=F6hle?= <CLoehle@hyperstone.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] sd: sd_open: prevent device removal during sd_open
Message-ID: <YTDeR1aYJsWoZZhY@kroah.com>
References: <98bfca4cbaa24462994bcb533d365414@hyperstone.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <98bfca4cbaa24462994bcb533d365414@hyperstone.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 02, 2021 at 01:57:13PM +0000, Christian Löhle wrote:
> sd and parent devices must not be removed as sd_open checks for events
> 
> sd_need_revalidate and sd_revalidate_disk traverse the device path
> to check for event changes. If during this, e.g. the scsi host is being
> removed and its resources freed, this traversal crashes.
> Locking with scan_mutex for just a scsi disk open may seem blunt, but there
> does not seem to be a more granular option. Also opening /dev/sdX directly
> happens rarely enough that this shouldn't cause any issues.
> 
> The issue occurred on an older kernel with the following trace:
> stack segment: 0000 [#1] PREEMPT SMP PTI
> CPU: 1 PID: 121457 Comm: python3 Not tainted 4.14.238hyLinux #1
> Hardware name: ASUS All Series/H81M-D, BIOS 0601 02/20/2014
> task: ffff888213dbb700 task.stack: ffffc90008c14000
> RIP: 0010:kobject_get_path+0x2a/0xe0
> ...
> Call Trace:
> kobject_uevent_env+0xe6/0x550
> disk_check_events+0x101/0x160
> disk_clear_events+0x75/0x100
> check_disk_change+0x22/0x60
> sd_open+0x70/0x170 [sd_mod]
> __blkdev_get+0x3fd/0x4b0
> ? get_empty_filp+0x57/0x1b0
> blkdev_get+0x11b/0x330
> ? bd_acquire+0xc0/0xc0
> do_dentry_open+0x1ef/0x320
> ? __inode_permission+0x85/0xc0
> path_openat+0x5cb/0x1500
> ? terminate_walk+0xeb/0x100
> do_filp_open+0x9b/0x110
> ? __check_object_size+0xb4/0x190
> ? do_sys_open+0x1bd/0x250
> do_sys_open+0x1bd/0x250
> do_syscall_64+0x67/0x120
> entry_SYSCALL_64_after_hwframe+0x41/0xa6
> 
> and this commit fixed that issue, as there has been no other such
> synchronization in place since then, the issue should still be present in
> recent kernels.
> 
> Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
> ---
>  drivers/scsi/sd.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 610ebba0d66e..ad4da985a473 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1436,6 +1436,16 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
>  	if (!scsi_block_when_processing_errors(sdev))
>  		goto error_out;
>  
> +	/*
> +	 * Checking for changes to the device must not race with the device
> +	 * or its parent host being removed, so lock until sd_open returns.
> +	 */
> +	mutex_lock(&sdev->host->scan_mutex);
> +	if (sdev->sdev_state != SDEV_RUNNING) {
> +		retval = -ERESTARTSYS;
> +		goto unlock_scan_error_out;
> +	}
> +
>  	if (sd_need_revalidate(bdev, sdkp))
>  		sd_revalidate_disk(bdev->bd_disk);
>  
> @@ -1444,7 +1454,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
>  	 */
>  	retval = -ENOMEDIUM;
>  	if (sdev->removable && !sdkp->media_present && !(mode & FMODE_NDELAY))
> -		goto error_out;
> +		goto unlock_scan_error_out;
>  
>  	/*
>  	 * If the device has the write protect tab set, have the open fail
> @@ -1452,7 +1462,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
>  	 */
>  	retval = -EROFS;
>  	if (sdkp->write_prot && (mode & FMODE_WRITE))
> -		goto error_out;
> +		goto unlock_scan_error_out;
>  
>  	/*
>  	 * It is possible that the disk changing stuff resulted in
> @@ -1462,15 +1472,19 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
>  	 */
>  	retval = -ENXIO;
>  	if (!scsi_device_online(sdev))
> -		goto error_out;
> +		goto unlock_scan_error_out;
>  
>  	if ((atomic_inc_return(&sdkp->openers) == 1) && sdev->removable) {
>  		if (scsi_block_when_processing_errors(sdev))
>  			scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
>  	}
>  
> +	mutex_unlock(&sdev->host->scan_mutex);
>  	return 0;
>  
> +unlock_scan_error_out:
> +	mutex_unlock(&sdev->host->scan_mutex);
> +
>  error_out:
>  	scsi_disk_put(sdkp);
>  	return retval;	
> -- 
> 2.32.0=
> Hyperstone GmbH | Line-Eid-Strasse 3 | 78467 Konstanz
> Managing Directors: Dr. Jan Peter Berns.
> Commercial register of local courts: Freiburg HRB381782
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
