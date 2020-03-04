Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5931790D3
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 14:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388096AbgCDNGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 08:06:20 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:53820 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388048AbgCDNGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 08:06:19 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 024D6IhF011908;
        Wed, 4 Mar 2020 07:06:18 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583327178;
        bh=YXzQppbglr+xPKbiEaDdJH1kY4n3UhI0W2ajY77vJNE=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=yJiakj4S7Opplp7tEymkkymcUSmZfZgIn20p0umYvd2cAWhubn2acqBd/7yfIh5sv
         dfer8+oCOgvgRkJsXOrGGk2VUQHwvskVj+ZVM3cBn5csRRpUV7exL/AXez2Qf+DW3h
         4e5u4m5SAtUN1H/dGJE8CBVJbgJ7CIHoZ48Itx/4=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 024D6IWQ070658
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Mar 2020 07:06:18 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 4 Mar
 2020 07:06:18 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 4 Mar 2020 07:06:18 -0600
Received: from ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with SMTP id 024D6Icj099558;
        Wed, 4 Mar 2020 07:06:18 -0600
Date:   Wed, 4 Mar 2020 07:10:53 -0600
From:   Benoit Parrot <bparrot@ti.com>
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>
CC:     Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [Patch] media: ti-vpe: cal: fix a kernel oops when unloading
 module
Message-ID: <20200304131053.k76vivpwv3tvr52d@ti.com>
References: <20200303172629.21339-1-bparrot@ti.com>
 <4010c13f-6a32-f3c3-5b6d-62a4e3782c64@ti.com>
 <f7f6dd87-147f-b9e9-aaa7-c063a8f3c11e@ti.com>
 <a2e6510f-ffd9-060e-ab03-cdc261ecc778@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a2e6510f-ffd9-060e-ab03-cdc261ecc778@ti.com>
User-Agent: NeoMutt/20171215
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tomi,

Thanks for the review, and fix!

Tomi Valkeinen <tomi.valkeinen@ti.com> wrote on Wed [2020-Mar-04 11:22:26 +0200]:
> On 04/03/2020 10:41, Tomi Valkeinen wrote:
> 
> >> Thanks, this fixes the crash for me.
> >>
> >> It does look a bit odd that something is allocated with kzalloc, and then it's freed somewhere 
> >> inside v4l2_async_notifier_cleanup, though. But if that's how it supposed to be used, looks fine 
> >> to me.
> > 
> > Well, sent that a few seconds too early... With this patch, I see kmemleaks.
> 
> This is caused by allocating asd for all ports, even if the port is not used, causing the allocated asd to be forgotten. Also, any error there would cause leak too.
> 
> I think something like this fixes both the unused port case and error paths:
> 

Yes I see that now. Good catch.
I'll fix it in v2.

Benoit

> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> index a928c9d66d5d..4b89dd53d2b4 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -372,8 +372,6 @@ struct cal_ctx {
>  	struct v4l2_subdev	*sensor;
>  	struct v4l2_fwnode_endpoint	endpoint;
>  
> -	struct v4l2_async_subdev asd;
> -
>  	struct v4l2_fh		fh;
>  	struct cal_dev		*dev;
>  	struct cc_data		*cc;
> @@ -2020,7 +2018,6 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>  
>  	parent = pdev->dev.of_node;
>  
> -	asd = &ctx->asd;
>  	endpoint = &ctx->endpoint;
>  
>  	ep_node = NULL;
> @@ -2067,8 +2064,6 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>  		ctx_dbg(3, ctx, "can't get remote parent\n");
>  		goto cleanup_exit;
>  	}
> -	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> -	asd->match.fwnode = of_fwnode_handle(sensor_node);
>  
>  	v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep_node), endpoint);
>  
> @@ -2098,9 +2093,17 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>  
>  	v4l2_async_notifier_init(&ctx->notifier);
>  
> +	asd = kzalloc(sizeof(*asd), GFP_KERNEL);
> +	if (!asd)
> +		goto cleanup_exit;
> +
> +	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
> +	asd->match.fwnode = of_fwnode_handle(sensor_node);
> +
>  	ret = v4l2_async_notifier_add_subdev(&ctx->notifier, asd);
>  	if (ret) {
>  		ctx_err(ctx, "Error adding asd\n");
> +		kfree(asd);
>  		goto cleanup_exit;
>  	}
>  
>  Tomi
> 
> -- 
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
> Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
