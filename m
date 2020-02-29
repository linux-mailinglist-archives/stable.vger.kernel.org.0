Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7153617493F
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 21:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbgB2UhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 15:37:03 -0500
Received: from mout.web.de ([212.227.17.11]:47869 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbgB2UhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Feb 2020 15:37:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1583008618;
        bh=w9cAr7LmPhwGLRr4s0x8s5Z4bBjVwaC0/iME9jkIhgw=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=A9fApO1QkF8GVgWIQ2GHbgdHaHLgz+26IDFvyghJUKv9Kr0EbD5vr8jNPzwA5Hg57
         bO3mpjBwUQt88sfJLcl9tc6emyrvw7cU6PQo337ATD2JMMJO2SnqajS8CsnIUM+BUx
         vhwuMJ7BhzQHRhCGgVT8CsNFq9rlqRJYvYbF+tFU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.55.156]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LfiuU-1jitRT3LlS-00pLzh; Sat, 29
 Feb 2020 21:36:57 +0100
Subject: Re: [FYI PATCH 1/3] KVM: nVMX: Don't emulate instructions in guest
 mode
To:     Jim Mattson <jmattson@google.com>
Cc:     Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable@vger.kernel.org
References: <1582570596-45387-1-git-send-email-pbonzini@redhat.com>
 <1582570596-45387-2-git-send-email-pbonzini@redhat.com>
 <41d80479-7dbc-d912-ff0e-acd48746de0f@web.de>
 <CAOQ_QshE7SMX2cO7H+21Fkdpg53oE2D3xrHPJHR_MCfH4r9QCQ@mail.gmail.com>
 <CALMp9eRETy1RLWHWKtFHqpcpFHbQKtPgJHDD_N+LPzaUPx-Jvg@mail.gmail.com>
 <e8fe4664-d948-f239-4ec9-82d9010b7d26@web.de>
 <CALMp9eR9zcXO64n7hDTzZHPkfV8qtuMHAbc=nLX8S8x7Crum+A@mail.gmail.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <3b63f015-8a00-9aae-87a0-8713195001aa@web.de>
