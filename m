Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8A526BDEE
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 09:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgIPH2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 03:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgIPH2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 03:28:12 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D435BC06174A;
        Wed, 16 Sep 2020 00:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JYfiuMkxr5TNFodNlGV/93yVFf6ozsY7Fc+hf04Cztw=; b=VIk1ltm1ccqpD00Ta9/qJb9j2z
        h7r/ol/y6qs1x3mmQuz/Um8WoS4xNLXNcPQ7FUygqIjCe8GrNR3RICF4m/bSVxoFSQvJNw+c9k9VH
        mgDTvlT9hMnS8m8xuaIgxB1Xg94Y0uOCwpb0uzw7qVN4hO606pxDP3vGEwVpH9l24E29juKjLnvqp
        Atzv3iHecwHR3ayXrl7jb0s2yctMQHd4MMhdG7Oc4Age4CVLTO8ULOXIzHiNjQ/YWucGo0Zbc/+w8
        GRPM9kzvVuGTxzJsKTchaTPJqs/fvi5bUHz3IUI/i1fjka8zd6vgaT4cD4g+I0eto6CZu5u6TncbG
        ELNqxvrA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIRrL-0007ze-D7; Wed, 16 Sep 2020 07:28:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9D778305815;
        Wed, 16 Sep 2020 09:28:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 882332C27E219; Wed, 16 Sep 2020 09:28:05 +0200 (CEST)
Date:   Wed, 16 Sep 2020 09:28:05 +0200
From:   peterz@infradead.org
To:     Andy Lutomirski <luto@kernel.org>
Cc:     x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Bill Wendling <morbo@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Greg Thelen <gthelen@google.com>,
        John Sperbeck <jsperbeck@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/smap: Fix the smap_save() asm
Message-ID: <20200916072805.GH2674@hirez.programming.kicks-ass.net>
References: <9f513eef618b6e72a088cc8b2787496f190d1c2d.1600203307.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f513eef618b6e72a088cc8b2787496f190d1c2d.1600203307.git.luto@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 01:55:58PM -0700, Andy Lutomirski wrote:
> The old smap_save() code was:
> 
>   pushf
>   pop %0
> 
> with %0 defined by an "=rm" constraint.  This is fine if the
> compiler picked the register option, but it was incorrect with an
> %rsp-relative memory operand.  With some intentional abuse, I can
> get both gcc and clang to generate code along these lines:
> 
>   pushfq
>   popq 0x8(%rsp)
>   mov 0x8(%rsp),%rax
> 
> which is incorrect and will not work as intended.

We need another constraint :-)

> Fix it by removing the memory option.  This issue is exacerbated by
> a clang optimization bug:
> 
>   https://bugs.llvm.org/show_bug.cgi?id=47530
> 
> Fixes: e74deb11931f ("x86/uaccess: Introduce user_access_{save,restore}()")
> Cc: stable@vger.kernel.org
> Reported-by: Bill Wendling <morbo@google.com> # I think
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  arch/x86/include/asm/smap.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/smap.h b/arch/x86/include/asm/smap.h
> index 8b58d6975d5d..be6d675ae3ac 100644
> --- a/arch/x86/include/asm/smap.h
> +++ b/arch/x86/include/asm/smap.h
> @@ -61,7 +61,7 @@ static __always_inline unsigned long smap_save(void)
>  		      ALTERNATIVE("jmp 1f", "", X86_FEATURE_SMAP)
>  		      "pushf; pop %0; " __ASM_CLAC "\n\t"
>  		      "1:"
> -		      : "=rm" (flags) : : "memory", "cc");
> +		      : "=r" (flags) : : "memory", "cc");

native_save_fl() has the exact same code; you'll need to fix both.
