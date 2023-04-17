Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391BA6E4E8A
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 18:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjDQQsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 12:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDQQsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 12:48:10 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88CC526A;
        Mon, 17 Apr 2023 09:48:06 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Q0XyV6DTBz6D9h3;
        Tue, 18 Apr 2023 00:46:58 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 17 Apr
 2023 17:48:03 +0100
Date:   Mon, 17 Apr 2023 17:48:02 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Dan Williams <dan.j.williams@intel.com>
CC:     <linux-cxl@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 4/5] cxl/port: Scan single-target ports for decoders
Message-ID: <20230417174802.00005427@Huawei.com>
In-Reply-To: <168149845130.792294.3210421233937427962.stgit@dwillia2-xfh.jf.intel.com>
References: <168149842935.792294.13212627946146993066.stgit@dwillia2-xfh.jf.intel.com>
        <168149845130.792294.3210421233937427962.stgit@dwillia2-xfh.jf.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Apr 2023 11:54:11 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

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

*Happy face*

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


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
> 

