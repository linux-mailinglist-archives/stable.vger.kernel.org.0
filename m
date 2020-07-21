Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0AC2276C5
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 05:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbgGUDdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 23:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgGUDdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 23:33:35 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19119C061794;
        Mon, 20 Jul 2020 20:33:35 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id u8so8703547qvj.12;
        Mon, 20 Jul 2020 20:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cLD63HVz7cMknBL4wWGEVVq5fT472O42ahxwzC+ygv8=;
        b=N0xmZDOqHUb4jVCuhhRlxsAawQPNEPouqOJF666NlI5J9shQVxg6EIlorfO7ROp0qj
         +5Un5Mkb2rPtuN83IBOozQn8rvDWAxjrxBA4diI1gJO7RxkozJuft6dwTe6NcQnewzK7
         VaqKn0Q4Lx9lDxu+LeIrK0ozQA5cj2Fo5OHYMTyjc1r11gr7ucHVB+ooOhsuzMJRL0F9
         aNOre2/3TcBeHKbL1wlfCFfHThc76jPki/cXTjniK+IZ0ht5aCHqqFf3a2n1fkJI+FgR
         seLq86CShgp68h22vbzIDmUhml7V6MlU1mPXGa4McU3t2iT8AKhI0Ja5wJKvsgqN8bh4
         8Jug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cLD63HVz7cMknBL4wWGEVVq5fT472O42ahxwzC+ygv8=;
        b=CfZflGoO2zDTUt8j/p6zHpHd/tzIwEdFxhbNAl859STslYlW3iSA+1BV1QkBmHHVnw
         1OAyxVOdr2gY6r0I6L1nQo23Jm6kwgbR9AYpEr69dpIV1qUeYYMdYzJWcotFj2SSM5je
         cGUX+UiknL/kYuw1ghep4msetGFSvOSVFoip8H2HAi538teFRHaCfBGYMe0GvtnmfLzn
         R2VcK+FCCKY4GxywxLg7eBQfvwWbLKyfXNZ3RjpYf7RmJHQwhLOAk20cou9aaLRAXJBu
         Ahaz2AwXnEhz7GQixPFcr7WNJ/7935UCk0vJE99gS8f64LLbKi6dV48SNhiQPRvVNq8Q
         kmxg==
X-Gm-Message-State: AOAM531vsvYIeXRP9YUCQlakDM76+jXb6MBglBEVG5vQQttV8l44d95S
        J5EYBFE3pyBmzImydU0AHkoCxd15rAufHKfxnMg=
X-Google-Smtp-Source: ABdhPJwtURi/POzxLcVWiStZdyZxxmIbAnE33dRmIQI8XYzmQzbfylxBKwPnoJcte3kMI579qVquVMZKWd7pkAmJb7E=
X-Received: by 2002:ad4:4732:: with SMTP id l18mr23948292qvz.208.1595302414313;
 Mon, 20 Jul 2020 20:33:34 -0700 (PDT)
MIME-Version: 1.0
References: <1595220978-9890-1-git-send-email-iamjoonsoo.kim@lge.com> <20200720162313.1381e1ec82daa6a92ae4cda7@linux-foundation.org>
In-Reply-To: <20200720162313.1381e1ec82daa6a92ae4cda7@linux-foundation.org>
From:   Joonsoo Kim <js1304@gmail.com>
Date:   Tue, 21 Jul 2020 12:33:23 +0900
Message-ID: <CAAmzW4MMSrzkfX9oGfSfmwxY1ejWWTAMLc7KR8yuniru563n3Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm/page_alloc: fix non cma alloc context
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

2020=EB=85=84 7=EC=9B=94 21=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 8:23, A=
ndrew Morton <akpm@linux-foundation.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> On Mon, 20 Jul 2020 13:56:15 +0900 js1304@gmail.com wrote:
>
> > Currently, preventing cma area in page allocation is implemented by usi=
ng
> > current_gfp_context(). However, there are two problems of this
> > implementation.
> >
> > First, this doesn't work for allocation fastpath. In the fastpath,
> > original gfp_mask is used since current_gfp_context() is introduced in
> > order to control reclaim and it is on slowpath.
> > Second, clearing __GFP_MOVABLE has a side effect to exclude the memory
> > on the ZONE_MOVABLE for allocation target.
> >
> > To fix these problems, this patch changes the implementation to exclude
> > cma area in page allocation. Main point of this change is using the
> > alloc_flags. alloc_flags is mainly used to control allocation so it fit=
s
> > for excluding cma area in allocation.
> >
> > Fixes: d7fefcc8de91 (mm/cma: add PF flag to force non cma alloc)
> > Cc: <stable@vger.kernel.org>
>
> This patch is against linux-next (or -mm) and has a lot of issues
> applying to mainline.  If we indeed wish to backport it to -stable, it
> should be against mainline, please.

I sent a revised patch against the mainline a minute ago. Subject and commi=
t
description is updated.

Thanks.
