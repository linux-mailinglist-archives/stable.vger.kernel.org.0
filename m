Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62316641DB8
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 16:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLDPvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 10:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiLDPvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 10:51:00 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF12113D16
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 07:50:56 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 408BC856A7;
        Sun,  4 Dec 2022 16:50:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1670169053;
        bh=IkR+a0wQaJHRUyMrC/B8vmTUXFxr7Nz0B/kASdDdyME=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QGB/noS9hEw7tUeyhzSPXkVR0slEXfMJH46Efp3PCdmTi24HbOGAUzTQkVOwJSf0z
         TtEDXD22kAFZZVMhKEuaL9o5gGa/9IbI41bhmSyQk0q9MSt3Dtf1K02hE5u8L4gAuN
         d5EKAzrlYiSv4nyx/iz88xtiwqQ0/074wzm0ivtNLbRwkdXvKn+nynOjy7LOfC10WL
         MkETaHB+DSpkibUp5gLiD8k5/g0w3x25TsZr5MoeMfIYWZLsPLCaNEqUrZu2L1jIkO
         T1GZaLpNSu3iPIUmLgC07zpr4AL+Wke22o/31LFklHxZSAUl6y7plER7xKxJIHmL3b
         x/cUYO351kXqQ==
Message-ID: <7feb2cde-bfeb-5f8c-8cc4-7870e6fcf56c@denx.de>
Date:   Sun, 4 Dec 2022 16:50:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Francesco Dolcini <francesco@dolcini.it>
Cc:     Richard Weinberger <richard@nod.at>,
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
 <f6417f32-cf30-2e01-701e-ed1634055c6a@leemhuis.info>
 <cc497c19-050a-b3c2-d3e2-640c07338ff6@denx.de>
 <b652fe29-5fbc-b548-266a-d494733b6e32@leemhuis.info>
Content-Language: en-US
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <b652fe29-5fbc-b548-266a-d494733b6e32@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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

On 12/4/22 13:59, Thorsten Leemhuis wrote:
> On 04.12.22 13:50, Marek Vasut wrote:
>> On 12/2/22 16:56, Thorsten Leemhuis wrote:
>>> On 02.12.22 15:31, Marek Vasut wrote:
>>>> On 12/2/22 15:05, Miquel Raynal wrote:
>>>> [...]
>>>>> 3. To fix the current situation:
>>>>>       Immediately revert commit (and prevent it from being backported):
>>>>>       753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
>>>>>       This way your own boot flow is fixed in the short term.
>>>>
>>>> Here I disagree, the fix is correct and I think we shouldn't proliferate
>>>> incorrect DTs which don't match the binding document. Rather, if a
>>>> bootloader generates incorrect (new) DT entries, I believe the driver
>>>> should implement a fixup and warn user about this. PC does that as well
>>>> with broken ACPI tables as far as I can tell.
>>>
>>> Well, that might be the right solution in the long run, that's up for
>>> others to decide, but we need to fix this *quickly*. For two reasons
>>> actually: the 6.1 release is near and the change was backported to
>>> stable already.
>>>
>>> For details wrt to the "quickly", see "Prioritize work on fixing
>>> regressions" here:
>>> https://docs.kernel.org/process/handling-regressions.html
>>>
>>> IOW: Ideally it should be fixed by Sunday.
>>>
>>> I'll hence likely soon will point Linus to this and suggest to revert
>>> this, unless there are strong reasons against that or some sort of
>>> agreement on a better solution.
>>
>> You might want to wait until everyone is back on Monday, the discussion
>> is still ongoing, but it seems to be getting to a conclusion.
> 
> Yeah, came to a similar conclusion, but want to mentioned it
> nevertheless and already have this prepared (together will appropriate
> links to the discussion):
> 
> ```
> A regression causing boot failures on iMX7 (due to a backport this is
> also affecting 6.0.y) could be fixed with a quick revert as well. But
> looks like there is no need for it, after some back and forth the
> developers that care are close to come to an agreement how to fix the
> problem properly soonish:
> ```

ACK, thanks
