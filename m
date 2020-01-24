Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3ADA14789E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 07:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgAXGqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 01:46:54 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36359 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgAXGqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 01:46:54 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so604384wma.1;
        Thu, 23 Jan 2020 22:46:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ceFjGGiWoFMAA9UT7Zn787IQlb7e7FJtvY2pMaDdPIg=;
        b=Gxv17RncT8ap+fPBQKE0R2CiM54rC0fSHbxygq/XRUYNjrV31iZvWV4xlMrtxu6rGI
         ai055BGisTLXK4RXCzGT9SngPOoiDesG07pNwLlZ3vaevUt5WIEjdTp9RgrwTGNuhB+B
         M4tya5TI5l73YwaAzA/s26ctPoEpUDqXelWs81Gzdpk8Rj6ehO0xMb1hH3fyOMyLOY3D
         WdF1fuQ5Av8a4mDhIrs7auQybSFH32TuW977uUqN7vliWJ60Yvdz4N2LUlSi1gvG4dNy
         dxT2NS7EaKbnMbbaGe1dl2Bu5iBh7a8YPaz6xReHfq89wPYEN+SP64vwh83DucPKsQ3E
         Sm5g==
X-Gm-Message-State: APjAAAUCOmAk0GseUO+QcI/kGs4eXpdPdJDuYkA1v2InFv60ims03lBb
        BljGKzCtOl9lVmPFJd1/EbpVZrei
X-Google-Smtp-Source: APXvYqwVDEdRt5Olnj1NsGVliK0l7NWMm0Od52XXHYIaFzv034E6xvGh2WxWdUyCXdlSGFI7kDuovQ==
X-Received: by 2002:a1c:7c11:: with SMTP id x17mr1871368wmc.168.1579848411533;
        Thu, 23 Jan 2020 22:46:51 -0800 (PST)
Received: from localhost (ip-37-188-162-110.eurotel.cz. [37.188.162.110])
        by smtp.gmail.com with ESMTPSA id c195sm6257033wmd.45.2020.01.23.22.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 22:46:50 -0800 (PST)
Date:   Fri, 24 Jan 2020 07:46:49 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Wei Yang <richardw.yang@linux.intel.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [v2 PATCH] mm: move_pages: report the number of non-attempted
 pages
Message-ID: <20200124064649.GM29276@dhcp22.suse.cz>
References: <1579736331-85494-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200123032736.GA22196@richard>
 <20200123085526.GH29276@dhcp22.suse.cz>
 <20200123225647.GB29851@richard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123225647.GB29851@richard>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 24-01-20 06:56:47, Wei Yang wrote:
> On Thu, Jan 23, 2020 at 09:55:26AM +0100, Michal Hocko wrote:
> >On Thu 23-01-20 11:27:36, Wei Yang wrote:
> >> On Thu, Jan 23, 2020 at 07:38:51AM +0800, Yang Shi wrote:
> >> >Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
> >> >the semantic of move_pages() was changed to return the number of
> >> >non-migrated pages (failed to migration) and the call would be aborted
> >> >immediately if migrate_pages() returns positive value.  But it didn't
> >> >report the number of pages that we even haven't attempted to migrate.
> >> >So, fix it by including non-attempted pages in the return value.
> >> >
> >> 
> >> First, we want to change the semantic of move_pages(2). The return value
> >> indicates the number of pages we didn't managed to migrate?
> >> 
> >> Second, the return value from migrate_pages() doesn't mean the number of pages
> >> we failed to migrate. For example, one -ENOMEM is returned on the first page,
> >> migrate_pages() would return 1. But actually, no page successfully migrated.
> >
> >ENOMEM is considered a permanent failure and as such it is returned by
> >migrate pages (see goto out).
> >
> >> Third, even the migrate_pages() return the exact non-migrate page, we are not
> >> sure those non-migrated pages are at the tail of the list. Because in the last
> >> case in migrate_pages(), it just remove the page from list. It could be a page
> >> in the middle of the list. Then, in userspace, how the return value be
> >> leveraged to determine the valid status? Any page in the list could be the
> >> victim.
> >
> >Yes, I was wrong when stating that the caller would know better which
> >status to check. I misremembered the original patch as it was quite some
> >time ago. While storing the error code would be possible after some
> >massaging of migrate_pages is this really something we deeply care
> >about. The caller can achieve the same by initializing the status array
> >to a non-node number - e.g. -1 - and check based on that.
> >
> 
> So for a user, the best practice is to initialize the status array to -1 and
> check each status to see whether the page is migrated successfully?

Yes IMO. Just consider -errno return value. You have no way to find out
which pages have been migrated until we reached that error. The
possitive return value would fall into the same case.

> Then do we need to return the number of non-migrated page? What benefit could
> user get from the number. How about just return an error code to indicate the
> failure? I may miss some point, would you mind giving me a hint?

This is certainly possible. We can return -EAGAIN if some pages couldn't
be migrated because they are pinned. But please read my previous email
to the very end for arguments why this might cause more problems than it
actually solves.

> >This system call has quite a complex semantic and I am not 100% sure
> >what is the right thing to do here. Maybe we do want to continue and try
> >to migrate as much as possible on non-fatal migration failures and
> >accumulate the number of failed pages while doing so.
> >
> >The main problem is that we can have an academic discussion but
> >the primary question is what do actual users want. A lack of real
> >bug reports suggests that nobody has actually noticed this. So I
> >would rather keep returning the correct number of non-migrated
> >pages. Why? Because new users could have started depending on it. It
> >is not all that unlikely that the current implementation would just
> >work for them because they are migrating a set of pages on to the same
> >node so the batch would be a single list throughout the whole given
> >page set.

-- 
Michal Hocko
SUSE Labs
