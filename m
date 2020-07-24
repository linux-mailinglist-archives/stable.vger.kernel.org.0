Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F82622BBF4
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 04:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgGXCYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 22:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgGXCYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 22:24:04 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96D8C0619D3;
        Thu, 23 Jul 2020 19:24:03 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id j187so7379327qke.11;
        Thu, 23 Jul 2020 19:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e+jZCuU3Ve6QR85zz/PL3yFkpaft9ds9mBhO6o6ZpyY=;
        b=U1hYBfMcnyvMs+MLC9D8LqGdUxOMlYQIWWNO0j8ynexGUjP4w9D5yMJm0Ntse7qcYn
         rhFR3y42TEOVrgcYjwaM0PIanHcrRQtN7+woDWaFv3zniPgy/UFsBAShCXlqpCeUkX6R
         3dIzHByqgNHdBVAgJXjdaVTRj/pGXLhTzO6aaUsr/PO6lr/SQn0SD4iFNZcAy5Bw703u
         vrqhnFJF4Ymop7BnvwLL1XqVb/urs0FkxyGtFQRK0savf8JqkjIBf+imw/5bgQ18qGuq
         dz2YutXRgfbuW7P45Bn8VpKiaVC8pAuv7JmCx4sXtL0iT9RAvhSy2UBieWoaVF+8c+XE
         oN1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e+jZCuU3Ve6QR85zz/PL3yFkpaft9ds9mBhO6o6ZpyY=;
        b=W9Lvjr4rhF09Lzxs/AYDWpYS3huKiCRJMTB2LVh43dUCdzgJc04TU7rq9lvdBsZwZa
         HkwNEWhbQZW02HRfl+QxMabiO791fIAJTA4xxZZLaxuvYUHb+1JYqmecZjq2v6Sqb+kr
         4RZISDSo7/ky2kxVb8QDUEpRE7okOfm1IyPY82qfOEcNxSv5DcNIf2Hu1lbLD2TFv5CC
         M8+IBQppBBuoC08Wjd0k22XwlxJ7TvKdADpKqPQjbyRL/7RkH1Q5+Ls+2lx8FhbGaEqJ
         mONfbqkmBErZ6POm+1VP3yIBsEfAoc/ifYFA8qxTzjgfz+kJG/Am/Q+ems/m6vk3C45l
         rNrg==
X-Gm-Message-State: AOAM533+X9mpjMQaD/n+vgDhV7MWmszgIIU2D7RzBHng72WPKUP4vBM0
        dfgxqSWysHBCMF4akX6c9RsCIRl/ofl2kP8Rvog=
X-Google-Smtp-Source: ABdhPJxqsC3pLWE/fyOiunBBLjtuZ7bZwqLt4KjdFH0iouvpdDH+V0oGQljmm0q99xmB/mDs+Yfu5TStxwRowM6JPPc=
X-Received: by 2002:a37:9b95:: with SMTP id d143mr7937124qke.272.1595557443029;
 Thu, 23 Jul 2020 19:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <1595468942-29687-1-git-send-email-iamjoonsoo.kim@lge.com> <20200723180814.acde28b92ce6adc785a79120@linux-foundation.org>
In-Reply-To: <20200723180814.acde28b92ce6adc785a79120@linux-foundation.org>
From:   Joonsoo Kim <js1304@gmail.com>
Date:   Fri, 24 Jul 2020 11:23:52 +0900
Message-ID: <CAAmzW4N9Y4W7CHenWA=TYu9tttgpYR=ZN+ky1vmXPgUJcjitAw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/page_alloc: fix memalloc_nocma_{save/restore} APIs
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@lge.com,
        Vlastimil Babka <vbabka@suse.cz>,
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

2020=EB=85=84 7=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 10:08, =
Andrew Morton <akpm@linux-foundation.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> On Thu, 23 Jul 2020 10:49:02 +0900 js1304@gmail.com wrote:
>
> > From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> > Currently, memalloc_nocma_{save/restore} API that prevents CMA area
> > in page allocation is implemented by using current_gfp_context(). Howev=
er,
> > there are two problems of this implementation.
> >
> > First, this doesn't work for allocation fastpath. In the fastpath,
> > original gfp_mask is used since current_gfp_context() is introduced in
> > order to control reclaim and it is on slowpath. So, CMA area can be
> > allocated through the allocation fastpath even if
> > memalloc_nocma_{save/restore} APIs are used.
>
> Whoops.
>
> > Currently, there is just
> > one user for these APIs and it has a fallback method to prevent actual
> > problem.
>
> Shouldn't the patch remove the fallback method?

It's not just the fallback but it also has its own functionality. So,
we should not remove it.

> > Second, clearing __GFP_MOVABLE in current_gfp_context() has a side effe=
ct
> > to exclude the memory on the ZONE_MOVABLE for allocation target.
>
> More whoops.
>
> Could we please have a description of the end-user-visible effects of
> this change?  Very much needed when proposing a -stable backport, I think=
.

In fact, there is no noticeable end-user-visible effect since the fallback =
would
cover the problematic case. It's mentioned in the commit description. Perha=
p,
performance would be improved due to reduced retry and more available memor=
y
(we can use ZONE_MOVABLE with this patch) but it would be neglectable.

> d7fefcc8de9147c is over a year old.  Why did we only just discover
> this?  This makes one wonder how serious those end-user-visible effects
> are?

As mentioned above, there is no visible problem to the end-user.

Thanks.
