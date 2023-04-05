Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7700B6D8470
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 19:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233791AbjDERCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 13:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbjDERCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 13:02:03 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF376A4D;
        Wed,  5 Apr 2023 10:00:23 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id dw14so24107652pfb.6;
        Wed, 05 Apr 2023 10:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680713967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8DcuuYVp4lBpbnwNZw6dcWtfsLRDW/kYgpPy1GgV8X8=;
        b=AFIzP3KPzIpj+6ehD1zoVcl5dyDzmj/vAjnX/9Plg+T7hmbu9BPSazINsMASRnjMpa
         s6XvVTXA6xmpQwnGgweEVTj86ikmfijGw+t89gg2j/RfOZW0ykrfcpuClEKbIrJrROjy
         Jrv29UFSm3qnfCyMj/TioDS1TGMVmIPqEPYkbgLGwY4wQRSu8fTitoOU1d+DUF00cSpO
         5ZU9AcMC8Wl/JhS4wxVguVurwIBSQfikRmGNkpvY/iOKCDmjFpTIvERNklmKqQ66tBQT
         UgeXRVTA7AFs+NlwAam2GZPws6KR8mFP8eLbZBX5/KvWM8VHhLusJbiM69492x0lLhst
         RN7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680713967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8DcuuYVp4lBpbnwNZw6dcWtfsLRDW/kYgpPy1GgV8X8=;
        b=PgE5Se2vYasrEOG+ZqdZddIlgw7MXnZu45k83b+xA5KolaT+uz2vUnCVt6BbJB62Ju
         rQ0dUNudTMpUJ6v9qc8UZF8dZoVqox+ClsKqC4ypV9qZWWh5tDlY/g0k7hoox//Rp9H4
         RUCVJ9yootIIRq23MRgzXeQZB0a1Q5KQ9KJy9xtC1/WJhAX9q6iMuHAWiPs7s16PdTc3
         wkrW9DCP0IXBgIWzoXZFkgZqQUNROZENas3FDPhJwfoc2KlY8xo8cGGmPcF6eZzTZpvV
         KMZnUmHXN4S84IaL1Xu0EbCkdeXuDq3q5auvO7SdQFN6RIoAVVyxSMkkVcp2P4K41GAb
         xyDw==
X-Gm-Message-State: AAQBX9frChQ5mqG+85IQrLJ+RoT/QhKOWZvZf6fIlJx6sIrD0LXr5KQw
        rvBluEW9xqgEy5vVvoJ2X8Wq/EOlJgddm6NIoCA=
X-Google-Smtp-Source: AKy350ZNBa+4aZrn1jl9jaZLyzGz/4+iwTpCulbn97BE9QQwzUBNEt4Xg5jPqvSPvWvu+6+rf/CPt3TSCBEiymjzD0w=
X-Received: by 2002:a05:6a00:2d25:b0:625:96ce:f774 with SMTP id
 fa37-20020a056a002d2500b0062596cef774mr3871869pfb.0.1680713967230; Wed, 05
 Apr 2023 09:59:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230405155120.3608140-1-peterx@redhat.com>
In-Reply-To: <20230405155120.3608140-1-peterx@redhat.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Wed, 5 Apr 2023 09:59:15 -0700
Message-ID: <CAHbLzkqKE-TE9Od1E=PQDGuhoR+r-TOz4LP8WQgucm_6ZVYTRA@mail.gmail.com>
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

On Wed, Apr 5, 2023 at 8:51=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> Khugepaged collapse an anonymous thp in two rounds of scans.  The 2nd rou=
nd
> done in __collapse_huge_page_isolate() after hpage_collapse_scan_pmd(),
> during which all the locks will be released temporarily. It means the
> pgtable can change during this phase before 2nd round starts.
>
> It's logically possible some ptes got wr-protected during this phase, and
> we can errornously collapse a thp without noticing some ptes are
> wr-protected by userfault.  e1e267c7928f wanted to avoid it but it only d=
id
> that for the 1st phase, not the 2nd phase.
>
> Since __collapse_huge_page_isolate() happens after a round of small page
> swapins, we don't need to worry on any !present ptes - if it existed
> khugepaged will already bail out.  So we only need to check present ptes
> with uffd-wp bit set there.
>
> This is something I found only but never had a reproducer, I thought it w=
as
> one caused a bug in Muhammad's recent pagemap new ioctl work, but it turn=
s
> out it's not the cause of that but an userspace bug.  However this seems =
to
> still be a real bug even with a very small race window, still worth to ha=
ve
> it fixed and copy stable.

Yeah, I agree. But I got confused by userfaultfd_wp(vma) and
pte_uffd_wp(pte). If a vma is armed with uffd wp, shall we skip the
whole vma? If so, whether it is better to just check vma? We do
revalidate vma once reacquiring mmap_lock, so we should be able to
bail out earlier.

>
> Cc: linux-stable <stable@vger.kernel.org>
> Fixes: e1e267c7928f ("khugepaged: skip collapse if uffd-wp detected")
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/khugepaged.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index a19aa140fd52..42ac93b4bd87 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -575,6 +575,10 @@ static int __collapse_huge_page_isolate(struct vm_ar=
ea_struct *vma,
>                         result =3D SCAN_PTE_NON_PRESENT;
>                         goto out;
>                 }
> +               if (pte_uffd_wp(pteval)) {
> +                       result =3D SCAN_PTE_UFFD_WP;
> +                       goto out;
> +               }
>                 page =3D vm_normal_page(vma, address, pteval);
>                 if (unlikely(!page) || unlikely(is_zone_device_page(page)=
)) {
>                         result =3D SCAN_PAGE_NULL;
> --
> 2.39.1
>
