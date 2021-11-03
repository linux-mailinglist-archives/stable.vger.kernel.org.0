Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB844446B1
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 18:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhKCRMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 13:12:31 -0400
Received: from verein.lst.de ([213.95.11.211]:60391 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhKCRMa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 13:12:30 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AD4B368AA6; Wed,  3 Nov 2021 18:09:51 +0100 (CET)
Date:   Wed, 3 Nov 2021 18:09:51 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] scsi: scsi_ioctl: Validate command size
Message-ID: <20211103170951.GA4896@lst.de>
References: <20211103170659.22151-1-tadeusz.struk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103170659.22151-1-tadeusz.struk@linaro.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 10:06:58AM -0700, Tadeusz Struk wrote:
> Need to make sure the command size is valid before copying
> the command from user.
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: James E.J. Bottomley <jejb@linux.ibm.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: <linux-scsi@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: <stable@vger.kernel.org> # 5.15, 5.14, 5.10
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
> Changes in v2:
> - removed check for upper len limit as it is handled in sg_io()
> ---
>  drivers/scsi/scsi_ioctl.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
> index 6ff2207bd45a..a06c61f22742 100644
> --- a/drivers/scsi/scsi_ioctl.c
> +++ b/drivers/scsi/scsi_ioctl.c
> @@ -347,6 +347,8 @@ static int scsi_fill_sghdr_rq(struct scsi_device *sdev, struct request *rq,
>  {
>  	struct scsi_request *req = scsi_req(rq);
>  
> +	if (hdr->cmd_len < 6)
> +		return -EMSGSIZE;

The checks looks good, but I'd be tempted to place it next to the
other check on hdr->cmd_len in the caller.
