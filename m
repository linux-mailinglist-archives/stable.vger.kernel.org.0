Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3117D396B9C
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 04:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhFACu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 22:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbhFACuy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 22:50:54 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FB1C06174A
        for <stable@vger.kernel.org>; Mon, 31 May 2021 19:49:13 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 6so9604453pgk.5
        for <stable@vger.kernel.org>; Mon, 31 May 2021 19:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ad/ebKGk9z3z3I+HUu58qVArVkz4m/aeRPexM3Rwwvk=;
        b=DiNt3xGYt7qf+8T6SJ1WUnMXg7DsokaGU9mI4Ne5Q3bitizlguODLXOnhKqNglmr4v
         YH8HkasRyD4EH+WIXQB0Jh/KLyosjglvLy0nxgvPfzLmsbi1xHqCj2d12H69qU7gDrmD
         0PDNUhrEBkk0HavDfd7A/UZ/WWWpZrLCH/fad8emDV9MxtEwwc21VORuFCquYj0HcvhG
         9sOVgYv8RBqzZT5lBZGgyzn0Kzq1iSyFdyqZPSoO+ucmRKJPuIB2cIMXqaRYDMhVfKPl
         QCxm9OHPMREBqv5CKe+WKGWw0LLWlmFOCMQ3PRXCgEnI0DyR9mYQifNtUFk7yIQn6dmt
         2cUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ad/ebKGk9z3z3I+HUu58qVArVkz4m/aeRPexM3Rwwvk=;
        b=TTLN4LDJ+ZCGnFSoVSvzM2KH7RHAYUKoDuYkCeEox10IF3zHZI6+P3cD1BojhWpVyX
         g8/6+irK6t8O78Rchayy5rcRTl94BxS8EYTSKkUE2ukEeIRmWfV9DH5xylx5ZRM+EiHe
         0rjZ9oV3jzeaNOMQQ0rslUmCKMjBGFzQBnVpeyadCsQkvZNjgc2ENWoVcL7EdhfYg9NT
         y/64q+Aw2T4ccHfS6ptW08WtRTX+KG6VdJ400ao25xpw3R4vSxhR6O4ZMcd70aDs4NkD
         9oBr8hK82sdkbqcNXIz39t0oYnGP+YdsbFuYnq7WKd/kG5lL+si2A9t9556DUD4Q9acS
         Hn2w==
X-Gm-Message-State: AOAM530GSgXzqr0v23CqzFQgMih6mZNCnVHzoiMg9XBTO62szvFW1X0u
        FCxqeSdXJos+kqQ61mrblWzRMW4Sl8c0W1wf4XraJQ==
X-Google-Smtp-Source: ABdhPJxh9g8ZbvdaAcPE7c2eFiazXiNGXqYMv4e2dqHQxotNCcyONBCuqE8GBR8WPmbDYAhFyCsqOWt7LS9c1Jduv8I=
X-Received: by 2002:a63:3c56:: with SMTP id i22mr1858771pgn.291.1622515752547;
 Mon, 31 May 2021 19:49:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210528004649.85298-1-almasrymina@google.com> <20210531173733.615fd539396ff7a173a2bf8b@linux-foundation.org>
In-Reply-To: <20210531173733.615fd539396ff7a173a2bf8b@linux-foundation.org>
From:   Mina Almasry <almasrymina@google.com>
Date:   Mon, 31 May 2021 19:49:01 -0700
Message-ID: <CAHS8izO_-wK8GL9iK6HiG5xJc1unMLxO0uzFF20v4HKU36R8Ug@mail.gmail.com>
Subject: Re: [PATCH v4] mm, hugetlb: Fix simple resv_huge_pages underflow on UFFDIO_COPY
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 5:37 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu, 27 May 2021 17:46:49 -0700 Mina Almasry <almasrymina@google.com> wrote:
>
> > The userfaultfd hugetlb tests detect a resv_huge_pages underflow. This
> > happens when hugetlb_mcopy_atomic_pte() is called with !is_continue on
> > an index for which we already have a page in the cache. When this
> > happens, we allocate a second page, double consuming the reservation,
> > and then fail to insert the page into the cache and return -EEXIST.
> >
> > To fix this, we first if there exists a page in the cache which already
> > consumed the reservation, and return -EEXIST immediately if so.
> >
> > There is still a rare condition where we fail to copy the page contents
> > AND race with a call for hugetlb_no_page() for this index and again we
> > will underflow resv_huge_pages. That is fixed in a more complicated
> > patch not targeted for -stable.
> >
> > Test:
> > Hacked the code locally such that resv_huge_pages underflows produce
> > a warning, then:
> >
> > ./tools/testing/selftests/vm/userfaultfd hugetlb_shared 10
> >       2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success
> > ./tools/testing/selftests/vm/userfaultfd hugetlb 10
> >       2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success
> >
> > Both tests succeed and produce no warnings. After the
> > test runs number of free/resv hugepages is correct.
> >
> > Signed-off-by: Mina Almasry <almasrymina@google.com>
> > Cc: Axel Rasmussen <axelrasmussen@google.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: linux-mm@kvack.org
> > Cc: Mike Kravetz <mike.kravetz@oracle.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: stable@vger.kernel.org
>
> Do we have a Fixes: for this, or is it an always-been-there issue?

This reproduces as far back as 4.15 kernel. Looks like always-been-there issue.
