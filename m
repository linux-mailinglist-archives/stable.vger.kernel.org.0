Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7738F65C1B4
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 15:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjACOTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 09:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjACOTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 09:19:48 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD1B259
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 06:19:47 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id d10so18047698ilc.12
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 06:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=P421F/GOg58FrtBIy3dQLQWF/Mue7ayz0hctz4juYTQ=;
        b=npQ5w2ZAMMefWMeBsQHckTEhtrjqmjJnZp0ue8LyucXDB6VZbZCgY86CaxckW2skdn
         m+0spjE0h9eQ4UriQpRbI4JLLbk7o/r9qWThGQDHEv4rT9frTeHu9C9spxHio06g0FUO
         5hd7nl8JszNZ9JsUScP3+mc1O4HFwBGjK2BFqsojErPcZ4ynMUuOHFNH76cyoF0J6Xej
         xZI3tOWbWQXoQBq62eTZVlg3GFhen3Ce+d/sWsAHcCGWjjhU2IN1tGDGYvGGMKkrwiVZ
         1aGAodYB94f/YZUFo9Fqb6i1SrGnGvLOLceDr5txNsLGqhEpjGY8L8u5A8oC+pAdkIlI
         W54g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P421F/GOg58FrtBIy3dQLQWF/Mue7ayz0hctz4juYTQ=;
        b=KNj7oLWU4uTIu/zdIGR3CvnnLfc3Qs/AMqgl+Rl2hKthbR1wEaE8l8z7vWsS/BDD7r
         42ArYrUQGVbRulyQEhLYCmTCE1J2GLXaSAVUUcyfIUWJoXrwV+7gRKPuRx9kEwiVgre4
         UzkZ7WTavtYKUl338RJKTwpw/SUsf3eZW8Hp+WZss55nkgpKYFWgyRSUAIxacMGTcp7D
         cNE5V2EQ6BF4tdHM6Jw8U2gQv5I9qJ/Mjn4Brcqu4r8gp0ciC20K/viDtMJvBCW2b3W5
         PTlplFdqw7occT5QEwaJeuXVs+gcfFXemY8KoeR4V3TE8RvB80iRRWNdKL7P3kalBqn7
         Ng2w==
X-Gm-Message-State: AFqh2komQJ/BhSZnKqL2P4BvBi/cIbk9HR86GaiRvw/4O5ICOt6lTLuz
        SMuYpOylW0jQvrVpvY26BhflK5hpjAT2cRpy3WoMXHEhZd7PaA==
X-Google-Smtp-Source: AMrXdXtdCdChbbrWCUbfU4iwVAkBC69L40w6JpxCHdjpkKnZfAJ8/m46D3W9JYdMsaMvUxTNHyj49nAy5g0pRnUeXYc=
X-Received: by 2002:a92:cb87:0:b0:30c:877:db26 with SMTP id
 z7-20020a92cb87000000b0030c0877db26mr2375591ilo.101.1672755587083; Tue, 03
 Jan 2023 06:19:47 -0800 (PST)
MIME-Version: 1.0
References: <20221212173238.963128-1-jannh@google.com> <Y5rDDBl07kjQmnTa@kroah.com>
In-Reply-To: <Y5rDDBl07kjQmnTa@kroah.com>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 3 Jan 2023 15:19:10 +0100
Message-ID: <CAG48ez3ZnCftnn9KJz=QPfRmxztS9dF-Qa2K55ycbBtA4CE8qw@mail.gmail.com>
Subject: Re: [PATCH v2 stable 4.19 1/2] mm/khugepaged: fix GUP-fast
 interaction by sending IPI
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Dec 15, 2022 at 7:47 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Dec 12, 2022 at 06:32:35PM +0100, Jann Horn wrote:
> > Since commit 70cbc3cc78a99 ("mm: gup: fix the fast GUP race against THP
> > collapse"), the lockless_pages_from_mm() fastpath rechecks the pmd_t to
> > ensure that the page table was not removed by khugepaged in between.
> >
> > However, lockless_pages_from_mm() still requires that the page table is
> > not concurrently freed.  Fix it by sending IPIs (if the architecture uses
> > semi-RCU-style page table freeing) before freeing/reusing page tables.
> >
> > Link: https://lkml.kernel.org/r/20221129154730.2274278-2-jannh@google.com
> > Link: https://lkml.kernel.org/r/20221128180252.1684965-2-jannh@google.com
> > Link: https://lkml.kernel.org/r/20221125213714.4115729-2-jannh@google.com
> > Fixes: ba76149f47d8 ("thp: khugepaged")
> > Signed-off-by: Jann Horn <jannh@google.com>
> > Reviewed-by: Yang Shi <shy828301@gmail.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > [manual backport: two of the three places in khugepaged that can free
> > ptes were refactored into a common helper between 5.15 and 6.0;
> > TLB flushing was refactored between 5.4 and 5.10;
> > TLB flushing was refactored between 4.19 and 5.4;
> > pmd collapse for PTE-mapped THP was only added in 5.4;
> > ugly hack needed in <=4.19 for s390]
> > Signed-off-by: Jann Horn <jannh@google.com>
>
> All now queued up, thanks for the backports!

Uuugh, as reported by the kernel test robot, when you build this code
on 32-bit ARM with LPAE, it fails to build. The robot reported it for
4.14 but it also applies to 4.19. I'll go and fix this up again for
<=4.19...
