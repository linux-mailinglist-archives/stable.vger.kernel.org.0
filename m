Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDBA22A4D0
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 03:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387473AbgGWBm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 21:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729198AbgGWBm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 21:42:56 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7340DC0619DC;
        Wed, 22 Jul 2020 18:42:56 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l6so3986539qkc.6;
        Wed, 22 Jul 2020 18:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Hgi93fl+d8Jztwv9C8gs6eaqKANcCITr2o5G6xotyng=;
        b=D7L/ZNI66qtNV5JuQnNjl0SDMvevUM3dgtVUc3cnxUfKR6te7KrNdPlqKJ1Ein65u9
         N3BUT+aba14tAPV8r5EpRwSBTrSOidxRu0tvFHicS1i3b4rrrQwuI/zatq6iRtoAdOP1
         n4nBfsIgNrvXpejJPUSk82EtwqoZ+RIErwzhBvTmUsz+l2ppEp4TzbUHNMvg3Ggs51yp
         4ULdTCZBIuAcRu5fauMdldzyk8J8okz06GyatZcdIUvF/WIoW8yNM770AYGD8hcJxXNl
         jFYaxrifYlQsd8MJkXraL5j9bZzTynkTH/5eCRfgu2WzVfSSAPTh3OW6JdckQUl5XoJT
         6Q6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Hgi93fl+d8Jztwv9C8gs6eaqKANcCITr2o5G6xotyng=;
        b=WIuaKZ99t6+07TnOGMVKsaKeAk+dRfelT4vYl2zq+z3MCvxjjV+JzS/RsFkbBO9WjK
         2o+0xqzfeON3X3t8q6nD6ZOytHtSpNVtu9BRYO2x4C6LXN29GFej8UoKQyNVUFH3fVVU
         FUh6I9WTQVbhCw4iCNkU8QEA/48ahgQHX5994adVL5KJKNtwjEp7DUshTyFz26uGDbRX
         bBiZ2QWBtDZwqtHaK2lSoiKVVsz8nXnDMfAN83QiOzrez4pRZkjq8DLX4MQr0jKigZhX
         6C+ayP4iCg4AJcloOUZxpKf45w8JuVyuwFCEXon/daOyY2J6xFBPqfMMH3GQAHZG9jva
         ogvA==
X-Gm-Message-State: AOAM531UqRucIacbVi1dnlvlK4GWzdhM4kdXxF0o8sDenz3S4QMLl8Sx
        yI3WTMc1jhNyXHDSjM/+jTJFuKmahK7SA/LK7fQ=
X-Google-Smtp-Source: ABdhPJx8VAfEHMvN7Qs5nLr0PCFEisdQTFTIrLgCPq5V5asR/gkL6ddOABn+KhrG/fW8UMQSRzNi5vC/24zVqfQ9BWc=
X-Received: by 2002:a37:6d2:: with SMTP id 201mr2782563qkg.187.1595468575726;
 Wed, 22 Jul 2020 18:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <1595302129-23895-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20200721120533.GD15516@casper.infradead.org> <4c484ce0-cfed-0c50-7a20-d1474ce9afee@suse.cz>
 <20200721124312.GE15516@casper.infradead.org>
In-Reply-To: <20200721124312.GE15516@casper.infradead.org>
From:   Joonsoo Kim <js1304@gmail.com>
Date:   Thu, 23 Jul 2020 10:42:44 +0900
Message-ID: <CAAmzW4NSQi016QH4rwZ4d5nCfS+9bpRZGd0wovaUSWnuySTvoQ@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: fix memalloc_nocma_{save/restore} APIs
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
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

2020=EB=85=84 7=EC=9B=94 21=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 9:43, M=
atthew Wilcox <willy@infradead.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Tue, Jul 21, 2020 at 02:38:56PM +0200, Vlastimil Babka wrote:
> > On 7/21/20 2:05 PM, Matthew Wilcox wrote:
> > > On Tue, Jul 21, 2020 at 12:28:49PM +0900, js1304@gmail.com wrote:
> > >> @@ -4619,8 +4631,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsign=
ed int order,
> > >>            wake_all_kswapds(order, gfp_mask, ac);
> > >>
> > >>    reserve_flags =3D __gfp_pfmemalloc_flags(gfp_mask);
> > >> -  if (reserve_flags)
> > >> +  if (reserve_flags) {
> > >>            alloc_flags =3D reserve_flags;
> > >> +          alloc_flags =3D current_alloc_flags(gfp_mask, alloc_flags=
);
> > >> +  }
> > >
> > > Is this right?  Shouldn't you be passing reserve_flags to
> > > current_alloc_flags() here?  Also, there's no need to add { } here.
> >
> > Note the "alloc_flags =3D reserve_flags;" line is not being deleted her=
e. But if
> > it was, your points would be true, and yeah it would be a bit more tidy=
.
>
> Oh ... I should wake up a little more.
>
> Yeah, I'd recommend just doing this:
>
> -               alloc_flags =3D reserve_flags;
> +               alloc_flags =3D current_alloc_flags(gfp_mask, reserve_fla=
gs);

Okay. I will change it. Just note that the reason that I added it
separately is that
I think that separation is more readable since we can easily notice
that alloc_flags
is changed to reserve_flags without inspecting currect_alloc_flags() functi=
on.

Thanks.
