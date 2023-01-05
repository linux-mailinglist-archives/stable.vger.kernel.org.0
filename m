Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED3065E2AC
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 02:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjAEBvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 20:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjAEBu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 20:50:59 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD13B0E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 17:50:57 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so263434wms.4
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 17:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yqfl4xJm+Wld0bPquuUz0o/yojxexveabYMG4JIRCRw=;
        b=Qok5PnDts10sjUXsNh9QcIsGF42bksh+y/PzDySJHxG0qPjMJGnjJu0D2IBu9Ljw0S
         bKWr6Oqgz24nXkftP02bkHPGE8PGfIlchPKVTQnioZ97vJ913mBvaoPzir/3gmdnj6S6
         p0ml9kjP1sgAvonF5uWIf39mt9iE4GT9DeJ4WxTIHqdXOXm6zVA8Y4SKKWQ3qHgdfGJ6
         6yGt7L2qZyt+ECDwFtr8DARAUHVnH2qTtZKmiwW33+gJILmfie2jXi7MtqyWDrpEpz0k
         sS6J6yd414UxQsb2UE8WdLl74rUmPEEv7VskJ2+2+kzkNqcLSXHpt/wxBVa0neVubM2o
         SQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yqfl4xJm+Wld0bPquuUz0o/yojxexveabYMG4JIRCRw=;
        b=puyafeoTpCHASxoGhaDtx6AMR69EJfrjFGs1t3wHpIkQ03ZyMiQgkD0cRdLo5BtX3Q
         8A+yMvIcFZVBqdXjaQpgsTIaYa+kCLbMaJWALDjGht+YhnHT1W3hFoP/bVVnBvDuo2Qx
         6i/NYQYZsurAkyEuxpcTp7STMPwZBGfq7DpBaFrkpgXez9PUdJM1fgkvq0NEZDFFMfWL
         XrHwEoZmRwp6JZw3SU6C4Do4Bn/gRt2a8xS0JJK9NS8bxqIjoGoQW91Ru7JkY92Cg7Zr
         tQ249Fu/Gu6RqKEqfDgtOiw82h8cAIdEUuB6b+s1TJLe6FNVXqXLLq3YJWm41sFBAbVw
         I++w==
X-Gm-Message-State: AFqh2kom/O702B8hjPy9NuXC0cS1L0gB/fUXf5l2Mn5oE0n3Pd0J2u3i
        vIdYWnzHVSOwHMqEOzGvY4dbAYX0f15k4tGiy41YOA==
X-Google-Smtp-Source: AMrXdXtg7ahs4squVQDsseVSKq1N8Am3Wh9SCbdeRbHyzAK0hNiDqhlUbY8czXt2TEKWbAPu6YgC6GQxpY54u1pUQ9k=
X-Received: by 2002:a05:600c:4b95:b0:3d1:da8c:7869 with SMTP id
 e21-20020a05600c4b9500b003d1da8c7869mr2632215wmp.26.1672883455586; Wed, 04
 Jan 2023 17:50:55 -0800 (PST)
MIME-Version: 1.0
References: <20230104225207.1066932-1-peterx@redhat.com> <20230104225207.1066932-2-peterx@redhat.com>
In-Reply-To: <20230104225207.1066932-2-peterx@redhat.com>
From:   James Houghton <jthoughton@google.com>
Date:   Thu, 5 Jan 2023 01:50:42 +0000
Message-ID: <CADrL8HW0cJn+kuPp5CD1ponepDsBpyfDQEDP3cYjdxcK6uC5Rw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/hugetlb: Pre-allocate pgtable pages for uffd wr-protects
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 4, 2023 at 10:52 PM Peter Xu <peterx@redhat.com> wrote:
>
> Userfaultfd-wp uses pte markers to mark wr-protected pages for both shmem
> and hugetlb.  Shmem has pre-allocation ready for markers, but hugetlb path
> was overlooked.
>
> Doing so by calling huge_pte_alloc() if the initial pgtable walk fails to
> find the huge ptep.  It's possible that huge_pte_alloc() can fail with high
> memory pressure, in that case stop the loop immediately and fail silently.
> This is not the most ideal solution but it matches with what we do with
> shmem meanwhile it avoids the splat in dmesg.
>
> Cc: linux-stable <stable@vger.kernel.org> # 5.19+
> Fixes: 60dfaad65aa9 ("mm/hugetlb: allow uffd wr-protect none ptes")
> Reported-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/hugetlb.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

Acked-by: James Houghton <jthoughton@google.com>
