Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3245F5012D9
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243681AbiDNONQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347755AbiDNN7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:31 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562B3ADD4F;
        Thu, 14 Apr 2022 06:52:29 -0700 (PDT)
Received: from zn.tnic (p2e55d808.dip0.t-ipconnect.de [46.85.216.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5A22C1EC0528;
        Thu, 14 Apr 2022 15:52:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1649944343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=fQgHc4czP4/s+ov58mWIy2itnrhyUqDjJiRz0eAusuQ=;
        b=P2umxhzc6D+5zvIJYnM79nTO6MH6q8AqRhwO/hJ/8i/Uwam9nXDcA6V8TELpfUrUoUZ0a7
        gPDtAjl9ijWd06nxH/yV2i/3EDn8xiTEmjnudzGjf/QRW9muIipnrcNIv22BMACd8wg44t
        aNafyo5YZ1fjZzp6Z7Q5NxC+hWfqnvE=
Date:   Thu, 14 Apr 2022 15:52:23 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Cc:     linux-edac@vger.kernel.org, michal.simek@xilinx.com,
        mchehab@kernel.org, tony.luck@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] edac: synopsys: Fix the issue in reporting of the
 error count
Message-ID: <YlgnFxbripsQcCm5@zn.tnic>
References: <20220414102813.4468-1-shubhrajyoti.datta@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220414102813.4468-1-shubhrajyoti.datta@xilinx.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 03:58:13PM +0530, Shubhrajyoti Datta wrote:
> Currently the error count from status register is being read which
> is not correct. Fix the issue by reading the count from the
> error count register(ERRCNT).
> 
> Fixes: b500b4a029d5 ("EDAC, synopsys: Add ECC support for ZynqMP DDR controller")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
> ---
> v2:
> Remove the cumulative count change
> v3:
> Add the fixes and stable tag
> 
>  drivers/edac/synopsys_edac.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
> index f05ff02c0656..1a9a5b886903 100644
> --- a/drivers/edac/synopsys_edac.c
> +++ b/drivers/edac/synopsys_edac.c
> @@ -164,6 +164,11 @@
>  #define ECC_STAT_CECNT_SHIFT		8
>  #define ECC_STAT_BITNUM_MASK		0x7F
>  
> +/* ECC error count register definitions */
> +#define ECC_ERRCNT_UECNT_MASK		0xFFFF0000
> +#define ECC_ERRCNT_UECNT_SHIFT		16
> +#define ECC_ERRCNT_CECNT_MASK		0xFFFF
> +
>  /* DDR QOS Interrupt register definitions */
>  #define DDR_QOS_IRQ_STAT_OFST		0x20200
>  #define DDR_QOSUE_MASK			0x4
> @@ -423,14 +428,16 @@ static int zynqmp_get_error_info(struct synps_edac_priv *priv)
>  	base = priv->baseaddr;
>  	p = &priv->stat;
>  
> +	regval = readl(base + ECC_ERRCNT_OFST);
> +	p->ce_cnt = regval & ECC_ERRCNT_CECNT_MASK;
> +	p->ue_cnt = (regval & ECC_ERRCNT_UECNT_MASK) >> ECC_ERRCNT_UECNT_SHIFT;
> +	if (!p->ce_cnt)
> +		goto ue_err;
> +
>  	regval = readl(base + ECC_STAT_OFST);
>  	if (!regval)
>  		return 1;
>  
> -	p->ce_cnt = (regval & ECC_STAT_CECNT_MASK) >> ECC_STAT_CECNT_SHIFT;
> -	p->ue_cnt = (regval & ECC_STAT_UECNT_MASK) >> ECC_STAT_UECNT_SHIFT;
> -	if (!p->ce_cnt)
> -		goto ue_err;
>  
>  	p->ceinfo.bitpos = (regval & ECC_STAT_BITNUM_MASK);
>  
> -- 

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
