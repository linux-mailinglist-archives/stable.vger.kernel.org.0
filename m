Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA47C22A4A7
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 03:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387424AbgGWBi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 21:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728914AbgGWBi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 21:38:28 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5338C0619DC;
        Wed, 22 Jul 2020 18:38:28 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id j187so3949592qke.11;
        Wed, 22 Jul 2020 18:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YZZc8tkRzFODbKr19PJHEkff/Ao3Y0B9UKvSStxkk20=;
        b=WUAK93PyKvCgFkmf5Q+ixIMgxah07B/C0uAthIE/DzScCc+w8IR30LCq1mYDz6LfpH
         1kOMw5ip73ylC2ovfZfd+IorBh3E0ezinrSrm4wUS7en6CApNbl5AAAuwlRjCNprNYjY
         a2j+nVQyF8A7JHdd8vW4FkB7zykVjT7KL8/maqPetPanjWHbr4DnbEYBgGz3P4nmxTqh
         L8dFReXq+kVNsAs1inGVG+sRoGzsbJ52VC0WXJzDum3MCFbF8XCYvBvXwtuNyG1BGlv7
         PpFz9jK9CS75DEL9XdEfB64fm2wws0swbFGwiWoK0HFQvKV8GyQMrNFbb/ueYvmIKt+b
         M3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YZZc8tkRzFODbKr19PJHEkff/Ao3Y0B9UKvSStxkk20=;
        b=LLX+lvlSYy5bWaXoUlCSXzGKXRSucOcesvL19Tw8aN/dP64zI21lAUCIyDIgCP2v89
         NLwtBruHw7cobbIExNPMPPMENfN8WxSX1RQIdx6lgoyKFLBbCyEvq3AR5tT0/2aZ0rHg
         u8KJJpSenYVeTxdKHbfe5Qww91RzIE61VlZ1ehsKL7HDIqG+fGdD2gUFFPxh43aa0S00
         mLdgrk1yx5o+744BvRBHEB+mWuP/T1UDRP5llaQ7OieYnjQtJM4YmnuUeTLiF2WOdxu4
         YsNAeWvJuQn/Vbg3F12o3gnJpxOn2Q75kcMZIjX9F2yntwsXNzHeePs7cZKPijvvowgZ
         9Mbg==
X-Gm-Message-State: AOAM530hYpKL3n0hsXOIlPX01NS+1SCZ2A8UgEDwpZs7Ws1Qh/3kGi9k
        2zV/OTJyDuJEsAB3WUf9oZ2N2rU3IzCITl4k1sQ=
X-Google-Smtp-Source: ABdhPJzEPNS6XZft4HQw4J9+FY04X6wifZJcaeJ9gK+GPmo4Kkrtg1rJ0VNFEiFCXwfeMMXPSn2gWbM+MF4x+PinGKE=
X-Received: by 2002:a37:6d2:: with SMTP id 201mr2771283qkg.187.1595468307797;
 Wed, 22 Jul 2020 18:38:27 -0700 (PDT)
MIME-Version: 1.0
References: <1595302129-23895-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20200721120533.GD15516@casper.infradead.org> <4c484ce0-cfed-0c50-7a20-d1474ce9afee@suse.cz>
In-Reply-To: <4c484ce0-cfed-0c50-7a20-d1474ce9afee@suse.cz>
From:   Joonsoo Kim <js1304@gmail.com>
Date:   Thu, 23 Jul 2020 10:38:16 +0900
Message-ID: <CAAmzW4NZ3aG6ZOJ1oFxHrB9AK01=5Kt0LsAw3HT14g9L3yyxzQ@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: fix memalloc_nocma_{save/restore} APIs
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@lge.com,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2020=EB=85=84 7=EC=9B=94 21=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 9:39, V=
lastimil Babka <vbabka@suse.cz>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On 7/21/20 2:05 PM, Matthew Wilcox wrote:
> > On Tue, Jul 21, 2020 at 12:28:49PM +0900, js1304@gmail.com wrote:
> >> +static inline unsigned int current_alloc_flags(gfp_t gfp_mask,
> >> +                                    unsigned int alloc_flags)
> >> +{
> >> +#ifdef CONFIG_CMA
> >> +    unsigned int pflags =3D current->flags;
> >> +
> >> +    if (!(pflags & PF_MEMALLOC_NOCMA) &&
> >> +            gfp_migratetype(gfp_mask) =3D=3D MIGRATE_MOVABLE)
> >> +            alloc_flags |=3D ALLOC_CMA;
> >
> > Please don't indent by one tab when splitting a line because it looks l=
ike
> > the second line and third line are part of the same block.  Either do
> > this:
> >
> >       if (!(pflags & PF_MEMALLOC_NOCMA) &&
> >           gfp_migratetype(gfp_mask) =3D=3D MIGRATE_MOVABLE)
> >               alloc_flags |=3D ALLOC_CMA;
> >
> > or this:
> >       if (!(pflags & PF_MEMALLOC_NOCMA) &&
> >                       gfp_migratetype(gfp_mask) =3D=3D MIGRATE_MOVABLE)
> >               alloc_flags |=3D ALLOC_CMA;
>
> Ah, good point.

Will change it.

Thanks.
