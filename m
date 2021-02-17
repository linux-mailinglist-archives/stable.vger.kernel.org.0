Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B576B31DF5C
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 20:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhBQTDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 14:03:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231239AbhBQTDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 14:03:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90D3E6186A;
        Wed, 17 Feb 2021 19:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613588572;
        bh=odEQGZsuO+lEqXY7esyTBK2QgwaJ1DoXNXR2BQ1SGlc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zOE7O/FpIEoPbTe+GWOPDp8/ki03sqzNLQavTgdbhGlzxCACNYMYDEhpwElSTFUBL
         Yfl2GW/J+6CTXv3m9VJE3WvAMVoOeEs9OSFrC0+zD5g5d9qL7KeS4Ny3PlR9JNKEre
         Mxh3+R1H1GFO9zDdiQ2Egb0nNz/TTDgN7jsz0T9E=
Date:   Wed, 17 Feb 2021 11:02:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Davidlohr Bueso <dbueso@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] hugetlb: fix update_and_free_page contig page
 struct assumption
Message-Id: <20210217110252.185c7f5cd5a87c3f7b0c0144@linux-foundation.org>
In-Reply-To: <20210217184926.33567-1-mike.kravetz@oracle.com>
References: <20210217184926.33567-1-mike.kravetz@oracle.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 17 Feb 2021 10:49:25 -0800 Mike Kravetz <mike.kravetz@oracle.com> wrote:

> page structs are not guaranteed to be contiguous for gigantic pages.  The
> routine update_and_free_page can encounter a gigantic page, yet it assumes
> page structs are contiguous when setting page flags in subpages.
> 
> If update_and_free_page encounters non-contiguous page structs, we can
> see “BUG: Bad page state in process …” errors.
> 
> Non-contiguous page structs are generally not an issue.  However, they can
> exist with a specific kernel configuration and hotplug operations.  For
> example: Configure the kernel with CONFIG_SPARSEMEM and
> !CONFIG_SPARSEMEM_VMEMMAP.  Then, hotplug add memory for the area where the
> gigantic page will be allocated.
> Zi Yan outlined steps to reproduce here [1].
> 
> [1] https://lore.kernel.org/linux-mm/16F7C58B-4D79-41C5-9B64-A1A1628F4AF2@nvidia.com/
> 
> Fixes: 944d9fec8d7a ("hugetlb: add support for gigantic page allocation at runtime")

June 2014.  That's a long lurk time for a bug.  I wonder if some later
commit revealed it.

I guess it doesn't matter a lot, but some -stable kernel maintainers
might wonder if they really need this fix...


