Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E81D7AB1
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 18:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfJOQAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 12:00:43 -0400
Received: from foss.arm.com ([217.140.110.172]:41884 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfJOQAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 12:00:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CCD128;
        Tue, 15 Oct 2019 09:00:42 -0700 (PDT)
Received: from [10.37.12.83] (unknown [10.37.12.83])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 576CE3F68E;
        Tue, 15 Oct 2019 09:00:39 -0700 (PDT)
Subject: =?UTF-8?Q?Re=3a_=e2=9d=8c_FAIL=3a_Test_report_for_kernel_5=2e4=2e0-?=
 =?UTF-8?Q?rc2-d6c2c23=2ecki_=28stable-next=29?=
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        Jan Stancek <jstancek@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        LTP List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Szabolcs Nagy <szabolcs.nagy@arm.com>,
        Dave P Martin <Dave.Martin@arm.com>
References: <cki.B4A567748F.PFM8G4WKXI@redhat.com>
 <805988176.6044584.1571038139105.JavaMail.zimbra@redhat.com>
 <CAAeHK+zxFWvCOgTYrMuD-oHJAFMn5DVYmQ6-RvU8NrapSz01mQ@mail.gmail.com>
 <20191014162651.GF19200@arrakis.emea.arm.com>
 <20191014213332.mmq7narumxtkqumt@willie-the-truck>
 <20191015152651.GG13874@arrakis.emea.arm.com>
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Message-ID: <342a9218-d840-f56d-2349-a5cfaafb6e16@arm.com>
Date:   Tue, 15 Oct 2019 17:02:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015152651.GG13874@arrakis.emea.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Catalin,

On 10/15/19 4:26 PM, Catalin Marinas wrote:
> Adding Szabolcs and Dave from ARM as we've discussed this internally
> briefly but we should include the wider audience.
> 
> On Mon, Oct 14, 2019 at 10:33:32PM +0100, Will Deacon wrote:
>> On Mon, Oct 14, 2019 at 05:26:51PM +0100, Catalin Marinas wrote:
>>> On Mon, Oct 14, 2019 at 02:54:17PM +0200, Andrey Konovalov wrote:
>>>> On Mon, Oct 14, 2019 at 9:29 AM Jan Stancek <jstancek@redhat.com> wrote:
>>>>>> We ran automated tests on a recent commit from this kernel tree:
>>>>>>
>>>>>>        Kernel repo:
>>>>>>        git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux-stable.git
>>>>>>             Commit: d6c2c23a29f4 - Merge branch 'stable-next' of
>>>>>>             ssh://chubbybox:/home/sasha/data/next into stable-next
>>>>>>
>>>>>> The results of these automated tests are provided below.
>>>>>>
>>>>>>     Overall result: FAILED (see details below)
>>>>>>              Merge: OK
>>>>>>            Compile: OK
>>>>>>              Tests: FAILED
>>>>>>
>>>>>> All kernel binaries, config files, and logs are available for download here:
>>>>>>
>>>>>>   https://artifacts.cki-project.org/pipelines/223563
>>>>>>
>>>>>> One or more kernel tests failed:
>>>>>>
>>>>>>     aarch64:
>>>>>>       ❌ LTP: openposix test suite
>>>>>>
>>>>>
>>>>> Test [1] is passing value close to LONG_MAX, which on arm64 is now treated as tagged userspace ptr:
>>>>>   057d3389108e ("mm: untag user pointers passed to memory syscalls")
>>>>>
>>>>> And now seems to hit overflow check after sign extension (EINVAL).
>>>>> Test should probably find different way to choose invalid pointer.
>>>>>
>>>>> [1] https://github.com/linux-test-project/ltp/blob/master/testcases/open_posix_testsuite/conformance/interfaces/mlock/8-1.c
>>>>

[...]

>>> The options I see:
>>>
>>> 1. Revert commit 057d3389108e and try again to document that the memory
>>>    syscalls do not support tagged pointers
>>>
>>> 2. Change untagged_addr() to only 0-extend from bit 55 or leave the
>>>    tag unchanged if bit 55 is 1. We could mask out the tag (0 rather
>>>    than sign-extend) but if we had an mlock test passing ULONG_MASK,
>>>    then we get -ENOMEM instead of -EINVAL
>>>
>>> 3. Make untagged_addr() depend on the TIF_TAGGED_ADDR bit and we only
>>>    break the ABI for applications opting in to this new ABI. We did look
>>>    at this but the ptrace(PEEK/POKE_DATA) needs a bit more thinking on
>>>    whether we check the ptrace'd process or the debugger flags
>>>
>>> 4. Leave things as they are, consider the address space 56-bit and
>>>    change the test to not use LONG_MAX on arm64. This needs to be passed
>>>    by the sparc guys since they probably have a similar issue
>>
>> I'm in favour of (2) or (4) as long as there's also an update to the docs.
> 
> With (4) we'd start differing from other architectures supported by
> Linux. This works if we consider the test to be broken. However, reading
> the mlock man page:
> 
>        EINVAL The result of the addition addr+len was less than addr
>        (e.g., the addition may have resulted in an overflow).
> 
>        ENOMEM Some of the specified address range does not correspond to
>        mapped pages in the address space of the process.
> 
> There is no mention of EINVAL outside the TASK_SIZE, seems to fall more
> within the ENOMEM description above.
>

I agree with your analysis and vote for option (2) as well, because of what you
reported about mlock() error meanings and because being this ABI I would prefer
where possible to not diverge from other architectures.
 [...]

-- 
Regards,
Vincenzo
