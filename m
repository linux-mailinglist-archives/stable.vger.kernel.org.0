Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD9550B4F7
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 12:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446512AbiDVK3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 06:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379632AbiDVK3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 06:29:17 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B01BA546BE;
        Fri, 22 Apr 2022 03:26:24 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37DEF1477;
        Fri, 22 Apr 2022 03:26:24 -0700 (PDT)
Received: from [10.57.12.164] (unknown [10.57.12.164])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C18F3F766;
        Fri, 22 Apr 2022 03:26:18 -0700 (PDT)
Message-ID: <91c64a80-3892-944d-4178-5b57a4f2899d@arm.com>
Date:   Fri, 22 Apr 2022 11:26:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] binfmt_flat: Remove shared library support
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Greg Ungerer <gerg@linux-m68k.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Mike Frysinger <vapier@gentoo.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Jesse Taube <Mr.Bossman075@gmail.com>,
        Giulio Benetti <giulio.benetti@benettiengineering.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
 <f379cb56-6ff5-f256-d5f2-3718a47e976d@opensource.wdc.com>
 <Yli8voX7hw3EZ7E/@x1-carbon>
 <81788b56-5b15-7308-38c7-c7f2502c4e15@linux-m68k.org>
 <87levzzts4.fsf_-_@email.froward.int.ebiederm.org>
 <01b063d7-d5c2-8af0-ad90-ed6c069252c5@linux-m68k.org>
 <CAMuHMdXd94L=766usN4WG-hK2MpQLy50mJZ=9G9NGv03kx8V8Q@mail.gmail.com>
 <CAK8P3a3Cjna7H_YxFvg6UEOqQf9ZqLp9EVOCFFewzWBHVT4nWg@mail.gmail.com>
From:   Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <CAK8P3a3Cjna7H_YxFvg6UEOqQf9ZqLp9EVOCFFewzWBHVT4nWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/21/22 8:12 AM, Arnd Bergmann wrote:
> On Thu, Apr 21, 2022 at 8:52 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Thu, Apr 21, 2022 at 1:53 AM Greg Ungerer <gerg@linux-m68k.org> wrote:
>>> On 21/4/22 00:58, Eric W. Biederman wrote:
>>>> In a recent discussion[1] it was reported that the binfmt_flat library
>>>> support was only ever used on m68k and even on m68k has not been used
>>>> in a very long time.
>>>>
>>>> The structure of binfmt_flat is different from all of the other binfmt
>>>> implementations becasue of this shared library support and it made
>>>> life and code review more effort when I refactored the code in fs/exec.c.
>>>>
>>>> Since in practice the code is dead remove the binfmt_flat shared libarary
>>>> support and make maintenance of the code easier.
>>>>
>>>> [1] https://lkml.kernel.org/r/81788b56-5b15-7308-38c7-c7f2502c4e15@linux-m68k.org
>>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> ---
>>>>
>>>> Can the binfmt_flat folks please verify that the shared library support
>>>> really isn't used?
>>>
>>> I can definitely confirm I don't use it on m68k. And I don't know of
>>> anyone that has used it in many years.
>>>
>>>
>>>> Was binfmt_flat being enabled on arm and sh the mistake it looks like?
>>
>> I think the question was intended to be
>>
>>      Was *binfmt_flat_shared_flat* being enabled on arm and sh the
>>      mistake it looks like?
>>
>>>>
>>>>    arch/arm/configs/lpc18xx_defconfig |   1 -
>>>>    arch/arm/configs/mps2_defconfig    |   1 -
>>>>    arch/arm/configs/stm32_defconfig   |   1 -
>>>>    arch/arm/configs/vf610m4_defconfig |   1 -
> 
> Adding stm32, mps2 and imxrt maintainers to Cc, they are the most active
> armv7-m users and should know if the shared library support is used anywhere.

Never seen shared library in use for flat format, so FWIW

Acked-by: Vladimir Murzin <vladimir.murzin@arm.com> # ARM


> 
>       Arnd

