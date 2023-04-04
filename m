Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DDD6D5EEA
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 13:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbjDDLZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 07:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234712AbjDDLZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 07:25:50 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448241FEF;
        Tue,  4 Apr 2023 04:25:49 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pjenL-0005Zk-3U; Tue, 04 Apr 2023 13:25:47 +0200
Message-ID: <1473b364-777a-ede8-3ff6-36d9e1d577ad@leemhuis.info>
Date:   Tue, 4 Apr 2023 13:25:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: dmaengine: at_hdmac: Regression regarding rs485 via dma in v5.4
Content-Language: en-US, de-DE
To:     tudor.ambarus@microchip.com
References: <CADBnMvj93bSO=+wU4=pLTgONV7w_hhecxQHAc_YS4P4GaqMNrA@mail.gmail.com>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Cc:     Linux kernel regressions list <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kristof Havasi <havasiefr@gmail.com>,
        dmaengine@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <CADBnMvj93bSO=+wU4=pLTgONV7w_hhecxQHAc_YS4P4GaqMNrA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1680607549;38fe22e1;
X-HE-SMSGID: 1pjenL-0005Zk-3U
X-Spam-Status: No, score=-1.9 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Adding a few pople to the list of recipients that were involved in
developing the culprit; also CCing the regression list, as it should be
in the loop for regressions:
https://docs.kernel.org/admin-guide/reporting-regressions.html]

[TLDR: I'm adding this report to the list of tracked Linux kernel
regressions; the text you find below is based on a few templates
paragraphs you might have encountered already in similar form.
See link in footer if these mails annoy you.]

On 29.03.23 16:31, Kristof Havasi wrote:
> 
> I was rebasing the Kernel branch of our SAMA5D35 based board from
> v5.4.189 to v5.4.238.
> I noticed that after the rebase we could _only send, but not receive_
> through our RS485 interface.
> 
> I could bisect the problem to 77b97ef4908aa917e7b68667ec6b344cc5dc5034
> in the v5.4.225 release. 

FWIW, that's 7176a6a8982d ("dmaengine: at_hdmac: Don't start
transactions at tx_submit level") in mainline.

Kristof Havasi: would be good to know if this is something that happens
with recent mainline as well, because if not it might be something the
stable team needs to handle.

> If I revert this commit, the tx/rx works just
> like before.
> Maybe this use-case wasn't considered when this patch was created?
> I haven't seen a documentation change regarding this in DT bindings,
> but if the config should be something else, please let me know.
> Otherwise this commit breaks the RS485 function of atmel_serial at
> least in the v5.4.y branch.
> 
> Best Regards,
> Kristóf Havasi
> 
> The relevant device tree nodes:
> 
> from sama5d3.dtsi:
> 
> usart1: serial@f0020000 {
>   compatible = "atmel,at91sam9260-usart";
>   reg = <0xf0020000 0x100>;
>   interrupts = <13 IRQ_TYPE_LEVEL_HIGH 5>;
>   dmas = <&dma0 2 AT91_DMA_CFG_PER_ID(5)>,
>   <&dma0 2 (AT91_DMA_CFG_PER_ID(6) | AT91_DMA_CFG_FIFOCFG_ASAP)>;
>   dma-names = "tx", "rx";
>   pinctrl-names = "default";
>   pinctrl-0 = <&pinctrl_usart1>;
>   clocks = <&usart1_clk>;
>   clock-names = "usart";
>   status = "disabled";
> };
> 
> pinctrl_usart1: usart1-0 {
>   atmel,pins =
>   <AT91_PIOB 28 AT91_PERIPH_A AT91_PINCTRL_PULL_UP
>    AT91_PIOB 29 AT91_PERIPH_A AT91_PINCTRL_NONE>;
> };
> pinctrl_usart1_rts_cts: usart1_rts_cts-0 {
>   atmel,pins =
>   <AT91_PIOB 26 AT91_PERIPH_A AT91_PINCTRL_NONE /* PB26 periph A,
> conflicts with GRX7 */
>    AT91_PIOB 27 AT91_PERIPH_A AT91_PINCTRL_NONE>; /* PB27 periph A,
> conflicts with G125CKO */
> };
> 
> from our dts:
> 
> &usart1 {
>   pinctrl-0 = <&pinctrl_usart1 &pinctrl_usart1_rts_cts>;
>   atmel,use-dma-rx;
>   atmel,use-dma-tx;
>   rs485-rx-during-tx;
>   linux,rs485-enabled-at-boot-time;
>   status = "okay";
> };
> 
> HW:
> The SAMA5D3's PB27 is connected to the |RE+DE of the RS485 transceiver
> SP3458EN-L


Thanks for the report. To be sure the issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, the Linux kernel regression
tracking bot:

#regzbot ^introduced 77b97ef4908aa
#regzbot title dmaengine: at_hdmac: receiving data through the RS485
interface broke
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (the parent of this mail). See page linked in footer for
details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.
