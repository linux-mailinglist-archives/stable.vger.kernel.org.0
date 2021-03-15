Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B911733BF3C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 16:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhCOO72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:59:28 -0400
Received: from elvis.franken.de ([193.175.24.41]:60567 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232141AbhCOO7I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:59:08 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lLogP-0003dk-00; Mon, 15 Mar 2021 15:59:01 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 04BF7C0791; Mon, 15 Mar 2021 15:58:50 +0100 (CET)
Date:   Mon, 15 Mar 2021 15:58:50 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     YunQiang Su <yunqiang.su@cipunited.com>
Cc:     linux-mips@vger.kernel.org, macro@orcam.me.uk,
        jiaxun.yang@flygoat.com, f4bug@amsat.org, stable@vger.kernel.org
Subject: Re: [PATCH v7 RESEND] MIPS: force use FR=0 or FRE for FPXX binaries
Message-ID: <20210315145850.GA12494@alpha.franken.de>
References: <20210312104859.16337-1-yunqiang.su@cipunited.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312104859.16337-1-yunqiang.su@cipunited.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 10:48:59AM +0000, YunQiang Su wrote:
> The MIPS FPU may have 3 mode:
>   FR=0: MIPS I style, all of the FPR are single.
>   FR=1: all 32 FPR can be double.
>   FRE: redirecting the rw of odd-FPR to the upper 32bit of even-double FPR.
> 
> The binary may have 3 mode:
>   FP32: can only work with FR=0 and FRE mode
>   FPXX: can work with all of FR=0/FR=1/FRE mode.
>   FP64: can only work with FR=1 mode
> 
> Some binary, for example the output of golang, may be mark as FPXX,
> while in fact they are FP32. It is caused by the bug of design and linker:
>   Object produced by pure Go has no FP annotation while in fact they are FP32;
>   if we link them with the C module which marked as FPXX,
>   the result will be marked as FPXX. If these fake-FPXX binaries is executed
>   in FR=1 mode, some problem will happen.
> 
> In Golang, now we add the FP32 annotation, so the future golang programs
> won't have this problem. While for the existing binaries, we need a
> kernel workaround.

what about just rebuilding them ? They are broken, so why should we fix
broken user binaries with kernel hacks ?

> Currently, FR=1 mode is used for all FPXX binary, it makes some wrong
> behivour of the binaries. Since FPXX binary can work with both FR=1 and FR=0,
> we force it to use FR=0 or FRE (for R6 CPU).

I'm not sure, if I want to take this patch.

Maciej, what's your take on this ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
