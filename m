Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F226597E4F
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 08:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240330AbiHRGAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 02:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240278AbiHRGAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 02:00:11 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D11D7CAA7;
        Wed, 17 Aug 2022 23:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660802408; x=1692338408;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version:content-transfer-encoding;
  bh=0K95CIdwabnHvsYz7rM9st6e0p/vmx0aIBOyC+F0+UE=;
  b=FNnig1FRRpyfbS816eVJApGQC+HSP8zfZZyC66jcvc4CSv5N0DzfMixF
   0rW4z5d5jSpHwQwoRyjCWx3Vn1hKkvf3gAnP9wFSc3xBLvdNsrK720Jjj
   6Ru4/4PxsE94BIJ6kZP1HTOV9ifc2dK0UsOKcDPqWOKqNMaJCxqH+Itxe
   K2zmpMkdY/ryNE40y7Oj/BD5r+6iS3e12Tx3Xiex4vPa/Dw+5jI6I1rk9
   7hfADCnTVj9IBu0zE/QIuIvCd7Nd1UfNsuqwdaJAC0UuJI0KDKsLExocO
   VWW9AZQv5ebE9WXyyYRAGvrBcnfyqy51lqChDXwdBGHrfGaePCNJysHyJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="356665472"
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="356665472"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 23:00:04 -0700
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="584069199"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 22:59:58 -0700
From:   "Huang, Ying" <ying.huang@intel.com>
To:     Nadav Amit <nadav.amit@gmail.com>
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
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
References: <6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com>
        <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
        <Yvv/eGfi3LW8WxPZ@xz-m1.local> <871qtfvdlw.fsf@nvdebian.thelocal>
        <YvxWUY9eafFJ27ef@xz-m1.local> <87o7wjtn2g.fsf@nvdebian.thelocal>
        <87tu6bbaq7.fsf@yhuang6-desk2.ccr.corp.intel.com>
        <1D2FB37E-831B-445E-ADDC-C1D3FF0425C1@gmail.com>
Date:   Thu, 18 Aug 2022 13:59:49 +0800
In-Reply-To: <1D2FB37E-831B-445E-ADDC-C1D3FF0425C1@gmail.com> (Nadav Amit's
        message of "Wed, 17 Aug 2022 02:41:19 -0700")
Message-ID: <87ilmqay7e.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Nadav Amit <nadav.amit@gmail.com> writes:

