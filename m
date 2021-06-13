Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847B43A5948
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 17:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhFMPRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 11:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbhFMPRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 11:17:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7893C061574;
        Sun, 13 Jun 2021 08:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=v98zU0j/C6eV6H036hdUoeCGabSgBkr+f3noxRgGg0w=; b=jkiVo7PoDoav/f/Yu12SWrXrPO
        K2LfqUn41R17NKRPAe9Ce4z3jncIm2SaRlYt0R0Rbn9TzMa+caKUS3fTbz7WVoU5GXXqoI9T8NOxo
        ZA+259/CVDbq/nczC4MkMwa4OZBgSG49/KQRj3KxgoKo1d2C0UIDzET4ZEqJwB8gGxJsSTsqm1q0M
        0Gcg+ym9OnioCBhRTTWgmRjy//rz2gq+Fn3ZrA7f/RnyaVaSUbHPIVQT3a0fJin0slPJTMPWSa7o0
        zrMcRsm0aNb7JlwKlKlXW2hMKacpOnSMk+ayUMvXv52uhQmQuQ+5vMY/SS1qhTI2/tsKvjFqQNkHE
        z3cZTxIQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lsRpJ-004bY9-Px; Sun, 13 Jun 2021 15:15:10 +0000
Date:   Sun, 13 Jun 2021 16:15:05 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-cachefs@redhat.com,
        pfmeec@rit.edu, dhowells@redhat.com, idryomov@gmail.com,
        stable@vger.kernel.org, Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH v4] ceph: fix write_begin optimization when write is
 beyond EOF
Message-ID: <YMYg+dYOhSVGg58R@casper.infradead.org>
References: <YMXmRo17oy8fDn2b@casper.infradead.org>
 <20210613113650.8672-1-jlayton@kernel.org>
 <a58a297994700b95c85c15bc13e830ecb7ac61e7.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a58a297994700b95c85c15bc13e830ecb7ac61e7.camel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 13, 2021 at 08:02:12AM -0400, Jeff Layton wrote:
> > +	/* clamp length to end of the current page */
> > +	if (len > PAGE_SIZE)
> > +		len = PAGE_SIZE - offset;
> 
> Actually, I think this should be:
> 
> 	len = min(len, PAGE_SIZE - offset);
> 
> Otherwise, len could still go beyond the end of the page.

I don't understand why you want to clamp length instead of just coping
with len being > PAGE_SIZE.

> > +
> > +	/* full page write */
> > +	if (offset == 0 && len == PAGE_SIZE)
> > +		goto zero_out;

That becomes >=.

> > +	/* zero-length file */
> > +	if (i_size == 0)
> > +		goto zero_out;
> > +
> > +	/* position beyond last page in the file */
> > +	if (index > ((i_size - 1) / PAGE_SIZE))
> > +		goto zero_out;
> > +
> > +	/* write that covers the the page from start to EOF or beyond it */
> > +	if (offset == 0 && (pos + len) >= i_size)
> > +		goto zero_out;

That doesn't need any change.

> > +	return false;
> > +zero_out:
> > +	zero_user_segments(page, 0, offset, offset + len, PAGE_SIZE);

That also doesn't need any change.

