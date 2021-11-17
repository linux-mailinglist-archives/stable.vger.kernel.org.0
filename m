Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784DB454CA8
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 18:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhKQSBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 13:01:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236569AbhKQSBO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 13:01:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 176BD61283;
        Wed, 17 Nov 2021 17:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637171895;
        bh=3uMyTN+tYokF3Y9uxBXXociR+C7cv+nS9BgfTzHqOrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pJldTi5HJl4/RAbADfGI1NxIhDmun42nJk4GDf4A13ZCm2S1lubPsdkMP3NibdYrS
         Yvh/xJ/OebUk7fhaeX5DJR2jfL20IThHzEelM/oKdj900D8g4PsPKMS1IJC1K+mHiM
         Mp+rE1eEqrb+sZl+6iHqjT1qhDe5464Hiw+h45OE=
Date:   Wed, 17 Nov 2021 18:58:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Orson Zhai <orsonzhai@gmail.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>, orson.zhai@gmail.com,
        Orson Zhai <orson.zhai@unisoc.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Fix tm request when non-fatal error
 happens
Message-ID: <YZVCtaw22NLBEdc1@kroah.com>
References: <1637059711-11746-1-git-send-email-orsonzhai@gmail.com>
 <1637059711-11746-3-git-send-email-orsonzhai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1637059711-11746-3-git-send-email-orsonzhai@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 06:48:31PM +0800, Orson Zhai wrote:
> From: Jaegeuk Kim <jaegeuk@kernel.org>
> 
> [ Upstream commit eeb1b55b6e25c5f7265ff45cd050f3bc2cc423a4 ]
> 
> When non-fatal error like line-reset happens, ufshcd_err_handler() starts
> to abort tasks by ufshcd_try_to_abort_task(). When it tries to issue a task
> management request, we hit two warnings:
> 
> WARNING: CPU: 7 PID: 7 at block/blk-core.c:630 blk_get_request+0x68/0x70
> WARNING: CPU: 4 PID: 157 at block/blk-mq-tag.c:82 blk_mq_get_tag+0x438/0x46c
> 
> After fixing the above warnings we hit another tm_cmd timeout which may be
> caused by unstable controller state:
> 
> __ufshcd_issue_tm_cmd: task management cmd 0x80 timed-out
> 
> Then, ufshcd_err_handler() enters full reset, and kernel gets stuck. It
> turned out ufshcd_print_trs() printed too many messages on console which
> requires CPU locks. Likewise hba->silence_err_logs, we need to avoid too
> verbose messages. This is actually not an error case.
> 
> Change-Id: I8a422b1f0e3152191f576548cc371a1a41115f59
> Link: https://lore.kernel.org/r/20210107185316.788815-3-jaegeuk@kernel.org
> Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs")
> Reviewed-by: Can Guo <cang@codeaurora.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Orson Zhai <orson.zhai@unisoc.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a5d4ee6..4004506 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4748,7 +4748,8 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  		break;
>  	} /* end of switch */
>  
> -	if ((host_byte(result) != DID_OK) && !hba->silence_err_logs)
> +	if ((host_byte(result) != DID_OK) &&
> +	    (host_byte(result) != DID_REQUEUE) && !hba->silence_err_logs)
>  		ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
>  	return result;
>  }
> @@ -5661,9 +5662,13 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
>  		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
>  	}
>  
> -	if (enabled_intr_status && retval == IRQ_NONE) {
> -		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x\n",
> -					__func__, intr_status);
> +	if (enabled_intr_status && retval == IRQ_NONE &&
> +				!ufshcd_eh_in_progress(hba)) {
> +		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x (0x%08x, 0x%08x)\n",
> +					__func__,
> +					intr_status,
> +					hba->ufs_stats.last_intr_status,
> +					enabled_intr_status);
>  		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
>  	}
>  
> @@ -5705,7 +5710,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>  	/*
>  	 * blk_get_request() is used here only to get a free tag.
>  	 */
> -	req = blk_get_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
> +	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
> +	if (IS_ERR(req))
> +		return PTR_ERR(req);
> +
>  	req->end_io_data = &wait;
>  	ufshcd_hold(hba, false);
>  
> -- 
> 2.7.4
> 

This commit does not build :(

Did you test it?

Please fix up and resend AFTER testing it.

thanks,

greg k-h
