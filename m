Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D4B2E017D
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 21:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgLUUXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 15:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUUXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 15:23:51 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF1DC0613D3;
        Mon, 21 Dec 2020 12:23:11 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id y8so6184120plp.8;
        Mon, 21 Dec 2020 12:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=IhDqxXtaSRuZsIjaLCj/NmcYBTl37UcNZwF/uRakx8k=;
        b=jUNhpSVIQNM4f3fXEAeUMtmUJ1gSJB8MISFd63Iq7QAUKXXonTSA/gbsmBJbtdncAb
         HyRXprr1VgIiB+ypCp0/MkhlFNwZaR7bHbw9sbxVUK4kQzWt3krAM2WzFQ3jOVkrJu27
         ADcOVcW0ImaLLra1uJ83kx5HdO62gOp0kk5RzNaQf2/TSfOx3Vb4SEQP7u7B0g+ZB8hJ
         283d8tU5RipqWYfCTliyWzoq3EuNViPy1sPn9EkYrXUCaF4Yes9Xfewouv4qqCUTx6Y0
         mxwKIbaMY98nvf72SQGzZuJ5kHjyr/tQa+thlusILZ/JKC4d8WLb/yfmXkSlZdu4KAKt
         lnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=IhDqxXtaSRuZsIjaLCj/NmcYBTl37UcNZwF/uRakx8k=;
        b=auIybPcN5GhFI29uTrhUv26PS9vrumktCeS3UYDtRUP8O+PyrY+khR7fJD/Ly9jAmF
         3jFgS6UEsifaLKI5RdS77orSYFZ4+713HsdxFv996jBBlwE3FVmwwGZhV/V7zqqzrLbS
         bzysAdc5r6RIaIN6xm4yMz6m7tjwEUfOnms16l3Y7vx5j6W5aDPpYqx8otS9Lkkkwcta
         o5cQhwvoOavOMQ7WE+gyNDDN4VqNclyCT95WTXHV2xxrwoKIfymZPx1kSCpUhMr2jE2P
         iWWK72biyZB9ISYqEGFb5fEqYlbfx/cujaguHnyGTWRP+7kyEIKHayqk4nEDvQ4I3QU2
         RS1A==
X-Gm-Message-State: AOAM533iFsXAndEty6jC7ERewS+R7lI9SfISVbBk6OsG0e+4LpJlnQXe
        XStsO/k9TpQ2B5YI5mW13c0=
X-Google-Smtp-Source: ABdhPJzejpo1qNQLXklic1ZtlJOOw2VX+WgbbKLGqczDFXLubIFnNa3AddddFXTAil1PfzsgjS1uVw==
X-Received: by 2002:a17:902:a708:b029:da:ec42:a3d4 with SMTP id w8-20020a170902a708b02900daec42a3d4mr17639493plq.40.1608582190897;
        Mon, 21 Dec 2020 12:23:10 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:104c:8d35:de28:b8dc? ([2601:647:4700:9b2:104c:8d35:de28:b8dc])
        by smtp.gmail.com with ESMTPSA id s10sm17598459pgg.76.2020.12.21.12.23.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Dec 2020 12:23:09 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
Date:   Mon, 21 Dec 2020 12:23:06 -0800
Cc:     Yu Zhao <yuzhao@google.com>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 21, 2020, at 11:55 AM, Linus Torvalds =
<torvalds@linux-foundation.org> wrote:
>=20
> On Mon, Dec 21, 2020 at 11:16 AM Yu Zhao <yuzhao@google.com> wrote:
>> Nadav Amit found memory corruptions when running userfaultfd test =
above.
>> It seems to me the problem is related to commit 09854ba94c6a ("mm:
>> do_wp_page() simplification"). Can you please take a look? Thanks.
>>=20
>> TL;DR: it may not safe to make copies of singly mapped (non-COW) =
pages
>> when it's locked or has additional ref count because concurrent
>> clear_soft_dirty or change_pte_range may have removed pte_write but =
yet
>> to flush tlb.
>=20
> Hmm. The TLB flush shouldn't actually matter, because anything that
> changes the writable bit had better be serialized by the page table
> lock.
>=20
> Yes, we often load the page table value without holding the page table
> lock (in order to know what we are going to do), but then before we
> finalize the operation, we then re-check - undet the page table lock -
> that the value we loaded still matches.
>=20
> But I think I see what *MAY* be going on.  The userfaultfd
> mwriteprotect_range() code takes the mm lock for _reading_. Which
> means that you can have
>=20
> Thread A     Thread B
>=20
> - fault starts. Sees write-protected pte, allocates memory, copies =
data
>=20
>                   - userfaultfd makes the regions writable
>=20
>                   - usefaultfd case writes to the region
>=20
>                   - userfaultfd makes region non-writable
>=20
> - fault continues, gets the page table lock, sees that the pte is the
> same, uses old copied data
>=20
> But if this is what's happening, I think it's a userfaultfd bug. I
> think the mmap_read_lock(dst_mm) in mwriteprotect_range() needs to be
> a mmap_write_lock().
>=20
> mprotect() does this right, it looks like userfaultfd does not. You
> cannot just change the writability of a page willy-nilly without the
> correct locking.
>=20
> Maybe there are other causes, but this one stands out to me as one
> possible cause.
>=20
> Comments?

Using mmap_write_lock() was my initial fix and there was a strong =
pushback
on this approach due to its potential impact on performance.

So I think there are 4 possible directions for solutions that I thought =
of
or others have raised/hinted:

1. mmap_write_lock()

2. Copy the page in cow_user_page() while holding the PTL and after =
flushing
   has been done. I am not sure if there are potential problems with
   special-pages (2 flushes might be necessary for special pages).

3. Always reuse the page and never COW on userfaultfd/soft-dirty.
   I do not know if it is feasible.

4. Retry the page-fault if mm->tlb_flush_pending is set.

Hopefully I did not miss any other suggestion.


