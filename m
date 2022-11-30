Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFC963E3D6
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 23:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiK3W7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 17:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiK3W7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 17:59:09 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B74656EE2;
        Wed, 30 Nov 2022 14:59:07 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 93E508111E;
        Wed, 30 Nov 2022 23:59:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1669849145;
        bh=bdA1VnRIIkiIh4W3bkfPn+gLXMAwXCZKDzJmdNdc+MY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=L3RtkQOsXifidGFPEHwAczFj+vf47C5a9/5u7x82CftpoBNX6XPZhqLC/AZNW/q4Y
         IxKfbOuPWHPWUkT1S/JG1gnBPv1VTGc2IJzFCtaehekV0br8rlcW1g88fVaSdxrDed
         pQcBI9PlfHFREyu2UN3iDAtasEneCYHBVy+y/0CcMRSnVuc2cnX/HWwC0PQPqm23nB
         ntW/qCLxVcvykWZoZ3Fx4igjk02tG7LF+ePKJjJ2fnT9irVqxwqnXwuA4ol3SNIRLx
         hg7Da8sdWmpz5XJnfYhFujND5ww3E6be4fJOEsaV8pF8LNtZGsvvDpYg6VKsBtsLcK
         3tXSjjAQPQEVw==
Message-ID: <fef2598e-e5fc-c4fc-0530-2d3c380ed39a@denx.de>
Date:   Wed, 30 Nov 2022 23:59:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: Boot failure regression on 6.0.10 stable kernel on iMX7
Content-Language: en-US
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
References: <Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com>
 <12f7fbb7-8252-4520-89c2-c5138931a696@denx.de>
 <Y4fCZmjDMtMMyu+E@francesco-nb.int.toradex.com>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <Y4fCZmjDMtMMyu+E@francesco-nb.int.toradex.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/30/22 21:51, Francesco Dolcini wrote:
> On Wed, Nov 30, 2022 at 03:41:13PM +0100, Marek Vasut wrote:
>> On 11/30/22 14:52, Francesco Dolcini wrote:
>>> [    0.000000] Booting Linux on physical CPU 0x0
>>> [    0.000000] Linux version 6.0.10 (francesco@francesco-nb) (arm-linux-gnueabihf-gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.
>>> 4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #36 SMP Wed Nov 30 14:07:15 CET 2022
>>> ...
>>> [    4.407499] gpmi-nand: error parsing ofpart partition /soc/nand-controller@33002000/partition@0 (/soc/nand-controller
>>> @33002000)
>>> [    4.438401] gpmi-nand 33002000.nand-controller: driver registered.
>>> ...
>>> [    5.933906] VFS: Cannot open root device "ubi0:rootfs" or unknown-block(0,0): error -19
>>> [    5.946504] Please append a correct "root=" boot option; here are the available partitions:
>>> ...
>>>
>>> Any idea? I'm not familiar with the gpmi-nand driver and I would just revert it, but
>>> maybe you have a better idea.
>>
>> Can you share the relevant snippet of your nand controller DT node ?
> 
> We just have
> 
> from imx7-colibri.dtsi,
> 
>    &gpmi {
>    	fsl,use-minimum-ecc;
>    	nand-ecc-mode = "hw";
>    	nand-on-flash-bbt;
>    	pinctrl-names = "default";
>    	pinctrl-0 = <&pinctrl_gpmi_nand>;
>    };
> 
> OF partition are created by U-Boot from
>    mtdparts=mtdparts=gpmi-nand:512k(mx7-bcb),1536k(u-boot1)ro,1536k(u-boot2)ro,512k(u-boot-env),-(ubi)
> env variables calling fdt_fixup_mtdparts from colibri_imx7.c
> 
> Everything is available in the upstream Linux/U-Boot git, no downstream
> repo of any sort.
> 
>> Probably up to first partition is enough. I suspect you need to fill in the
>> correct address-cells/size-cells there, which might be currently missing in
>> your DT and worked by chance.
> 
> This is generated by U-Boot, I would need to dump what he did generate
> from the standard fdt_fixup_mtdparts(). I will try to do it tomorrow
> unless what I wrote here is already enough to understand what's going
> on.

Oh drat ... I see. It's the u-boot fdt_node_set_part_info() which checks 
the current NAND controller #size-cells and uses that when generating 
MTD partitions 'reg' properties. Since #size-cells is now zero, the reg 
properties would be malformed.

Now, what I am unsure is whether the right fix is to update mx7 colibri 
DT and include &gpmi { #size-cells=<1>; }; , or , revert this patch. The 
former fixes the problem for colibri and retains the correct 
#size-cells=<0> behavior for any other board which does not specify MTD 
partitions in the GPMI NAND node. The later also covers boards which we 
don't know about which might also use generated MTD partitions in DT 
using fdt_fixup_mtdparts() in U-Boot, but I am not convinced that is 
correct.

So, would you be OK with fixing up the colibri mx7 DT with #size-cells=<1> ?
