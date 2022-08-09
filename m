Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4CA058E08F
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 22:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245288AbiHIUDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 16:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346150AbiHIUAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 16:00:55 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64E21403C
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 13:00:53 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id tl27so24123988ejc.1
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 13:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=3Nw+UCMkb8eM5P4o4fg5DPpCP6PyLs67xhLCM5SqQGM=;
        b=VRBM9D6pcPFAJOfjA+37UektR0jrpOFKofLKXQ8dh9+GHqA9kghDd4C5F1PQSSakLC
         uiJ/X8JuI7hj3D7sznroAaF0LHsLxleBjlrNKIUQ1Fvc76loYqdCHQw/er29PAcKm6dz
         RWHrVlurVBlAOBYpfxEdiWKtz+KG/FFvLYv3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=3Nw+UCMkb8eM5P4o4fg5DPpCP6PyLs67xhLCM5SqQGM=;
        b=sgG/ZXasN4feXRuOQte5IXq/7HxVPcvV+hsGk80lZBkroDfaWCINIZ3yJuvRFy2ae0
         RpNO+HnmO+qwpdElVwVj2qrHFrQyq0ulOa54uq7Ov4yZ4ZWZpGEUKV0Fy/lwonXNafMJ
         gvjMg5ul/TBvrmmGikHplOv5ij8ZwpVArsIQdA/n9/hfFWFutvK9TcUc+zR0xDIVsOZG
         Ut5o+YS1sgerkVIauyQTO+X73OiNqXnd3uor9z+3uhsEXAYqprXyzNv0nFKgGBjNSBd3
         0vM46WZaIbJTrF+NSdubSFjp55eFJJKudV6L07AlkI77vlRMXXM+fZ/FgXEXGXRShPxP
         klTA==
X-Gm-Message-State: ACgBeo1Ty0E7Qa5qTAQpy6GuNasQbPuEVj6LIWqtNvLYccAFk5l4Pqdl
        OzFPz/cKZsyqIKFypHjgXthROtBENkyDkM7czvM=
X-Google-Smtp-Source: AA6agR7eUQ96cCdiyUBzbL477sdaMUMwu5XDqCzx9LLPhYgDoDoeSuj2phH5ksvedQDIopDwT7E6Cw==
X-Received: by 2002:a17:907:9688:b0:730:f098:86d0 with SMTP id hd8-20020a170907968800b00730f09886d0mr15277570ejc.60.1660075252179;
        Tue, 09 Aug 2022 13:00:52 -0700 (PDT)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id d23-20020a05640208d700b0043a7134b381sm6423903edz.11.2022.08.09.13.00.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:00:51 -0700 (PDT)
Received: by mail-wr1-f53.google.com with SMTP id l4so15436870wrm.13
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 13:00:51 -0700 (PDT)
X-Received: by 2002:a5d:56cf:0:b0:21e:ce64:afe7 with SMTP id
 m15-20020a5d56cf000000b0021ece64afe7mr14978811wrw.281.1660075250807; Tue, 09
 Aug 2022 13:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220808073232.8808-1-david@redhat.com>
In-Reply-To: <20220808073232.8808-1-david@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Aug 2022 13:00:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgsDOz5MfYYS9mE7PvFn4kLhTFdBwXvN6HCEsw1kvJnRQ@mail.gmail.com>
Message-ID: <CAHk-=wgsDOz5MfYYS9mE7PvFn4kLhTFdBwXvN6HCEsw1kvJnRQ@mail.gmail.com>
Subject: Re: [PATCH v1] mm/gup: fix FOLL_FORCE COW security issue and remove FOLL_COW
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 8, 2022 at 12:32 AM David Hildenbrand <david@redhat.com> wrote:
>

So I've read through the patch several times, and it seems fine, but
this function (and the pmd version of it) just read oddly to me.

> +static inline bool can_follow_write_pte(pte_t pte, struct page *page,
> +                                       struct vm_area_struct *vma,
> +                                       unsigned int flags)
> +{
> +       if (pte_write(pte))
> +               return true;
> +       if (!(flags & FOLL_FORCE))
> +               return false;
> +
> +       /*
> +        * See check_vma_flags(): only COW mappings need that special
> +        * "force" handling when they lack VM_WRITE.
> +        */
> +       if (vma->vm_flags & VM_WRITE)
> +               return false;
> +       VM_BUG_ON(!is_cow_mapping(vma->vm_flags));

So apart from the VM_BUG_ON(), this code just looks really strange -
even despite the comment. Just conceptually, the whole "if it's
writable, return that you cannot follow it for a write" just looks so
very very strange.

That doesn't make the code _wrong_, but considering how many times
this has had subtle bugs, let's not write code that looks strange.

So I would suggest that to protect against future bugs, we try to make
it be fairly clear and straightforward, and maybe even a bit overly
protective.

For example, let's kill the "shared mapping that you don't have write
permissions to" very explicitly and without any subtle code at all.
The vm_flags tests are cheap and easy, and we could very easily just
add some core ones to make any mistakes much less critical.

Now, making that 'is_cow_mapping()' check explicit at the very top of
this would already go a long way:

        /* FOLL_FORCE for writability only affects COW mappings */
        if (!is_cow_mapping(vma->vm_flags))
                return false;

but I'd actually go even further: in this case that "is_cow_mapping()"
helper to some degree actually hides what is going on.

So I'd actually prefer for that function to be written something like

        /* If the pte is writable, we can write to the page */
        if (pte_write(pte))
                return true;

        /* Maybe FOLL_FORCE is set to override it? */
        if (flags & FOLL_FORCE)
                return false;

        /* But FOLL_FORCE has no effect on shared mappings */
        if (vma->vm_flags & MAP_SHARED)
                return false;

        /* .. or read-only private ones */
        if (!(vma->vm_flags & MAP_MAYWRITE))
                return false;

        /* .. or already writable ones that just need to take a write fault */
        if (vma->vm_flags & MAP_WRITE)
                return false;

and the two first vm_flags tests above are basically doing tat
"is_cow_mapping()", and maybe we could even have a comment to that
effect, but wouldn't it be nice to just write it out that way?

And after you've written it out like the above, now that

        if (!page || !PageAnon(page) || !PageAnonExclusive(page))
                return false;

makes you pretty safe from a data sharing perspective: it's most
definitely not a shared page at that point.

So if you write it that way, the only remaining issues are the magic
special soft-dirty and uffd ones, but at that point it's purely about
the semantics of those features, no longer about any possible "oh, we
fooled some shared page to be writable".

And I think the above is fairly legible without any subtle cases, and
the one-liner comments make it all fairly clear that it's testing.

Is any of this in any _technical_ way different from what your patch
did? No. It's literally just rewriting it to be a bit more explicit in
what it is doing, I think, and it makes that odd "it's not writable if
VM_WRITE is set" case a bit more explicit.

Hmm?

                  Linus
