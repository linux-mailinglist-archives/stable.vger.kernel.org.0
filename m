Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B272C50DA4C
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 09:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236399AbiDYHoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 03:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiDYHoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 03:44:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621E43B290;
        Mon, 25 Apr 2022 00:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51017B810AD;
        Mon, 25 Apr 2022 07:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F0AC385A4;
        Mon, 25 Apr 2022 07:40:49 +0000 (UTC)
Message-ID: <ee410d9d-25dc-3b87-08d2-c4c8e71575a3@linux-m68k.org>
Date:   Mon, 25 Apr 2022 17:40:46 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] binfmt_flat: Remove shared library support
Content-Language: en-US
To:     Rob Landley <rob@landley.net>, Kees Cook <keescook@chromium.org>,
        Rich Felker <dalias@libc.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>, ebiederm@xmission.com,
        damien.lemoal@opensource.wdc.com, Niklas.Cassel@wdc.com,
        viro@zeniv.linux.org.uk, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, vapier@gentoo.org, stable@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
        geert@linux-m68k.org, linux-m68k@lists.linux-m68k.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        ysato@users.sourceforge.jp
References: <87levzzts4.fsf_-_@email.froward.int.ebiederm.org>
 <mhng-32cab6aa-87a3-4a5c-bf83-836c25432fdd@palmer-ri-x1c9>
 <20220420165935.GA12207@brightrain.aerifal.cx>
 <202204201044.ACFEB0C@keescook>
 <ab454879-5506-fe7d-cd59-812a6bc9d193@landley.net>
From:   Greg Ungerer <gerg@linux-m68k.org>
In-Reply-To: <ab454879-5506-fe7d-cd59-812a6bc9d193@landley.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 25/4/22 13:38, Rob Landley wrote:
> On 4/20/22 12:47, Kees Cook wrote:
>>> For what it's worth, bimfmt_flat (with or without shared library
>>> support) should be simple to implement as a binfmt_misc handler if
>>> anyone needs the old shared library support (or if kernel wanted to
>>> drop it entirely, which I would be in favor of). That's how I handled
>>> old aout binaries I wanted to run after aout was removed: trivial
>>> binfmt_misc loader.
>>
>> Yeah, I was trying to understand why systems were using binfmt_flat and
>> not binfmt_elf, given the mention of elf2flat -- is there really such a
>> large kernel memory footprint savings to be had from removing
>> binfmt_elf?
> 
> elf2flat is a terrible name: it doesn't take an executable as input, it takes a
> .o file as input. (I mean it's an elf format .o file, but... misleading.)

No, not at all. "elf2flt" is exactly what it does. Couldn't get a
more accurate name.


>> But regardless, yes, it seems like if you're doing anything remotely
>> needing shared libraries with binfmt_flat, such a system could just use
>> ELF instead.
> 
> A) The binfmt_elf.c loader won't run on nommu systems. The fdpic loader will,
> and in theory can handle normal ELF binaries (it's ELF with _more_
> capabilities), but sadly it's not supported on most architectures for reasons
> that are unclear to me.

Inertia. Flat format has been around a very long time.
And for most people it just works. Flat format works on MMU systems
as well, though you would have to be crazy to choose to do that.


> B) You can't run conventional ELF on nommu, because everything is offset from 0
> so PID 1 eats that address range and you can't run exec program.
> 
> You can run PIE binaries on nommu (the symbols offset from a base pointer which
> can point anywhere), but they're inefficient (can't share text or rodata
> sections between instances because every symbol is offset from a single shared
> base pointer), and highly vulnerable to fragmentation (because it needs a
> contiguous blob of memory for text, rodata, bss, and data: see single base
> pointer everything has an integer offset from).
> 
> All fdpic really does is give you 4 base pointers, one for each section. That
> way you can share text and rodata, and put bss and data into smaller independent
> fragments of memory. Various security guys use this as super-aslr even on mmu
> systems, but tend not to advertise that they're doing so. :)

Well flat got half way there. You can have separate text/rodata and data/bss,
used a lot back in the day for execute-in-place of the code.

Regards
Greg


