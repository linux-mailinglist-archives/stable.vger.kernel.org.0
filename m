Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71700314F37
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 13:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhBIMkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 07:40:37 -0500
Received: from elvis.franken.de ([193.175.24.41]:36528 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230228AbhBIMj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 07:39:59 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1l9SIV-0003IE-05; Tue, 09 Feb 2021 13:39:15 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 37F2FC0DBF; Tue,  9 Feb 2021 13:38:17 +0100 (CET)
Date:   Tue, 9 Feb 2021 13:38:17 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Youling Tang <tangyouling@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Xingxing Su <suxingxing@loongson.cn>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH mips-fixes] MIPS: compressed: fix build with enabled UBSAN
Message-ID: <20210209123817.GE11264@alpha.franken.de>
References: <20210208123645.101354-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208123645.101354-1-alobakin@pm.me>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 12:37:42PM +0000, Alexander Lobakin wrote:
> Commit 1e35918ad9d1 ("MIPS: Enable Undefined Behavior Sanitizer
> UBSAN") added a possibility to build the entire kernel with UBSAN
> instrumentation for MIPS, with the exception for VDSO.
> However, self-extracting head wasn't been added to exceptions, so
> this occurs:
> 
> mips-alpine-linux-musl-ld: arch/mips/boot/compressed/decompress.o:
> in function `FSE_buildDTable_wksp':
> decompress.c:(.text.FSE_buildDTable_wksp+0x278): undefined reference
> to `__ubsan_handle_shift_out_of_bounds'
> mips-alpine-linux-musl-ld: decompress.c:(.text.FSE_buildDTable_wksp+0x2a8):
> undefined reference to `__ubsan_handle_shift_out_of_bounds'
> mips-alpine-linux-musl-ld: decompress.c:(.text.FSE_buildDTable_wksp+0x2c4):
> undefined reference to `__ubsan_handle_shift_out_of_bounds'
> mips-alpine-linux-musl-ld: arch/mips/boot/compressed/decompress.o:
> decompress.c:(.text.FSE_buildDTable_raw+0x9c): more undefined references
> to `__ubsan_handle_shift_out_of_bounds' follow
> 
> Add UBSAN_SANITIZE := n to mips/boot/compressed/Makefile to exclude
> it from instrumentation scope and fix this issue.
> 
> Fixes: 1e35918ad9d1 ("MIPS: Enable Undefined Behavior Sanitizer UBSAN")
> Cc: stable@vger.kernel.org # 5.0+
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  arch/mips/boot/compressed/Makefile | 1 +
>  1 file changed, 1 insertion(+)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
