Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268F45815F4
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 17:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiGZPFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 11:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbiGZPFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 11:05:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D97657E;
        Tue, 26 Jul 2022 08:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2524060687;
        Tue, 26 Jul 2022 15:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B11C433C1;
        Tue, 26 Jul 2022 15:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658847935;
        bh=PyA1TS9ySl7LrDhyRcyjQljVl5Q3NH7xSHY8ccNSeCI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jR4MqOwu8XxZo4Y5Dvf1Oc+rssVaQ0TxfUYSvuFPPITm4ST6I9lIWkVQ9hhS/u6t5
         RrwOBV14b3nKGYfAOVODrx5zhPXdOQlMXO2BQJFVvsIO4hiQzwVSpDMgzC4SDlidvl
         rH8Ftw/KBJ07cVG+oR2BdEgP1Q+63q1vME8I/K3E=
Date:   Tue, 26 Jul 2022 17:05:30 +0200
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
Subject: Re: [PATCH v4] ufs: core: correct ufshcd_shutdown flow
Message-ID: <YuACuoUszpHSvFnM@kroah.com>
References: <20220726113653.25024-1-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726113653.25024-1-peter.wang@mediatek.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 26, 2022 at 07:36:53PM +0800, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> In normal case: ufshcd_wl_shutdown -> ufshcd_shtdown
> ufshcd_shtdown should turn off clock/power after ufshcd_wl_shutdown
> which set device power off and link off.
> 
> Also remove pm_runtime_get_sync.
> The reason why here can remove pm_runtime_get_sync is because,
> (1) ufshcd_wl_shutdown -> pm_runtime_get_sync, will resume hba->dev too.
> (2) device resume(turn on clk/power) is not required, even if device is in RPM_SUSPENDED.
> 
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>  drivers/ufs/core/ufshcd.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c7b337480e3e..d13c76983555 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9462,12 +9462,8 @@ EXPORT_SYMBOL(ufshcd_runtime_resume);
>  int ufshcd_shutdown(struct ufs_hba *hba)
>  {
>  	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
> -		goto out;
> -
> -	pm_runtime_get_sync(hba->dev);
> +		ufshcd_suspend(hba);
>  
> -	ufshcd_suspend(hba);
> -out:
>  	hba->is_powered = false;
>  	/* allow force shutdown even in case of errors */
>  	return 0;
> -- 
> 2.18.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
