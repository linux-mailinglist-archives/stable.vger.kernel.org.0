Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9235815F3
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 17:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbiGZPFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 11:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239507AbiGZPFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 11:05:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FF32BE2;
        Tue, 26 Jul 2022 08:05:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E907060688;
        Tue, 26 Jul 2022 15:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F22C433D7;
        Tue, 26 Jul 2022 15:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658847928;
        bh=wM7GMMqvGXyen9o/+5FX2f4nRHr5ieuD/bpcqbER3zI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g9ZXgjHQaNDeuOKik8174WLiFKS3Rqd1xn02QCW8prURFkchEuMWRsxmSGPIX5sir
         KLPWJNP3rBYweHJ+GCt2hupHXbICe01vFZmCU7wOYTUzlP5EBvT7tth4DBey6s54+9
         ia6slX/2BIFi9OayzXrfuDRxXaNZEY/knSQYDGcA=
Date:   Tue, 26 Jul 2022 17:05:24 +0200
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
        stable@vger.kernel.org
Subject: Re: [PATCH v3] ufs: core: fix lockdep warning of clk_scaling_lock
Message-ID: <YuACtFnW6QJ7QFyq@kroah.com>
References: <20220726091433.22755-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726091433.22755-1-peter.wang@mediatek.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 26, 2022 at 05:14:33PM +0800, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> There have a lockdep warning like below in current flow.
> kworker/u16:0:  Possible unsafe locking scenario:
> 
> kworker/u16:0:        CPU0                    CPU1
> kworker/u16:0:        ----                    ----
> kworker/u16:0:   lock(&hba->clk_scaling_lock);
> kworker/u16:0:                                lock(&hba->dev_cmd.lock);
> kworker/u16:0:                                lock(&hba->clk_scaling_lock);
> kworker/u16:0:   lock(&hba->dev_cmd.lock);
> kworker/u16:0:
> 
> Before this patch clk_scaling_lock was held in reader mode during the ufshcd_wb_toggle() call.
> With this patch applied clk_scaling_lock is not held while ufshcd_wb_toggle() is called.
> 
> This is safe because ufshcd_wb_toggle will held clk_scaling_lock in reader mode "again" in flow
> ufshcd_wb_toggle -> __ufshcd_wb_toggle -> ufshcd_query_flag_retry -> ufshcd_query_flag ->
> ufshcd_exec_dev_cmd -> down_read(&hba->clk_scaling_lock);
> The protect should enough and make sure clock is not change while send command.
> 
> ufshcd_wb_toggle can protected by hba->clk_scaling.is_allowed to make sure
> ufshcd_devfreq_scale function not run concurrently.
> 
> Fixes: 0e9d4ca43ba8 ("scsi: ufs: Protect some contexts from unexpected clock scaling")
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>  drivers/ufs/core/ufshcd.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c7b337480e3e..aa57126fdb49 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -272,6 +272,7 @@ static void ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
>  static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
>  static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
>  static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba);
> +static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow);
>  
>  static inline void ufshcd_enable_irq(struct ufs_hba *hba)
>  {
> @@ -1249,12 +1250,10 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>  	return ret;
>  }
>  
> -static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
> +static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
>  {
> -	if (writelock)
> -		up_write(&hba->clk_scaling_lock);
> -	else
> -		up_read(&hba->clk_scaling_lock);
> +	up_write(&hba->clk_scaling_lock);
> +
>  	ufshcd_scsi_unblock_requests(hba);
>  	ufshcd_release(hba);
>  }
> @@ -1271,7 +1270,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
>  static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
>  {
>  	int ret = 0;
> -	bool is_writelock = true;
> +	bool wb_toggle = false;
>  
>  	ret = ufshcd_clock_scaling_prepare(hba);
>  	if (ret)
> @@ -1300,13 +1299,19 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
>  		}
>  	}
>  
> -	/* Enable Write Booster if we have scaled up else disable it */
> -	downgrade_write(&hba->clk_scaling_lock);
> -	is_writelock = false;
> -	ufshcd_wb_toggle(hba, scale_up);
> +	/* Disable clk_scaling until ufshcd_wb_toggle finish */
> +	hba->clk_scaling.is_allowed = false;
> +	wb_toggle = true;
>  
>  out_unprepare:
> -	ufshcd_clock_scaling_unprepare(hba, is_writelock);
> +	ufshcd_clock_scaling_unprepare(hba);
> +
> +	/* Enable Write Booster if we have scaled up else disable it */
> +	if (wb_toggle) {
> +		ufshcd_wb_toggle(hba, scale_up);
> +		ufshcd_clk_scaling_allow(hba, true);
> +	}
> +
>  	return ret;
>  }
>  
> -- 
> 2.18.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
