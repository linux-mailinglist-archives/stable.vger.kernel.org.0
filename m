Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCE264D69C
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 07:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiLOGry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 01:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLOGrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 01:47:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F000555A8B
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 22:47:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D83E61C64
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 06:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F1BC433D2;
        Thu, 15 Dec 2022 06:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671086872;
        bh=j4VB43+7zCV40L1yfU2umCljYzs+qBybGDnPbjk0jXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dvs6u/xZ203YnqIJkAUpo3dWz4mNbQK/VgeFrl30/sSrv+/C0ZX1V+abCpq25cpX6
         ST8QF0uLwfAncg4+B2PcTBcXN28UWiLqtpYO21Mk6RW0vLhpAo4e9JZawlNDXjXQ2T
         vZPzQ8eQvnYMT1Fj7CD1JG+4CBiOR4Xs8WiCKyuU=
Date:   Thu, 15 Dec 2022 07:47:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jann Horn <jannh@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 stable 4.19 1/2] mm/khugepaged: fix GUP-fast
 interaction by sending IPI
Message-ID: <Y5rDDBl07kjQmnTa@kroah.com>
References: <20221212173238.963128-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212173238.963128-1-jannh@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 06:32:35PM +0100, Jann Horn wrote:
> Since commit 70cbc3cc78a99 ("mm: gup: fix the fast GUP race against THP
> collapse"), the lockless_pages_from_mm() fastpath rechecks the pmd_t to
> ensure that the page table was not removed by khugepaged in between.
> 
> However, lockless_pages_from_mm() still requires that the page table is
> not concurrently freed.  Fix it by sending IPIs (if the architecture uses
> semi-RCU-style page table freeing) before freeing/reusing page tables.
> 
> Link: https://lkml.kernel.org/r/20221129154730.2274278-2-jannh@google.com
> Link: https://lkml.kernel.org/r/20221128180252.1684965-2-jannh@google.com
> Link: https://lkml.kernel.org/r/20221125213714.4115729-2-jannh@google.com
> Fixes: ba76149f47d8 ("thp: khugepaged")
> Signed-off-by: Jann Horn <jannh@google.com>
> Reviewed-by: Yang Shi <shy828301@gmail.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> [manual backport: two of the three places in khugepaged that can free
> ptes were refactored into a common helper between 5.15 and 6.0;
> TLB flushing was refactored between 5.4 and 5.10;
> TLB flushing was refactored between 4.19 and 5.4;
> pmd collapse for PTE-mapped THP was only added in 5.4;
> ugly hack needed in <=4.19 for s390]
> Signed-off-by: Jann Horn <jannh@google.com>

All now queued up, thanks for the backports!

greg k-h
