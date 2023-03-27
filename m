Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413F86CA139
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 12:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjC0KXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 06:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbjC0KXT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 06:23:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A26E4222;
        Mon, 27 Mar 2023 03:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AAACECE12DA;
        Mon, 27 Mar 2023 10:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A426CC433EF;
        Mon, 27 Mar 2023 10:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679912589;
        bh=cznD+cbBiom3mZdOBAF5neKKYMVd/kyzeOHaPpGn7q0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hv7zuAqo1uTMOAoGK5/bleBXMR0ApJAVGiiL3r15iEu4vABCjfjxLfp+Wyc8alcg+
         DzgDI/cvMlvkBPKSSIVXGYNE9+DVx3ok757cNQ3OKCl4YDw8nAKt6yOA+E0B1sJx8/
         v3CzvwlwTCffJ08BMVtmbohIHChkqijE2kEeArCaW7m6qAXFuswJ6XjsGQccRY6qaR
         EHl1JPR86iO8Ct0Z8QlhqlQ/+8IpvrbmHWocOLnW/cjlzzs2nYDAsKqycwmN9svEIu
         BwHAMWa8hhZLHIyaBVYxIEPLVOykH6VoP7FPJsIAs4UbiTYUqCMvcaSQd5Nl00Lndw
         SJDx+NYf3filg==
Date:   Mon, 27 Mar 2023 15:52:57 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Jeffrey Hugo <quic_jhugo@quicinc.com>
Cc:     mani@kernel.org, mhi@lists.linux.dev,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] bus: mhi: host: Range check CHDBOFF and ERDBOFF
Message-ID: <20230327102257.GC16424@thinkpad>
References: <1679674384-27209-1-git-send-email-quic_jhugo@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1679674384-27209-1-git-send-email-quic_jhugo@quicinc.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 24, 2023 at 10:13:04AM -0600, Jeffrey Hugo wrote:
> If the value read from the CHDBOFF and ERDBOFF registers is outside the
> range of the MHI register space then an invalid address might be computed
> which later causes a kernel panic.  Range check the read value to prevent
> a crash due to bad data from the device.
> 
> Fixes: 6cd330ae76ff ("bus: mhi: core: Add support for ringing channel/event ring doorbells")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jeffrey Hugo <quic_jhugo@quicinc.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

Thanks,
Mani

> Reviewed-by: Pranjal Ramajor Asha Kanojiya <quic_pkanojiy@quicinc.com>
> ---
> 
> v2:
> -CC stable
> -Use ERANGE for the error code
> 
>  drivers/bus/mhi/host/init.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/bus/mhi/host/init.c b/drivers/bus/mhi/host/init.c
> index 3d779ee..b46a082 100644
> --- a/drivers/bus/mhi/host/init.c
> +++ b/drivers/bus/mhi/host/init.c
> @@ -516,6 +516,12 @@ int mhi_init_mmio(struct mhi_controller *mhi_cntrl)
>  		return -EIO;
>  	}
>  
> +	if (val >= mhi_cntrl->reg_len - (8 * MHI_DEV_WAKE_DB)) {
> +		dev_err(dev, "CHDB offset: 0x%x is out of range: 0x%zx\n",
> +			val, mhi_cntrl->reg_len - (8 * MHI_DEV_WAKE_DB));
> +		return -ERANGE;
> +	}
> +
>  	/* Setup wake db */
>  	mhi_cntrl->wake_db = base + val + (8 * MHI_DEV_WAKE_DB);
>  	mhi_cntrl->wake_set = false;
> @@ -532,6 +538,12 @@ int mhi_init_mmio(struct mhi_controller *mhi_cntrl)
>  		return -EIO;
>  	}
>  
> +	if (val >= mhi_cntrl->reg_len - (8 * mhi_cntrl->total_ev_rings)) {
> +		dev_err(dev, "ERDB offset: 0x%x is out of range: 0x%zx\n",
> +			val, mhi_cntrl->reg_len - (8 * mhi_cntrl->total_ev_rings));
> +		return -ERANGE;
> +	}
> +
>  	/* Setup event db address for each ev_ring */
>  	mhi_event = mhi_cntrl->mhi_event;
>  	for (i = 0; i < mhi_cntrl->total_ev_rings; i++, val += 8, mhi_event++) {
> -- 
> 2.7.4
> 
> 

-- 
மணிவண்ணன் சதாசிவம்
