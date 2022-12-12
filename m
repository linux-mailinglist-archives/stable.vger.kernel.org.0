Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A301164A8C7
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 21:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiLLUgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 15:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbiLLUgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 15:36:10 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA7F15838
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 12:36:09 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id v71so15170409ybv.6
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 12:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0dMhDUB72BePilNkVmMSswDSENS33OIY/8tXTH/slg4=;
        b=VALgahziLcR9p427xDFh1XxBekhCCtrDl4pBjEfh2MFdUvdlxk6GmUnHANnlKBxTrq
         UT2EJEOf+QZIwY5MuwEjMscuR9z06NdCkEQncgSDpjrXp3hodLWtoTvAQo3JNaJUsPt3
         lfYRLgGZ8KnvKH951J1tZjKRSfbqoE7yPNDlP82ryW3mfqy4zkaKfMIJ1Fjs+JKSZqbG
         0kuUD1v4dVYyOuKPIoeYIMU4cpd4WdNZVeQrmJamCWNsBo64DfF/zelPwOqeJJNn0bO+
         ctjT6VTGvrPnF52wSj/K/IO0R1SHWMMZqwYEOncDltQghSuOHXndtIPoXWet6EuzajJs
         1VSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0dMhDUB72BePilNkVmMSswDSENS33OIY/8tXTH/slg4=;
        b=5s5t8uoWfcMs942t7R5uSbLLPeaXIxX8Y3SejuEloHQxMSnOjdkUlDiF56BA2aPFfI
         iwDX4gkDIcgNsz5gawrvB3YbkiByA/9S5r6FTMh7JnY46WqY4K1Wl7HB/YdGmJwAxx49
         Xj/uuDZwFT4pHEa9y0d94INGgEKz9/ulc16uNfIgKY6u7oS3bFSV75nzYr0K0/UWV4jN
         I19UchsgIg/6w7aVemagU0YabhnL1blTXs3BwZaBDHszu10IluXkYeSXgSnV5N+StNXJ
         kHaSru7eA4FG/E3vRHm46mBv3i9pipPK4DdhTni8kVYa51AkR+KBELdYody31G499i+G
         KGmQ==
X-Gm-Message-State: ANoB5pma35vM05AN9U7dJFqiimC04SAyZoLMcdPc4kDWawbg+W7VyzvG
        X5yHzp0aj5HTzjIauZ3vfeHITg==
X-Google-Smtp-Source: AA0mqf6h644TKANgzkwZdoDdLgr7HeNuK8OcwsM2S18P04rc7i6iDBJNXLk38X3w9fCLS4GfX/1vZA==
X-Received: by 2002:a25:5906:0:b0:6f9:c559:d531 with SMTP id n6-20020a255906000000b006f9c559d531mr16917809ybb.35.1670877368205;
        Mon, 12 Dec 2022 12:36:08 -0800 (PST)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id bj17-20020a05620a191100b006b95b0a714esm6485115qkb.17.2022.12.12.12.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 12:36:07 -0800 (PST)
Date:   Mon, 12 Dec 2022 12:35:57 -0800 (PST)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        "Chen, Rong A" <rong.a.chen@intel.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "Huang, Ying" <ying.huang@intel.com>, Jann Horn <jannh@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        =?ISO-8859-15?Q?Mika_Penttil=E4?= <mika.penttila@nextfour.com>,
        Minchan Kim <minchan@kernel.org>,
        Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, Gavin Shan <gshan@redhat.com>,
        Zhenyu Zhang <zhenyzha@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5.10 001/106] mm/mlock: remove lru_lock on
 TestClearPageMlocked
In-Reply-To: <20221212130924.929782499@linuxfoundation.org>
Message-ID: <8ad6ed6-5f7c-f1cd-8693-caf88bfca73a@google.com>
References: <20221212130924.863767275@linuxfoundation.org> <20221212130924.929782499@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463760895-100399986-1670877367=:4310"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463760895-100399986-1670877367=:4310
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 12 Dec 2022, Greg Kroah-Hartman wrote:

