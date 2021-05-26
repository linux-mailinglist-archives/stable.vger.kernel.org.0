Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248AB39176C
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 14:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhEZMhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 08:37:18 -0400
Received: from foss.arm.com ([217.140.110.172]:43918 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233221AbhEZMhR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 08:37:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2C7D1516;
        Wed, 26 May 2021 05:35:45 -0700 (PDT)
Received: from [10.163.81.152] (unknown [10.163.81.152])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 429983F73B;
        Wed, 26 May 2021 05:35:43 -0700 (PDT)
Subject: Re: [PATCH 1/1] mm/debug_vm_pgtable: fix alignment for
 pmd/pud_advanced_tests()
To:     Anatoly Pugachev <matorola@gmail.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-sparc <sparclinux@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, stable@vger.kernel.org
References: <20210525130043.186290-1-gerald.schaefer@linux.ibm.com>
 <20210525130043.186290-2-gerald.schaefer@linux.ibm.com>
 <CADxRZqxdPodO8y+u=R4HB_727pjmXZFt8M5PPhg_qSsT1S-saQ@mail.gmail.com>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <3aadc76c-3a8c-d5d6-5ad2-e83c09f08213@arm.com>
Date:   Wed, 26 May 2021 18:06:25 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CADxRZqxdPodO8y+u=R4HB_727pjmXZFt8M5PPhg_qSsT1S-saQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/26/21 4:57 PM, Anatoly Pugachev wrote:
> On Tue, May 25, 2021 at 4:03 PM Gerald Schaefer
> <gerald.schaefer@linux.ibm.com> wrote:
>>
>> In pmd/pud_advanced_tests(), the vaddr is aligned up to the next pmd/pud
>> entry, and so it does not match the given pmdp/pudp and (aligned down) pfn
>> any more.
>>
>> For s390, this results in memory corruption, because the IDTE instruction
>> used e.g. in xxx_get_and_clear() will take the vaddr for some calculations,
>> in combination with the given pmdp. It will then end up with a wrong table
>> origin, ending on ...ff8, and some of those wrongly set low-order bits will
>> also select a wrong pagetable level for the index addition. IDTE could
>> therefore invalidate (or 0x20) something outside of the page tables,
>> depending on the wrongly picked index, which in turn depends on the random
>> vaddr.
>>
>> As result, we sometimes see "BUG task_struct (Not tainted): Padding
>> overwritten" on s390, where one 0x5a padding value got overwritten with
>> 0x7a.
>>
>> Fix this by aligning down, similar to how the pmd/pud_aligned pfns are
>> calculated.
>>
>> Fixes: a5c3b9ffb0f40 ("mm/debug_vm_pgtable: add tests validating advanced arch page table helpers")
>> Cc: <stable@vger.kernel.org> # v5.9+
>> Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> 
> boot tested on sparc64 with quick run of stress-ng ( --class memory
> --sequential -1 --timeout 10s -v --pathological --oomable
> --metrics-brief )
> stress-ng: debug: [371408] system: Linux ttip
> 5.13.0-rc3-00043-gad9f25d33860-dirty #218 SMP Wed May 26 11:55:54 MSK
> 2021 sparc64
> 
> Tested-by: Anatoly Pugachev <matorola@gmail.com>
> 

spac64 does not enable ARCH_HAS_DEBUG_VM_PGTABLE, did you enable it
before running the test ? Did the entire test debug_vm_pgtable() run
successfully on sparc64 ?
