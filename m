Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA576E2B57
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 22:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjDNUzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 16:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDNUzm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 16:55:42 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAF64227;
        Fri, 14 Apr 2023 13:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681505742; x=1713041742;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ceC8rrUoQfXie/VLB99NgF8wEEsEU0H0l+IPJPr37gk=;
  b=H1ToALZyiuFdtLRmRxzF96C+0UVWlPjtRBnVhc5fCtAxMW95AYtpDFEQ
   QtbEgXKWqoD9nnWX84P6yKsKstH+tjPozAjmexP7bFPwx7jLO/XioJ9JT
   shTl853PD2CWGyeHVydW/ERT3Af3Aq/9ZKquwqCZFeHVio6it2l4Na/Mi
   icXX+0Rp+MUXIM0vkq88LdxAqJSax+JDmJ+2/Gw4jh5mbT1O4BY/eKR1R
   7Tn0LOER9e+yDMnYaKOwRZok1ATWspaDfCiKLA6jtAjPvYEAq/c9vNe6H
   CZx88bwpDhNZpbGYvYznxPaJY0cLnjvmPzC10Xo49xzHoISTcvHKE+sY3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="342061811"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="342061811"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 13:55:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="864336773"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="864336773"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.22.80])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 13:55:41 -0700
Date:   Fri, 14 Apr 2023 13:55:39 -0700
From:   Alison Schofield <alison.schofield@intel.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-cxl@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4/5] cxl/port: Scan single-target ports for decoders
Message-ID: <ZDm9yzuLbPqUaOwW@aschofie-mobl2>
References: <168149842935.792294.13212627946146993066.stgit@dwillia2-xfh.jf.intel.com>
 <168149845130.792294.3210421233937427962.stgit@dwillia2-xfh.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168149845130.792294.3210421233937427962.stgit@dwillia2-xfh.jf.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 14, 2023 at 11:54:11AM -0700, Dan Williams wrote:
> Do not assume that a single-target port falls back to a passthrough
> decoder configuration. Scan for decoders and only fallback after probing
> that the HDM decoder capability is not present.
> 
> One user visible affect of this bug is the inability to enumerate
> present CXL regions as the decoder settings for the present decoders are
> skipped.
> 
> Fixes: d17d0540a0db ("cxl/core/hdm: Add CXL standard decoder enumeration to the core")
> Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Link: http://lore.kernel.org/r/20230227153128.8164-1-Jonathan.Cameron@huawei.com
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> ---
>  drivers/cxl/core/hdm.c |    5 +++--
>  drivers/cxl/port.c     |   18 +++++++++++++-----
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 6fdf7981ddc7..abe3877cfa63 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -92,8 +92,9 @@ static int map_hdm_decoder_regs(struct cxl_port *port, void __iomem *crb,
>  
>  	cxl_probe_component_regs(&port->dev, crb, &map.component_map);
>  	if (!map.component_map.hdm_decoder.valid) {
> -		dev_err(&port->dev, "HDM decoder registers invalid\n");
> -		return -ENXIO;
> +		dev_dbg(&port->dev, "HDM decoder registers not implemented\n");
> +		/* unique error code to indicate no HDM decoder capability */
> +		return -ENODEV;
>  	}
>  
>  	return cxl_map_component_regs(&port->dev, regs, &map,
> diff --git a/drivers/cxl/port.c b/drivers/cxl/port.c
> index 22a7ab2bae7c..eb57324c4ad4 100644
> --- a/drivers/cxl/port.c
> +++ b/drivers/cxl/port.c
> @@ -66,14 +66,22 @@ static int cxl_switch_port_probe(struct cxl_port *port)
>  	if (rc < 0)
>  		return rc;
>  
> -	if (rc == 1)
> -		return devm_cxl_add_passthrough_decoder(port);
> -
>  	cxlhdm = devm_cxl_setup_hdm(port, NULL);
> -	if (IS_ERR(cxlhdm))
> +	if (!IS_ERR(cxlhdm))
> +		return devm_cxl_enumerate_decoders(cxlhdm, NULL);
> +
> +	if (PTR_ERR(cxlhdm) != -ENODEV) {
> +		dev_err(&port->dev, "Failed to map HDM decoder capability\n");
>  		return PTR_ERR(cxlhdm);
> +	}
> +
> +	if (rc == 1) {
> +		dev_dbg(&port->dev, "Fallback to passthrough decoder\n");
> +		return devm_cxl_add_passthrough_decoder(port);
> +	}
>  
> -	return devm_cxl_enumerate_decoders(cxlhdm, NULL);
> +	dev_err(&port->dev, "HDM decoder capability not found\n");
> +	return -ENXIO;
>  }
>  
>  static int cxl_endpoint_port_probe(struct cxl_port *port)
> 
