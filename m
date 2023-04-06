Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571216D9918
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 16:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbjDFOJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 10:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239045AbjDFOIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 10:08:45 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A6A9EC6
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 07:08:25 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id g18so1697673ejj.5
        for <stable@vger.kernel.org>; Thu, 06 Apr 2023 07:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680790099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jW9/JTaDylpgeIAJECkEaG5KDiwSixA3SIgLvbU4AaM=;
        b=Ldvqw71+VNh7tiIc4Z+CvHM5E4lX14+MqS/bwxliBBbEllQmotXyQ5XfnUEEGp2HQY
         ztGbZZSn94MOcBsnIWgnD52vWIU2B3+rXqpHy58REb6k+o5QnpsPP/mLEGqU1uHId5z4
         B454ZFZ4TX/JEQ9Th4j7J3bptmCB+wC3Qk7vApbN+hRZNpKyp7uu9Cjr3TQYIKHoBUgj
         ux2ery45Q/wVCkabLZ18a2xTySnSL+7qT4PwHpRRQj8khOrn+OiD03Hi+UOvMSCYnojY
         S3Fj/UNROxw2E7+y1nPMRKJKj/dMqKtXo5CTWUrrhUrHojUncvHbJQq8Vy6A7D2rCnFB
         bkRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680790099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jW9/JTaDylpgeIAJECkEaG5KDiwSixA3SIgLvbU4AaM=;
        b=4S08he5UxuRk80YWDCxhxhZVx5mPDLjCPtOY1/jTfIsHDQX0A0U3FnLrQSKKcr9fr5
         ba+EUpIGNFocy8OzEsB5VSrrNX8ovsw0Vh2l035xgqN0RrnYWkJvRbBHRWJQ3SFFLJ8I
         sWPMuj4rhrjbf2IhS9Mah1uiB9j8WIzf769wR66lnzblH0qzVOb+fcsJjSm9exiEpFUI
         W1sF2fAIbi/YXRIAYa80deSOITQc/wDOJCOkoQTg6kHdv0vvDOXUmOMc9kyaCKhQ+VZi
         q5Pbw+YpoPqsVtKVCRCyrWu0hMTf+buPp74awZXfeUU/7CzJAFL56h4BBmuehjBTvOQQ
         q+3w==
X-Gm-Message-State: AAQBX9cO6VJCXBpq+f9J9ueF3bh9e1bUJ7mdReqNFBjQ5qMCQECDA4Dw
        yYxlR9Xr/PH8i9yCYWpoTh0Kt3hmIC2QrtYl8xqr+A==
X-Google-Smtp-Source: AKy350bAFhVGMCwwfVhJTeYwOabUOGX15M4Xne8OZst89OyUnu4BGUc8xSUVle/vqmycb4Kkggnju+5sLAPNViJx+lE=
X-Received: by 2002:a17:906:af6b:b0:931:6e39:3d0b with SMTP id
 os11-20020a170906af6b00b009316e393d0bmr3399835ejb.15.1680790099297; Thu, 06
 Apr 2023 07:08:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230405185427.1246289-1-yosryahmed@google.com>
 <20230405185427.1246289-2-yosryahmed@google.com> <a8cb406a-70cd-aa47-fdda-50cd0eb8c941@redhat.com>
In-Reply-To: <a8cb406a-70cd-aa47-fdda-50cd0eb8c941@redhat.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Thu, 6 Apr 2023 07:07:42 -0700
Message-ID: <CAJD7tkbNsLo8Cd0nOm22oxD14GMppPoLNOHx2f8BJZA1wkpWnQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] mm: vmscan: ignore non-LRU-based reclaim in memcg reclaim
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for taking a look, David!

On Thu, Apr 6, 2023 at 3:31=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 05.04.23 20:54, Yosry Ahmed wrote:
> > We keep track of different types of reclaimed pages through
> > reclaim_state->reclaimed_slab, and we add them to the reported number
> > of reclaimed pages.  For non-memcg reclaim, this makes sense. For memcg
> > reclaim, we have no clue if those pages are charged to the memcg under
> > reclaim.
> >
> > Slab pages are shared by different memcgs, so a freed slab page may hav=
e
> > only been partially charged to the memcg under reclaim.  The same goes =
for
> > clean file pages from pruned inodes (on highmem systems) or xfs buffer
> > pages, there is no simple way to currently link them to the memcg under
> > reclaim.
> >
> > Stop reporting those freed pages as reclaimed pages during memcg reclai=
m.
> > This should make the return value of writing to memory.reclaim, and may
> > help reduce unnecessary reclaim retries during memcg charging.  Writing=
 to
