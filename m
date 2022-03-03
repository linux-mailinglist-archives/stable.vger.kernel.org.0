Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73944CB340
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 01:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiCCAIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 19:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiCCAHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 19:07:48 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0878CB0EA2;
        Wed,  2 Mar 2022 16:07:03 -0800 (PST)
Received: from [192.168.43.69] (unknown [182.2.41.243])
        by gnuweeb.org (Postfix) with ESMTPSA id E76197E29A;
        Thu,  3 Mar 2022 00:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646266023;
        bh=FXJ5RIO8Oqa50icw+tN38pTqQ1lL1MDXri2vESEbOg0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Qs9kOFlmA24f/j91hiJ5vZ3XiNoZkicH8EA217zJ1ThsXNvKfiiqjO7jYUumaa7bZ
         8/H1DD9nGRCQUQtxXuWMDRO8pyV6jPga/5rXM6xOWVIfSdwY6xfzf3BPsDmR8bhJqj
         r1vIt6IKpd4bg6BbOZmYLO+J2y+J+SPtJ6f6tA4CneYu8CmiviamL/qocX7V4NgVmK
         T6HlKHPP7BApNnUeNaZJcy7aorzSN5XKQgcE1m3nGdxj1jgUJc3Pcc62v3lVZUFaPO
         ulS5kViDcEBZDYlGNUCLG2i0PIWua8fPKz8gZ+m4wS15XdA6sysccIAUZHPAuVIvSV
         Mf7KExPwK02Ew==
Message-ID: <4f7d2b07-c5e5-33dc-f6a7-c62b1c5329b9@gnuweeb.org>
Date:   Thu, 3 Mar 2022 07:06:52 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 1/2] x86/delay: Fix the wrong asm constraint in
 `delay_loop()`
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        x86@kernel.org, stable@vger.kernel.org,
        Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Laight <David.Laight@ACULAB.COM>
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
 <20220301094608.118879-2-ammarfaizi2@gnuweeb.org>
 <CAOG64qPgTv5tQNknuG9d-=oL2EPQQ1ys7xu2FoBpNLyzv1qYzA@mail.gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <CAOG64qPgTv5tQNknuG9d-=oL2EPQQ1ys7xu2FoBpNLyzv1qYzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/22 6:33 PM, Alviro Iskandar Setiawan wrote:
> hi sir, it might also be interesting to know that even if it never be
> inlined, it's still potential to break.
> 
> for example this code (https://godbolt.org/z/xWMTxhTET)
> 
>    __attribute__((__noinline__)) static void x(int a)
>    {
>        asm("xorl\t%%r8d, %%r8d"::"a"(a));
>    }
> 
>    extern int p(void);
> 
>    int f(void)
>    {
>        int ret = p();
>        x(ret);
>        return ret;
>    }
> 
> translates to this asm
> 
>    x:
>            movl    %edi, %eax
>            xorl    %r8d, %r8d
>            ret
>    f:
>            subq    $8, %rsp
>            call    p
>            movl    %eax, %r8d
>            movl    %eax, %edi
>            call    x
>            movl    %r8d, %eax
>            addq    $8, %rsp
>            ret
> 
> See the %r8d? It should be clobbered by a function call too. But since
> no one tells the compiler that we clobber %r8d, it assumes %r8d never
> changes after that call. The compiler thinks x() is static and will
> not clobber %r8d, even the ABI says %r8d will be clobbered by a
> function call. So i think it should be backported to the stable
> kernel, it's still a fix

Thanks. I will add CC stable in the v5.

-- 
Ammar Faizi
