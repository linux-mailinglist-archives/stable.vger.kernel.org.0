Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817A36D85EE
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 20:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbjDESZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 14:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjDESZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 14:25:37 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22A13ABC;
        Wed,  5 Apr 2023 11:25:36 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id cu12so24267784pfb.13;
        Wed, 05 Apr 2023 11:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680719136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iCptc+kA5zXDdmAuA5of1pjj6ECPBD9EyosUWG9DOXY=;
        b=b0wEGUnlTwRu184txYCFSgU2+1bYA32X8C5SLFPd+pjOQ2zXGpQxoat+6txV4sYjCm
         cL7gvZagcwGc+pjq2zl2c0aNLW5CJZdYMhU+25BnYZhFxT7+Waako8RpTlAFUaZHlP86
         JHYKZMqcULWxbGSVQziwbxkFOLSqIAkYqURZ+1nt4Ad5TRFe9N+fTSgOtVO6AuRCtCvb
         42mmmtEKBsoe2QTXn215aqHmlo4ThRkTNco3b17whfWNwPWTuYO3AJxqjlaYJsZ4ivFq
         D6e8C5I9wuQmNJNLYy3/HuTJ/S9PG46kFbAHWTUukbRb4zblNUYsbZ0XCJE4Tl6GPY1K
         aLyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680719136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iCptc+kA5zXDdmAuA5of1pjj6ECPBD9EyosUWG9DOXY=;
        b=UZ4J4eHjekOO0VYxjNQwGdnBow47Ku54wXDBEqOzLxzn0fBQ+kZFxSchysTU5O8Z/k
         chLdCcLiBbsaL/4FjlGFLkDkRYpZQtrw+zi/YBzg9MYoSR6vwPCJO5UC24RAwqHGDsKi
         McMiYzfEPdkTm0zM0vatP3GraIQ8xor615ofE3FRkYHRd/mFHYHM0xsQKBYoSG+GTrbH
         4tCEr6cO39/dirG3A1UYhCqeoMjG44R/mTXPrQTusjdVUYk/fedwTUuydA/CTKHm+D1M
         mTssh7d1zEmpe84wlFjtU0DHVzKElBUDZ4sC7+wF9enRvbTRRMVg6o/yFbmgLixTc9EJ
         igxw==
X-Gm-Message-State: AAQBX9erKIIAzoX0sqScukCO6V7KPes62N08gFwHMw/hpZO9Vktrq6c1
        2daHSjzkatFWShEsjbcpMhqQ+SMI6FClyfXOO5Y=
X-Google-Smtp-Source: AKy350b2Wbwyv1L6f98Vzq50lFWkxGC/rY4GOuWs7FtED4TSHS3YhFkk1MiIL8vg5A5HXY/zuoZ7yyYU0CHr6Hvz1hw=
X-Received: by 2002:a05:6a00:1783:b0:62b:e52e:1bb with SMTP id
 s3-20020a056a00178300b0062be52e01bbmr3905606pfg.0.1680719135951; Wed, 05 Apr
 2023 11:25:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230405155120.3608140-1-peterx@redhat.com> <CAHbLzkqKE-TE9Od1E=PQDGuhoR+r-TOz4LP8WQgucm_6ZVYTRA@mail.gmail.com>
 <ZC25d12d0sc1L7tS@x1n>
In-Reply-To: <ZC25d12d0sc1L7tS@x1n>
From:   Yang Shi <shy828301@gmail.com>
Date:   Wed, 5 Apr 2023 11:25:24 -0700
Message-ID: <CAHbLzkqzYxCrJdH8f7OY5x9-mngK+xKJUZ+HCB9V-O+yQqKE4w@mail.gmail.com>
Subject: Re: [PATCH] mm/khugepaged: Check again on anon uffd-wp during isolation
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Axel Rasmussen <axelrasmussen@google.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 5, 2023 at 11:10=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> On Wed, Apr 05, 2023 at 09:59:15AM -0700, Yang Shi wrote:
> > On Wed, Apr 5, 2023 at 8:51=E2=80=AFAM Peter Xu <peterx@redhat.com> wro=
te:
> > >
> > > Khugepaged collapse an anonymous thp in two rounds of scans.  The 2nd=
 round
> > > done in __collapse_huge_page_isolate() after hpage_collapse_scan_pmd(=
),
> > > during which all the locks will be released temporarily. It means the
> > > pgtable can change during this phase before 2nd round starts.
> > >
> > > It's logically possible some ptes got wr-protected during this phase,=
 and
> > > we can errornously collapse a thp without noticing some ptes are
> > > wr-protected by userfault.  e1e267c7928f wanted to avoid it but it on=
ly did
> > > that for the 1st phase, not the 2nd phase.
> > >
> > > Since __collapse_huge_page_isolate() happens after a round of small p=
age
> > > swapins, we don't need to worry on any !present ptes - if it existed
> > > khugepaged will already bail out.  So we only need to check present p=
tes
> > > with uffd-wp bit set there.
> > >
> > > This is something I found only but never had a reproducer, I thought =
it was
> > > one caused a bug in Muhammad's recent pagemap new ioctl work, but it =
turns
> > > out it's not the cause of that but an userspace bug.  However this se=
ems to
> > > still be a real bug even with a very small race window, still worth t=
o have
> > > it fixed and copy stable.
> >
> > Yeah, I agree. But I got confused by userfaultfd_wp(vma) and
> > pte_uffd_wp(pte). If a vma is armed with uffd wp, shall we skip the
> > whole vma? If so, whether it is better to just check vma? We do
> > revalidate vma once reacquiring mmap_lock, so we should be able to
> > bail out earlier.
>
> Checking against VMA is safe too, the difference is current code still
> allows thp to be collapsed as long as none of the page is explicitly
> protected over the thp range, even if the range is registered with
> userfault-wp.  That's also what e1e267c7928f does.
>
> Here we have slightly different handling between anon / file thps (file
> thps checks against the vma flags), IMHO mostly because we don't scan
> pgtables when making decisions to collapse a shmem thp, so we made it
> simple by checking against vma flags.  We can make it the same as anon bu=
t
> it might be an overkill just to scan the entries for uffd-wp purpose.
>
> For anon we always scans the pgtable anyway so it's easier to make a more
> accurate decision.

Aha, I see. It does resolve my confusion. Thanks for elaborating.

The patch looks good to me. Reviewed-by: Yang Shi <shy828301@gmail.com>

>
> Thanks,
>
> --
> Peter Xu
>
