Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E821640B7C
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 17:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbiLBQ7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 11:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbiLBQ7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 11:59:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8C4E1756
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 08:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670000192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b4eKbFg7g83Utc9laDTG1bfOmc5hP5ybhCQkldsbAH0=;
        b=bCw0BQeD60rFD7Nz14BJotNzPVhgMSmRzInIbVMPUf2BG5pnnO+zj31OAYvv104Ar9Dkm4
        bnkgVHqJzodWVrZWVcomz5pkJaIIIyV4N/4wRTVMeJIXuO1ED+cmP4bsERKLLGLbzHyY5e
        N9zkw6keyanH4iB2cnIKpMBkSLCrqHQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-599-iegX97wDON2uPk8l7rHwAA-1; Fri, 02 Dec 2022 11:56:27 -0500
X-MC-Unique: iegX97wDON2uPk8l7rHwAA-1
Received: by mail-wr1-f70.google.com with SMTP id m24-20020adfa3d8000000b00242168ce9d1so1223608wrb.15
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 08:56:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b4eKbFg7g83Utc9laDTG1bfOmc5hP5ybhCQkldsbAH0=;
        b=O7qeG6c2X6q2298ELdT8iI+V7KsMmjs4gn5LF5qiwSMC4qX49s68Z17AtDguUIUMxp
         9NAgctkR5rPoFM1l3IVLpHDwp0zfaHxBAv73uz7YMLtQ/voTLZ5VmfQrGL5NP4YwRTIE
         GcZM94I+KYNdwSix9okFYVjZ3WZjLidJizfi0NJExOU160YKglJuzeonPI4I6lWDOrdW
         iaHz2ardZGUR99/CFYk8OOQ5xpjscIGVyPULmijrt2v1JN804SXr7r9Uv1WRboPsJKEZ
         OhpcHq1kI5Op34bsOlGdQszKODitY0jmWdTqhgL41GQADx7UddvHHSMDmbIJqjV2AfeN
         uwNA==
X-Gm-Message-State: ANoB5pkp17zTlzt1kSb/M4MkndxM2XNng8lvdk5AEB+vXxBIF1Xgb4Lf
        rFjQovKsoRxtHU8SCf0NwMO2IpkKfXGjfVzmXYV/fv1+rIdSwEh+XjiEFob+xDtx2xhx2lF1+KO
        7PNx21WpaC5tHpuBI
X-Received: by 2002:adf:a117:0:b0:242:d27:c359 with SMTP id o23-20020adfa117000000b002420d27c359mr18435637wro.152.1670000185305;
        Fri, 02 Dec 2022 08:56:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7K8uiiQgOvY60dYoLLbXPrh/iZzkx1xZ9Vi6Ebb/jodwg3ulKWAaHj6tRrBwlKdxWfBo7N6g==
X-Received: by 2002:adf:a117:0:b0:242:d27:c359 with SMTP id o23-20020adfa117000000b002420d27c359mr18435628wro.152.1670000184965;
        Fri, 02 Dec 2022 08:56:24 -0800 (PST)
Received: from ?IPV6:2003:cb:c703:7a00:852e:72cd:ed76:d72f? (p200300cbc7037a00852e72cded76d72f.dip0.t-ipconnect.de. [2003:cb:c703:7a00:852e:72cd:ed76:d72f])
        by smtp.gmail.com with ESMTPSA id u17-20020a05600c19d100b003c6f8d30e40sm14189295wmq.31.2022.12.02.08.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 08:56:24 -0800 (PST)
Message-ID: <690afe0f-c9a0-9631-b365-d11d98fdf56f@redhat.com>
Date:   Fri, 2 Dec 2022 17:56:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ives van Hoorne <ives@codesandbox.io>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>,
        Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20221202122748.113774-1-david@redhat.com> <Y4oo6cN1a4Yz5prh@x1n>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH RFC] mm/userfaultfd: enable writenotify while
 userfaultfd-wp is enabled for a VMA
In-Reply-To: <Y4oo6cN1a4Yz5prh@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02.12.22 17:33, Peter Xu wrote:
> On Fri, Dec 02, 2022 at 01:27:48PM +0100, David Hildenbrand wrote:
>> Currently, we don't enable writenotify when enabling userfaultfd-wp on
>> a shared writable mapping (for now we only support SHMEM). The consequence
> 
> and hugetlbfs
> 
>> is that vma->vm_page_prot will still include write permissions, to be set
>> as default for all PTEs that get remapped (e.g., mprotect(), NUMA hinting,
>> page migration, ...).
> 
> The thing is by default I think we want the write bit..
> 
> The simple example is (1) register UFFD_WP on shmem writable, (2) write a
> page.  Here we didn't wr-protect anything, so we want the write bit there.
> 
> Or the other example is when UFFDIO_COPY with flags==0 even if with
> VM_UFFD_WP.  We definitely wants the write bit.
> 
> We only doesn't want the write bit when uffd-wp is explicitly set.
> 
> I think fundamentally the core is uffd-wp is pte-based, so the information
> resides in pte not vma.  I'm not strongly objecting this patch, especially
> you mentioned auto-numa so I need to have a closer look later there.
> However I do think uffd-wp is slightly special because we always need to
> consider pte information anyway, so a per-vma information doesn't hugely
> help, IMHO.

