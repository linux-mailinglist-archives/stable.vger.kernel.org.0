Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E886640BC3
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 18:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbiLBRI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 12:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbiLBRI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 12:08:26 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC27C5118
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 09:08:25 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 35FEC843E4;
        Fri,  2 Dec 2022 18:08:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1670000903;
        bh=JK/ai9l9hTLZbTMNKDkKRqkQBK7kfMQ22sdksRiNvfo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nBxPm+YFGzCsBvpYZZXWw7b19M2ta96kP1rpU8d9n4p3JAwP4gHfLivrEia1r4uyJ
         sSqYJ2ayRGHIHVrW5X/fzfDX8Lo4hL9j9f9Q9AW1Fp9SUqX4fd0AG6MmJRIKw9azA9
         l8xSqeAFgJ1P3h4SXn9eryHjKcTcVpUagp4LI5ZFCRfjwQJWgB0gZlWEXkkGJ3j61G
         ODo3RcA212lWb53PhorqGEVdoyt28gmw/HrmirGSxvgesQcxVL/R+4XwisyaT3mMm4
         O2fDLRRwZmfuCSTAzUkn5H2XFnnlNQHcAiqd8yz0F+pPQq02X3CV53IoCDxpWcW2XZ
         lq2cTKZQAlFGQ==
Message-ID: <7afd364c-33b8-38a9-65a6-015b4360db6b@denx.de>
Date:   Fri, 2 Dec 2022 18:08:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
References: <20221202071900.1143950-1-francesco@dolcini.it>
 <20221202101418.6b4b3711@xps-13>
 <Y4nPmzdgaabg3a3/@francesco-nb.int.toradex.com>
 <Y4nSXQirO2N5IRfu@francesco-nb.int.toradex.com>
 <20221202115327.4475d3a2@xps-13>
 <Y4ngOaKq224LIpQc@francesco-nb.int.toradex.com>
 <20221202150556.14c5ae43@xps-13>
 <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
 <20221202160030.1b8d0b8a@xps-13>
 <223b7a4e-3aff-8070-7387-c77d2ded1dd6@denx.de>
 <20221202164904.08d750df@xps-13>
 <0503c46d-c385-74f5-f762-51d87a5ebaff@denx.de>
 <20221202174255.2c1cb2ff@xps-13>
 <e80377c9-1542-d47d-6d35-2efdc15bcbf8@denx.de>
 <20221202175730.231d75d5@xps-13>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20221202175730.231d75d5@xps-13>
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

On 12/2/22 17:57, Miquel Raynal wrote:
> Hi Marek,

Hi,

>> On 12/2/22 17:42, Miquel Raynal wrote:
>>> Hi Marek,
>>
>> Hi,
>>
>> [...]
>>
>>>>> However, it should not be empty, at the very least a reg property
>>>>> should indicate on which CS it is wired, as expected there:
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git/tree/Documentation/devicetree/bindings/mtd/nand-chip.yaml?h=mtd/next
>>>>
>>>> OK, I see your point. So basically this?
>>>>
>>>> &gpmi {
>>>>      #size-cells = <1>;
>>>>      ...
>>>>      nand-chip@0 {
>>>>        reg = <0>;
>>>>      };
>>>> };
>>>>
>>>> btw. the GPMI NAND controller supports only one chipselect, so the reg in nand-chip node makes little sense.
>>>
>>> I randomly opened a reference manual (IMX6DQL.pdf), they say:
>>>
>>> 	"Up to four NAND devices, supported by four chip-selects and one
>>> 	 ganged ready/ busy."
>>
>> Doh, and MX7D has the same controller, so size-cells = <1>; makes sense with nand-chip@N {} .
> 
> Actually #address-cells is here for that. You need to point at one CS,
> so in most cases this is:
> 
> controller {
> 	#address-cells = <1>;
> 	#size-cells = <0>;
> 	chip@N {
> 		reg = <N>;
> 	};
> };

Right ... thanks for spotting this.

But then the size-cells in the controller node should be zero. And 
753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells") is 
therefore correct ?

But that correction in 753395ea1e45 breaks setup where old U-Boot 
injects partition@N directly into the nand-controller node, without 
updating the nand-controller node size-cells, i.e. this:
nand-controller {
	#address-cells = <1>;
	#size-cells = <0>;

+       partition@0 { ... };
};
Because the size-cells is 0 in that case, and U-Boot does not update the 
size-cells .

It used to work before because Linux DT contained size-cells=<1> in the 
nand-controller node before 753395ea1e45 ("ARM: dts: imx7: Fix NAND 
controller size-cells").

But here I would say this is a firmware bug and it might have to be 
handled like a firmware bug, i.e. with fixup in the partition parser. I 
seem to be changing my opinion here again.
