Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1A263D861
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 15:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiK3OlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 09:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiK3OlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 09:41:21 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851CB51C23;
        Wed, 30 Nov 2022 06:41:16 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id BCCF58111E;
        Wed, 30 Nov 2022 15:41:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1669819274;
        bh=Z5IKzSwGxXlJOYbUYMPGB0yC0DBElvsVC9HCLUtH3vQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=WmLMrsnzpilqnB8v7T8krcMcPU4H+K/Uh2KhY1v9J4hUmcS4gJNw/sF/ep7RJ2eLH
         SvU8spR3Pbeqwhu/Xxwsgdk7d2tQXcT6JN42zjQR9druRFzPklErS33MgqLBeOHq+W
         U4qzT18reXMiOdfCl7pEbJZ2mymi2L/JqXREnInlRVkStnjVaQ/Fh6EdM9flEBol81
         UZ/2lU2Ri+6isO3n6dcWeIeP2kQId6eI0UcHgKLWipjG0w5/3c8ImEtzs0sxBkuLuZ
         2kE9Rr5mkrsjZzWX8qXIImeo9U0sqAX2+TqTce2lihHDxvNUvMDDzxtracSjczpwv/
         AomveH3o882tw==
Message-ID: <12f7fbb7-8252-4520-89c2-c5138931a696@denx.de>
Date:   Wed, 30 Nov 2022 15:41:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: Boot failure regression on 6.0.10 stable kernel on iMX7
Content-Language: en-US
To:     Francesco Dolcini <francesco@dolcini.it>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
References: <Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com>
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

On 11/30/22 14:52, Francesco Dolcini wrote:
> Hello Marek,

Hi,

> it looks like commit 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller
> size-cells"), that was backported to stable 6.0.10, introduce a boot
> regression on colibri-imx7, at least.
> 
> What I get is
> 
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Linux version 6.0.10 (francesco@francesco-nb) (arm-linux-gnueabihf-gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.
> 4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #36 SMP Wed Nov 30 14:07:15 CET 2022
> ...
> [    4.407499] gpmi-nand: error parsing ofpart partition /soc/nand-controller@33002000/partition@0 (/soc/nand-controller
> @33002000)
> [    4.438401] gpmi-nand 33002000.nand-controller: driver registered.
> ...
> [    5.933906] VFS: Cannot open root device "ubi0:rootfs" or unknown-block(0,0): error -19
> [    5.946504] Please append a correct "root=" boot option; here are the available partitions:
> ...
> 
> Any idea? I'm not familiar with the gpmi-nand driver and I would just revert it, but
> maybe you have a better idea.

Can you share the relevant snippet of your nand controller DT node ? 
Probably up to first partition is enough. I suspect you need to fill in 
the correct address-cells/size-cells there, which might be currently 
missing in your DT and worked by chance.
