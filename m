Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493EE3554D6
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 15:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243573AbhDFNSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 09:18:53 -0400
Received: from elvis.franken.de ([193.175.24.41]:59078 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242526AbhDFNSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 09:18:47 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lTlbK-0006qP-03; Tue, 06 Apr 2021 15:18:38 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 0A7CBC24D9; Tue,  6 Apr 2021 15:06:30 +0200 (CEST)
Date:   Tue, 6 Apr 2021 15:06:29 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     linux-mips@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: Fix a longstanding error in div64.h
Message-ID: <20210406130629.GE9505@alpha.franken.de>
References: <20210406112404.2671507-1-chenhuacai@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406112404.2671507-1-chenhuacai@loongson.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 07:24:03PM +0800, Huacai Chen wrote:
> Only 32bit kernel need __div64_32(), but commit c21004cd5b4cb7d479514d4
> ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.") makes it depend
> on 64bit kernel by mistake. This patch fix this longstanding error.
> 
> Fixes: c21004cd5b4cb7d479514d4 ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>  arch/mips/include/asm/div64.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/mips/include/asm/div64.h b/arch/mips/include/asm/div64.h
> index dc5ea5736440..d199fe36eb46 100644
> --- a/arch/mips/include/asm/div64.h
> +++ b/arch/mips/include/asm/div64.h
> @@ -11,7 +11,7 @@
>  
>  #include <asm-generic/div64.h>
>  
> -#if BITS_PER_LONG == 64
> +#if BITS_PER_LONG == 32

are you sure this will make a difference ? asm-generic/div64.h checks
for __div64_32, which is not defined before including it here.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
