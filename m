Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5D6628ED6
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 02:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbiKOBDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 20:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiKOBDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 20:03:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40B0D102;
        Mon, 14 Nov 2022 17:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=S6yPAiRk+t6GLKlx3IP8Wnv/9rrtxQRSekfjt97Zb+8=; b=JnabfKpwSCOpDwZ0W2eKClxxIQ
        soxyUh9RIFMta8dqyp/uw27XIPqsMMSVskTC14VDTkCQ+R2dU6JlxP2kCE9DdJaphOLiOZlNYLzFV
        W1etSV11Izu0Uxep73RR0ArJ1n0rkYQbU3ILUI9yfRmk+8ewr8RfrUil93kHUjjePjOBDDdVWZCdt
        cGr/bV0fUzTXtPZL7qm8cLa2gv6CCPnLckRHFoOsNilPaRNGAOSqqJ5O9cuwbs1khzKTFoMcfD+tG
        dx1sbHTe8tPwVoMB4W9vsI8GmiDrb9slBd9EwiPqyy+Ss9OTmtDrYz7cXTJIo1NjsZ9hqL1ovHuS4
        WJc0Fbaw==;
Received: from [2601:1c2:d80:3110::a2e7]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oukLw-006VGP-GI; Tue, 15 Nov 2022 01:03:04 +0000
Message-ID: <48206188-97e3-1477-87f1-8946320be737@infradead.org>
Date:   Mon, 14 Nov 2022 17:03:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v1 1/1] fpga: m10bmc-sec: Fix kconfig dependencies
Content-Language: en-US
To:     Russ Weight <russell.h.weight@intel.com>, mdf@kernel.org,
        hao.wu@intel.com, yilun.xu@intel.com, trix@redhat.com,
        linux-fpga@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     lgoncalv@redhat.com, marpagan@redhat.com,
        matthew.gerlach@linux.intel.com,
        basheer.ahmed.muddebihal@intel.com, tianfei.zhang@intel.com,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
References: <20221115001127.289890-1-russell.h.weight@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20221115001127.289890-1-russell.h.weight@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/14/22 16:11, Russ Weight wrote:
> The secure update driver depends on the firmware-upload functionality of
> the firmware-loader. The firmware-loader is carried in the firmware-class
> driver which is enabled with the tristate CONFIG_FW_LOADER option. The
> firmware-upload functionality is included in the firmware-class driver if
> the bool FW_UPLOAD config is set.
> 
> The current dependency statement, "depends on FW_UPLOAD", is not adequate
> because it does not implicitly turn on FW_LOADER. Instead of adding a
> dependency, follow the convention used by drivers that require the
> FW_LOADER_USER_HELPER functionality of the firmware-loader by using
> select for both FW_LOADER and FW_UPLOAD.
> 
> Fixes: bdf86d0e6ca3 ("fpga: m10bmc-sec: create max10 bmc secure update")
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Russ Weight <russell.h.weight@intel.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> ---
>  drivers/fpga/Kconfig | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index d1a8107fdcb3..6ce143dafd04 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -246,7 +246,9 @@ config FPGA_MGR_VERSAL_FPGA
>  
>  config FPGA_M10_BMC_SEC_UPDATE
>  	tristate "Intel MAX10 BMC Secure Update driver"
> -	depends on MFD_INTEL_M10_BMC && FW_UPLOAD
> +	depends on MFD_INTEL_M10_BMC
> +	select FW_LOADER
> +	select FW_UPLOAD
>  	help
>  	  Secure update support for the Intel MAX10 board management
>  	  controller.

-- 
~Randy