> On Aug 17, 2022, at 12:17 AM, Huang, Ying <ying.huang@intel.com> wrote:
>
>> Alistair Popple <apopple@nvidia.com> writes:
>>=20
>>> Peter Xu <peterx@redhat.com> writes:
>>>=20
>>>> On Wed, Aug 17, 2022 at 11:49:03AM +1000, Alistair Popple wrote:
>>>>> Peter Xu <peterx@redhat.com> writes:
>>>>>=20
>>>>>> On Tue, Aug 16, 2022 at 04:10:29PM +0800, huang ying wrote:
>>>>>>>> @@ -193,11 +194,10 @@ static int migrate_vma_collect_pmd(pmd_t *pm=
dp,
>>>>>>>>                        bool anon_exclusive;
>>>>>>>>                        pte_t swp_pte;
>>>>>>>>=20
>>>>>>>> +                       flush_cache_page(vma, addr, pte_pfn(*ptep)=
);
>>>>>>>> +                       pte =3D ptep_clear_flush(vma, addr, ptep);
>>>>>>>=20
>>>>>>> Although I think it's possible to batch the TLB flushing just before
>>>>>>> unlocking PTL.  The current code looks correct.
>>>>>>=20
>>>>>> If we're with unconditionally ptep_clear_flush(), does it mean we sh=
ould
>>>>>> probably drop the "unmapped" and the last flush_tlb_range() already =
since
>>>>>> they'll be redundant?
>>>>>=20
>>>>> This patch does that, unless I missed something?
>>>>=20
>>>> Yes it does.  Somehow I didn't read into the real v2 patch, sorry!
>>>>=20
>>>>>> If that'll need to be dropped, it looks indeed better to still keep =
the
>>>>>> batch to me but just move it earlier (before unlock iiuc then it'll =
be
>>>>>> safe), then we can keep using ptep_get_and_clear() afaiu but keep "p=
te"
>>>>>> updated.
>>>>>=20
>>>>> I think we would also need to check should_defer_flush(). Looking at
>>>>> try_to_unmap_one() there is this comment:
>>>>>=20
>>>>> 			if (should_defer_flush(mm, flags) && !anon_exclusive) {
>>>>> 				/*
>>>>> 				 * We clear the PTE but do not flush so potentially
>>>>> 				 * a remote CPU could still be writing to the folio.
>>>>> 				 * If the entry was previously clean then the
>>>>> 				 * architecture must guarantee that a clear->dirty
>>>>> 				 * transition on a cached TLB entry is written through
>>>>> 				 * and traps if the PTE is unmapped.
>>>>> 				 */
>>>>>=20
>>>>> And as I understand it we'd need the same guarantee here. Given
>>>>> try_to_migrate_one() doesn't do batched TLB flushes either I'd rather
>>>>> keep the code as consistent as possible between
>>>>> migrate_vma_collect_pmd() and try_to_migrate_one(). I could look at
>>>>> introducing TLB flushing for both in some future patch series.
>>>>=20
>>>> should_defer_flush() is TTU-specific code?
>>>=20
>>> I'm not sure, but I think we need the same guarantee here as mentioned
>>> in the comment otherwise we wouldn't see a subsequent CPU write that
>>> could dirty the PTE after we have cleared it but before the TLB flush.
>>>=20
>>> My assumption was should_defer_flush() would ensure we have that
>>> guarantee from the architecture, but maybe there are alternate/better
>>> ways of enforcing that?
>>>> IIUC the caller sets TTU_BATCH_FLUSH showing that tlb can be omitted s=
ince
>>>> the caller will be responsible for doing it.  In migrate_vma_collect_p=
md()
>>>> iiuc we don't need that hint because it'll be flushed within the same
>>>> function but just only after the loop of modifying the ptes.  Also it'=
ll be
>>>> with the pgtable lock held.
>>>=20
>>> Right, but the pgtable lock doesn't protect against HW PTE changes such
>>> as setting the dirty bit so we need to ensure the HW does the right
>>> thing here and I don't know if all HW does.
>>=20
>> This sounds sensible.  But I take a look at zap_pte_range(), and find
>> that it appears that the implementation requires the PTE dirty bit to be
>> write-through.  Do I miss something?
>>=20
>> Hi, Nadav, Can you help?
>
> Sorry for joining the discussion late. I read most ofthis thread and I ho=
pe
> I understand what you ask me. So at the risk of rehashing or repeating wh=
at
> you already know - here are my 2 cents. Feel free to ask me again if I did
> not understand your questions:
>
> 1. ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH is currently x86 specific. There is a
> recent patch that want to use it for arm64 as well [1]. The assumption th=
at
> Alistair cited from the code (regarding should_defer_flush()) might not be
> applicable to certain architectures (although most likely it is). I tried
> to encapsulate the logic on whether an unflushed RO entry can become dirty
> in an arch specific function [2].
>
> 2. Having said all of that, using the logic of =E2=80=9Cflush if there ar=
e pending
> TLB flushes for this mm=E2=80=9D as done by UNMAP_TLB_FLUSH makes sense I=
MHO
> (although I would have considered doing it in finer granularity of
> VMA/page-table as I proposed before and got somewhat lukewarm response [3=
]).
>
> 3. There is no question that flushing after dropping the ptl is wrong. But
> reading the thread, I think that you only focus on whether a dirty
> indication might get lost. The problem, I think, is bigger, as it might a=
lso
> cause correction problems after concurrently removing mappings. What happ=
ens
> if we get for a clean PTE something like:
>
>   CPU0					CPU1
>   ----					----
>
>   migrate_vma_collect_pmd()
>   [ defer flush, release ptl ]
> 					madvise(MADV_DONTNEED)
> 					-> zap_pte_range()
> 					[ PTE not present; mmu_gather
> 					  not updated ]
>=20=09=09=09=09=09
> 					[ no flush; stale PTE in TLB ]
>
> 					[ page is still accessible ]
>
> [ might apply to munmap(); I usually regard MADV_DONTNEED since it does
>   not call mmap_write_lock() ]

Yes.  You are right.  Flushing after PTL unlocking can cause more
serious problems.

I also want to check whether the dirty bit can be lost in
zap_pte_range(), where the TLB flush will be delayed if the PTE is
clean.  Per my understanding, PTE dirty bit must be write-through to
make this work correctly.  And I cannot imagine how CPU can do except
page fault if

- PTE is non-present
- TLB entry is clean
- CPU writes the page

Then, can we assume PTE dirty bit are always write-through on any
architecture?

> 4. Having multiple TLB flushing infrastructures makes all of these
> discussions very complicated and unmaintainable. I need to convince myself
> in every occasion (including this one) whether calls to
> flush_tlb_batched_pending() and tlb_flush_pending() are needed or not.
>
> What I would like to have [3] is a single infrastructure that gets a
> =E2=80=9Cticket=E2=80=9D (generation when the batching started), the old =
PTE and the new PTE
> and checks whether a TLB flush is needed based on the arch behavior and t=
he
> current TLB generation. If needed, it would update the =E2=80=9Cticket=E2=
=80=9D to the new
> generation. Andy wanted a ring for pending TLB flushes, but I think it is=
 an
> overkill with more overhead and complexity than needed.
>
> But the current situation in which every TLB flush is a basis for long
> discussions and prone to bugs is impossible.
>
> I hope it helps. Let me know if you want me to revive the patch-set or ot=
her
> feedback.
>
> [1] https://lore.kernel.org/all/20220711034615.482895-5-21cnbao@gmail.com/
> [2] https://lore.kernel.org/all/20220718120212.3180-13-namit@vmware.com/
> [3] https://lore.kernel.org/all/20210131001132.3368247-16-namit@vmware.co=
m/

Haven't looked at this in depth yet.  Will do that.

Best Regards,
Huang, Ying
