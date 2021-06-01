Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCBEF396A5D
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 02:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhFAAjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 20:39:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232366AbhFAAjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 20:39:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7C40611CB;
        Tue,  1 Jun 2021 00:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622507853;
        bh=hSbXTlNRap0TMykMgzRT7IHS4sVlT83yO/koAonPLlA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RBTnngxJml+laVwubXrQR8E8jWDxGtOczjthaJsEsiFZEGtTS2TxAFAS3cMh/hQb3
         +IUuEX8weZK4X1Clyws1J/IpWtKNfwgoTfieywpzzejOM99a+Xtfq83W5qfkQ4ZkyN
         l00OS8KceYts5fsaG+zTfmJ94VoKP9ElU/lLTeQY=
Date:   Mon, 31 May 2021 17:37:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Mina Almasry <almasrymina@google.com>
Cc:     Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
        Mike Kravetz <mike.kravetz@oracle.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] mm, hugetlb: Fix simple resv_huge_pages underflow on
 UFFDIO_COPY
Message-Id: <20210531173733.615fd539396ff7a173a2bf8b@linux-foundation.org>
In-Reply-To: <20210528004649.85298-1-almasrymina@google.com>
References: <20210528004649.85298-1-almasrymina@google.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 May 2021 17:46:49 -0700 Mina Almasry <almasrymina@google.com> wrote:

> The userfaultfd hugetlb tests detect a resv_huge_pages underflow. This
> happens when hugetlb_mcopy_atomic_pte() is called with !is_continue on
> an index for which we already have a page in the cache. When this
> happens, we allocate a second page, double consuming the reservation,
> and then fail to insert the page into the cache and return -EEXIST.
> 
> To fix this, we first if there exists a page in the cache which already
> consumed the reservation, and return -EEXIST immediately if so.
> 
> There is still a rare condition where we fail to copy the page contents
> AND race with a call for hugetlb_no_page() for this index and again we
> will underflow resv_huge_pages. That is fixed in a more complicated
> patch not targeted for -stable.
> 
> Test:
> Hacked the code locally such that resv_huge_pages underflows produce
> a warning, then:
> 
> ./tools/testing/selftests/vm/userfaultfd hugetlb_shared 10
> 	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success
> ./tools/testing/selftests/vm/userfaultfd hugetlb 10
> 	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success
> 
> Both tests succeed and produce no warnings. After the
> test runs number of free/resv hugepages is correct.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: linux-mm@kvack.org
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org

Do we have a Fixes: for this, or is it an always-been-there issue?
