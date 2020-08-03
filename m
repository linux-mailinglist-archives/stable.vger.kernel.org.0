Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC0A23B083
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 00:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgHCWwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 18:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgHCWwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 18:52:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94144C06174A;
        Mon,  3 Aug 2020 15:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=b+URD2kuuxPvQN0WgLKZwbxYQpwUjRiQmsZqq1/8gQs=; b=dkPCs+mrjBgij3TZqvL8qsr16Y
        IazgD9Jl2F9O87Yk9A4tJ3yTMOx8XVdgwrulePxCaZb2jkP8S1Lrj/3NnKzYdEBSr8USXuFf0WKNI
        dmdAqWJlxSyoUoTI5+KddVB5aeVeN/yHmb5JQoirM3m/rbmRarVgyZB2rXMIwJv53dsQt0/vYq9Xm
        src4tTj+2BwAPXXjIcabkGedEMXvjFGnmj+18v6UaDktuwbWFwl8gDN75XXlZ0D+pEbY562LIK0iP
        uynQizi3Zc7DMKmZxkZU+bSNGXqbVj3GWaBoSiH57EB8ZyNhkF1DxmKCU9DbhQMj9g/b8vQhwRmLd
        5elqjUww==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k2jJq-0005tT-Au; Mon, 03 Aug 2020 22:52:34 +0000
Date:   Mon, 3 Aug 2020 23:52:34 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Prakash Sangappa <prakash.sangappa@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] hugetlbfs: remove call to huge_pte_alloc without
 i_mmap_rwsem
Message-ID: <20200803225234.GD23808@casper.infradead.org>
References: <20200803224335.55794-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803224335.55794-1-mike.kravetz@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 03, 2020 at 03:43:35PM -0700, Mike Kravetz wrote:
> Commit c0d0381ade79 ("hugetlbfs: use i_mmap_rwsem for more pmd sharing
> synchronization") requires callers of huge_pte_alloc to hold i_mmap_rwsem
> in at least read mode.  This is because the explicit locking in
> huge_pmd_share (called by huge_pte_alloc) was removed.  When restructuring
> the code, the call to huge_pte_alloc in the else block at the beginning
> of hugetlb_fault was missed.

Should we have a call to mmap_assert_locked() in huge_pte_alloc(),
at least the generic one?
