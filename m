Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BAE642CBB
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 17:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiLEQZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 11:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiLEQZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 11:25:16 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A820F1DA7A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 08:25:14 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id B918A851A4;
        Mon,  5 Dec 2022 17:25:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1670257512;
        bh=XRBQL3ANkfRLt1ZmdDnM6T1k6QmnmvivFD5ygRvJDCA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=frp3kYFpF3zHArqSezOQzPXl0Nasq2nlca2xDcecLT0QFUNSHHgvL171nFR/+B58E
         Z2HdD6qX77I4JbtU6TtPQwScPhvt3iJVsXaF3m7jwK1I1NbMC9mX8zKz3kcbpukQJF
         kOqG3E5rD4DGb5YoGB9eNajiyRsKc3PV0WOG+4Fi6grgTwr0pKZCczhquSV7nDfCr6
         3onvhm2hZS1Jo06fZe3ax/OxfayBJ7NvdhmutzcJ/QO15lfND4D9b4zuiPhLSzVg13
         1Cx/kY8SwxMzhZJh7OHo/C4+7OHE2BnEZhajpONGYo0SpAbA6cELzmo/LMl9UGflQl
         N2q6vhg0S81TQ==
Message-ID: <ecca019d-b0b7-630c-4221-2684cb51634c@denx.de>
Date:   Mon, 5 Dec 2022 17:25:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Francesco Dolcini <francesco@dolcini.it>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
References: <20221202150556.14c5ae43@xps-13>
 <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
 <20221202160030.1b8d0b8a@xps-13>
 <223b7a4e-3aff-8070-7387-c77d2ded1dd6@denx.de>
 <20221202164904.08d750df@xps-13>
 <0503c46d-c385-74f5-f762-51d87a5ebaff@denx.de>
 <20221202174255.2c1cb2ff@xps-13>
 <e80377c9-1542-d47d-6d35-2efdc15bcbf8@denx.de>
 <20221202175730.231d75d5@xps-13>
 <7afd364c-33b8-38a9-65a6-015b4360db6b@denx.de>
 <Y43VdPftDbq6cD2L@francesco-nb.int.toradex.com>
 <20221205144917.6514168a@xps-13>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20221205144917.6514168a@xps-13>
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

On 12/5/22 14:49, Miquel Raynal wrote:
> Hi Francesco,

Hi,

> francesco@dolcini.it wrote on Mon, 5 Dec 2022 12:26:44 +0100:
> 
>> On Fri, Dec 02, 2022 at 06:08:22PM +0100, Marek Vasut wrote:
>>> But here I would say this is a firmware bug and it might have to be handled
>>> like a firmware bug, i.e. with fixup in the partition parser. I seem to be
>>> changing my opinion here again.
>>
>> I was thinking at this over the weekend, and I came to the following
>> ideas:
>>
>>   - we need some improvement on the fixup we already have in the
>>     partition parser. We cannot ignore the fdt produced by U-Boot - as
>>     bad as it is.
>>   - the proposed fixup is fine for the immediate need, but it is
>>     not going to be enough to cover the general issue with the U-Boot
>>     generated partitions. U-Boot might keep generating partitions as direct
>>     child of the nand controller even when a partitions{} node is
>>     available. In this case the current parser just fails since it looks
>>     only into it and it will find it empty.
>>   - the current U-Boot only handle partitions{} as a direct child of the
>>     nand-controller, the nand-chip is ignored. This is not the way it is
>>     supposed to work. U-Boot code would need to be improved.
> 
> I've been thinking about it this weekend as well and the current fix
> which "just set" s_cell to 1 seems risky for me, it is typically the
> type of quick & dirty fix that might even break other board (nobody
> knew that U-Boot current logic expected #size-cells to be set in the
> DT, what if another "broken" DT expects the opposite...)

Then with the current configuration, such broken DT would not work, 
since current DT does set #size-cells=<1> (wrongly).

> , not
> mentioning potential issues with big storages (> 4GiB).
> 
> All in all, I really think we should revert the DT change now, reverting
> as little to no drawbacks besides a dt_binding_check warning and gives
> us time to deal with it properly (both in U-Boot and Linux).

I am really not happy with this, but if that's marked as intermediate 
fix, go for it.

How do we deal with this in the long run however? Parser-side fix like 
this one, maybe with better heuristics ?
