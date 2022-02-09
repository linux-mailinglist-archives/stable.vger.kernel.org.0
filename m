Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733BE4AF23B
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 14:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbiBINAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 08:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiBINAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 08:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C970CC05CB9A;
        Wed,  9 Feb 2022 05:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76575B820FD;
        Wed,  9 Feb 2022 13:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCE1C340E7;
        Wed,  9 Feb 2022 13:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644411622;
        bh=/9X2xp0j3tXfdxWQ7rCzTJr5aPGFd8EeKLBHz48x/oE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jhm64i+brAqc11UYf7pdgHKYCcqwsnFGTTe8UFR7UeAC/KPXuENCgwkKFaUeW/t+k
         o2mdgr/jviqmqGPHBo0s9JuRn1JQ9seArYZRzYx9TLGEwXsi7bRPKAmjfDPGovKwP3
         eHZGPPO55IKOo/cRdkzLQYJIZ/GKhqOV6otRaSUswXpKVEcF68IUZFoVUU35U9o2id
         lFkOUIQzMIq36jRfyXJJ8alaIkCwzOd46/s1o8pd9iczbUTUvPQctLC0aw+iy6b43M
         vQcjkfa0++k5pQi+YrmQep0jMDdQoDzZq6Ki7MGuGVr0msBsiVx3+rBWhzmUSrBazg
         HAiqprwBGeg2Q==
Date:   Wed, 9 Feb 2022 18:30:14 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     mhi@lists.linux.dev
Cc:     quic_hemantk@quicinc.com, quic_bbhatt@quicinc.com,
        quic_jhugo@quicinc.com, vinod.koul@linaro.org,
        bjorn.andersson@linaro.org, dmitry.baryshkov@linaro.org,
        quic_vbadigan@quicinc.com, quic_cang@quicinc.com,
        quic_skananth@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, elder@linaro.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>,
        Hemant Kumar <hemantk@codeaurora.org>, stable@vger.kernel.org
Subject: Re: [PATCH 01/23] bus: mhi: Fix pm_state conversion to string
Message-ID: <20220209130014.GC10700@workstation>
References: <20220209094601.26131-1-manivannan.sadhasivam@linaro.org>
 <20220209094601.26131-2-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209094601.26131-2-manivannan.sadhasivam@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 09, 2022 at 03:15:39PM +0530, Manivannan Sadhasivam wrote:
> From: Paul Davey <paul.davey@alliedtelesis.co.nz>
> 
> On big endian architectures the mhi debugfs files which report pm state
> give "Invalid State" for all states.  This is caused by using
> find_last_bit which takes an unsigned long* while the state is passed in
> as an enum mhi_pm_state which will be of int size.
> 
> Fix by using __fls to pass the value of state instead of find_last_bit.
> 
> Fixes: a6e2e3522f29 ("bus: mhi: core: Add support for PM state transitions")
> Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Please ignore this patch. It is missing the v2 prefix.

Thanks,
Mani

> ---
>  drivers/bus/mhi/core/init.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
> index 046f407dc5d6..0d588b60929e 100644
> --- a/drivers/bus/mhi/core/init.c
> +++ b/drivers/bus/mhi/core/init.c
> @@ -79,10 +79,12 @@ static const char * const mhi_pm_state_str[] = {
>  
>  const char *to_mhi_pm_state_str(enum mhi_pm_state state)
>  {
> -	unsigned long pm_state = state;
> -	int index = find_last_bit(&pm_state, 32);
> +	int index;
>  
> -	if (index >= ARRAY_SIZE(mhi_pm_state_str))
> +	if (state)
> +		index = __fls(state);
> +
> +	if (!state || index >= ARRAY_SIZE(mhi_pm_state_str))
>  		return "Invalid State";
>  
>  	return mhi_pm_state_str[index];
> @@ -789,7 +791,6 @@ static int parse_ch_cfg(struct mhi_controller *mhi_cntrl,
>  		mhi_chan->offload_ch = ch_cfg->offload_channel;
>  		mhi_chan->db_cfg.reset_req = ch_cfg->doorbell_mode_switch;
>  		mhi_chan->pre_alloc = ch_cfg->auto_queue;
> -		mhi_chan->wake_capable = ch_cfg->wake_capable;
>  
>  		/*
>  		 * If MHI host allocates buffers, then the channel direction
> -- 
> 2.25.1
> 
