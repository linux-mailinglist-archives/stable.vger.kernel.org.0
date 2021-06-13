Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1230B3A5960
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 17:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhFMP1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 11:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231782AbhFMP1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 13 Jun 2021 11:27:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0162F61040;
        Sun, 13 Jun 2021 15:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623597950;
        bh=lL30hCZuGJ/MUVZMNgStCbD9n1DnvzAhrTqwMKJ7P0M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PqY8/rjNpDw4kI0M6NyJWPVi/+ZVEs0gvHUQ9V2QV1mZI5re11obpdwMFdwKRRBIb
         ho/nB4yJYP41mSgmD8kvCmQfzfSZasno6kmsLv5dar/aaI3FLaF8ZNkXYCn+Sm0LXz
         CMgUhWIHJPgm0p0kkptutvs4ByYUzsM7TsoZ/3qnOCvw2bK3UgUfBsZpwgRu0VbXVf
         y+i63CQ14Q1qXlKuImYwwOENMgjeqEb6aRL9Syx1I8ffJM6AYgiGGHP/Uf61JaR+ZD
         IMJL5x4BZ30huzT7hOv5iXmrnWXIf717jrtvbOE3+ugJDyud13LBfAEu1OnLxIcfOn
         V2/13mJxX6M+Q==
Message-ID: <04174e6beaff47fb4dc32ff6cc32ae8667008edd.camel@kernel.org>
Subject: Re: [PATCH v4] ceph: fix write_begin optimization when write is
 beyond EOF
From:   Jeff Layton <jlayton@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     ceph-devel@vger.kernel.org, linux-cachefs@redhat.com,
        pfmeec@rit.edu, dhowells@redhat.com, idryomov@gmail.com,
        stable@vger.kernel.org, Andrew W Elble <aweits@rit.edu>
Date:   Sun, 13 Jun 2021 11:25:48 -0400
In-Reply-To: <YMYg+dYOhSVGg58R@casper.infradead.org>
References: <YMXmRo17oy8fDn2b@casper.infradead.org>
         <20210613113650.8672-1-jlayton@kernel.org>
         <a58a297994700b95c85c15bc13e830ecb7ac61e7.camel@kernel.org>
         <YMYg+dYOhSVGg58R@casper.infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2021-06-13 at 16:15 +0100, Matthew Wilcox wrote:
> On Sun, Jun 13, 2021 at 08:02:12AM -0400, Jeff Layton wrote:
> > > +	/* clamp length to end of the current page */
> > > +	if (len > PAGE_SIZE)
> > > +		len = PAGE_SIZE - offset;
> > 
> > Actually, I think this should be:
> > 
> > 	len = min(len, PAGE_SIZE - offset);
> > 
> > Otherwise, len could still go beyond the end of the page.
> 
> I don't understand why you want to clamp length instead of just coping
> with len being > PAGE_SIZE.
> 
> > > +
> > > +	/* full page write */
> > > +	if (offset == 0 && len == PAGE_SIZE)
> > > +		goto zero_out;
> 
> That becomes >=.
> 
> > > +	/* zero-length file */
> > > +	if (i_size == 0)
> > > +		goto zero_out;
> > > +
> > > +	/* position beyond last page in the file */
> > > +	if (index > ((i_size - 1) / PAGE_SIZE))
> > > +		goto zero_out;
> > > +
> > > +	/* write that covers the the page from start to EOF or beyond it */
> > > +	if (offset == 0 && (pos + len) >= i_size)
> > > +		goto zero_out;
> 
> That doesn't need any change.
> 
> > > +	return false;
> > > +zero_out:
> > > +	zero_user_segments(page, 0, offset, offset + len, PAGE_SIZE);
> 
> That also doesn't need any change.
> 

Won't it though? offset+len will could be beyond the end of the page at
that point. Hmm I guess zero_user_segments does this:

        if (start2 >= end2)
                start2 = end2 = 0;

...so that makes the second segment copy a no-op.

Ok, fair enough -- I'll get rid of the clamping and just allow len to be
longer than PAGE_SIZE in the checks.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

