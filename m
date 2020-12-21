Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F92B2DFFD4
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 19:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgLUScl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 13:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgLUScl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 13:32:41 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEEFC0613D6;
        Mon, 21 Dec 2020 10:32:01 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id h186so6949350pfe.0;
        Mon, 21 Dec 2020 10:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=HCY8w6wAd8FcQcRYUZs1swNNxWTGmV4HkMU4xhZmf5g=;
        b=PfmrzFqttYHr+qoFvUFefQjYiMHfeA+60gzbWd15gpG17mHkTC9KsHiFQdIuIjtj6c
         yewrJepM7uUGnPB5TpGejklEnCzxA3Ey0OO8Wse6VqTzWCNvXMTIZkmvYFRqHYdSfoJk
         N0CNw0vycja9C1HqyLM6TWWPEyMHxcFy2ch5QioPDVYLTqaaDWxZrKP3tU7mUqt3Noz8
         1YlnP2pbrQzrrIfC6g5culARrcmSRbYdEfpYx+8J/uSz4hXM88DWhw3tMEIvon/csl9j
         piXUzoLub2Zqmzq4F215ZNxDWchtEB4LQs1Tvve1QX+zqLBNtU3RjsviIfkTsxycZfOV
         CwtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=HCY8w6wAd8FcQcRYUZs1swNNxWTGmV4HkMU4xhZmf5g=;
        b=snfhKiaM9bbovXokng+80ZY85m7RD0Wx5FOLxRDdzUx5YxZXCRN9YvpkQCPD0WZJyv
         cvIHxSN427F3HBsYsmrHIGjvrC3dmCdtL6Ufiz95Xe4MfaU+uSexlVh8qMgdfgVzASiR
         SLbXf0vzh43Ok9cuzecMfbY5/Ihw1QyzEFlt1JpjYblY3MPeo1gSKpYTiQ/vBbfZhPpE
         Pfd+e3KUoc5si2/NhM+oLA4Ud9MwT2F1hUzi4Wo7kzYSRvsIABZfEynJVZ/JK45UUcSK
         DrpilN7+WUxkxuyeVpmyEDg2zrOerl4NTVpDXZlFUR2YLEs73cEj/7dtRiu9HtuhwLYO
         Zf/g==
X-Gm-Message-State: AOAM530C9q90cw4SxSTcotKlgjqnhEnHkO0Kh5kgmPaaD5/BHbiJ4jEz
        ENomiQcSaKyfK94rCF/44ZU=
X-Google-Smtp-Source: ABdhPJzDuUUuKqtLU7584aeLXqn4qvLTbBvwOuj3NGYyNc7XzZ5zLZRRkrrvAtr+sUMza55iYtZriw==
X-Received: by 2002:a63:1d12:: with SMTP id d18mr16202857pgd.314.1608575520652;
        Mon, 21 Dec 2020 10:32:00 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:104c:8d35:de28:b8dc? ([2601:647:4700:9b2:104c:8d35:de28:b8dc])
        by smtp.gmail.com with ESMTPSA id k21sm16041734pfu.7.2020.12.21.10.31.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Dec 2020 10:31:59 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20201221172711.GE6640@xz-x1>
Date:   Mon, 21 Dec 2020 10:31:57 -0800
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1>
To:     Peter Xu <peterx@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 21, 2020, at 9:27 AM, Peter Xu <peterx@redhat.com> wrote:
>=20
> Hi, Nadav,
>=20
> On Sun, Dec 20, 2020 at 12:06:38AM -0800, Nadav Amit wrote:
>=20
> [...]
>=20
>> So to correct myself, I think that what I really encountered was =
actually
>> during MM_CP_UFFD_WP_RESOLVE (i.e., when the protection is removed). =
The
>> problem was that in this case the =E2=80=9Cwrite=E2=80=9D-bit was =
removed during unprotect.
>> Sorry for the strange formatting to fit within 80 columns:
>=20
> I assume I can ignore the race mentioned in the commit message but =
only refer
> to this one below.  However I'm still confused.  Please see below.
>=20
>> [ Start: PTE is writable ]
>>=20
>> cpu0				cpu1			cpu2
>> ----				----			----
>> 							[ Writable PTE=20=

>> 							  cached in TLB =
]
>=20
> Here cpu2 got writable pte in tlb.  But why?
>=20
> If below is an unprotect, it means it must have been protected once by
> userfaultfd, right?  If so, the previous change_protection_range() =
which did
> the wr-protect should have done a tlb flush already before it returns =
(since
> pages>0 - we protected one pte at least).  Then I can't see why cpu2 =
tlb has
> stall data.

Thanks, Peter. Just as you can munprotect() a region which was not =
protected
before, you can ufff-unprotect a region that was not protected before. =
It
might be that the user tried to unprotect a large region, which was
partially protected and partially unprotected.

The selftest obviously blindly unprotect some regions to check for bugs.

So to your question - it was not write-protected (think about initial =
copy
without write-protecting).

> If I assume cpu2 doesn't have that cached tlb, then "write to old =
page" won't
> happen either, because cpu1/cpu2 will all go through the cow path and =
pgtable
> lock should serialize them.
>=20
>> userfaultfd_writeprotect()			=09
>> [ write-*unprotect* ]
>> mwriteprotect_range()
>> mmap_read_lock()
>> change_protection()
>>=20
>> change_protection_range()
>> ...
>> change_pte_range()
>> [ *clear* =E2=80=9Cwrite=E2=80=9D-bit ]
>> [ defer TLB flushes]
>> 				[ page-fault ]
>> 				=E2=80=A6
>> 				wp_page_copy()
>> 				 cow_user_page()
>> 				  [ copy page ]
>> 							[ write to old
>> 							  page ]
>> 				=E2=80=A6
>> 				 set_pte_at_notify()
>>=20
>> [ End: cpu2 write not copied form old to new page. ]
>=20
> Could you share how to reproduce the problem?  I would be glad to give =
it a
> shot as well.

You can run the selftests/userfaultfd with my small patch [1]. I ran it =
with
the following parameters: =E2=80=9C ./userfaultfd anon 100 100 =E2=80=9C. =
I think that it is
more easily reproducible with =E2=80=9Cmitigations=3Doff idle=3Dpoll=E2=80=
=9D as kernel
parameters.

[1] https://lore.kernel.org/patchwork/patch/1346386/

>=20
>> [1] https://lore.kernel.org/patchwork/patch/1346386
>=20
> PS: Sorry to not have read the other series of yours.  It seems to =
need some
> chunk of time so I postponed it a bit due to other things; but I'll =
read at
> least the fixes very soon.

Thanks again, I will post RFCv2 with some numbers soon.

