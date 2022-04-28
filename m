Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF94513A8C
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 18:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350225AbiD1RBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 13:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237800AbiD1RBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 13:01:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641B0B7C79;
        Thu, 28 Apr 2022 09:58:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 091D8620DA;
        Thu, 28 Apr 2022 16:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1614DC385A0;
        Thu, 28 Apr 2022 16:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651165108;
        bh=rRYfPKxgxNtuctLNZINx2WjTVD0L+QQFc8NiveAo8F4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t/rk7yYn0zKRWE6t/17O1ULZRsOkTRCl+d9FFhnNgShNSFNe+bgVQBZDPZ1wPpnak
         ANgOu2G6CbMGLpMZbytpRsB6tyljM4jd7bmpiiqmyWcw8HE5vGPskOdkxoMoKGeLLk
         ibBcqiqXFQwq4QhYrbwpSmZyVRBB8GZgi3naOxdY=
Date:   Thu, 28 Apr 2022 18:58:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Shi <shy828301@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH AUTOSEL 13/14] mm/thp: ClearPageDoubleMap in first
 page_add_file_rmap()
Message-ID: <YmrHsVZTEzqIDiKd@kroah.com>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
 <20220428154222.1230793-13-gregkh@linuxfoundation.org>
 <c2ed1fe1-247e-e644-c367-87d32eb92cf5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2ed1fe1-247e-e644-c367-87d32eb92cf5@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 28, 2022 at 09:51:58AM -0700, Hugh Dickins wrote:
> On Thu, 28 Apr 2022, Greg Kroah-Hartman wrote:
> 
> > From: Hugh Dickins <hughd@google.com>
> > 
> > commit bd55b0c2d64e84a75575f548a33a3dfecc135b65 upstream.
> > 
> > PageDoubleMap is maintained differently for anon and for shmem+file: the
> > shmem+file one was never cleared, because a safe place to do so could
> > not be found; so it would blight future use of the cached hugepage until
> > evicted.
> > 
> > See https://lore.kernel.org/lkml/1571938066-29031-1-git-send-email-yang.shi@linux.alibaba.com/
> > 
> > But page_add_file_rmap() does provide a safe place to do so (though later
> > than one might wish): allowing testing to return to an initial state
> > without a damaging drop_caches.
> > 
> > Link: https://lkml.kernel.org/r/61c5cf99-a962-9a25-597a-53ab1bd8fbc0@google.com
> > Fixes: 9a73f61bdb8a ("thp, mlock: do not mlock PTE-mapped file huge pages")
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > Reviewed-by: Yang Shi <shy828301@gmail.com>
> > Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> NAK.
> 
> I thought we had a long-standing agreement that AUTOSEL does not try
> to add patches from akpm's tree which had not been marked for stable.

True, this was my attempt at saying "hey these all look like they should
go to stable trees, why not?"

> I've chosen to answer to this patch of my 3 in your 14 AUTOSELs,
> because this one is just an improvement, not at all a bugfix needed
> for stable (maybe AUTOSEL noticed "racy" or "safely" in the comments,
> and misunderstood).  The "Fixes" was intended to help any humans who
> wanted to backport into their trees.

This all was off of the Fixes: tag.  Again, if these commits fix
something why are they not for stable?  I'm a human asking to backport
these into the stable trees based on that :)

> I do recall that this 13/14, and 14/14, are mods to mm/rmap.c
> which followed other (mm/munlock) mods to mm/rmap.c in 5.18-rc1,
> which affected the out path of the function involved, and somehow
> made 14/14 a little cleaner.  I'm sorry, but I just don't rate it
> worth my time at the moment, to verify whether 14/14 happens to
> have ended up as a correct patch or not.
> 
> And nobody can verify them without these AUTOSELs saying to which
> tree they are targeted - 5.17 I suppose.

5.17 to start with, older ones based on where the Fixes: tags went to.

So do you really want me to drop these?  I will but why are you adding
fixes: tags if you don't want people to take them?

thanks,

greg k-h
