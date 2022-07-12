Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484055716FA
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 12:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbiGLKPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 06:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiGLKPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 06:15:50 -0400
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CB8AB7F2;
        Tue, 12 Jul 2022 03:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
        t=1657620946; bh=Qy2aD4jae7WRAGs22QTr9i9ghQ5lCrNooZtoNWm8ScQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=RRtr77MUySNcX97jwUMcUn+6qBESgQgGDvXyiPq9xzL21rjz6fFV4uiAczcvP2r+M
         tOp9Fdl1WwRfL/6Ot/Yq/DSEzMxi0yWymcwedsaYrD80zX6hknS1JceruJ+Ms3p1M+
         gQMt0vUkYqd4dM1/vKkbWytp2ocxqylhnyzbR0PM=
Received: from [100.100.57.190] (unknown [220.248.53.61])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 763A1607C5;
        Tue, 12 Jul 2022 18:15:45 +0800 (CST)
Message-ID: <c8c959fa-f17d-f0dd-6a8d-e0b0ce622f3a@xen0n.name>
Date:   Tue, 12 Jul 2022 18:15:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:104.0)
 Gecko/20100101 Thunderbird/104.0a1
Subject: Re: [PATCH 3/6] M68K: cpuinfo: Fix a warning for
 CONFIG_CPUMASK_OFFSTACK
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Huacai Chen <chenhuacai@gmail.com>
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michal Simek <monstr@monstr.eu>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        loongarch@lists.linux.dev, Linux-Arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guo Ren <guoren@kernel.org>, Xuerui Wang <kernel@xen0n.name>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        stable <stable@vger.kernel.org>
References: <20220712075255.1345991-1-chenhuacai@loongson.cn>
 <20220712075255.1345991-3-chenhuacai@loongson.cn>
 <CAMuHMdUazqHLbc80vpZ+Msg9A3j5aPJ3fx+CdCG3kuWDSf8WSw@mail.gmail.com>
 <CAAhV-H775jXMbcR9j=oLBuHo1PfFziZSUQWttJAEw20sUt+GAA@mail.gmail.com>
 <CAMuHMdUHbepd974u5iox3BcOyo_Q2ZgT-znruk+WCt+HMQ_Lgw@mail.gmail.com>
 <CAAhV-H78Fi0aE-h5MOgRa5L+Jt7D0wG0nLcYzx45jVney8T1BQ@mail.gmail.com>
 <CAMuHMdVXFmKR4LuXHYRrSk3Q0VRqATGbsM512DxayWCPCE-wvg@mail.gmail.com>
From:   WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <CAMuHMdVXFmKR4LuXHYRrSk3Q0VRqATGbsM512DxayWCPCE-wvg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Geert and Huacai,

On 2022/7/12 17:13, Geert Uytterhoeven wrote:
> Hi Huacai,
>
> On Tue, Jul 12, 2022 at 11:08 AM Huacai Chen <chenhuacai@gmail.com> wrote:
>> On Tue, Jul 12, 2022 at 5:01 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>> On Tue, Jul 12, 2022 at 10:53 AM Huacai Chen <chenhuacai@gmail.com> wrote:
>>>> On Tue, Jul 12, 2022 at 4:33 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>>>> On Tue, Jul 12, 2022 at 9:53 AM Huacai Chen <chenhuacai@loongson.cn> wrote:
>>>>>> When CONFIG_CPUMASK_OFFSTACK and CONFIG_DEBUG_PER_CPU_MAPS is selected,
>>>>> DEBUG_PER_CPU_MAPS depends on SMP, which is not supported on m68k,
>>>>> and thus cannot be enabled.
>>>> This patch is derived from MIPS and LoongArch, I search all
>>>> architectures and change those that look the same as MIPS and
>>>> LoongArch.
>>>> And the warning message below is also a copy-paste from LoongArch, sorry.
>>>>
>>>> Since M68K doesn't support SMP, then this patch seems to make no
>>>> difference, but does it make sense to keep consistency across all
>>>> architectures?
>>> Yes, having consistency is good.  But that should be mentioned in the
>>> patch description, instead of a scary warning CCed to stable ;-)
>>>
>>> BTW, you probably want to update the other copy of c_start() in
>>> arch/m68k/kernel/setup_mm.c, too.
>> For no-SMP architectures, it seems c_start() in
>> arch/m68k/kernel/setup_mm.c is more reasonable (just use 1, neither
>> NR_CPUS, nor nr_cpu_ids)?
> The advantage of using nr_cpu_ids() is that this is one place less
> to update when adding SMP support later...

Hmm, so I've been watching m68k development lately (although not as 
closely as I'd like to, due to lack of vintage hardware at hand), given 
the current amazing  momentum all the hobbyists/developers have been 
contributing to, SMP is well within reach...

But judging from the intent of this patch series (fixing WARNs on 
certain configs), and that the triggering condition is currently 
impossible on m68k (and other non-SMP) platforms, I think cleanups for 
such arches could come as a separate patch series later. I think the 
m68k refactoring is reasonable after all, due to my observation above, 
but for the other non-SMP arches we may want to wait for the respective 
maintainers' opinions.

