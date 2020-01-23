Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 456501463F5
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 09:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgAWIza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 03:55:30 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46022 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgAWIza (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 03:55:30 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so2090715wrj.12;
        Thu, 23 Jan 2020 00:55:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QN0GytJlQ8IoR8mCnHpKkK8Cwd+3Z4QrENywxxSV18c=;
        b=l+xpVWnEjOFkUjd5ufVUmmO3pxr/q5FSCe5xcJG6Pn0ugmSOrgrRKjyiqEB5rt7sab
         lZxtzjbHw4nteRmF86/EWiJUIEoPAWbyIj5rtd7qf4am4X8OLxcWTb3JLOMmHBGvSWMq
         psirjH41GsGDa+iLTwizJtQl/c0FPSxvVyR7QqHmGxjcOcfRPeG8Q8TIVwsgkcVVYC7n
         XO/2WxBNmIuVNCigQHmrAhZtpHpG9r1HxtOgNXlpVLfL+xQmjYqp70ZeFo2td/6VgdxN
         wDJ2Wil1HdyLWuHr5nRzliDyc/H1ddrawRtS5dW56mNtgyadh2gIh2REKdnOx2/9erVR
         kzNQ==
X-Gm-Message-State: APjAAAWrXfOmxR670rUUj7c8OlgzbDFu9KBSK6P+2eiuy/LsUhhvppYr
        gvnODqyqsEVZY5wi9Ucrnl8=
X-Google-Smtp-Source: APXvYqxE4kCL96Yx0I5czZuD0dgQc16eDRuFzdGJRJuBkF2YjgYdk0l++2io4mKgbgJpWP9ttZvgZw==
X-Received: by 2002:adf:dfc1:: with SMTP id q1mr16374200wrn.155.1579769727653;
        Thu, 23 Jan 2020 00:55:27 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id f12sm1821295wmf.28.2020.01.23.00.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 00:55:26 -0800 (PST)
Date:   Thu, 23 Jan 2020 09:55:26 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Wei Yang <richardw.yang@linux.intel.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [v2 PATCH] mm: move_pages: report the number of non-attempted
 pages
Message-ID: <20200123085526.GH29276@dhcp22.suse.cz>
References: <1579736331-85494-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200123032736.GA22196@richard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123032736.GA22196@richard>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 23-01-20 11:27:36, Wei Yang wrote:
> On Thu, Jan 23, 2020 at 07:38:51AM +0800, Yang Shi wrote:
> >Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
> >the semantic of move_pages() was changed to return the number of
> >non-migrated pages (failed to migration) and the call would be aborted
> >immediately if migrate_pages() returns positive value.  But it didn't
> >report the number of pages that we even haven't attempted to migrate.
> >So, fix it by including non-attempted pages in the return value.
> >
> 
> First, we want to change the semantic of move_pages(2). The return value
> indicates the number of pages we didn't managed to migrate?
> 
> Second, the return value from migrate_pages() doesn't mean the number of pages
> we failed to migrate. For example, one -ENOMEM is returned on the first page,
> migrate_pages() would return 1. But actually, no page successfully migrated.

ENOMEM is considered a permanent failure and as such it is returned by
migrate pages (see goto out).

> Third, even the migrate_pages() return the exact non-migrate page, we are not
> sure those non-migrated pages are at the tail of the list. Because in the last
> case in migrate_pages(), it just remove the page from list. It could be a page
> in the middle of the list. Then, in userspace, how the return value be
> leveraged to determine the valid status? Any page in the list could be the
> victim.

Yes, I was wrong when stating that the caller would know better which
status to check. I misremembered the original patch as it was quite some
time ago. While storing the error code would be possible after some
massaging of migrate_pages is this really something we deeply care
about. The caller can achieve the same by initializing the status array
to a non-node number - e.g. -1 - and check based on that.

This system call has quite a complex semantic and I am not 100% sure
what is the right thing to do here. Maybe we do want to continue and try
to migrate as much as possible on non-fatal migration failures and
accumulate the number of failed pages while doing so.

The main problem is that we can have an academic discussion but
the primary question is what do actual users want. A lack of real
bug reports suggests that nobody has actually noticed this. So I
would rather keep returning the correct number of non-migrated
pages. Why? Because new users could have started depending on it. It
is not all that unlikely that the current implementation would just
work for them because they are migrating a set of pages on to the same
node so the batch would be a single list throughout the whole given
page set.
-- 
Michal Hocko
SUSE Labs