Date:   Sat, 29 Feb 2020 21:36:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eR9zcXO64n7hDTzZHPkfV8qtuMHAbc=nLX8S8x7Crum+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Q/ugFKcVWk5O4DZmpOtPypb3xEqE7vN6F4jI5L2kwElt8Q2DPz1
 aqR9mHRZwKVESdyulkhjYq2PPNhlIM/0vcLev4bEV5jnKJjypnxKcC3/ZYWCUPTWRntfcBq
 0EETDI23Vopdf5xkU+UVIXmTrTL/4kxHAXh0j+BxdSg2B2moOl5r7QtFWvtjrek1KumBHxa
 AJDlMgTKkiDDpagPI6Ciw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+/hErHdUzRA=:yEIdljjMPrGM4NTE9dVn6K
 QSzujLVelMxzlrbs/JLPNPAIwPp3GucYa4b6MUhaZcFGhPXlOQUrSmBjJO328HqYV7C/FAWX/
 iLJxQq1rjfOS/MpEe94olRO4WddYNILtm0qhzhUfE8wxMqj2YWFzFNf/O2so7Is/UfsljpnOk
 s1gIgp6aOsbmEgjGn2cLlwJStWmE7VF36NluaKcxuy/TOq7kpCkvtpqbUpHmL8D3sPC+wQNFJ
 A73McUh4CGkTDVPBgCZ42navVtjiMI6C27BMMC7TP9wFVNwrtib9fOYhe3LoXwNtqsmxv19x1
 LjffLuX3uNv7/gS0ne5XPkbukBd2QkLSyVg+bi9nk0Mf/yzyi8H97YBGX5nkfAR0xu7Ki37Ch
 nMJJqeKgDT254jw1tMa1gOTIEqrM7r9HrEfc9ooF90bQZ1J3oDGWP5KAg/PlzGXFY7HHjDkEG
 esQXabbZTtOzffcmF1lhZg1TDMFzavajXQYaMC86VGQ3HttM+YfzXMiMiLrbpaYQ7B5VwvXeK
 cjrhFU8bqhIJZyc4UXgjpyGxa0YJcDpXh+5u0OvJuphwxOrPaYItDfNNFMks34/aNLd9bM+He
 5SPVy3uascjGhKKZ+6gO9EBoVWq8X1pDK8NNaCO3nd8FfxPE78QTJ9jZNl/I669GqQkwtf24h
 FjKKXKceMXg3GALzMYgQ3UEwOwzMUFoZpqITZ+MHMzoX/7+80vCTy1O1BpQrUJOaSIWPlRcmd
 buVoA0S/bnBvMIxzb4rvEBr2/fqYh5ObA881ja1KVXSc9V8zJyUixiU7PmI1oaspEQpoqg8K8
 gTYorMU1d/4jhJIhew2JHINUPnJb+6xx55qkr2WCL3gj1geM1brONKYpd7GG58lXhiymOjaB9
 aI6wameCL6Ya/x/LcqaI6tmq9J/iVGoLjHeNWm6Dik9I5W9czr7kEgUM9YgEu5YHu1P/LN10W
 4h/pcqoe9oQHHNLJFBXCvHbz8odYm2mFMEaU14D741PXbPX/ZKZE88mo5jDcSfp6FDJlo0lOC
 wjfkuVJxPna2dGOHAUpvNdMpixfFxCJvm9xY8rSBOVpV187fCbLcgwSdgA/nxqGUrk25huSAX
 FUzBCJd7SqldF+neZ0LE4dZ1y7oEDJKCCGb1+prdynUboxHXagt02uV9M4bto2MV0IEKcelPg
 yAuyEHuooZIsAlWEPwJrgdS4n2+vZXL8o4k+d3Dy1ozgqK9SOitsj+7Ad+ImExJkSKEokYOAK
 9lmvE7hqA8xudmW5j
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 29.02.20 21:17, Jim Mattson wrote:
> Since UMIP emulation is broken, I'm not sure why anyone would use it.
> (Sorry, Paolo.)

FWIW, adding "-umip" to the "-cpu host" in my qemu setup works around
the bug.

Jan

>
> On Sat, Feb 29, 2020 at 11:21 AM Jan Kiszka <jan.kiszka@web.de> wrote:
>>
>> On 29.02.20 20:00, Jim Mattson wrote:
>>> On Sat, Feb 29, 2020 at 10:33 AM Oliver Upton <oupton@google.com> wrot=
e:
>>>>
>>>> Hi Jan,
>>>>
>>>> On Sat, Feb 29, 2020 at 10:00 AM Jan Kiszka <jan.kiszka@web.de> wrote=
:
>>>>> Is this expected to cause regressions on less common workloads?
>>>>> Jailhouse as L1 now fails when Linux as L2 tries to boot a CPU: L2-L=
inux
>>>>> gets a triple fault on load_current_idt() in start_secondary(). Only
>>>>> bisected so far, didn't debug further.
>>>>
>>>> I'm guessing that Jailhouse doesn't use 'descriptor table exiting', s=
o
>>>> when KVM gets the corresponding exit from L2 the emulation burden is
>>>> on L0. We now refuse the emulation, which kicks a #UD back to L2. I
>>>> can get a patch out quickly to address this case (like the PIO exitin=
g
>>>> one that came in this series) but the eventual solution is to map
>>>> emulator intercept checks into VM-exits + call into the
>>>> nested_vmx_exit_reflected() plumbing.
>>>
>>> If Jailhouse doesn't use descriptor table exiting, why is L0
>>> intercepting descriptor table instructions? Is this just so that L0
>>> can partially emulate UMIP on hardware that doesn't support it?
>>>
>>
>> That seems to be the case: My host lacks umip, L1 has it. So, KVM is
>> intercepting descriptor table load instructions to emulate umip.
>> Jailhouse never activates that interception.
>>
>> Jan
