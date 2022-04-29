Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1425148EE
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 14:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358945AbiD2MQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 08:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358940AbiD2MQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 08:16:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25FAB89A5;
        Fri, 29 Apr 2022 05:13:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BCEF6211A;
        Fri, 29 Apr 2022 12:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39947C385A7;
        Fri, 29 Apr 2022 12:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651234385;
        bh=jw3d4LjLrONS5HEaxrtjgz2gOcFZwXgKxK34kfuT4Fo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cuaxore1r67I0zMIAh5pfZjIzO8Mw3KTAeSh0/X2rmMZWK+F6NQQnlz7gSV20veKC
         7aUzCdcz3ur6BsW+hQHcRVS/oS3cX1Tp5bfJjCRbKdiMtl9g1+35n/D3kYP+yx7oSx
         Pz3POg2/Nv/zv2inYg+xG+eumP5KQS1IqXRX5qtg=
Date:   Fri, 29 Apr 2022 14:13:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Hugh Dickins <hughd@google.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Shi <shy828301@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-mm@kvack.org, Sasha Levin <sashal@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH AUTOSEL 13/14] mm/thp: ClearPageDoubleMap in first
 page_add_file_rmap()
Message-ID: <YmvWTrT+3jaWHpkC@kroah.com>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
 <20220428154222.1230793-13-gregkh@linuxfoundation.org>
 <c2ed1fe1-247e-e644-c367-87d32eb92cf5@google.com>
 <YmrHsVZTEzqIDiKd@kroah.com>
 <bec6e6cf-daa7-d632-7f81-471acba69c9d@google.com>
 <YmsY/n+yXkoEaqqr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmsY/n+yXkoEaqqr@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 28, 2022 at 10:45:18PM +0000, Sean Christopherson wrote:
> +Sasha and Paolo
> 
> On Thu, Apr 28, 2022, Hugh Dickins wrote:
> > On Thu, 28 Apr 2022, Greg Kroah-Hartman wrote:
> > > On Thu, Apr 28, 2022 at 09:51:58AM -0700, Hugh Dickins wrote:
> > > > On Thu, 28 Apr 2022, Greg Kroah-Hartman wrote:
> > > > 
> > > > > From: Hugh Dickins <hughd@google.com>
> > > > > 
> > > > > commit bd55b0c2d64e84a75575f548a33a3dfecc135b65 upstream.
> > > > > 
> > > > > PageDoubleMap is maintained differently for anon and for shmem+file: the
> > > > > shmem+file one was never cleared, because a safe place to do so could
> > > > > not be found; so it would blight future use of the cached hugepage until
> > > > > evicted.
> > > > > 
> > > > > See https://lore.kernel.org/lkml/1571938066-29031-1-git-send-email-yang.shi@linux.alibaba.com/
> > > > > 
> > > > > But page_add_file_rmap() does provide a safe place to do so (though later
> > > > > than one might wish): allowing testing to return to an initial state
> > > > > without a damaging drop_caches.
> > > > > 
> > > > > Link: https://lkml.kernel.org/r/61c5cf99-a962-9a25-597a-53ab1bd8fbc0@google.com
> > > > > Fixes: 9a73f61bdb8a ("thp, mlock: do not mlock PTE-mapped file huge pages")
> > > > > Signed-off-by: Hugh Dickins <hughd@google.com>
> > > > > Reviewed-by: Yang Shi <shy828301@gmail.com>
> > > > > Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > 
> > > > NAK.
> > > > 
> > > > I thought we had a long-standing agreement that AUTOSEL does not try
> > > > to add patches from akpm's tree which had not been marked for stable.
> > > 
> > > True, this was my attempt at saying "hey these all look like they should
> > > go to stable trees, why not?"
> > 
> > Okay, it seems I should have read "AUTOSEL" as "Hey, GregKH here,
> > these all look like they should go to stable trees, why not?",
> > which would have drawn a friendlier response.
> 
> FWIW, Sasha has been using MANUALSEL for the KVM tree to solicit an explicit ACK
> from Paolo for these types of patches.  AFAICT, it has been working quite well.

Yes, that is what I should have put here, sorry about that.  These were
manually picked by me and I am asking if they should be included or not.
I'll resend after dropping Hugh's patches from the series.

thanks,

greg k-h
