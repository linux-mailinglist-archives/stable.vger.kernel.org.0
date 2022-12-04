Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B09641D1B
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 13:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiLDMuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 07:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDMuI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 07:50:08 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AE6270A
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 04:50:06 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 02F81852D9;
        Sun,  4 Dec 2022 13:50:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1670158203;
        bh=9958Kz0WUBI9KPlNJZhUoXLQZhLb+n3wPGuY1e4qLCM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=D2JVdSqCwuajzEHj24yafBggZ+ANz+iyIMLGZviIA7lQwnzcz4y5Nu22diAh+QpQq
         uN+rhMEaZ3fDYsNk3roUiML/fm2jtL4tyakjrczk8YZdYJ1q5FH9F73icI5lwsoMJz
         A6GsVR+h5GSQ4inn8xVJI6BVGy9ktK5kq8hN/r5SCbYRCFR6slnxJ7JDdveY2aYSWg
         3x7K5KeTr0Roqlt8OYxtqxG9Z9tNQGHBjvCy9VwlsuUotCFms163bKqjOmQ0osLRLF
         6SD64HQd252cRAofRZkiVVURHOdgVXBFJP2Q5TFLfcN8a8nIvCbgY2r8D97BPQw4r4
         OCj8TTbnPTbHQ==
Message-ID: <cc497c19-050a-b3c2-d3e2-640c07338ff6@denx.de>
Date:   Sun, 4 Dec 2022 13:50:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Content-Language: en-US
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
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <f6417f32-cf30-2e01-701e-ed1634055c6a@leemhuis.info>
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

On 12/2/22 16:56, Thorsten Leemhuis wrote:
> On 02.12.22 15:31, Marek Vasut wrote:
>> On 12/2/22 15:05, Miquel Raynal wrote:
>> [...]
>>> 3. To fix the current situation:
>>>      Immediately revert commit (and prevent it from being backported):
>>>      753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
>>>      This way your own boot flow is fixed in the short term.
>>
>> Here I disagree, the fix is correct and I think we shouldn't proliferate
>> incorrect DTs which don't match the binding document. Rather, if a
>> bootloader generates incorrect (new) DT entries, I believe the driver
>> should implement a fixup and warn user about this. PC does that as well
>> with broken ACPI tables as far as I can tell.
> 
> Well, that might be the right solution in the long run, that's up for
> others to decide, but we need to fix this *quickly*. For two reasons
> actually: the 6.1 release is near and the change was backported to
> stable already.
> 
> For details wrt to the "quickly", see "Prioritize work on fixing
> regressions" here:
> https://docs.kernel.org/process/handling-regressions.html
> 
> IOW: Ideally it should be fixed by Sunday.
> 
> I'll hence likely soon will point Linus to this and suggest to revert
> this, unless there are strong reasons against that or some sort of
> agreement on a better solution.

You might want to wait until everyone is back on Monday, the discussion 
is still ongoing, but it seems to be getting to a conclusion.
