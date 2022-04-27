Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD4F51640E
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 13:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345232AbiEAL2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 07:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiEAL2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 07:28:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595D25F8D6
        for <stable@vger.kernel.org>; Sun,  1 May 2022 04:25:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2F3DB80B52
        for <stable@vger.kernel.org>; Sun,  1 May 2022 11:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44686C385AA;
        Sun,  1 May 2022 11:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651404303;
        bh=R4dogtmuNKqT2Go0dKikPNtfQXV5BL31dAZTPnaL32I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iBM0zDbte6BnzxTpb5G0CmNfO0PWX8BklaSw/XiUJwCKex6AH4Q4vpz78Slgjn83J
         QGX+NR9+5yWZteIA1rKNSCrN9b7akGMZX6F5Qu0wFwcLVQDy4ay3K9/NwWQ/sMi1Xg
         pDlO2JMsO6agxt2rMpKsS+bylFS+srIB6OI4dRN4=
Date:   Wed, 27 Apr 2022 07:37:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Partha Sarathi Satapathy <partha.satapathy@oracle.com>
Cc:     linux_uek_grp@oracle.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: fix VM_BUG_ON(PageTail) and BUG_ON(PageWriteback)
Message-ID: <YmjWh44pNkpg+PUV@kroah.com>
References: <1651034789-32295-1-git-send-email-partha.satapathy@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1651034789-32295-1-git-send-email-partha.satapathy@oracle.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 27, 2022 at 04:46:28AM +0000, Partha Sarathi Satapathy wrote:
> From: Hugh Dickins <hughd@google.com>
> 
> Twice now, when exercising ext4 looped on shmem huge pages, I have crashed
> on the PF_ONLY_HEAD check inside PageWaiters(): ext4_finish_bio() calling
> end_page_writeback() calling wake_up_page() on tail of a shmem huge page,
> no longer an ext4 page at all.
> 
> The problem is that PageWriteback is not accompanied by a page reference
> (as the NOTE at the end of test_clear_page_writeback() acknowledges): as
> soon as TestClearPageWriteback has been done, that page could be removed
> from page cache, freed, and reused for something else by the time that
> wake_up_page() is reached.
> 
> https://lore.kernel.org/linux-mm/20200827122019.GC14765@casper.infradead.org/
> Matthew Wilcox suggested avoiding or weakening the PageWaiters() tail
> check; but I'm paranoid about even looking at an unreferenced struct page,
> lest its memory might itself have already been reused or hotremoved (and
> wake_up_page_bit() may modify that memory with its ClearPageWaiters()).
> 
> Then on crashing a second time, realized there's a stronger reason against
> that approach.  If my testing just occasionally crashes on that check,
> when the page is reused for part of a compound page, wouldn't it be much
> more common for the page to get reused as an order-0 page before reaching
> wake_up_page()?  And on rare occasions, might that reused page already be
> marked PageWriteback by its new user, and already be waited upon?  What
> would that look like?
> 
> It would look like BUG_ON(PageWriteback) after wait_on_page_writeback()
> in write_cache_pages() (though I have never seen that crash myself).
> 
> Matthew Wilcox explaining this to himself:
>  "page is allocated, added to page cache, dirtied, writeback starts,
> 
>   --- thread A ---
>   filesystem calls end_page_writeback()
>         test_clear_page_writeback()
>   --- context switch to thread B ---
>   truncate_inode_pages_range() finds the page, it doesn't have writeback set,
>   we delete it from the page cache.  Page gets reallocated, dirtied, writeback
>   starts again.  Then we call write_cache_pages(), see
>   PageWriteback() set, call wait_on_page_writeback()
>   --- context switch back to thread A ---
>   wake_up_page(page, PG_writeback);
>   ... thread B is woken, but because the wakeup was for the old use of
>   the page, PageWriteback is still set.
> 
>   Devious"
> 
> And prior to 2a9127fcf229 ("mm: rewrite wait_on_page_bit_common() logic")
> this would have been much less likely: before that, wake_page_function()'s
> non-exclusive case would stop walking and not wake if it found Writeback
> already set again; whereas now the non-exclusive case proceeds to wake.
> 
> I have not thought of a fix that does not add a little overhead: the
> simplest fix is for end_page_writeback() to get_page() before calling
> test_clear_page_writeback(), then put_page() after wake_up_page().
> 
> Was there a chance of missed wakeups before, since a page freed before
> reaching wake_up_page() would have PageWaiters cleared?  I think not,
> because each waiter does hold a reference on the page.  This bug comes
> when the old use of the page, the one we do TestClearPageWriteback on,
> had *no* waiters, so no additional page reference beyond the page cache
> (and whoever racily freed it).  The reuse of the page has a waiter
> holding a reference, and its own PageWriteback set; but the belated
> wake_up_page() has woken the reuse to hit that BUG_ON(PageWriteback).
> 
> Orabug: 33634162
> 
> Reported-by: syzbot+3622cea378100f45d59f@syzkaller.appspotmail.com
> Reported-by: Qian Cai <cai@lca.pw>
> Fixes: 2a9127fcf229 ("mm: rewrite wait_on_page_bit_common() logic")
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: stable@vger.kernel.org # v5.8+
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> (cherry picked from commit 073861ed77b6b957c3c8d54a11dc503f7d986ceb)
> Signed-off-by: Partha Sarathi Satapathy <partha.satapathy@oracle.com>

What stable kernel(s) are you wanting this backported to?  It's already
in the 5.10 release and shouldn't go further back than 5.9.

confused,

greg k-h
