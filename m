Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3AB4744EC
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 15:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbhLNO1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 09:27:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44152 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbhLNO1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 09:27:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DECDB819D8;
        Tue, 14 Dec 2021 14:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE7AC34605;
        Tue, 14 Dec 2021 14:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639492068;
        bh=dCz5ROLGxZLneatRf5FXTOfJtzRu8rVmoSoKBqTdjXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RDShaVNVDy35TPyYZfgQGttZzray0L7j/zEehaC0dcgcknPO2ZJebJOmatrwsx1Mk
         nVHTGNrko9R9EBj3Hs6AN+t1y8oTs+jBjUPSVdhdY/5v615ggvMD3uujz3RrByCCaq
         KeqOjbJb8iV/NkfT0iHNBOe8Ik40Ken55lK70iXs=
Date:   Tue, 14 Dec 2021 15:27:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] libata: if T_LENGTH is zero, dma direction should be
 DMA_NONE
Message-ID: <Ybip4T50J3wCKpxH@kroah.com>
References: <1639491411-14401-1-git-send-email-george.kennedy@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639491411-14401-1-git-send-email-george.kennedy@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 14, 2021 at 09:16:51AM -0500, George Kennedy wrote:
> Avoid data corruption by rejecting pass-through commands where
> T_LENGTH is zero (No data is transferred) and the dma direction
> is not DMA_NONE.
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: syzkaller<syzkaller@googlegroups.com>
> Signed-off-by: George Kennedy<george.kennedy@oracle.com>
> ---
>  drivers/ata/libata-scsi.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 1b84d55..313e947 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2859,8 +2859,19 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
>  		goto invalid_fld;
>  	}
>  
> -	if (ata_is_ncq(tf->protocol) && (cdb[2 + cdb_offset] & 0x3) == 0)
> -		tf->protocol = ATA_PROT_NCQ_NODATA;
> +	if ((cdb[2 + cdb_offset] & 0x3) == 0) {
> +		/*
> +		 * When T_LENGTH is zero (No data is transferred), dir should
> +		 * be DMA_NONE.
> +		 */
> +		if (scmd->sc_data_direction != DMA_NONE) {
> +			fp = 2 + cdb_offset;
> +			goto invalid_fld;
> +		}
> +
> +		if (ata_is_ncq(tf->protocol))
> +			tf->protocol = ATA_PROT_NCQ_NODATA;
> +	}
>  
>  	/* enable LBA */
>  	tf->flags |= ATA_TFLAG_LBA;
> -- 
> 1.8.3.1
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/SubmittingPatches for what needs to be done
  here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
