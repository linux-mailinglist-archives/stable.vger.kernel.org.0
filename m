Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570FF4262D1
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 05:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhJHDWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 23:22:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45690 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229644AbhJHDWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 23:22:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633663205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HOxpgrZnYdSvGQKrZaYcau9KwEc1jKvSXQuLLBcGQBQ=;
        b=DRaXGeIwdviheMyu49PWZg6qIx7V/lXHkbqQ5UEPWuc54QCtCOfO3pd4E7JdfyY/iON4f5
        YYSMOkovDIIlycvrYG00C/VdGikmyBR/iCQjOvTLRTZ2Y+SVzXtdNv0+VLYvNNY2l+aGWY
        zEyNMwj5KzASUbj97MVdO/P547MlQ+8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-xeDznztWNGyFLvxssR47RQ-1; Thu, 07 Oct 2021 23:20:01 -0400
X-MC-Unique: xeDznztWNGyFLvxssR47RQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1A601084680;
        Fri,  8 Oct 2021 03:19:59 +0000 (UTC)
Received: from T590 (ovpn-8-29.pek2.redhat.com [10.72.8.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0044A5D6D5;
        Fri,  8 Oct 2021 03:19:52 +0000 (UTC)
Date:   Fri, 8 Oct 2021 11:19:47 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     kys@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        haiyangz@microsoft.com, bvanassche@acm.org, john.garry@huawei.com,
        linux-scsi@vger.kernel.org, linux-hyperv@vger.kernel.org,
        longli@microsoft.com, mikelley@microsoft.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: core: Fix shost->cmd_per_lun calculation in
 scsi_add_host_with_dma()
Message-ID: <YV+40/pHlLwseFw/@T590>
References: <20211007174957.2080-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007174957.2080-1-decui@microsoft.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 07, 2021 at 10:49:57AM -0700, Dexuan Cui wrote:
> After commit ea2f0f77538c, a 416-CPU VM running on Hyper-V hangs during
> boot because scsi_add_host_with_dma() sets shost->cmd_per_lun to a
> negative number (the below numbers may differ in different kernel versions):
> in drivers/scsi/storvsc_drv.c, 	storvsc_drv_init() sets
> 'max_outstanding_req_per_channel' to 352, and storvsc_probe() sets
> 'max_sub_channels' to (416 - 1) / 4 = 103 and sets scsi_driver.can_queue to
> 352 * (103 + 1) * (100 - 10) / 100 = 32947, which exceeds SHRT_MAX.
> 
> Use min_t(int, ...) to fix the issue.
> 
> Fixes: ea2f0f77538c ("scsi: core: Cap scsi_host cmd_per_lun at can_queue")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
> 
> v1 tried to fix the issue by changing the storvsc driver:
> https://lwn.net/ml/linux-kernel/BYAPR21MB1270BBC14D5F1AE69FC31A16BFB09@BYAPR21MB1270.namprd21.prod.outlook.com/
> 
> v2 directly fixes the scsi core change instead as Michael Kelley and
> John Garry suggested (refer to the above link).
> 
>  drivers/scsi/hosts.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 3f6f14f0cafb..24b72ee4246f 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -220,7 +220,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>  		goto fail;
>  	}
>  
> -	shost->cmd_per_lun = min_t(short, shost->cmd_per_lun,
> +	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
> +	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
>  				   shost->can_queue);

Looks fine:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

