Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5759D6E2BA1
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 23:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjDNVUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 17:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDNVUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 17:20:09 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4A01725;
        Fri, 14 Apr 2023 14:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681507205; x=1713043205;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gYgpMiJnMxZhUNwNzX8IbaRazzg3EoAnMxnRPSdSyvA=;
  b=RGOA/MnBCMpOo2CCojSmkCO2jBQuZAibUpN5sUUTtSuBWCnAw7hm0UWk
   Vmr5NtEEnmLcJaq5uErTPXjKQcDT1sec2xMkZvE700gkP2G1ddWy9aGc8
   Y015Qra9tnxxGYN5AdBXH5YpIzyJZn82XVfACda9LEB9MASsb2adJcpmg
   7C+PxTDPx91e62FUBPKyOLq/bAedjBJoXuOCPXl+RTb3KWlIan6ANHn/f
   nbwPOC91bGDpABIzSpDKMURhPOWhMS4tC/cbTtdXPGln1VspaABB8xGcc
   s3e2qPPHHepkCwKvDo6CTLN+XpyebqdT8cUsYAcTJsbtVrqjIDLnq0uqQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="407458570"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="407458570"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 14:20:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="754591514"
X-IronPort-AV: E=Sophos;i="5.99,198,1677571200"; 
   d="scan'208";a="754591514"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.212.122.87]) ([10.212.122.87])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 14:20:04 -0700
Message-ID: <7e4223af-ecdf-9677-9682-7519bb15e9a1@intel.com>
Date:   Fri, 14 Apr 2023 14:19:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH 1/5] cxl/hdm: Fail upon detecting 0-sized decoders
To:     Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <168149842935.792294.13212627946146993066.stgit@dwillia2-xfh.jf.intel.com>
 <168149843516.792294.11872242648319572632.stgit@dwillia2-xfh.jf.intel.com>
Content-Language: en-US
From:   Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <168149843516.792294.11872242648319572632.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/14/23 11:53 AM, Dan Williams wrote:
> Decoders committed with 0-size lead to later crashes on shutdown as
> __cxl_dpa_release() assumes a 'struct resource' has been established in
> the in 'cxlds->dpa_res'. Just fail the driver load in this instance
> since there are deeper problems with the enumeration or the setup when
> this happens.
> 
> Fixes: 9c57cde0dcbd ("cxl/hdm: Enumerate allocated DPA")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   drivers/cxl/core/hdm.c |   15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 02cc2c38b44b..35b338b716fe 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -269,8 +269,11 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
>   
>   	lockdep_assert_held_write(&cxl_dpa_rwsem);
>   
> -	if (!len)
> -		goto success;
> +	if (!len) {
> +		dev_warn(dev, "decoder%d.%d: empty reservation attempted\n",
> +			 port->id, cxled->cxld.id);
> +		return -EINVAL;
> +	}
>   
>   	if (cxled->dpa_res) {
>   		dev_dbg(dev, "decoder%d.%d: existing allocation %pr assigned\n",
> @@ -323,7 +326,6 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
>   		cxled->mode = CXL_DECODER_MIXED;
>   	}
>   
> -success:
>   	port->hdm_end++;
>   	get_device(&cxled->cxld.dev);
>   	return 0;
> @@ -833,6 +835,13 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
>   				 port->id, cxld->id);
>   			return -ENXIO;
>   		}
> +
> +		if (size == 0) {
> +			dev_warn(&port->dev,
> +				 "decoder%d.%d: Committed with zero size\n",
> +				 port->id, cxld->id);
> +			return -ENXIO;
> +		}
>   		port->commit_end = cxld->id;
>   	} else {
>   		/* unless / until type-2 drivers arrive, assume type-3 */
> 
