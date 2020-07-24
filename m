Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404A222BC52
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 05:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgGXDEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 23:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgGXDEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 23:04:14 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A344AC0619D3;
        Thu, 23 Jul 2020 20:04:14 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id u8so3515995qvj.12;
        Thu, 23 Jul 2020 20:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Pq5OZv+1Cdv1nhK/D4C8Dz963Kl7Du6n7kqUvhsIG9o=;
        b=qsGf5Y+eAHB2nfvmMACk9RPMbSNLUk3wCIuPP0VRSEch3lQ01wDuEuqsN/3wbSre4n
         h+hryRYytPrwoB3pf2nnN/OJzTS9VnnL0daQ5L4b+GuC7l9etql0GSlZRagIqz00WqOL
         6CsD5xOvOA577EZxSjSkqLbsEUXYO63r60YNioeEPaJ+tWqfI9yy6EwrqFWt+uNitbHT
         R8EEiiUNREX6zswIU3QlVOAlAA4edHBllH9GwyLn+3DbrXXQsaQplONQQ/5F+eGOAJcy
         s3RGVSiuB4zPBhq8JJjE/HXJa/stf5lKdhzi8Gs7X+0JNDQFdZxHsPo/Pg2xdxHE8UqX
         OPBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Pq5OZv+1Cdv1nhK/D4C8Dz963Kl7Du6n7kqUvhsIG9o=;
        b=QAmXhYfFylLSoM+A2e5PkoUyceRmOMRCnGZLH4CjjnW4R1mMWylp7Rug0azlmI07Th
         mwB4SMdo6E+8MbtIy0zjiG0Fxb8YxyWQL0pdIN0Zcc8TInMHoc40UgtStA3aBWTtYL/k
         O0QZxqxYS0cM5pcY+kxWTJCOWQO7sqMQxpoYJLvmnpcaYcg7z18YSBbkpfN+q6PmX7nn
         RnnMAbCGT4ZcA+dIOVrh83KbjKsGHVQnL5z2O+s4h9fp4MNtO5Tor5fRnZetI5G+ZHDY
         DSkkSjWaN2hNmOXYjEuyxnZ8HVFLgjOBqY1Gg5eFPn6ruVsYICHccwD/SPx+l/wsjMTY
         aI0Q==
X-Gm-Message-State: AOAM531FPt4ld6bAaC3Ms1GH81uuaTlXpGviOTk40dWULl6ECjoagSt7
        DJbjWUsa/NMDr0GjTtoVbBW1RmIrwDYy3ILonsdAQi7S
X-Google-Smtp-Source: ABdhPJw1SXbemGwJXMtHFRJrSmfqWp6LYCjOQKzlcVM2YAiR4TBph55l7a03bvdSluU1+C4UQ0f9q8MUWMfU8Q2WK6A=
X-Received: by 2002:a0c:a306:: with SMTP id u6mr7860949qvu.88.1595559853706;
 Thu, 23 Jul 2020 20:04:13 -0700 (PDT)
MIME-Version: 1.0
References: <1595468942-29687-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20200723180814.acde28b92ce6adc785a79120@linux-foundation.org>
 <CAAmzW4N9Y4W7CHenWA=TYu9tttgpYR=ZN+ky1vmXPgUJcjitAw@mail.gmail.com> <20200723193600.28e3eedd00925b22f7ca9780@linux-foundation.org>
In-Reply-To: <20200723193600.28e3eedd00925b22f7ca9780@linux-foundation.org>
From:   Joonsoo Kim <js1304@gmail.com>
Date:   Fri, 24 Jul 2020 12:04:02 +0900
Message-ID: <CAAmzW4NhY0iaE02vwf+2O+aeK66CoKG_-BvsgqpfwZv3Q-w8dA@mail.gmail.com>
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

2020=EB=85=84 7=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 11:36, =
Andrew Morton <akpm@linux-foundation.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> On Fri, 24 Jul 2020 11:23:52 +0900 Joonsoo Kim <js1304@gmail.com> wrote:
>
> > > > Second, clearing __GFP_MOVABLE in current_gfp_context() has a side =
effect
> > > > to exclude the memory on the ZONE_MOVABLE for allocation target.
> > >
> > > More whoops.
> > >
> > > Could we please have a description of the end-user-visible effects of
> > > this change?  Very much needed when proposing a -stable backport, I t=
hink.
> >
> > In fact, there is no noticeable end-user-visible effect since the fallb=
ack would
> > cover the problematic case. It's mentioned in the commit description. P=
erhap,
> > performance would be improved due to reduced retry and more available m=
emory
> > (we can use ZONE_MOVABLE with this patch) but it would be neglectable.
> >
> > > d7fefcc8de9147c is over a year old.  Why did we only just discover
> > > this?  This makes one wonder how serious those end-user-visible effec=
ts
> > > are?
> >
> > As mentioned above, there is no visible problem to the end-user.
>
> OK, thanks.  In that case, I don't believe that a stable backport is
> appropriate?
>
> (Documentation/process/stable-kernel-rules.rst)

Thanks for the pointer!

Hmm... I'm not sure the correct way to handle this patch. I thought that
memalloc_nocma_{save,restore} is an API that is callable from the module.
If it is true, it's better to regard this patch as the stable candidate sin=
ce
out-of-tree modules could use it without the fallback and it would cause
a problem. But, yes, there is no visible problem to the end-user, at least,
within the mainline so it is possibly not a stable candidate.

Please share your opinion about this situation.

Thanks.
