Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5611A2E0152
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 20:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgLUTza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 14:55:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23878 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726025AbgLUTza (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 14:55:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608580443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zU38n9umUo1jYRE3cwoN9aCysH5tPAi2O3MLmmeDuyM=;
        b=AndW9m30jvE45JldbMVluUebmmc9w1KUT83OSTApCpyi3N+Ka4ISibveUuFLSiB4VXgVso
        shyGbDm/nSc0GF1GTpfYjY65KdQkC7gMb9ZuOTuLIsGPamG2HE+UF8cF+Khykv0EntsiY2
        yCGGmkqTbDIqnQiM5OgkDJWbd9eHlRs=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-i0cflK4YPkaCqkR7oHa-bA-1; Mon, 21 Dec 2020 14:54:00 -0500
X-MC-Unique: i0cflK4YPkaCqkR7oHa-bA-1
Received: by mail-qt1-f199.google.com with SMTP id v9so8589462qtw.12
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 11:54:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zU38n9umUo1jYRE3cwoN9aCysH5tPAi2O3MLmmeDuyM=;
        b=duYvawdnIBbDVRgRZXjoyNGTWoLBjKPnWRu0+yJ8lcAmLZivGsFDhlLiswWkFXvUYs
         N3F+TDBhno6jzPW627U5Z4v9baGWBHdcWcIK0pPtVrD2HZVnjjBRe7K/hg0DOVDyz3EG
         efHn+r++7cfiE4aqKD7ydc4JxEJXysdWCMAPEMGyVm8Zrn1L/K0u4hXhRalf9Vir63oo
         CC5G5nAw2IausfCCFzXkfwv0kCUQp3ut5vLpjfRMUnVLgPyEA0xqHA7g0W9NcHecOVkX
         GLSRvGUTzcikINNBlqEkGCX9KK05fiVZonyObLHfF2Mk7o1vPdiv+3T4bmxQ7lo/D6G4
         ALDw==
X-Gm-Message-State: AOAM533ik34w25QnnEMSTNz01uqN2hk/qFnipVms56065TqeZgvVspg8
        qC/BNA1BKlCW0+8ZvQQXXx6GdLUXFHhDEMJ6OzV31MSFY7cAMbQbJSNrO954SMSlTOPHzPt21EJ
        TkVW95fsm3+7HOsGb
X-Received: by 2002:a05:6214:13a3:: with SMTP id h3mr18853337qvz.5.1608580440173;
        Mon, 21 Dec 2020 11:54:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZUFJ0EpSQHCnxqLVRZJf/1yoKx4zvQDrvPQ1qmp6MpiTzd+fKsVYX8djRGDxm9PLeaE8t5g==
X-Received: by 2002:a05:6214:13a3:: with SMTP id h3mr18853313qvz.5.1608580439943;
        Mon, 21 Dec 2020 11:53:59 -0800 (PST)
Received: from xz-x1 ([142.126.83.202])
        by smtp.gmail.com with ESMTPSA id w33sm10147410qth.34.2020.12.21.11.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 11:53:59 -0800 (PST)
Date:   Mon, 21 Dec 2020 14:53:57 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Yu Zhao <yuzhao@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable@vger.kernel.org, minchan@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <20201221195357.GI6640@xz-x1>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 10:31:57AM -0800, Nadav Amit wrote:
> > On Dec 21, 2020, at 9:27 AM, Peter Xu <peterx@redhat.com> wrote:
> > 
> > Hi, Nadav,
> > 
> > On Sun, Dec 20, 2020 at 12:06:38AM -0800, Nadav Amit wrote:
> > 
> > [...]
> > 
> >> So to correct myself, I think that what I really encountered was actually
> >> during MM_CP_UFFD_WP_RESOLVE (i.e., when the protection is removed). The
> >> problem was that in this case the “write”-bit was removed during unprotect.
> >> Sorry for the strange formatting to fit within 80 columns:
> > 
> > I assume I can ignore the race mentioned in the commit message but only refer
> > to this one below.  However I'm still confused.  Please see below.
> > 
> >> [ Start: PTE is writable ]
> >> 
> >> cpu0				cpu1			cpu2
> >> ----				----			----
> >> 							[ Writable PTE 
> >> 							  cached in TLB ]
> > 
> > Here cpu2 got writable pte in tlb.  But why?
> > 
> > If below is an unprotect, it means it must have been protected once by
> > userfaultfd, right?  If so, the previous change_protection_range() which did
> > the wr-protect should have done a tlb flush already before it returns (since
> > pages>0 - we protected one pte at least).  Then I can't see why cpu2 tlb has
> > stall data.
> 
> Thanks, Peter. Just as you can munprotect() a region which was not protected
> before, you can ufff-unprotect a region that was not protected before. It
> might be that the user tried to unprotect a large region, which was
> partially protected and partially unprotected.
> 
> The selftest obviously blindly unprotect some regions to check for bugs.
> 
> So to your question - it was not write-protected (think about initial copy
> without write-protecting).

If that's the only case, how about we don't touch the ptes at all? Instead of
playing with preserve_write, I'm thinking something like this right before
ptep_modify_prot_start(), even for uffd_wp==true:

  if (uffd_wp && pte_uffd_wp(old_pte)) {
    WARN_ON_ONCE(pte_write(old_pte));
    continue;
  }

  if (uffd_wp_resolve && !pte_uffd_wp(old_pte))
      continue;

Then we can also avoid the heavy operations on changing ptes back and forth.

> 
> > If I assume cpu2 doesn't have that cached tlb, then "write to old page" won't
> > happen either, because cpu1/cpu2 will all go through the cow path and pgtable
> > lock should serialize them.
> > 
> >> userfaultfd_writeprotect()				
> >> [ write-*unprotect* ]
> >> mwriteprotect_range()
> >> mmap_read_lock()
> >> change_protection()
> >> 
> >> change_protection_range()
> >> ...
> >> change_pte_range()
> >> [ *clear* “write”-bit ]
> >> [ defer TLB flushes]
> >> 				[ page-fault ]
> >> 				…
> >> 				wp_page_copy()
> >> 				 cow_user_page()
> >> 				  [ copy page ]
> >> 							[ write to old
> >> 							  page ]
> >> 				…
> >> 				 set_pte_at_notify()
> >> 
> >> [ End: cpu2 write not copied form old to new page. ]
> > 
> > Could you share how to reproduce the problem?  I would be glad to give it a
> > shot as well.
> 
> You can run the selftests/userfaultfd with my small patch [1]. I ran it with
> the following parameters: “ ./userfaultfd anon 100 100 “. I think that it is
> more easily reproducible with “mitigations=off idle=poll” as kernel
> parameters.
> 
> [1] https://lore.kernel.org/patchwork/patch/1346386/

Thanks.

> 
> > 
> >> [1] https://lore.kernel.org/patchwork/patch/1346386
> > 
> > PS: Sorry to not have read the other series of yours.  It seems to need some
> > chunk of time so I postponed it a bit due to other things; but I'll read at
> > least the fixes very soon.
> 
> Thanks again, I will post RFCv2 with some numbers soon.

I read the patch 1/3 of the series.  Would it be better to post them separately
just in case Andrew would like to pick them earlier?

Since you seem to be heavily working on uffd-wp - I do still have a few uffd-wp
fixes locally even for anonymous.  I think they're related to some corner cases
like either thp or migration entry convertions, but anyway I'll see whether I
should post them even earlier (I planned to add smap/pagemap support for
uffd-wp so maybe I can even write some test case to verify some of them).  Just
a FYI...

Thanks,

-- 
Peter Xu

