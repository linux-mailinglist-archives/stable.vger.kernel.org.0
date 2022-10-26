Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE15460E8D6
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 21:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbiJZTPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 15:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235060AbiJZTOq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 15:14:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD956220CD
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 12:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nCOnhMjmscm8bPUZz6PCeiG5cbfFh3NwA6L9CBIA2OM=; b=etraGE3/YTqfWWS7h31AsL9q+x
        KS66WDnU6wxQfL4k7NjmTFE7h+kXlhYIATiSBIgZ2egFTfNaglA0FlbqDf6NeD6RYo4FfP9zAVt5V
        2C/7Wu0K/vhMcZo9j8ZDpafjcI3/Jk4q8UlCNBUWYCULcvvpNsYCXzyr+cdb0XDE7ma2w9+JtFMKR
        5tuhe2cMVN2Z8yb2lyHm6eV8/qYJPAEk9yzAGfXD1XqD0rugPYjAfGI2F6itoRDIIqvmHlfo8MTbU
        gREfahxYz28kdY1j/BIYAdM9kIOHMGBr2CYo+96M34tmvDv+B2JAZVQdOHnULtibj3eRSuB0aCa61
        xJudGSug==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1onlpo-00HExC-1b; Wed, 26 Oct 2022 19:13:05 +0000
Date:   Wed, 26 Oct 2022 20:13:03 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Seth Jenkins <sethjenkins@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, Liam.Howlett@oracle.com,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH stable 4.19-5.19] mm: /proc/pid/smaps_rollup: fix no
 vma's null-deref
Message-ID: <Y1mGv8ydCfZbmU4U@casper.infradead.org>
References: <20221026162438.711738-1-sethjenkins@google.com>
 <Y1ljQBkfcCoLYTx+@kroah.com>
 <CALxfFW6a_Fe1rwbXf6LnG-1PvjtwLwGLHYYPr8c-Wda3NNJD8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALxfFW6a_Fe1rwbXf6LnG-1PvjtwLwGLHYYPr8c-Wda3NNJD8g@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 26, 2022 at 02:32:00PM -0400, Seth Jenkins wrote:
> Hi Greg,
> 
> The upstream commit that fixed the issue was not an intentional fix
> AFAIK, but a refactor to switch to maple tree VMA lookups. I was under
> the impression that there were no plans to backport maple trees back
> to stable trees but do let me know if that presumption is incorrect.

Backporting the maple tree to earlier kernels would be a giant upheaval.
I doubt it could ever be justified; certainly the need for this patch
would not be sufficient.  Not only would we have to backport the maple
tree data structure itself (which could be justified), but we'd also
have to redo the conversion of the VMAs from rbtree to maple tree.

> Assuming they're not getting backported, what do you think of this
> instead:
> c4c84f06285e on upstream resolves this issue as part of the switch to
> using maple trees for VMA lookups, but a fix must still be applied to
> stable trees 4.19-5.19.
> 
> On Wed, Oct 26, 2022 at 12:41 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Oct 26, 2022 at 12:24:38PM -0400, Seth Jenkins wrote:
> > > Commit 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value
> > > seq_file") introduced a null-deref if there are no vma's in the task in
> > > show_smaps_rollup.
> > >
> > > Fixes: 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value seq_file")
> > > Signed-off-by: Seth Jenkins <sethjenkins@google.com>
> > > Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
> > > Tested-by: Alexey Dobriyan <adobriyan@gmail.com>
> > > ---
> > > c4c84f06285e on upstream resolves this issue, but a fix must still be applied to stable trees 4.19-5.19.
> >
> > And you need to document really really really well why we can not take
> > that upstream commit please.
> >
> > Also note that 5.19.y is end-of-life.
> >
> > Please fix up and resend.
> >
> > thanks,
> >
> > greg k-h
