Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C50596C39
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 11:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiHQJl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 05:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiHQJl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 05:41:26 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8882D78BE6;
        Wed, 17 Aug 2022 02:41:23 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 24so11533447pgr.7;
        Wed, 17 Aug 2022 02:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc;
        bh=8wFsy8/iq1mV1VmQqVVpVmjFvPaMVz+u/8oZtkeEhNY=;
        b=maJYnfWJosyTTf82+6p9ysiroNH9d0hwZiyl+CCMs/SB3wHFOsiCEM59gDyMBWQ/PP
         uB/5yY33zGwkZ6PZgNkMFcQ+U5jhDLZbEveoMOTRPeD9YkenVTgIeCQZz7kUIdD9pVY4
         ZIBIGw+dXnmB+Ooy9hZvM0cFXmi49GtuE9C7J8x308Ppcn1fazS/qAI7C91Arp9fociA
         j3kvPpd85TrUtWPGS8khMb6P7opEEobomxOnz/HypmnlU2KfManQf5e2UX3j12Lo7IDf
         wB/LV4NSnCbIscyQWUNWMAP/Q1hyy5bFIjYgNEJXgvV0wD4PSf/4dYdt4qHmak+iYtrV
         sP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc;
        bh=8wFsy8/iq1mV1VmQqVVpVmjFvPaMVz+u/8oZtkeEhNY=;
        b=X0hpZR46FUuCnCQhFtAsHSUs7rOabUX9j5AiO8O4IkeLw1A/4nz9/vrgXdSHYqBX1Y
         NtXex2YXR+kYN8VUY8fSRsnap9ft75fNU+pc2gAtZFLooGvpoP5AeBffnb49W+oCFSGN
         MqEoVVFshqYLDyuZab3DItRXRPNG07dG9w53gfYoNDXwPpqxg058b4FDX7SUW8Nj+32B
         zMbZRGflCE8cGoE9yqv5r3zf2E9wl1o3IAcQUJd31tEMN+MDVrn9BSU2Wf1aFJei4YXT
         vWNe0Z5RtFoq74xKknwjje2lQAzOfI5lcCRj3zRhGDHIg7v1afZfQNpsPTXZj1pkniiB
         U4jQ==
X-Gm-Message-State: ACgBeo2qUjvHXhGBc42AYxiNHK6xw96Q9FOWQ5tCc9rsxjQAddWCeQis
        fNTRp0cNU3Rzo6MPdV1USVE=
X-Google-Smtp-Source: AA6agR4fQe0JMAMZT9E6T+BOdyywOXefDPIuSNMqKMCTzfgoN6Gv3+3INclu6TwqgICD+J0uWGhJgg==
X-Received: by 2002:aa7:88d3:0:b0:52e:ade6:6192 with SMTP id k19-20020aa788d3000000b0052eade66192mr24904496pff.41.1660729282369;
        Wed, 17 Aug 2022 02:41:22 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id u1-20020a1709026e0100b0016d62ba5665sm963653plk.254.2022.08.17.02.41.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Aug 2022 02:41:21 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <87tu6bbaq7.fsf@yhuang6-desk2.ccr.corp.intel.com>
Date:   Wed, 17 Aug 2022 02:41:19 -0700
Cc:     Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1D2FB37E-831B-445E-ADDC-C1D3FF0425C1@gmail.com>
References: <6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com>
 <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
 <Yvv/eGfi3LW8WxPZ@xz-m1.local> <871qtfvdlw.fsf@nvdebian.thelocal>
 <YvxWUY9eafFJ27ef@xz-m1.local> <87o7wjtn2g.fsf@nvdebian.thelocal>
 <87tu6bbaq7.fsf@yhuang6-desk2.ccr.corp.intel.com>
To:     "Huang, Ying" <ying.huang@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Aug 17, 2022, at 12:17 AM, Huang, Ying <ying.huang@intel.com> wrote:

