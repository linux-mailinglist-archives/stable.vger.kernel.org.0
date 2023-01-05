Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043C965EF49
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 15:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbjAEOvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 09:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbjAEOvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 09:51:14 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806C1E50
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 06:51:13 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 4CF5E855A8;
        Thu,  5 Jan 2023 15:51:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1672930271;
        bh=/KCS/HHilS8xqDlNaidjuTiF/A4a1HascV4VFQAEG5M=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Sb+lLl5yZaaTODqgFDM6YIV1/0aNdGBaA33R/0SCYPuFlTDcxtk45wadMfj+CI2cj
         NWGXEyq2CQZmavXOA3sxkH/ZaBOX3APs5F3zN/txxb3erUI+uKJGI4/rrdwOwAbY4j
         ggUbNjOgsgD/J+qwa92DQdrTti8ZQpsu88yA6rvNnn4BNK+M5jt/zPoKb43KNMf7+8
         RuIiyGlDHhbAb4f7quueMEYOfQx1z+ncw61YFHg0HTMSSGKMENl5iqgmdFgG8s5oMh
         CavwIl8PUsPYwySlMQ5Bj/zxOuWObJJZUEJxJsAZQcNOfCH7oKih7gxZEUjMQ+tXVl
         6h1tG7/uR7eKQ==
Message-ID: <f689c22c-dd93-8143-c730-2af4d472bd0f@denx.de>
Date:   Thu, 5 Jan 2023 15:51:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Content-Language: en-US
To:     Francesco Dolcini <francesco@dolcini.it>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
References: <Y5wiAPvPU+YY39oX@francesco-nb.int.toradex.com>
 <6f5f5b32-d7fe-13cc-b52d-83a27bd9f53e@denx.de>
 <20221216120155.4b78e5cf@xps-13>
 <Y5xmi62hR6JeYUt1@francesco-nb.int.toradex.com>
 <20221216143720.3c8923d8@xps-13>
 <fb55a784-eda3-8916-1413-581b9436b3f2@denx.de>
 <20221216163501.1c2ace21@xps-13>
 <Y5ydGhn/qYUalamm@francesco-nb.int.toradex.com>
 <20230102104004.6abae6da@xps-13> <20230105123334.7f90c289@xps-13>
 <Y7bG7GFDMS6bmQ4d@francesco-nb.int.toradex.com>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <Y7bG7GFDMS6bmQ4d@francesco-nb.int.toradex.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/5/23 13:47, Francesco Dolcini wrote:
> Hello Miquel,

Hi,

[...]

>> Let's move forward with this. Let's assume my fears are baseless. We
>> might consider the situation where someone tries to hide the partitions
>> by setting #size-cell to 0 even wronger and too unlikely. Hopefully we
>> will not break any other existing setups by applying an always-on fix.
> 
> Nice, good!

Indeed

>> I would still like to see U-Boot partitions handling evolve, at least:
>> - fix #size-cells in fdt_fixup_mtd()
>> - avoid the fdt_fixup_mtd() call from Collibri boards (ie. an example
>>    that can be followed by the other users)
> 
> Fine, I can do it.
> 
> However I am just not 100% sure about your proposal, I wonder if we
> should just deprecate this function or we should fix it.

I would say fix it.

> The exact end result will depend on the discussion with the U-Boot
> folks, but I absolutely agree that the current situation needs to
> change. I'll keep you in CC on those patches.
> 
>> On Linux side let's fix #size-cells like you proposed without filtering
>> against a list of compatibles. We however need to improve the
>> heuristics:
>> - Do it only when there are partitions declared within a NAND
>>    controller node.
>> - Change the warning to avoid mentioning backward compatibility, just
>>    mention this is utterly wrong and thus the value will be set to 1
>>    instead of 0.
>> - Mention in the comment above this only works on systems with <4GiB
>>    chips.
>> If you think about other conditions please feel free to add them.
>>
>> Do you concur?
> Yes, I do agree.

Same here, agreed, thanks.

[...]
