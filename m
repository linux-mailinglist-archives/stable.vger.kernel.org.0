Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91754AB80D
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 11:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbiBGJvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 04:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241300AbiBGJs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 04:48:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4295EC043181;
        Mon,  7 Feb 2022 01:48:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B69861214;
        Mon,  7 Feb 2022 09:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26145C004E1;
        Mon,  7 Feb 2022 09:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644227335;
        bh=mD9mtrxe++NaQ4w8np5HRlq449OvwX0lapT6hefnHms=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=DYl3gk8aTzu2bMYi4yOVAO0O5/wSE8m+Ruwq5cshoZ3i2OYncEBpWP6jQrChMPf+u
         ia/DIS0LOswizYAQiipJGWv7cQsjEKcUmqBdnCUbUxcRWH5CONceCp6b+LBajVLIbv
         owfoKvOPB+wUOj/sXmW+H8ZxYdVBFV/jjSH4gNjaeswTo4hwpOKKsghoBUVuZaYaNG
         f91nhaoNc/vHI3dVkQVIEsxFE3zpxGQ9Q/f0y9YI16w+/y9eZpB54HW+fCUvWPWA3z
         j16DfYZAbwmvsYpF1gVddW5ZrRspt5mjieAZB+w7cBbqgxG4SBuLNNoe+pkn897UN7
         BduOq6e4fdsyw==
Message-ID: <b4e83e9a-306c-ca80-e977-05bf23b91cfa@kernel.org>
Date:   Mon, 7 Feb 2022 03:48:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] ARM: socfpga: fix missing RESET_CONTROLLER
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
References: <20220207084404.212017-1-krzysztof.kozlowski@canonical.com>
 <b5c87b7d-fdb4-2288-5c21-c666fdd40005@kernel.org>
 <a655b739-f6f5-3e68-4e1a-4be76ebdaef5@canonical.com>
From:   Dinh Nguyen <dinguyen@kernel.org>
In-Reply-To: <a655b739-f6f5-3e68-4e1a-4be76ebdaef5@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/7/22 03:47, Krzysztof Kozlowski wrote:
> On 07/02/2022 10:45, Dinh Nguyen wrote:
>>
>>
>> On 2/7/22 02:44, Krzysztof Kozlowski wrote:
>>> The SocFPGA machine since commit b3ca9888f35f ("reset: socfpga: add an
>>> early reset driver for SoCFPGA") uses reset controller, so it should
>>> select RESET_CONTROLLER explicitly.  Selecting ARCH_HAS_RESET_CONTROLLER
>>> is not enough because it affects only default choice still allowing a
>>> non-buildable configuration:
>>>
>>>     /usr/bin/arm-linux-gnueabi-ld: arch/arm/mach-socfpga/socfpga.o: in function `socfpga_init_irq':
>>>     arch/arm/mach-socfpga/socfpga.c:56: undefined reference to `socfpga_reset_init'
>>>
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Cc: <stable@vger.kernel.org>
>>> Fixes: b3ca9888f35f ("reset: socfpga: add an early reset driver for SoCFPGA")
>>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>> ---
>>>    arch/arm/mach-socfpga/Kconfig | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/arch/arm/mach-socfpga/Kconfig b/arch/arm/mach-socfpga/Kconfig
>>> index 43ddec677c0b..594edf9bbea4 100644
>>> --- a/arch/arm/mach-socfpga/Kconfig
>>> +++ b/arch/arm/mach-socfpga/Kconfig
>>> @@ -2,6 +2,7 @@
>>>    menuconfig ARCH_INTEL_SOCFPGA
>>>    	bool "Altera SOCFPGA family"
>>>    	depends on ARCH_MULTI_V7
>>> +	select ARCH_HAS_RESET_CONTROLLER
>>>    	select ARCH_SUPPORTS_BIG_ENDIAN
>>>    	select ARM_AMBA
>>>    	select ARM_GIC
>>> @@ -18,6 +19,7 @@ menuconfig ARCH_INTEL_SOCFPGA
>>>    	select PL310_ERRATA_727915
>>>    	select PL310_ERRATA_753970 if PL310
>>>    	select PL310_ERRATA_769419
>>> +	select RESET_CONTROLLER
>>>    
>>>    if ARCH_INTEL_SOCFPGA
>>>    config SOCFPGA_SUSPEND
>>
>> Acked-By: Dinh Nguyen <dinguyen@kernel.org>
> 
> Hi Dinh,
> 
> I was expecting you will pick it up. If you only ack, who is going to
> take it? Shall I send it directly to soc@?
> 

Ok...I'll pick it up.

Dinh
