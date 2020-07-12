Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF2B21CAB5
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 19:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgGLRbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 13:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729103AbgGLRbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 13:31:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0706C061794;
        Sun, 12 Jul 2020 10:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0lZACZlm7hp7p3AuwMaMc3pMQx+Gf0OKUy9R5BwWajc=; b=EpxDrpEAuVkfls1cofHEt/ntsC
        hHzEneuO2eVxHcRPwBtIExjx8O4Z/1xHFraQYVBrYFT3o9pwMaPdtIuEVvVTD+GrePjU5HdJBDyLU
        ikdn0vwlBsmBCokv3BN6qLdTLdmkWygYGG9qmT0UvJOsGkjHujcq6vtI9ElBoFhqHTNjF3WyBpLHJ
        lLlsuggQuh8TTZAUo5T7erp/SKaCGf91TAcho55w0gd5+j89GqUA1Zv2tlS+FOPj9xigaGs5N8Gma
        Bf1E67MFWlMnvI+LHlTYI5GZ8VMDabrgeDnmRMoffKnq9ZjIEdICBMEIqXZOj8TsyHfEHn12gkl79
        Ce8OXG8w==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jufoS-0002Yv-FD; Sun, 12 Jul 2020 17:30:52 +0000
Date:   Sun, 12 Jul 2020 18:30:52 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        William Kucharski <william.kucharski@oracle.com>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>,
        lkft-triage@lists.linaro.org, Chris Down <chris@chrisdown.name>,
        Michel Lespinasse <walken@google.com>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Brian Geffon <bgeffon@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, pugaowei@gmail.com,
        Jerome Glisse <jglisse@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
Message-ID: <20200712173052.GU12769@casper.infradead.org>
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
 <CA+G9fYudT63yZrkWG+mfKHTcn5mP+Ay6hraEQy3G_4jufztrrA@mail.gmail.com>
 <CAHk-=whPrCRZpXYKois-0t8MibxH9KVXn=+-O1YVvOA016fqhw@mail.gmail.com>
 <CA+G9fYusSSrc5G_pZV6Lc-LjjkzQcc3EsLMo+ejSzvyRcMgbqw@mail.gmail.com>
 <CAHk-=wj_Bqu5n3OJCnKiO_gs97fYEpdx6eSacEw2kv9YnnSv_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj_Bqu5n3OJCnKiO_gs97fYEpdx6eSacEw2kv9YnnSv_w@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 11, 2020 at 11:12:58AM -0700, Linus Torvalds wrote:
> Yeah, that's just the commit that enables the code, not the commit
> that introduces the fundamental problem.
> 
> That said, this is a prime example of why I absolutely detest patch
> series that do this kind of thing, and are several patches that create
> new functionality, followed by one patch to enable it.
> 
> If you can't get things working incrementally, maybe you shouldn't do
> them at all. Doing a big series of "hidden work" and then enabling it
> later is wrong.

I'm struggling with exactly this for my current THP-in-pagecache patches.
There are about fifty patches, each fixing something that won't work if
the page is a THP.  And then there's the one patch which actually starts
creating THPs, and that's the one patch any bisect will point to.

But I don't see any other way to do it.  It's not like I can put THPs
in the page cache before fixing the things that won't work.

This probably wasn't the kind of thing you had in mind when you wrote
the above, but if you had some advice for my situation, I'd welcome it.
