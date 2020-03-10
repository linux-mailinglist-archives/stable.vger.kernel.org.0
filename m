Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 528A118006F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 15:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbgCJOmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 10:42:07 -0400
Received: from er-systems.de ([148.251.68.21]:44986 "EHLO er-systems.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbgCJOmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 10:42:07 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2020 10:42:06 EDT
Received: from localhost.localdomain (localhost [127.0.0.1])
        by er-systems.de (Postfix) with ESMTP id BD688D6006F;
        Tue, 10 Mar 2020 15:33:58 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on er-systems.de
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by er-systems.de (Postfix) with ESMTPS id 9DF71D6006D;
        Tue, 10 Mar 2020 15:33:58 +0100 (CET)
Date:   Tue, 10 Mar 2020 15:33:57 +0100 (CET)
From:   Thomas Voegtle <tv@lio96.de>
X-X-Sender: thomas@er-systems.de
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "H.J. Lu" <hjl.tools@gmail.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 62/88] x86/boot/compressed: Dont declare __force_order
 in kaslr_64.c
In-Reply-To: <20200310123621.868809541@linuxfoundation.org>
Message-ID: <alpine.LSU.2.21.2003101522120.20206@er-systems.de>
References: <20200310123606.543939933@linuxfoundation.org> <20200310123621.868809541@linuxfoundation.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Virus-Status: No
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.102.2/25747/Tue Mar 10 12:06:29 2020 signatures .
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Mar 2020, Greg Kroah-Hartman wrote:

> From: H.J. Lu <hjl.tools@gmail.com>
>
> [ Upstream commit df6d4f9db79c1a5d6f48b59db35ccd1e9ff9adfc ]
>
> GCC 10 changed the default to -fno-common, which leads to
>
>    LD      arch/x86/boot/compressed/vmlinux
>  ld: arch/x86/boot/compressed/pgtable_64.o:(.bss+0x0): multiple definition of `__force_order'; \
>    arch/x86/boot/compressed/kaslr_64.o:(.bss+0x0): first defined here
>  make[2]: *** [arch/x86/boot/compressed/Makefile:119: arch/x86/boot/compressed/vmlinux] Error 1
>
> Since __force_order is already provided in pgtable_64.c, there is no
> need to declare __force_order in kaslr_64.c.
>
> Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Link: https://lkml.kernel.org/r/20200124181811.4780-1-hjl.tools@gmail.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> arch/x86/boot/compressed/pagetable.c | 3 ---
> 1 file changed, 3 deletions(-)
>
> diff --git a/arch/x86/boot/compressed/pagetable.c b/arch/x86/boot/compressed/pagetable.c
> index 56589d0a804b1..2591f8f6d45f2 100644
> --- a/arch/x86/boot/compressed/pagetable.c
> +++ b/arch/x86/boot/compressed/pagetable.c
> @@ -25,9 +25,6 @@
> #define __PAGE_OFFSET __PAGE_OFFSET_BASE
> #include "../../mm/ident_map.c"
>
> -/* Used by pgtable.h asm code to force instruction serialization. */
> -unsigned long __force_order;
> -
> /* Used to track our page table allocation area. */
> struct alloc_pgt_data {
> 	unsigned char *pgt_buf;
>


This ends up for me in:

arch/x86/boot/compressed/pagetable.o: In function 
`initialize_identity_maps':
pagetable.c:(.text+0x309): undefined reference to `__force_order'
arch/x86/boot/compressed/pagetable.o: In function 
`finalize_identity_maps':
pagetable.c:(.text+0x41a): undefined reference to `__force_order'


pgtable_64.c doesn't exist in v4.9 for x86.

So I guess it's not correct to remove __force_order from pagetable.c?


    Thomas

