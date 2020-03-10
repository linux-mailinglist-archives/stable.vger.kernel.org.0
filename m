Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4983817F67E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 12:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgCJLlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 07:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgCJLlx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 07:41:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D0FF24655;
        Tue, 10 Mar 2020 11:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583840512;
        bh=Gj64/ELE0B6Bj17H0OiLSgbNBD39RqzuBC2a33w3nVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QPJCej0dDZNzyZlK2/xEDHpKNFcv8u2Geck0fXaNL6V91ZVO3a1Q522T8mBiXWp0Z
         w3TDPgV2x1gX+R54fjYOZqFiJJup52JPl1EY/kxqrjzCm0H07Vy7knA69+86Zg6mXf
         WONy3nUOT52fVIMF5SuDT00Kem3GMK3Z9rZU9ZIM=
Date:   Tue, 10 Mar 2020 12:41:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Viswas G <Viswas.G@microsemi.com>,
        Deepak Ukey <deepak.ukey@microsemi.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [stable-4.19 1/2] scsi: pm80xx: panic on ncq error cleaning up
 the read log.
Message-ID: <20200310114150.GE3106483@kroah.com>
References: <20200309101739.32483-1-jinpu.wang@cloud.ionos.com>
 <20200309101739.32483-2-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309101739.32483-2-jinpu.wang@cloud.ionos.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 09, 2020 at 11:17:38AM +0100, Jack Wang wrote:
> From: Viswas G <Viswas.G@microsemi.com>
> 
> commit 0b6df110b3d0c12562011fcd032cfb6ff16b6d56 upstream
> 
> when there's an error in 'ncq mode' the host has to read the ncq error
> log (10h) to clear the error state. however, the ccb that is setup for
> doing this doesn't setup the ccb so that the previous state is
> cleared. if the ccb was previously used for an IO n_elems is set and
> pm8001_ccb_task_free() treats this as the signal to go free a
> scatter-gather list (that's already been freed).
> 
> Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
> Signed-off-by: Viswas G <Viswas.G@microsemi.com>
> Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 8627feb80261..bd945d832eb8 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1500,8 +1500,9 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
>  	ccb->ccb_tag = ccb_tag;
>  	ccb->task = task;
>  	ccb->n_elem = 0;
> -	pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
> -	pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;
> +	pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;	// set this flag to indicate read log
> +	pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;	// set this flag to guard against 2nd RLE. Workaround 
> +						// till FW fix is available. 

Also, this isn't even the commit id referenced above :(

And there is trailing whitespace :(
