Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA46D61FDEF
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 19:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiKGSyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 13:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiKGSyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 13:54:07 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6411116;
        Mon,  7 Nov 2022 10:54:06 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o7so11436009pjj.1;
        Mon, 07 Nov 2022 10:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lAsPldyH1+ehPpIMIyGZ2Vh4cO9qav4LSbU+Q7y0YxQ=;
        b=U85gWRsDqLX0LQBt2vQ3TkgGPDTGTFbzCUlE3Zfx0OVbRkG6ETW1wqrGcAb3LrUf/c
         1WAw19BVcC4wWo/dXaGo1joKXPkckqLJwBPqo98cJ1u8G5sXNpZvIc4AnGRms5wRvJTD
         nsurz6HyKVDvQAujo8f5x4dmUof+0gfe6Fg9MEq9+4rpW6hF7rVPKlrJApYU2H2uxfmn
         aK6w+S76NYCsAp43HmrdaCDEpixBof6bOIZWMu2eGsPAomAJlwvlAKlWmBMJB8itQkDh
         0/NrratewXAxRepTTSK/x3JBxn814WWOwQ+qzLd3yrn6kQq8gLdu0jqTElYG6ePKiJpO
         PQOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lAsPldyH1+ehPpIMIyGZ2Vh4cO9qav4LSbU+Q7y0YxQ=;
        b=h1/1a3ND5eQxTPW3a8MJECYSP1jCP+dN5o/SQo5y3hwWEdAvgSp/RF8QFTTtVStpj8
         nhBsiuWkorBwzoLSsx34CNd4/6CQeziWJ1xa2YfSFVebS2F9CIu7Z9u/XGpAUrDvRQ8n
         /EG4nNo/pKncrrp2/ohwanUM3b/oAqZ30wfqRbw2wN3ANoDdvQqaF9MhKUjCuXOKW0L+
         6s0+oJk8Q48E62OVDFHSg/QH7c3BelsrJ6OhkbE03PJzUoXr3VXWCkg8exj0Ss05idUa
         JDmv8MVhL2uGr57g+SXpTUCwk+Vixnj13mjUHVmmkywt/XWtismNbteWgWGocirDcgWM
         l0Hw==
X-Gm-Message-State: ACrzQf2bCG5dxdyHnystAyi2C/T3ZI9QWmY6l7ija0fLTYMWx7Avn2+I
        hPAPM1qIq4445M2ZnFoMZTWrhhRY1PnAyYjC9UQ=
X-Google-Smtp-Source: AMsMyM7TkXgERxyf/LGmK6OXqXmyCV8AVdKCqfR9fWU8njcLEuOJo21O6kgcmd/BG+bxwnjRHSvJBnZymZusZgQiZBA=
X-Received: by 2002:a17:902:d512:b0:181:f1f4:fcb4 with SMTP id
 b18-20020a170902d51200b00181f1f4fcb4mr52554484plg.102.1667847245779; Mon, 07
 Nov 2022 10:54:05 -0800 (PST)
MIME-Version: 1.0
References: <20221107180548.2095056-1-jthoughton@google.com>
In-Reply-To: <20221107180548.2095056-1-jthoughton@google.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Mon, 7 Nov 2022 10:53:53 -0800
Message-ID: <CAHbLzkpae3RJkfFRKXv_kXPP1mgMcJL3YNPfMJTRX-XkmzCPUQ@mail.gmail.com>
Subject: Re: [PATCH v2] hugetlbfs: don't delete error page from pagecache
To:     James Houghton <jthoughton@google.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 7, 2022 at 10:06 AM James Houghton <jthoughton@google.com> wrote:
>
> This change is very similar to the change that was made for shmem [1],
> and it solves the same problem but for HugeTLBFS instead.
>
> Currently, when poison is found in a HugeTLB page, the page is removed
> from the page cache. That means that attempting to map or read that
> hugepage in the future will result in a new hugepage being allocated
> instead of notifying the user that the page was poisoned. As [1] states,
> this is effectively memory corruption.
>
> The fix is to leave the page in the page cache. If the user attempts to
> use a poisoned HugeTLB page with a syscall, the syscall will fail with
> EIO, the same error code that shmem uses. For attempts to map the page,
> the thread will get a BUS_MCEERR_AR SIGBUS.
>
> [1]: commit a76054266661 ("mm: shmem: don't truncate page if memory failure happens")
>
> Fixes: 78bb920344b8 ("mm: hwpoison: dissolve in-use hugepage in unrecoverable memory error")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: James Houghton <jthoughton@google.com>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Tested-by: Naoya Horiguchi <naoya.horiguchi@nec.com>

Reviewed-by: Yang Shi <shy828301@gmail.com>

> ---
>  fs/hugetlbfs/inode.c | 13 ++++++-------
>  mm/hugetlb.c         |  4 ++++
>  mm/memory-failure.c  |  5 ++++-
>  3 files changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index dd54f67e47fd..df7772335dc0 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -328,6 +328,12 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
>                 } else {
>                         unlock_page(page);
>
> +                       if (PageHWPoison(page)) {
> +                               put_page(page);
> +                               retval = -EIO;
> +                               break;
> +                       }
> +
>                         /*
>                          * We have the page, copy it to user space buffer.
>                          */
> @@ -1111,13 +1117,6 @@ static int hugetlbfs_migrate_folio(struct address_space *mapping,
>  static int hugetlbfs_error_remove_page(struct address_space *mapping,
>                                 struct page *page)
>  {
> -       struct inode *inode = mapping->host;
> -       pgoff_t index = page->index;
> -
> -       hugetlb_delete_from_page_cache(page);
> -       if (unlikely(hugetlb_unreserve_pages(inode, index, index + 1, 1)))
> -               hugetlb_fix_reserve_counts(inode);
> -
>         return 0;
>  }
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 546df97c31e4..e48f8ef45b17 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6111,6 +6111,10 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
>
>         ptl = huge_pte_lock(h, dst_mm, dst_pte);
>
> +       ret = -EIO;
> +       if (PageHWPoison(page))
> +               goto out_release_unlock;
> +
>         /*
>          * We allow to overwrite a pte marker: consider when both MISSING|WP
>          * registered, we firstly wr-protect a none pte which has no page cache
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 145bb561ddb3..bead6bccc7f2 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1080,6 +1080,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
>         int res;
>         struct page *hpage = compound_head(p);
>         struct address_space *mapping;
> +       bool extra_pins = false;
>
>         if (!PageHuge(hpage))
>                 return MF_DELAYED;
> @@ -1087,6 +1088,8 @@ static int me_huge_page(struct page_state *ps, struct page *p)
>         mapping = page_mapping(hpage);
>         if (mapping) {
>                 res = truncate_error_page(hpage, page_to_pfn(p), mapping);
> +               /* The page is kept in page cache. */
> +               extra_pins = true;
>                 unlock_page(hpage);
>         } else {
>                 unlock_page(hpage);
> @@ -1104,7 +1107,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
>                 }
>         }
>
> -       if (has_extra_refcount(ps, p, false))
> +       if (has_extra_refcount(ps, p, extra_pins))
>                 res = MF_FAILED;
>
>         return res;
> --
> 2.38.1.431.g37b22c650d-goog
>
