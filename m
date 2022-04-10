Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424864FACF8
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 10:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiDJIxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Apr 2022 04:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbiDJIxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Apr 2022 04:53:30 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BB31135
        for <stable@vger.kernel.org>; Sun, 10 Apr 2022 01:51:20 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1ndTHx-0003Ca-U5; Sun, 10 Apr 2022 10:51:17 +0200
Message-ID: <6b09d10e-2098-9fb7-be4c-ae67d802cd2d@leemhuis.info>
Date:   Sun, 10 Apr 2022 10:51:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v7 0/4] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Content-Language: en-US
To:     Tokunori Ikegami <ikegami.t@gmail.com>, miquel.raynal@bootlin.com
Cc:     richard@nod.at, vigneshr@ti.com, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org
References: <20220323170458.5608-1-ikegami.t@gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220323170458.5608-1-ikegami.t@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1649580680;a8dc91e0;
X-HE-SMSGID: 1ndTHx-0003Ca-U5
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker. Top-posting for once,
to make this easily accessible to everyone.

Miquel, Richard, Vignesh: what's up here? This patchset fixes a
regression. It's quite old, so it's not that urgent, but it looked like
nothing happened for two and a half week now. Or was progress made
somewhere?

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.

#regzbot poke

On 23.03.22 18:04, Tokunori Ikegami wrote:
> Since commit dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to
> check correct value") buffered writes fail on S29GL064N. This is
> because, on S29GL064N, reads return 0xFF at the end of DQ polling for
> write completion, where as, chip_good() check expects actual data
> written to the last location to be returned post DQ polling completion.
> Fix is to revert to using chip_good() for S29GL064N which only checks
> for DQ lines to settle down to determine write completion.
> 
> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
> 
> Tokunori Ikegami (4):
>   mtd: cfi_cmdset_0002: Move and rename
>     chip_check/chip_ready/chip_good_for_write
>   mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
>   mtd: cfi_cmdset_0002: Add S29GL064N ID definition
>   mtd: cfi_cmdset_0002: Rename chip_ready variables
> 
>  drivers/mtd/chips/cfi_cmdset_0002.c | 112 ++++++++++++++--------------
>  include/linux/mtd/cfi.h             |   1 +
>  2 files changed, 55 insertions(+), 58 deletions(-)
> 

