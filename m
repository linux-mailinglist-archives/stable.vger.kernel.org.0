Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C686E546BAE
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 19:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346245AbiFJRcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 13:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245357AbiFJRce (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 13:32:34 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4922FFD5
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 10:32:31 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id d123so7009515iof.10
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 10:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mYaarscCDbiYRQpS283kg18dErtB3WbPTISYZjeM1fg=;
        b=XI5SlOSdJe1INtlhWj4qWgSBvxqioEZ1C1eHjSENKnAALpsMLQnmHIl7ofJ8ddr82+
         AKcCrGbmvjkIEmkpO85nUOhBth3ZUYlKOMv2CzXt/rY5gQ0rTl/5bKaZl2/RoXyI9iGb
         5WaFMaUgqZ7YZseM5sE9+mfJ+F35Pgto9VjZb2JjEVY4D/MYDEJZQRl4Fh39a5tzZZ4V
         fCRkC6BdLFm0ZjmJpSilx7QznCErM5109JNzVOQx4E2bc150u8Q7aclLOmXCfqHPGbWM
         aoNQdALMTQYeaqJBNxJ5yQQMEREbtUs2xupMRo4QCDv2hZw5nEIS33TeV17Kdus9/het
         bJ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mYaarscCDbiYRQpS283kg18dErtB3WbPTISYZjeM1fg=;
        b=SNMWF8/dydITgqPewfQrWzobkVtm8o0eT7JMat9F0a2dmzgzS/0p1SGSGqXP4UJTmg
         OmHfxnqpp+z+q+oumNxbeRxNtiawwxx5seHZsCJlAj9b4sKkqt206EL6mjX34UpOTtVm
         kYm5+TUNVU3KDD0K+F7uiVLj8BiwA9g1ieiyVr7EYUHX15z+/UemEHaf7cpMK7nxnpVb
         71/Uw2ju8MBZT1I2MyMIskfAuxH54X7qctkZB6X7+hUuiuq2D+v6v7XXEpzAIJ/dTNgA
         MdDobqva5lDjbjIR063S/Pw4LiS66o2PLPibH5Z3Z5qqneyLK8699Q53NXHnZwazOGMJ
         5A7A==
X-Gm-Message-State: AOAM533c+qUv5DPBLtIegT35mrncVKuV8c9fBU7KVJhiWH/jGb+/Q4V1
        UQzDWa4mNCYTOfuAyn6Y/5DPwFl/pDi7dvWWr5Fvjw==
X-Google-Smtp-Source: ABdhPJzi4n+BiEugpCfRZawhd4LlJudPgFHb/9fD3ahN+VmylkhLwh3Qhr5k4K2Z/P7/U2b/mPvy1OVGt3qs4TagwNo=
X-Received: by 2002:a6b:bac1:0:b0:669:b1fe:58e4 with SMTP id
 k184-20020a6bbac1000000b00669b1fe58e4mr4354104iof.171.1654882350815; Fri, 10
 Jun 2022 10:32:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220603205741.12888-1-axelrasmussen@google.com> <YqJpny7cU+tBa093@xz-m1.local>
In-Reply-To: <YqJpny7cU+tBa093@xz-m1.local>
From:   Axel Rasmussen <axelrasmussen@google.com>
Date:   Fri, 10 Jun 2022 10:31:53 -0700
Message-ID: <CAJHvVcg92v28j+m5Cs2kg8W5dz_rqZBAY7Oqfod=wJkUMTMwLQ@mail.gmail.com>
Subject: Re: [PATCH] mm: userfaultfd: fix UFFDIO_CONTINUE on fallocated shmem pages
To:     Peter Xu <peterx@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ah, thanks for pointing this out Peter, it is definitely something I missed.

You're right that elsewhere in mm/userfaultfd.c we use -ENOENT for
some special case. I think for mcontinue_atomic_pte, we don't want to
change the status quo - if we fail to lookup an existing page, we
should just return -EFAULT just like we were doing before. We
certainly shouldn't return -ENOENT, as that causes us to take a wrong,
unrelated code path a couple of callers up, as you mentioned.

I'll send a v2 with this small modification.

On Thu, Jun 9, 2022 at 2:44 PM Peter Xu <peterx@redhat.com> wrote:
>
> Hi, Axel,
>
> Sorry to read this late.
>
> On Fri, Jun 03, 2022 at 01:57:41PM -0700, Axel Rasmussen wrote:
> > When fallocate() is used on a shmem file, the pages we allocate can end
> > up with !PageUptodate.
> >
> > Since UFFDIO_CONTINUE tries to find the existing page the user wants to
> > map with SGP_READ, we would fail to find such a page, since
> > shmem_getpage_gfp returns with a "NULL" pagep for SGP_READ if it
> > discovers !PageUptodate. As a result, UFFDIO_CONTINUE returns -EFAULT,
> > as it would do if the page wasn't found in the page cache at all.
> >
> > This isn't the intended behavior. UFFDIO_CONTINUE is just trying to find
> > if a page exists, and doesn't care whether it still needs to be cleared
> > or not. So, instead of SGP_READ, pass in SGP_NOALLOC. This is the same,
> > except for one critical difference: in the !PageUptodate case,
> > SGP_NOALLOC will clear the page and then return it. With this change,
> > UFFDIO_CONTINUE works properly (succeeds) on a shmem file which has been
> > fallocated, but otherwise not modified.
> >
> > Fixes: 153132571f02 ("userfaultfd/shmem: support UFFDIO_CONTINUE for shmem")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> > ---
> >  mm/userfaultfd.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 4f4892a5f767..c156f7f5b854 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -246,7 +246,7 @@ static int mcontinue_atomic_pte(struct mm_struct *dst_mm,
> >       struct page *page;
> >       int ret;
> >
> > -     ret = shmem_getpage(inode, pgoff, &page, SGP_READ);
> > +     ret = shmem_getpage(inode, pgoff, &page, SGP_NOALLOC);
> >       if (ret)
> >               goto out;
> >       if (!page) {
>
> It all looks sane if the page is !uptodate as you described.  Though I've a
> question on what'll happen if the page is actually missing rather than just
> !PageUptodate().
>
> My reading is previously it'll keep returning 0 on shmem_getpage_gfp() for
> both cases, but now for the missing page shmem_getpage_gfp() will return
> -ENOENT instead.
>
> This reminded me on whether this will errornously let __mcopy_atomic() go
> into the special path to copy the page without mmap lock, please see this
> commit:
>
> b6ebaedb4cb1 ("userfaultfd: avoid mmap_sem read recursion in mcopy_atomic", 2015-09-04)
>
> Would that be a problem?  Or could I read it wrong?
>
> This also reminded me that whether we'd better need some protection in the
> -ENOENT handling in __mcopy_atomic() to be always safe.
>
> Thanks,
>
> --
> Peter Xu
>