> Alistair Popple <apopple@nvidia.com> writes:
>=20
>> Peter Xu <peterx@redhat.com> writes:
>>=20
>>> On Wed, Aug 17, 2022 at 11:49:03AM +1000, Alistair Popple wrote:
>>>> Peter Xu <peterx@redhat.com> writes:
>>>>=20
>>>>> On Tue, Aug 16, 2022 at 04:10:29PM +0800, huang ying wrote:
>>>>>>> @@ -193,11 +194,10 @@ static int migrate_vma_collect_pmd(pmd_t =
*pmdp,
>>>>>>>                        bool anon_exclusive;
>>>>>>>                        pte_t swp_pte;
>>>>>>>=20
>>>>>>> +                       flush_cache_page(vma, addr, =
pte_pfn(*ptep));
>>>>>>> +                       pte =3D ptep_clear_flush(vma, addr, =
ptep);
>>>>>>=20
>>>>>> Although I think it's possible to batch the TLB flushing just =
before
>>>>>> unlocking PTL.  The current code looks correct.
>>>>>=20
>>>>> If we're with unconditionally ptep_clear_flush(), does it mean we =
should
>>>>> probably drop the "unmapped" and the last flush_tlb_range() =
already since
>>>>> they'll be redundant?
>>>>=20
>>>> This patch does that, unless I missed something?
>>>=20
>>> Yes it does.  Somehow I didn't read into the real v2 patch, sorry!
>>>=20
>>>>> If that'll need to be dropped, it looks indeed better to still =
keep the
>>>>> batch to me but just move it earlier (before unlock iiuc then =
it'll be
>>>>> safe), then we can keep using ptep_get_and_clear() afaiu but keep =
"pte"
>>>>> updated.
>>>>=20
>>>> I think we would also need to check should_defer_flush(). Looking =
at
>>>> try_to_unmap_one() there is this comment:
>>>>=20
>>>> 			if (should_defer_flush(mm, flags) && =
!anon_exclusive) {
>>>> 				/*
>>>> 				 * We clear the PTE but do not flush so =
potentially
>>>> 				 * a remote CPU could still be writing =
to the folio.
>>>> 				 * If the entry was previously clean =
then the
>>>> 				 * architecture must guarantee that a =
clear->dirty
>>>> 				 * transition on a cached TLB entry is =
written through
>>>> 				 * and traps if the PTE is unmapped.
>>>> 				 */
>>>>=20
>>>> And as I understand it we'd need the same guarantee here. Given
>>>> try_to_migrate_one() doesn't do batched TLB flushes either I'd =
rather
>>>> keep the code as consistent as possible between
>>>> migrate_vma_collect_pmd() and try_to_migrate_one(). I could look at
>>>> introducing TLB flushing for both in some future patch series.
>>>=20
>>> should_defer_flush() is TTU-specific code?
>>=20
>> I'm not sure, but I think we need the same guarantee here as =
mentioned
>> in the comment otherwise we wouldn't see a subsequent CPU write that
>> could dirty the PTE after we have cleared it but before the TLB =
flush.
>>=20
>> My assumption was should_defer_flush() would ensure we have that
>> guarantee from the architecture, but maybe there are alternate/better
>> ways of enforcing that?
>>> IIUC the caller sets TTU_BATCH_FLUSH showing that tlb can be omitted =
since
>>> the caller will be responsible for doing it.  In =
migrate_vma_collect_pmd()
>>> iiuc we don't need that hint because it'll be flushed within the =
same
>>> function but just only after the loop of modifying the ptes.  Also =
it'll be
>>> with the pgtable lock held.
>>=20
>> Right, but the pgtable lock doesn't protect against HW PTE changes =
such
>> as setting the dirty bit so we need to ensure the HW does the right
>> thing here and I don't know if all HW does.
>=20
> This sounds sensible.  But I take a look at zap_pte_range(), and find
> that it appears that the implementation requires the PTE dirty bit to =
be
> write-through.  Do I miss something?
>=20
> Hi, Nadav, Can you help?

Sorry for joining the discussion late. I read most ofthis thread and I =
hope
I understand what you ask me. So at the risk of rehashing or repeating =
what
you already know - here are my 2 cents. Feel free to ask me again if I =
did
not understand your questions:

1. ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH is currently x86 specific. There is =
a
recent patch that want to use it for arm64 as well [1]. The assumption =
that
Alistair cited from the code (regarding should_defer_flush()) might not =
be
applicable to certain architectures (although most likely it is). I =
tried
to encapsulate the logic on whether an unflushed RO entry can become =
dirty
in an arch specific function [2].

2. Having said all of that, using the logic of =E2=80=9Cflush if there =
are pending
TLB flushes for this mm=E2=80=9D as done by UNMAP_TLB_FLUSH makes sense =
IMHO
(although I would have considered doing it in finer granularity of
VMA/page-table as I proposed before and got somewhat lukewarm response =
[3]).

3. There is no question that flushing after dropping the ptl is wrong. =
But
reading the thread, I think that you only focus on whether a dirty
indication might get lost. The problem, I think, is bigger, as it might =
also
cause correction problems after concurrently removing mappings. What =
happens
if we get for a clean PTE something like:

  CPU0					CPU1
  ----					----

  migrate_vma_collect_pmd()
  [ defer flush, release ptl ]
					madvise(MADV_DONTNEED)
					-> zap_pte_range()
					[ PTE not present; mmu_gather
					  not updated ]
				=09
					[ no flush; stale PTE in TLB ]

					[ page is still accessible ]

[ might apply to munmap(); I usually regard MADV_DONTNEED since it does
  not call mmap_write_lock() ]

4. Having multiple TLB flushing infrastructures makes all of these
discussions very complicated and unmaintainable. I need to convince =
myself
in every occasion (including this one) whether calls to
flush_tlb_batched_pending() and tlb_flush_pending() are needed or not.

What I would like to have [3] is a single infrastructure that gets a
=E2=80=9Cticket=E2=80=9D (generation when the batching started), the old =
PTE and the new PTE
and checks whether a TLB flush is needed based on the arch behavior and =
the
current TLB generation. If needed, it would update the =E2=80=9Cticket=E2=80=
=9D to the new
generation. Andy wanted a ring for pending TLB flushes, but I think it =
is an
overkill with more overhead and complexity than needed.

But the current situation in which every TLB flush is a basis for long
discussions and prone to bugs is impossible.

I hope it helps. Let me know if you want me to revive the patch-set or =
other
feedback.

[1] =
https://lore.kernel.org/all/20220711034615.482895-5-21cnbao@gmail.com/
[2] https://lore.kernel.org/all/20220718120212.3180-13-namit@vmware.com/
[3] =
https://lore.kernel.org/all/20210131001132.3368247-16-namit@vmware.com/