> > memory.reclaim on the root memcg is considered as cgroup_reclaim(), but
> > for this case we want to include any freed pages, so use the
> > global_reclaim() check instead of !cgroup_reclaim().
> >
> > Generally, this should make the return value of
> > try_to_free_mem_cgroup_pages() more accurate. In some limited cases (e.=
g.
> > freed a slab page that was mostly charged to the memcg under reclaim),
> > the return value of try_to_free_mem_cgroup_pages() can be underestimate=
d,
> > but this should be fine. The freed pages will be uncharged anyway, and =
we
>
> Can't we end up in extreme situations where
> try_to_free_mem_cgroup_pages() returns close to 0 although a huge amount
> of memory for that cgroup was freed up.
>
> Can you extend on why "this should be fine" ?
>
> I suspect that overestimation might be worse than underestimation. (see
> my comment proposal below)

In such extreme scenarios even though try_to_free_mem_cgroup_pages()
would return an underestimated value, the freed memory for the cgroup
will be uncharged. try_charge() (and most callers of
try_to_free_mem_cgroup_pages()) do so in a retry loop, so even if
try_to_free_mem_cgroup_pages() returns an underestimated value
charging will succeed the next time around.

The only case where this might be a problem is if it happens in the
final retry, but I guess we need to be *really* unlucky for this
extreme scenario to happen. One could argue that if we reach such a
situation the cgroup will probably OOM soon anyway.

>
> > can charge the memcg the next time around as we usually do memcg reclai=
m
> > in a retry loop.
> >
> > The next patch performs some cleanups around reclaim_state and adds an
> > elaborate comment explaining this to the code. This patch is kept
> > minimal for easy backporting.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > Cc: stable@vger.kernel.org
>
> Fixes: ?
>
> Otherwise it's hard to judge how far to backport this.

It's hard to judge. The issue has been there for a while, but
memory.reclaim just made it more user visible. I think we can
attribute it to per-object slab accounting, because before that any
freed slab pages in cgroup reclaim would be entirely charged to that
cgroup.

Although in all fairness, other types of freed pages that use
reclaim_state->reclaimed_slab cannot be attributed to the cgroup under
reclaim have been there before that. I guess slab is the most
significant among them tho, so for the purposes of backporting I
guess:

Fixes: f2fe7b09a52b ("mm: memcg/slab: charge individual slab objects
instead of pages")

>
> > ---
> >
> > global_reclaim(sc) does not exist in kernels before 6.3. It can be
> > replaced with:
> > !cgroup_reclaim(sc) || mem_cgroup_is_root(sc->target_mem_cgroup)
> >
> > ---
> >   mm/vmscan.c | 8 +++++---
> >   1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 9c1c5e8b24b8f..c82bd89f90364 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -5346,8 +5346,10 @@ static int shrink_one(struct lruvec *lruvec, str=
uct scan_control *sc)
> >               vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - s=
canned,
> >                          sc->nr_reclaimed - reclaimed);
> >
> > -     sc->nr_reclaimed +=3D current->reclaim_state->reclaimed_slab;
> > -     current->reclaim_state->reclaimed_slab =3D 0;
>
> Worth adding a comment like
>
> /*
>   * Slab pages cannot universally be linked to a single memcg. So only
>   * account them as reclaimed during global reclaim. Note that we might
>   * underestimate the amount of memory reclaimed (but won't overestimate
>   * it).
>   */
>
> but ...
>
> > +     if (global_reclaim(sc)) {
> > +             sc->nr_reclaimed +=3D current->reclaim_state->reclaimed_s=
lab;
> > +             current->reclaim_state->reclaimed_slab =3D 0;
> > +     }
> >
> >       return success ? MEMCG_LRU_YOUNG : 0;
> >   }
> > @@ -6472,7 +6474,7 @@ static void shrink_node(pg_data_t *pgdat, struct =
scan_control *sc)
> >
> >       shrink_node_memcgs(pgdat, sc);
> >
>
> ... do we want to factor the add+clear into a simple helper such that we
> can have above comment there?
>
> static void cond_account_reclaimed_slab(reclaim_state, sc)
> {
>         /*
>          * Slab pages cannot universally be linked to a single memcg. So
>          * only account them as reclaimed during global reclaim. Note
>          * that we might underestimate the amount of memory reclaimed
>          * (but won't overestimate it).
>          */
>         if (global_reclaim(sc)) {
>                 sc->nr_reclaimed +=3D reclaim_state->reclaimed_slab;
>                 reclaim_state->reclaimed_slab =3D 0;
>         }
> }
>
> Yes, effective a couple LOC more, but still straight-forward for a
> stable backport

The next patch in the series performs some refactoring and cleanups,
among which we add a helper called flush_reclaim_state() that does
exactly that and contains a sizable comment. I left this outside of
this patch in v5 to make the effective change as small as possible for
backporting. Looks like it can be confusing tho without the comment.

How about I pull this part to this patch as well for v6?

>
> > -     if (reclaim_state) {
> > +     if (reclaim_state && global_reclaim(sc)) {
> >               sc->nr_reclaimed +=3D reclaim_state->reclaimed_slab;
> >               reclaim_state->reclaimed_slab =3D 0;
> >       }
>
> --
> Thanks,
>
> David / dhildenb
>