> From: Alex Shi <alex.shi@linux.alibaba.com>
>=20
> [ Upstream commit 3db19aa39bac33f2e850fa1ddd67be29b192e51f ]
>=20
> In the func munlock_vma_page, comments mentained lru_lock needed for
> serialization with split_huge_pages.  But the page must be PageLocked as
> well as pages in split_huge_page series funcs.  Thus the PageLocked is
> enough to serialize both funcs.
>=20
> Further more, Hugh Dickins pointed: before splitting in
> split_huge_page_to_list, the page was unmap_page() to remove pmd/ptes
> which protect the page from munlock.  Thus, no needs to guard
> __split_huge_page_tail for mlock clean, just keep the lru_lock there for
> isolation purpose.
>=20
> LKP found a preempt issue on __mod_zone_page_state which need change to
> mod_zone_page_state.  Thanks!
>=20
> Link: https://lkml.kernel.org/r/1604566549-62481-13-git-send-email-alex.s=
hi@linux.alibaba.com
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Alexander Duyck <alexander.duyck@gmail.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: "Chen, Rong A" <rong.a.chen@intel.com>
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: "Huang, Ying" <ying.huang@intel.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mika Penttil=C3=A4 <mika.penttila@nextfour.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: Yang Shi <yang.shi@linux.alibaba.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Stable-dep-of: 829ae0f81ce0 ("mm: migrate: fix THP's mapcount on isolatio=
n")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

NAK from me to patches 001 through 007 here: 001 through 006 are a
risky subset of patches and followups to a per-memcg per-node lru_lock
series from Alex Shi, which made subtle changes to locking, memcg
charging, lru management, page migration etc.

The whole series could be backported to 5.10 (I did so myself for
internal usage), but cherry-picking parts of it into 5.10-stable is
misguided and contrary to stable principles.

Maybe there is in fact nothing wrong with the selection made:
but then give linux-mm guys two or three weeks to review and
test and give the thumbs up to that selection.

Much easier, quicker and safer would be to adjust 007 (I presume
the reason behind 001 through 006) to fit the 5.10-stable tree:
I can do that myself if you ask, but not until later this week.

Hugh

> ---
>  mm/mlock.c | 26 +++++---------------------
>  1 file changed, 5 insertions(+), 21 deletions(-)
>=20
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 884b1216da6a..796c726a0407 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -187,40 +187,24 @@ static void __munlock_isolation_failed(struct page =
*page)
>  unsigned int munlock_vma_page(struct page *page)
>  {
>  =09int nr_pages;
> -=09pg_data_t *pgdat =3D page_pgdat(page);
> =20
>  =09/* For try_to_munlock() and to serialize with page migration */
>  =09BUG_ON(!PageLocked(page));
> -
>  =09VM_BUG_ON_PAGE(PageTail(page), page);
> =20
> -=09/*
> -=09 * Serialize with any parallel __split_huge_page_refcount() which
> -=09 * might otherwise copy PageMlocked to part of the tail pages before
> -=09 * we clear it in the head page. It also stabilizes thp_nr_pages().
> -=09 */
> -=09spin_lock_irq(&pgdat->lru_lock);
> -
>  =09if (!TestClearPageMlocked(page)) {
>  =09=09/* Potentially, PTE-mapped THP: do not skip the rest PTEs */
> -=09=09nr_pages =3D 1;
> -=09=09goto unlock_out;
> +=09=09return 0;
>  =09}
> =20
>  =09nr_pages =3D thp_nr_pages(page);
> -=09__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
> +=09mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
> =20
> -=09if (__munlock_isolate_lru_page(page, true)) {
> -=09=09spin_unlock_irq(&pgdat->lru_lock);
> +=09if (!isolate_lru_page(page))
>  =09=09__munlock_isolated_page(page);
> -=09=09goto out;
> -=09}
> -=09__munlock_isolation_failed(page);
> -
> -unlock_out:
> -=09spin_unlock_irq(&pgdat->lru_lock);
> +=09else
> +=09=09__munlock_isolation_failed(page);
> =20
> -out:
>  =09return nr_pages - 1;
>  }
> =20
> --=20
> 2.35.1
>=20
>=20
>=20
>=20
---1463760895-100399986-1670877367=:4310--
