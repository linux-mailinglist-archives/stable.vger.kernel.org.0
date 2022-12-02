Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607FA640872
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 15:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbiLBObq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 09:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbiLBObp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 09:31:45 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC560DC852
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 06:31:43 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 2BF74849CD;
        Fri,  2 Dec 2022 15:31:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1669991501;
        bh=ApsMLtcwaIPedBPlT18dKOcSMuvH1AkPIvYODnI6wpQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=GyOowWd7DS4kgOEghgX1k8FniZ6k7udIcaibVbiFQyy4H5d0eISqa9DYsuc72WsWf
         DvRZhJ664XbiySi5IMHzkW4609PXD9fz8DcjWwa9cngovwHVl5zhGFU5V1vujBQmPW
         nMMqEofTTNW+BQmXcjMgBmQoCpWrtsOIXcTbWtY1SrgAqben2cyhohloxI9LKQPNg0
         mP5FIPCVc6BjxPBFKW3Ae1d0zc5qx596kEGn/7W73am7Y7wwLMxf/AHx53UEnE2Ajk
         QlE9IgtwoSe13e9UAd7rtssx0PuT5POG4qgJGE/WK7lphCF1H5EWp+RNUpMluSCPKG
         sI3xmsn5VhtoQ==
Message-ID: <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
Date:   Fri, 2 Dec 2022 15:31:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
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
Content-Language: en-US
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20221202150556.14c5ae43@xps-13>
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

On 12/2/22 15:05, Miquel Raynal wrote:
> Hi Francesco,

Hi,

[...]

> I still strongly disagree with the initial proposal but what I think we
> can do is:
> 
> 1. To prevent future breakages:
>    Fix fdt_fixup_mtdparts() in u-boot. This way newer U-Boot + any
>    kernel should work.
> 
> 2. To help tracking down situations like that:
>    Keep the warning in ofpart.c but continue to fail.
> 
> 3. To fix the current situation:
>     Immediately revert commit (and prevent it from being backported):
>     753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
>     This way your own boot flow is fixed in the short term.

Here I disagree, the fix is correct and I think we shouldn't proliferate 
incorrect DTs which don't match the binding document. Rather, if a 
bootloader generates incorrect (new) DT entries, I believe the driver 
should implement a fixup and warn user about this. PC does that as well 
with broken ACPI tables as far as I can tell.

I'm not convinced making a DT non-compliant with bindings again, only to 
work around a problem induced by bootloader, is the right approach here.

This would be setting a dangerous example, where anyone could request a 
DT fix to be reverted because their random bootloader does the wrong 
thing and with valid DT clean up, something broke.

> 4. There is no reason to partially fix a DT like what the above did
>     besides trying to avoid warnings emitted by the DT check tools.

Note that the 3. does not partially fix the DT, it fixes the node fully.

>     If
>     complying with modern bindings is a goal (and I think it should
>     be), then we can modernize this DT without breaking the boot flow:
>     Instead of only setting #size-cell = <0>, you can as well define
>     in your DT a subnode to define the NAND chip. NAND chips are not
>     supposed to have #size-cells properties, but in the past they did,
>     which means #address-cells and #size-cells are allowed (and marked
>     deprecated in the schema). So in practice, the dt-schema will not
>     warn you if they are there, which means you can still set
>     #size-cell = <1>.

I am really not convinced we should hack around this on the DT end and 
try to push some sort of convoluted workaround there, instead of fixing 
it on the driver side (and bootloader side, in the long run).

>     Please mind, the tools have been updated very recently to match
>     what I am describing above, so they will likely still report
>     errors until v6.2-rc1, see:
>     https://lore.kernel.org/linux-mtd/20221114090315.848208-1-miquel.raynal@bootlin.com/
> 
> Does this sound reasonable?

[...]
