Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 347746C71C0
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 21:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjCWUpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 16:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjCWUp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 16:45:29 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC2A18AA4;
        Thu, 23 Mar 2023 13:45:28 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id d22so13349142pgw.2;
        Thu, 23 Mar 2023 13:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679604328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HkFIb5y369ALv/uraf7WBJF0jCLGL7/0PVLZyZnzEfE=;
        b=ZC7LcbKKAX6hzUly+biSIToShZR6kNkrvYrU4uOUN0+3OxH8qN+ox1Ue5pAGqw4jOE
         SlL7k0SJFziPCc4qQxg7GjMkzR+dOT7gPCY3MNYIuV5ymYr6s2h6s6dPup/36L8+GRC+
         SCMs8wOe4brwI8svowpqIy3dwMQGwt2JI02Zfk5wzzzWxyKw7OSNzHDS+0A1pfp9zFif
         lRtYgjcFLP/Kd9zTfk07hqyHNCho/DTZb+Dg7VTuODRPG4z4kf94wPgic9i9L3iWeucq
         +EB1UlbTmBg5LjoLu45EYN/+vbCisVIfVKA40/+dh5HeAYpM93FixO8dOV6pueJODn8Q
         P8bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679604328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HkFIb5y369ALv/uraf7WBJF0jCLGL7/0PVLZyZnzEfE=;
        b=ExPRaEmfqFtbXXEnya1TydvePejsCSV8lYrXqmrdeYRVF56LVqs4W6DJZ/DyLtQ6OF
         IYKSYBPj+iEsDJJ1o5fuj4AILQ/wtA7lmTL+C5jzW3UvKVJqCKyPHmMX+DDQfizAt7CD
         MAP/GeC7n6/eUUGBn7Vhz8Uc2yX/u0XdddVQBbtfPWn9xLOvERYtVRuym+O77TLua4kc
         4XejpHcFDlTj1QVvfl6r1gSbQ4lgnIzQtbg4utMrqOrpn4c/Q5tvpiRkhbLKgBJ5cSVX
         f0d3fsAvA8qxmKYI9cA3DQ/LrzQ6/ifdEd9vMJqeef9jpGAdCK9LhDI6EPumOUC63O2F
         PBPA==
X-Gm-Message-State: AO0yUKX7hxyMy+xjrZi/NFgjrbiBpNLAZqIrMGxCKd+8WgCz+eFLKrgD
        P9Tmbb61h9huvHxVvbO0ZcjmDNfE1sAHar+5OQw=
X-Google-Smtp-Source: AK7set+0yy8YgmbG5LFZTd+1sGnN2sabKkbGcNeJ8C6HJt001bRUyI6k/+CrcqiRwC0aCBMqGKISiKVPqZzuUAYLX48=
X-Received: by 2002:a63:1919:0:b0:50b:e80f:caff with SMTP id
 z25-20020a631919000000b0050be80fcaffmr2319620pgl.0.1679604327835; Thu, 23 Mar
 2023 13:45:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220203182641.824731-1-shy828301@gmail.com> <132ba4a4-3b1d-329d-1db4-f102eea2fd08@suse.cz>
 <9ba70a5e-4e12-0e9f-a6a4-d955bf25d0fe@redhat.com> <64ec7939-0733-7925-0ec0-d333e62c5f21@suse.cz>
In-Reply-To: <64ec7939-0733-7925-0ec0-d333e62c5f21@suse.cz>
From:   Yang Shi <shy828301@gmail.com>
Date:   Thu, 23 Mar 2023 13:45:16 -0700
Message-ID: <CAHbLzkoZctsJf92Lw3wKMuSqT7-aje0SiAjc6JVW5Z3bNS1JNg@mail.gmail.com>
Subject: Re: [v4 PATCH] fs/proc: task_mmu.c: don't read mapcount for migration entry
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     David Hildenbrand <david@redhat.com>,
        kirill.shutemov@linux.intel.com, jannh@google.com,
        willy@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
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

On Thu, Mar 23, 2023 at 3:11=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 3/23/23 11:08, David Hildenbrand wrote:
> > On 23.03.23 10:52, Vlastimil Babka wrote:
> >> On 2/3/22 19:26, Yang Shi wrote:
> >>> --- a/fs/proc/task_mmu.c
> >>> +++ b/fs/proc/task_mmu.c
> >>> @@ -440,7 +440,8 @@ static void smaps_page_accumulate(struct mem_size=
_stats *mss,
> >>>   }
> >>>
> >>>   static void smaps_account(struct mem_size_stats *mss, struct page *=
page,
> >>> -           bool compound, bool young, bool dirty, bool locked)
> >>> +           bool compound, bool young, bool dirty, bool locked,
> >>> +           bool migration)
> >>>   {
> >>>     int i, nr =3D compound ? compound_nr(page) : 1;
> >>>     unsigned long size =3D nr * PAGE_SIZE;
> >>> @@ -467,8 +468,15 @@ static void smaps_account(struct mem_size_stats =
*mss, struct page *page,
> >>>      * page_count(page) =3D=3D 1 guarantees the page is mapped exactl=
y once.
> >>>      * If any subpage of the compound page mapped with PTE it would e=
levate
> >>>      * page_count().
> >>> +    *
> >>> +    * The page_mapcount() is called to get a snapshot of the mapcoun=
t.
> >>> +    * Without holding the page lock this snapshot can be slightly wr=
ong as
> >>> +    * we cannot always read the mapcount atomically.  It is not safe=
 to
> >>> +    * call page_mapcount() even with PTL held if the page is not map=
ped,
> >>> +    * especially for migration entries.  Treat regular migration ent=
ries
> >>> +    * as mapcount =3D=3D 1.
> >>>      */
> >>> -   if (page_count(page) =3D=3D 1) {
> >>> +   if ((page_count(page) =3D=3D 1) || migration) {
> >>
> >> Since this is now apparently a CVE-2023-1582 for whatever RHeasons...
> >>
> >> wonder if the patch actually works as intended when
> >> (page_count() || migration) is in this particular order and not the ot=
her one?
> >
> > Only the page_mapcount() call to a page that should be problematic, not
> > the page_count() call. There might be the rare chance of the page
>
> Oh right, page_mapcount() vs page_count(), I need more coffee.
>
> > getting remove due to memory offlining... but we're still holding the
> > page table lock with the migration entry, so we should be protected
> > against that.
> >
> > Regarding the CVE, IIUC the main reason for the CVE should be
> > RHEL-specific -- which behaves differently than other code bases; for
> > other code bases, it's just a way to trigger a BUG_ON as described here=
.

Out of curiosity, is there any public link for this CVE? Google search
can't find it.

>
> That's good to know so at least my bogus mail was useful for that, thanks=
!
