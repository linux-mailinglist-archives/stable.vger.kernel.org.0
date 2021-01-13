Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4272F48FA
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 11:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbhAMKox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 05:44:53 -0500
Received: from elvis.franken.de ([193.175.24.41]:47768 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727655AbhAMKox (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 05:44:53 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1kzddE-00021m-06; Wed, 13 Jan 2021 11:44:04 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id EDBF6C02B1; Wed, 13 Jan 2021 11:43:54 +0100 (CET)
Date:   Wed, 13 Jan 2021 11:43:54 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Jinyang He <hejinyang@loongson.cn>,
        Ralf Baechle <ralf@linux-mips.org>,
        Matt Redfearn <matt.redfearn@mips.com>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH mips-fixes] MIPS: relocatable: fix possible boot hangup
 with KASLR enabled
Message-ID: <20210113104354.GA10505@alpha.franken.de>
References: <20210110142023.185275-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110142023.185275-1-alobakin@pm.me>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 10, 2021 at 02:21:05PM +0000, Alexander Lobakin wrote:
> LLVM-built Linux triggered a boot hangup with KASLR enabled.
> 
> arch/mips/kernel/relocate.c:get_random_boot() uses linux_banner,
> which is a string constant, as a random seed, but accesses it
> as an array of unsigned long (in rotate_xor()).
> When the address of linux_banner is not aligned to sizeof(long),
> such access emits unaligned access exception and hangs the kernel.
> 
> Use PTR_ALIGN() to align input address to sizeof(long) and also
> align down the input length to prevent possible access-beyond-end.
> 
> Fixes: 405bc8fd12f5 ("MIPS: Kernel: Implement KASLR using CONFIG_RELOCATABLE")
> Cc: stable@vger.kernel.org # 4.7+
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  arch/mips/kernel/relocate.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

applied to mips-fixes.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
