Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE54120ED3
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 17:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfLPQIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 11:08:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60509 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725836AbfLPQIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 11:08:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576512518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yIpix4UPxBSh2MT6UEhohtiVputl6QStexIF4LGjRs4=;
        b=e7E7wDEmHt2NBORweIqJWxp7RTDI6qDa9ZT57tGMXVBzgClc9jl8S/KT37U6LS89d22XOl
        dsIgJ/DBTFHH9uOtqy5BiBTAaSivAsFFvPtwwGNQDTnaFl+ZUsEmfCObGwCuLT0iHB7xBr
        MolWmHOrjdiEZMeqXwtDhrdBabqo6tA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-7kEg1ncEP4GMpaNtCE07Ow-1; Mon, 16 Dec 2019 11:08:36 -0500
X-MC-Unique: 7kEg1ncEP4GMpaNtCE07Ow-1
Received: by mail-wm1-f72.google.com with SMTP id s25so1215950wmj.3
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 08:08:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yIpix4UPxBSh2MT6UEhohtiVputl6QStexIF4LGjRs4=;
        b=mNURSywDen3djJ7udWIoVon7W1fhVe6wGu+aGCIfgYgCfIwSNnM1LWtrQcxfLR4+P4
         50RP99kKvWKRLJs27JMd10zlRK3d5If810sCl944wfkxE4tprEgmWG1njMDUeeF/mDru
         siUIInTatBLquIEXI4UQn7livelg2s+44ijrkqARnMLg9Y4mEWbqvH7cM+sNOelBEcGl
         m43yrjgHh/mfzpflhFqqsQrRHAMoTNlRqPZAzeMlgGjDvgUg56ijqjEO62Hmv3ZaPdZX
         KqKYBRnxo7BJtbs35nmXuKRq509j0EF3rPUwrtTFJK4U5ajmRFSKYdyuRsnkJUmrVmuV
         5Wsw==
X-Gm-Message-State: APjAAAUC3bnLz963EGtXscDFDOndiHbgi+4vWhOwvKKtqtWw0MWZbSGK
        gjXiFSRLoPM8OWZhWU6/QII3nKAOe1U2r24IizyluyukaXcHdssu/JddzcKooNo7/myufLIOv4n
        bbzHG2t20mdqo/hEp
X-Received: by 2002:a1c:7c18:: with SMTP id x24mr31499808wmc.21.1576512515599;
        Mon, 16 Dec 2019 08:08:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqwDcQ7lKF+oayQgC++uUUuXpbNGgRnUniNAizGb6g1+QNaoRZFDljRrO1NXUlKqtodM3COvQA==
X-Received: by 2002:a1c:7c18:: with SMTP id x24mr31499763wmc.21.1576512515346;
        Mon, 16 Dec 2019 08:08:35 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g2sm21949089wrw.76.2019.12.16.08.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 08:08:34 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vlastimil Babka <vbabka@suse.cz>, Ajay Kaher <akaher@vmware.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        punit.agrawal@arm.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, willy@infradead.org,
        will.deacon@arm.com, mszeredi@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, srinidhir@vmware.com,
        bvikas@vmware.com, anishs@vmware.com, vsirnapalli@vmware.com,
        srostedt@vmware.com, Oscar Salvador <osalvador@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v3 8/8] x86, mm, gup: prevent get_page() race with munmap in paravirt guest
In-Reply-To: <1aacc7ac-87b0-e22e-a265-ea175506844d@suse.cz>
References: <1576529149-14269-1-git-send-email-akaher@vmware.com> <1576529149-14269-9-git-send-email-akaher@vmware.com> <20191216130443.GN2844@hirez.programming.kicks-ass.net> <87lfrc9z3v.fsf@vitty.brq.redhat.com> <20191216134725.GE2827@hirez.programming.kicks-ass.net> <1aacc7ac-87b0-e22e-a265-ea175506844d@suse.cz>
Date:   Mon, 16 Dec 2019 17:08:32 +0100
Message-ID: <87immg9rsv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vlastimil Babka <vbabka@suse.cz> writes:

