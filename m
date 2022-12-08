Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5B5646A0C
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 09:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiLHIDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 03:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHIDE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 03:03:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E493FB84;
        Thu,  8 Dec 2022 00:02:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB1EAB806A0;
        Thu,  8 Dec 2022 08:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3439C433C1;
        Thu,  8 Dec 2022 08:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670486576;
        bh=AhZ8skKJk8Msl/OSCwNDTiNXAlnXCrNdyRVs0QknuAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ARpwUGDwYKPok893gLJzzBF1P4ZP2UUH+ajyABfF67cXjZYqpgPtlXyuSxdc6Gg0G
         OJpj4w2bTRLeCMA57n0F2J75rjH2gKrT9hJJ4C3AHDlKVRSnSl91y+QDCMbjJCVD/c
         J1ngE2SokH6fRK6nEc5tlzhVlNVAsNYAs7ob1U68=
Date:   Thu, 8 Dec 2022 09:02:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     peter.wang@mediatek.com
Cc:     stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com, stable@vger.kernel.org
Subject: Re: [PATCH v6] ufs: core: wlun suspend SSU/enter hibern8 fail
 recovery
Message-ID: <Y5GaLX6AYEtHFU9F@kroah.com>
References: <20221208072520.26210-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208072520.26210-1-peter.wang@mediatek.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 08, 2022 at 03:25:20PM +0800, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> When SSU/enter hibern8 fail in wlun suspend flow, trigger error
> handler and return busy to break the suspend.
> If not, wlun runtime pm status become error and the consumer will
> stuck in runtime suspend status.
> 
> Fixes: b294ff3e3449 ("scsi: ufs: core: Enable power management for wlun")
> Cc: stable@vger.kernel.org
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  drivers/ufs/core/ufshcd.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index b1f59a5fe632..31ed3fdb5266 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6070,6 +6070,14 @@ void ufshcd_schedule_eh_work(struct ufs_hba *hba)
>  	}
>  }
>  
> +static void ufshcd_force_error_recovery(struct ufs_hba *hba) 
> +{
> +	spin_lock_irq(hba->host->host_lock);
> +	hba->force_reset = true;
> +	ufshcd_schedule_eh_work(hba);
> +	spin_unlock_irq(hba->host->host_lock);
> +}
> +
>  static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
>  {
>  	down_write(&hba->clk_scaling_lock);
> @@ -9049,6 +9057,15 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  
>  		if (!hba->dev_info.b_rpm_dev_flush_capable) {
>  			ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
> +			if (ret && pm_op != UFS_SHUTDOWN_PM) {
> +				/*
> +				 * If return err in suspend flow, IO will hang.
> +				 * Trigger error handler and break suspend for
> +				 * error recovery.
> +				 */
> +				ufshcd_force_error_recovery(hba);
> +				ret = -EBUSY;
> +			}
>  			if (ret)
>  				goto enable_scaling;
>  		}
> @@ -9060,6 +9077,15 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  	 */
>  	check_for_bkops = !ufshcd_is_ufs_dev_deepsleep(hba);
>  	ret = ufshcd_link_state_transition(hba, req_link_state, check_for_bkops);
> +	if (ret && pm_op != UFS_SHUTDOWN_PM) {
> +		/*
> +		 * If return err in suspend flow, IO will hang.
> +		 * Trigger error handler and break suspend for
> +		 * error recovery.
> +		 */
> +		ufshcd_force_error_recovery(hba);
> +		ret = -EBUSY;
> +	}
>  	if (ret)
>  		goto set_dev_active;
>  
> -- 
> 2.18.0
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
