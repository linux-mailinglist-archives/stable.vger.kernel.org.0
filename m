Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDEC2E3264
	for <lists+stable@lfdr.de>; Sun, 27 Dec 2020 19:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgL0SR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Dec 2020 13:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgL0SR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Dec 2020 13:17:28 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923D6C061794
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 10:16:47 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id o17so19504265lfg.4
        for <stable@vger.kernel.org>; Sun, 27 Dec 2020 10:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bnArJigGBdabFnIq+hfnR+zQf4osesgW3QYyMon5IsY=;
        b=v2G03nV+9gGBzxb5Ei6xCyhk+ThA79SlBStyTRawZsx+G7RliHUy1xcyejpJptiZBU
         yGDD7PKM2T9YXLbQW7nrtC5GOpsfUZ4d1pzWzGW8oKU421LZZ6drxDOdj/jdkVCfc/JM
         OzFy/key+ZtK/8CJ0MTeV4nuzBMcYxPB69traZy8+yV5mntyLFs+iiln39ZhOtLCzkhK
         RBhRCdIODMRuedFES95/c1byzajReyejDRWbmdEfw1V66l+gwg/k2DOrr36yv01RHECl
         08PqLzrZekSImPDElEQ/2xvnUcr/CymVw48DApfx7C+urzHwkO4GRvYg5oT7mAkhjnOs
         h5zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bnArJigGBdabFnIq+hfnR+zQf4osesgW3QYyMon5IsY=;
        b=hFuqu3jjWO6KnkdgDrHF0sZN9dQW9PcvIE8vRLftbXkyDmbOeuaXS/2C6QQlmkoIO6
         8DIt61HEcm3KFwS43tSE/MT9IJ54sfr3fxVYcIVI10El0hWqFH7+ZDI7Xm9LYsStMs+7
         kcCOBjdY9td1qTpfFlxSjbB5Y6eqMTqckLDBwqES7jAFii6c5sqBephm3lQt5bi8nC4u
         +CsWfw915z3ZkAs+Jda0QGWIAakjntGI2c7SwWjNRabb1a+qjKilRage6WKhU1J5DAQT
         cvPVHGSWTf4QAckJn7RJnUSjG+Ds6QQeW5OzbCcacAi98TFG6FFuQHkBDeI0i2RMLPQV
         WE7A==
X-Gm-Message-State: AOAM532Fuii8UJDja2xiipLN8cBL3YKfzpTgYU4lxsDIkqUUpZ7AjZ5j
        EpgaehvoSCZDctDCj2jm0fOEDYB+j20py+Vr/qbl2Q==
X-Google-Smtp-Source: ABdhPJwDYKZBXIYknNHaca3czY4qQ//XT+pNDroUzz129cq14PS/yME1kP4onu8WFtcbZBmG6ghGS3ZCRHe06MF2OAk=
X-Received: by 2002:ac2:47e7:: with SMTP id b7mr16818656lfp.117.1609093005766;
 Sun, 27 Dec 2020 10:16:45 -0800 (PST)
MIME-Version: 1.0
References: <20201227181310.3235210-1-shakeelb@google.com> <20201227181310.3235210-2-shakeelb@google.com>
In-Reply-To: <20201227181310.3235210-2-shakeelb@google.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Sun, 27 Dec 2020 10:16:34 -0800
Message-ID: <CALvZod5bH6gP=_Qo5d2wx=mpRxXDKGcoxwO3oXGPqe=HXx8ifA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: fix numa stats for thp migration
To:     Muchun Song <songmuchun@bytedance.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <guro@fb.com>,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 27, 2020 at 10:14 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> Currently the kernel is not correctly updating the numa stats for
> NR_FILE_PAGES and NR_SHMEM on THP migration. Fix that. For NR_FILE_DIRTY
> and NR_ZONE_WRITE_PENDING, although at the moment there is no need to
> handle THP migration as kernel still does not have write support for
> file THP but to be more future proof, this patch adds the THP support
> for those stats as well.
>
> Fixes: e71769ae52609 ("mm: enable thp migration for shmem thp")
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Cc: <stable@vger.kernel.org>
> ---
>  mm/migrate.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 613794f6a433..ade163c6ecdf 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -402,6 +402,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
>         struct zone *oldzone, *newzone;
>         int dirty;
>         int expected_count = expected_page_refs(mapping, page) + extra_count;
> +       int nr = thp_nr_pages(page);
>
>         if (!mapping) {
>                 /* Anonymous page without mapping */
> @@ -437,7 +438,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
>          */
>         newpage->index = page->index;
>         newpage->mapping = page->mapping;
> -       page_ref_add(newpage, thp_nr_pages(page)); /* add cache reference */
> +       page_ref_add(newpage, nr); /* add cache reference */
>         if (PageSwapBacked(page)) {
>                 __SetPageSwapBacked(newpage);
>                 if (PageSwapCache(page)) {
> @@ -459,7 +460,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
>         if (PageTransHuge(page)) {
>                 int i;
>
> -               for (i = 1; i < HPAGE_PMD_NR; i++) {
> +               for (i = 1; i < nr; i++) {
>                         xas_next(&xas);
>                         xas_store(&xas, newpage);
>                 }
> @@ -470,7 +471,7 @@ int migrate_page_move_mapping(struct address_space *mapping,
>          * to one less reference.
>          * We know this isn't the last reference.
>          */
> -       page_ref_unfreeze(page, expected_count - thp_nr_pages(page));
> +       page_ref_unfreeze(page, expected_count - nr);
>
>         xas_unlock(&xas);
>         /* Leave irq disabled to prevent preemption while updating stats */
> @@ -493,17 +494,17 @@ int migrate_page_move_mapping(struct address_space *mapping,
>                 old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
>                 new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
>
> -               __dec_lruvec_state(old_lruvec, NR_FILE_PAGES);
> -               __inc_lruvec_state(new_lruvec, NR_FILE_PAGES);
> +               __mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
> +               __mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
>                 if (PageSwapBacked(page) && !PageSwapCache(page)) {
> -                       __dec_lruvec_state(old_lruvec, NR_SHMEM);
> -                       __inc_lruvec_state(new_lruvec, NR_SHMEM);
> +                       __mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
> +                       __mod_lruvec_state(new_lruvec, NR_SHMEM, nr);
>                 }
>                 if (dirty && mapping_can_writeback(mapping)) {
> -                       __dec_lruvec_state(old_lruvec, NR_FILE_DIRTY);
> -                       __dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
> -                       __inc_lruvec_state(new_lruvec, NR_FILE_DIRTY);
> -                       __inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
> +                       __mod_lruvec_state(old_lruvec, NR_FILE_DIRTY, -nr);
> +                       __mod_zone_page_tate(oldzone, NR_ZONE_WRITE_PENDING, -nr);

This should be __mod_zone_page_state(). I fixed locally but sent the
older patch by mistake.

> +                       __mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
> +                       __mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
>                 }
>         }
>         local_irq_enable();
> --
> 2.29.2.729.g45daf8777d-goog
>