> On 12/16/19 2:47 PM, Peter Zijlstra wrote:
>> On Mon, Dec 16, 2019 at 02:30:44PM +0100, Vitaly Kuznetsov wrote:
>>> Peter Zijlstra <peterz@infradead.org> writes:
>>>
>>>> On Tue, Dec 17, 2019 at 02:15:48AM +0530, Ajay Kaher wrote:
>>>>> From: Vlastimil Babka <vbabka@suse.cz>
>>>>>
>>>>> The x86 version of get_user_pages_fast() relies on disabled interrupts to
>>>>> synchronize gup_pte_range() between gup_get_pte(ptep); and get_page() against
>>>>> a parallel munmap. The munmap side nulls the pte, then flushes TLBs, then
>>>>> releases the page. As TLB flush is done synchronously via IPI disabling
>>>>> interrupts blocks the page release, and get_page(), which assumes existing
>>>>> reference on page, is thus safe.
>>>>> However when TLB flush is done by a hypercall, e.g. in a Xen PV guest, there is
>>>>> no blocking thanks to disabled interrupts, and get_page() can succeed on a page
>>>>> that was already freed or even reused.
>>>>>
>>>>> We have recently seen this happen with our 4.4 and 4.12 based kernels, with
>>>>> userspace (java) that exits a thread, where mm_release() performs a futex_wake()
>>>>> on tsk->clear_child_tid, and another thread in parallel unmaps the page where
>>>>> tsk->clear_child_tid points to. The spurious get_page() succeeds, but futex code
>>>>> immediately releases the page again, while it's already on a freelist. Symptoms
>>>>> include a bad page state warning, general protection faults acessing a poisoned
>>>>> list prev/next pointer in the freelist, or free page pcplists of two cpus joined
>>>>> together in a single list. Oscar has also reproduced this scenario, with a
>>>>> patch inserting delays before the get_page() to make the race window larger.
>>>>>
>>>>> Fix this by removing the dependency on TLB flush interrupts the same way as the
>>>>
>>>> This is suppsed to be fixed by:
>>>>
>>>> arch/x86/Kconfig:       select HAVE_RCU_TABLE_FREE              if PARAVIRT
>>>>
>>>
>>> Yes,
>
> Well, that commit fixes the "page table can be freed under us" part. But
> this patch is about the "get_page() will succeed on a page that's being
> freed" part. Upstream fixed that unknowingly in 4.13 by a gup.c
> refactoring that would be too risky to backport fully.
>

(I also dislike receiving only this patch of the series, next time
please send the whole thing, it's only 8 patches, our mailfolders will
survive that)

When I was adding Hyper-V PV TLB flush to RHEL7 - which is 3.10 based -
in addition to adding page_cache_get_speculative() to
gup_get_pte()/gup_huge_pmd()/gup_huge_pud() I also had to synchronize
huge PMD split against gup_fast with the following hack:

+static void do_nothing(void *unused)
+{
+
+}
+
+static void serialize_against_pte_lookup(struct mm_struct *mm)
+{
+       smp_mb();
+       smp_call_function_many(mm_cpumask(mm), do_nothing, NULL, 1);
+}
+
 void pmdp_splitting_flush(struct vm_area_struct *vma,
                          unsigned long address, pmd_t *pmdp)
 {
@@ -434,9 +473,10 @@ void pmdp_splitting_flush(struct vm_area_struct *vma,
        set = !test_and_set_bit(_PAGE_BIT_SPLITTING,
                                (unsigned long *)pmdp);
        if (set) {
                /* need tlb flush only to serialize against gup-fast */
                flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+               if (pv_mmu_ops.flush_tlb_others != native_flush_tlb_others)
+                       serialize_against_pte_lookup(vma->vm_mm);
        }
 }

I'm not sure which stable kernel you're targeting (and if you addressed this
with other patches in the series, if this is needed,...) so JFYI.

-- 
Vitaly

