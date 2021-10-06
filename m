Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951364238B0
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 09:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbhJFHTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 03:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229861AbhJFHTv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 03:19:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 225C561100;
        Wed,  6 Oct 2021 07:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633504679;
        bh=9c9T1NGU8XxsuwplXdklZBi0suFm3I3jQ61YqsqEbz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LH4MydASCkGCd3Y9kMEZErEdyS0bAcPL6F24YoRHXicSBJOlghCv8CTInvsPSFVAz
         uKeWzf2sbeDDbyw3/ycr5QOGhMjKn6yKIBdL6/eW81GPtb6VlPJhoKSWFVnCeR6/YU
         ZNp/ctyuHYFid4+JoRfFHvRYWz4vnx7CF9I8o9TA=
Date:   Wed, 6 Oct 2021 09:17:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     kys@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        haiyangz@microsoft.com, ming.lei@redhat.com, bvanassche@acm.org,
        john.garry@huawei.com, linux-scsi@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] scsi: storvsc: Cap scsi_driver.can_queue to fix a hang
 issue during boot
Message-ID: <YV1NpdaVYJFHPml7@kroah.com>
References: <20211006070345.51713-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006070345.51713-1-decui@microsoft.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 12:03:45AM -0700, Dexuan Cui wrote:
> After commit ea2f0f77538c, a 416-CPU VM running on Hyper-V hangs during
> boot because scsi_add_host_with_dma() sets shost->cmd_per_lun to a
> negative number:
> 	'max_outstanding_req_per_channel' is 352,
> 	'max_sub_channels' is (416 - 1) / 4 = 103, so in storvsc_probe(),
> scsi_driver.can_queue = 352 * (103 + 1) * (100 - 10) / 100 = 32947, which
> is bigger than SHRT_MAX (i.e. 32767).
> 
> Fix the hang issue by capping scsi_driver.can_queue.
> 
> Add the below Fixed tag though ea2f0f77538c itself is good.
> 
> Fixes: ea2f0f77538c ("scsi: core: Cap scsi_host cmd_per_lun at can_queue")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index ebbbc1299c62..ba374908aec2 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1976,6 +1976,16 @@ static int storvsc_probe(struct hv_device *device,
>  				(max_sub_channels + 1) *
>  				(100 - ring_avail_percent_lowater) / 100;
>  
> +	/*
> +	 * v5.14 (see commit ea2f0f77538c) implicitly requires that

No need to put a version number in a comment, they do not track well
when people backport changes all over the place in other kernel trees.

If you want to refer to a commit, please do so in the documented way.

For this case, that would be:
	ea2f0f77538c ("scsi: core: Cap scsi_host cmd_per_lun at can_queue")

thanks,

greg k-h
