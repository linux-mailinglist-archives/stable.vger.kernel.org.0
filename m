Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6A32F8EC3
	for <lists+stable@lfdr.de>; Sat, 16 Jan 2021 19:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbhAPSxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jan 2021 13:53:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:37668 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbhAPSxm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Jan 2021 13:53:42 -0500
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 10GIie1u011583;
        Sat, 16 Jan 2021 12:44:40 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 10GIic6h011582;
        Sat, 16 Jan 2021 12:44:38 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Sat, 16 Jan 2021 12:44:38 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] powerpc: Handle .text.{hot,unlikely}.* in linker script
Message-ID: <20210116184438.GE30983@gate.crashing.org>
References: <20210104204850.990966-1-natechancellor@gmail.com> <20210104205952.1399409-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104205952.1399409-1-natechancellor@gmail.com>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

Very late of course, and the patch is fine, but:

On Mon, Jan 04, 2021 at 01:59:53PM -0700, Nathan Chancellor wrote:
> Commit eff8728fe698 ("vmlinux.lds.h: Add PGO and AutoFDO input
> sections") added ".text.unlikely.*" and ".text.hot.*" due to an LLVM
> change [1].
> 
> After another LLVM change [2], these sections are seen in some PowerPC
> builds, where there is a orphan section warning then build failure:
> 
> $ make -skj"$(nproc)" \
>        ARCH=powerpc CROSS_COMPILE=powerpc64le-linux-gnu- LLVM=1 O=out \
>        distclean powernv_defconfig zImage.epapr
> ld.lld: warning: kernel/built-in.a(panic.o):(.text.unlikely.) is being placed in '.text.unlikely.'

Is the section really called ".text.unlikely.", i.e. the name ending in
a dot?  How very unusual, is there some bug elsewhere?


Segher