That's the same as softdirty tracking, IMHO.

[...]

>> Running the mprotect() reproducer [1] without this commit:
>>    $ ./uffd-wp-mprotect
>>    FAIL: uffd-wp did not fire
>> Running the mprotect() reproducer with this commit:
>>    $ ./uffd-wp-mprotect
>>    PASS: uffd-wp fired
>>
>> [1] https://lore.kernel.org/all/222fc0b2-6ec0-98e7-833f-ea868b248446@redhat.com/T/#u
> 
> I still hope for a formal patch (non-rfc) we can have a reproducer outside
> mprotect().  IMHO mprotect() is really ambiguously here being used with
> uffd-wp, so not a good example IMO as I explained in the other thread [1].

I took the low hanging fruit to showcase that this is a more generic problem.
The reproducer is IMHO nice because it's simple and race-free.

> 
> I'll need to off-work most of the rest of today, but maybe I can also have
> a look in the weekend or Monday more on the numa paths.  Before that, can
> we first reach a consensus that we have the mm/migrate patch there to be
> merged first?  These are two issues, IMHO.
> 
> I know you're against me for some reason, but until now I sincerely don't
> know why.  That patch sololy recovers write bit status (by removing it for
> read-only) for a migration entry and that definitely makes sense to me.  As
> I also mentioned in the old version of that thread, we can rework migration
> entries and merge READ|WRITE entries into a GENERIC entry one day if you
> think proper, but that's for later.

I'm not against you. I'm against changing well-working, common code
when it doesn't make any sense to me to change it. And now we have proof that
mprotect() just behaves exactly the same way, using the basic rules of vma->vm_page_prot.

Yes, there is broken sparc64 (below), but that shouldn't dictate our implementation.


What *would* make sense to me, as I raised, is:

diff --git a/mm/migrate.c b/mm/migrate.c
index dff333593a8a..9fc181fd3c5a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -213,8 +213,10 @@ static bool remove_migration_pte(struct folio *folio,
                         pte = pte_mkdirty(pte);
                 if (is_writable_migration_entry(entry))
                         pte = maybe_mkwrite(pte, vma);
-               else if (pte_swp_uffd_wp(*pvmw.pte))
+               else if (pte_swp_uffd_wp(*pvmw.pte)) {
                         pte = pte_mkuffd_wp(pte);
+                       pt = pte_wrprotect(pte);
+               }
  
                 if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
                         rmap_flags |= RMAP_EXCLUSIVE;


It still requires patch each and every possible code location, which I dislike as
described in the patch description. The fact that there are still uffd-wp bugs
with your patch makes that hopefully clear. I'd be interested if they can be
reproduced witht his patch.


> 
> Let me provide another example why I think recovering write bit may matter
> outside uffd too so it's common and it's always good to explicit check it.
> 
> If you still remember for sparc64 (I think you're also in the loop)
> pte_mkdirty will also apply write bit there; even though I don't know why
> but it works like that for years.  Consider below sequence:

Yes, and I consider that having to be fixed properly on in sparc64 code.
pte_mkdirty() must not allow write access. That's why we have pte_mkwrite()
after all. It's just plain wrong and requires custom hacks all over the place.

As raised, the whole maybe_mkwrite() logic is completely broken on sparc64.

> 
>    - map a page writable, write to page (fault in, set dirty)
>    - mprotect(RO) on the page (keep dirty bit, vma/pte becomes RO)
>    - migrate the page
>      - mk_pte returns with WRITE bit cleared (which is correct)
>      - pte_mkdirty set dirty and write bit (because dirty used to set)
> 
> If without the previous mm/migrate patch [1] IIUC it'll allow the pte
> writable even without VM_WRITE here after migration.

That would be my reaction:

diff --git a/mm/migrate.c b/mm/migrate.c
index dff333593a8a..05183cd22f0f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -209,12 +209,20 @@ static bool remove_migration_pte(struct folio *folio,
                 entry = pte_to_swp_entry(*pvmw.pte);
                 if (!is_migration_entry_young(entry))
                         pte = pte_mkold(pte);
+               /*
+                * HACK alert. sparc64 really has to fix it's pte_mkwrite()
+                * implementation to not allow random write access.
+                */
+#ifndef CONFIG_SPARC64
                 if (folio_test_dirty(folio) && is_migration_entry_dirty(entry))
                         pte = pte_mkdirty(pte);
+#endif


> 
> I'm not sure whether I missed something, nor can I write a reproducer
> because I don't have sparc64 systems on hand, not to mention time.  But
> hopefully I explained why I think it's safer to just always double check on
> the write bit to be the same as when before migration, irrelevant of
> uffd-wp, vma pgprot or mk_pte().
> 
> For this patch itself, I'll rethink again when I read more on numa.

Most probably we'll have to agree to disagree.

-- 
Thanks,

David / dhildenb

