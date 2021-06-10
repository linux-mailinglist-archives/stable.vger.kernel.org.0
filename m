Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12633A34FA
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 22:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhFJUmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 16:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhFJUmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 16:42:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21D3F61429;
        Thu, 10 Jun 2021 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623357608;
        bh=cfPlMTfGXZjzDSIMKaRDT3uPARbvwJpdNQB661xjaDE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=T0SkyKAMumx70GptKP1ts1upsmUgHa2WyIbP+37ju/tIa3qR/yyFju5IcV+1nNcDa
         zl0hCC7wDd6dDdkCaz3Asouv/+xfL/gHZ55l+vpJkoF9YDn5VAog1zG+AHMexfDPJy
         QgKfvcbDzg9YkExqbJosGyPfSz/GSPyI9CnRTITFrBEn03Q78n6mlXL6uAX1KTCI4P
         BnRLHtj1LcxWo4Gp4VoyjLg1KXSrjX3Cud5g5Vj+CjT04us9gCnOEvtdWg+VgHSv6/
         vR8JQ/dwSNh0hMceMuhcetqxz9ii1VYQlg3N3pO4cy/RPdDdvTNzJD8/mAOansQehr
         qbvB94MBMLItA==
Subject: Re: [PATCH] x86/Makefile: make -stack-alignment conditional on LLD <
 13.0.0
To:     Tor Vic <torvic9@mailbox.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <214134496.67043.1623317284090@office.mailbox.org>
 <CAKwvOdmU9TUiZ6AatJja=ksneRKP5saNCkx0qodLMOi_BshSSg@mail.gmail.com>
 <156d8beb-2644-8c2b-789b-104cf9268c8a@mailbox.org>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <3e245a20-9e5b-9122-7add-11f6eed46ca1@kernel.org>
Date:   Thu, 10 Jun 2021 13:40:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <156d8beb-2644-8c2b-789b-104cf9268c8a@mailbox.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/10/2021 1:16 PM, Tor Vic wrote:
> 
> 
> On 10.06.21 19:20, Nick Desaulniers wrote:
>> On Thu, Jun 10, 2021 at 2:28 AM <torvic9@mailbox.org> wrote:
>>>
>>> Since LLVM commit 3787ee4, the '-stack-alignment' flag has been dropped [1],
>>> leading to the following error message when building a LTO kernel with
>>> Clang-13 and LLD-13:
>>>
>>>      ld.lld: error: -plugin-opt=-: ld.lld: Unknown command line argument
>>>      '-stack-alignment=8'.  Try 'ld.lld --help'
>>>      ld.lld: Did you mean '--stackrealign=8'?
>>>
>>> It also appears that the '-code-model' flag is not necessary anymore starting
>>> with LLVM-9 [2].
>>>
>>> Drop '-code-model' and make '-stack-alignment' conditional on LLD < 13.0.0.
>>
>> Please include this additional context in v2:
>> ```
>> These flags were necessary because these flags were not encoded in the
>> IR properly, so the link would restart optimizations without them. Now
>> there are properly encoded in the IR, and these flags exposing
>> implementation details are no longer necessary.
>> ```
>> That way it doesn't sound like we're not using an 8B stack alignment
>> on x86; we very much are so; AMDGPU GPFs without it!
>>
> 
> Will do so.
> Does this have to be a v2 (with a "changes from v1" info) or just a
> resend? It is based on mainline now and the line numbers have changed.

Yes, this should be a v2 because the commit message changed. It would be 
considered a resend if nothing changed and the patch just needed to be 
picked up rather than re-reviewed.

Cheers,
Nathan
