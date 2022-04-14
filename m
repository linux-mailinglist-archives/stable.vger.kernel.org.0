Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC985018B9
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 18:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237942AbiDNQex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 12:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239452AbiDNQeg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 12:34:36 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB26DF1EB1;
        Thu, 14 Apr 2022 09:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=XNjGhdRc5rgm9FzJSGOEdNif3xZg8UrHYjqABxVus/c=; b=LOXPXb4yWDQhvDn6IVISE4zjvL
        oyuO1vIPwaFqgLqlyhd7g9vuHEeK35IqKEI1JCt4JiLRH4L/tcP3g9p9IBUhGjgI1z8ipBLyrxki8
        v+aFvc6EI97OwOF11f5onuj1KxHxJ2aV2hT1j43mBFQvaQJCD2L4ogtebYIk0VlLLwxlQXesMP655
        MlUxYdejpEobFsL2JmqnVwlO0LvY7ZyTF1+fUqE8+3Cn5xafqJu4UjVAKjon9frz5/esQFOXY6gUd
        vqFMzjFmY66GmavTi4wFJzzBVTem28rTEXabT+UTXjyalf/jMTjD6b2tT6WO7rKHOQwog8NW1t3CG
        yRnNUCkw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nf1vB-0053Wm-Ud; Thu, 14 Apr 2022 16:02:14 +0000
Message-ID: <5f2712c2-9fc1-679d-b196-e7b7f8f4540d@infradead.org>
Date:   Thu, 14 Apr 2022 09:02:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 4.19 003/338] hv: utils: add PTP_1588_CLOCK to Kconfig to
 fix build
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        =?UTF-8?Q?Petr_=c5=a0tetiar?= <ynezz@true.cz>
References: <20220414110838.883074566@linuxfoundation.org>
 <20220414110838.987014792@linuxfoundation.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220414110838.987014792@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/14/22 06:08, Greg Kroah-Hartman wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> commit 1dc2f2b81a6a9895da59f3915760f6c0c3074492 upstream.
> 
> The hyperv utilities use PTP clock interfaces and should depend a
> a kconfig symbol such that they will be built as a loadable module or
> builtin so that linker errors do not happen.
> 
> Prevents these build errors:
> 
> ld: drivers/hv/hv_util.o: in function `hv_timesync_deinit':
> hv_util.c:(.text+0x37d): undefined reference to `ptp_clock_unregister'
> ld: drivers/hv/hv_util.o: in function `hv_timesync_init':
> hv_util.c:(.text+0x738): undefined reference to `ptp_clock_register'
> 
> Fixes: 3716a49a81ba ("hv_utils: implement Hyper-V PTP source")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Wei Liu <wei.liu@kernel.org>
> Cc: Dexuan Cui <decui@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Link: https://lore.kernel.org/r/20211126023316.25184-1-rdunlap@infradead.org
> Signed-off-by: Wei Liu <wei.liu@kernel.org>
> Cc: Petr Štetiar <ynezz@true.cz>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/hv/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/hv/Kconfig
> +++ b/drivers/hv/Kconfig
> @@ -16,6 +16,7 @@ config HYPERV_TSCPAGE
>  config HYPERV_UTILS
>  	tristate "Microsoft Hyper-V Utilities driver"
>  	depends on HYPERV && CONNECTOR && NLS
> +	depends on PTP_1588_CLOCK_OPTIONAL
>  	help
>  	  Select this option to enable the Hyper-V Utilities.

Please drop this one also. PTP_1588_CLOCK_OPTIONAL is not present
in 4.x kernels.

Sorry for the problem.

-- 
~Randy
