Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE3A148B5E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 16:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388566AbgAXPkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 10:40:19 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46196 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388413AbgAXPkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 10:40:19 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so2480211wrl.13;
        Fri, 24 Jan 2020 07:40:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4fSpakkXt7XJRLfsrbxsymX5+CsRlMsI5kEt8m9uUJc=;
        b=BRIfpTlTzvcE9xfK3Msu6eZsTeESMAS7PxwlrFM33BJpQgDepS5Y12YyECxNWwzDtQ
         C3YGd3DwmImBOJAmA+E5VFNSnzFdxR3EQKb27cngPX6+oAqlK0Uc5vXCBuLnEwiHS0pX
         JqT+xcmYZlv+L1K2/ZbEIxBiADUdMqyTdnoFaJtdrVuwN8DXobJ26L1KRkGLbJWeosuq
         xS5zVX/VRCBNyC1rGPOJcEgT+n52IpCldHzb1MEJ4Fitd3kH8XTc2scI0OjtzEmtH1lI
         HokPFX+Q80Buig5RCE0MqyDjTM2eQNi+ofBUM3K7F+2rOn2RCa4UWUtgwzKikeQiHoUZ
         MqmQ==
X-Gm-Message-State: APjAAAVuERDe4WMujyUTyQHdKdqYzCj3KAKDCrhJpl6VF9DRC1uiWvAP
        xfRE/K/P0jr2Y71sjeF3cvnxf27+
X-Google-Smtp-Source: APXvYqw/ikY9aTlEmhbvA3VEnZFfBXKY17UC6N1FnkK/VeK4UC5UgZ/QIMX+XixzBusWTkX5JkfUlg==
X-Received: by 2002:adf:82e7:: with SMTP id 94mr5444569wrc.60.1579880416703;
        Fri, 24 Jan 2020 07:40:16 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id x132sm13887991wmg.0.2020.01.24.07.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 07:40:15 -0800 (PST)
Date:   Fri, 24 Jan 2020 16:40:15 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Wei Yang <richardw.yang@linux.intel.com>
Cc:     g@richard.suse.de, Yang Shi <yang.shi@linux.alibaba.com>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v2 PATCH] mm: move_pages: report the number of non-attempted
 pages
Message-ID: <20200124154015.GW29276@dhcp22.suse.cz>
References: <1579736331-85494-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200123032736.GA22196@richard>
 <20200123085526.GH29276@dhcp22.suse.cz>
 <20200123225647.GB29851@richard>
 <20200124064649.GM29276@dhcp22.suse.cz>
 <20200124152642.GB12509@richard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124152642.GB12509@richard>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 24-01-20 23:26:42, Wei Yang wrote:
> On Fri, Jan 24, 2020 at 07:46:49AM +0100, Michal Hocko wrote:
> >On Fri 24-01-20 06:56:47, Wei Yang wrote:
> >> On Thu, Jan 23, 2020 at 09:55:26AM +0100, Michal Hocko wrote:
> >> >On Thu 23-01-20 11:27:36, Wei Yang wrote:
> >> >> On Thu, Jan 23, 2020 at 07:38:51AM +0800, Yang Shi wrote:
> >> >> >Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
> >> >> >the semantic of move_pages() was changed to return the number of
> >> >> >non-migrated pages (failed to migration) and the call would be aborted
> >> >> >immediately if migrate_pages() returns positive value.  But it didn't
> >> >> >report the number of pages that we even haven't attempted to migrate.
> >> >> >So, fix it by including non-attempted pages in the return value.
> >> >> >
> >> >> 
> >> >> First, we want to change the semantic of move_pages(2). The return value
> >> >> indicates the number of pages we didn't managed to migrate?
> >> >> 
> >> >> Second, the return value from migrate_pages() doesn't mean the number of pages
> >> >> we failed to migrate. For example, one -ENOMEM is returned on the first page,
> >> >> migrate_pages() would return 1. But actually, no page successfully migrated.
> >> >
> >> >ENOMEM is considered a permanent failure and as such it is returned by
> >> >migrate pages (see goto out).
> >> >
> >> >> Third, even the migrate_pages() return the exact non-migrate page, we are not
> >> >> sure those non-migrated pages are at the tail of the list. Because in the last
> >> >> case in migrate_pages(), it just remove the page from list. It could be a page
> >> >> in the middle of the list. Then, in userspace, how the return value be
> >> >> leveraged to determine the valid status? Any page in the list could be the
> >> >> victim.
> >> >
> >> >Yes, I was wrong when stating that the caller would know better which
> >> >status to check. I misremembered the original patch as it was quite some
> >> >time ago. While storing the error code would be possible after some
> >> >massaging of migrate_pages is this really something we deeply care
> >> >about. The caller can achieve the same by initializing the status array
> >> >to a non-node number - e.g. -1 - and check based on that.
> >> >
> >> 
> >> So for a user, the best practice is to initialize the status array to -1 and
> >> check each status to see whether the page is migrated successfully?
> >
> >Yes IMO. Just consider -errno return value. You have no way to find out
> >which pages have been migrated until we reached that error. The
> >possitive return value would fall into the same case.
> >
> >> Then do we need to return the number of non-migrated page? What benefit could
> >> user get from the number. How about just return an error code to indicate the
> >> failure? I may miss some point, would you mind giving me a hint?
> >
> >This is certainly possible. We can return -EAGAIN if some pages couldn't
> >be migrated because they are pinned. But please read my previous email
> >to the very end for arguments why this might cause more problems than it
> >actually solves.
> >
> 
> Let me put your comment here:
> 
>     Because new users could have started depending on it. It
>     is not all that unlikely that the current implementation would just
>     work for them because they are migrating a set of pages on to the same
>     node so the batch would be a single list throughout the whole given
>     page set.
> 
> Your idea is to preserve current semantic, return non-migrated pages number to
> userspace.
> 
> And the reason is:
> 
>    1. Users have started depending on it.
>    2. No real bug reported yet.
>    3. User always migrate page to the same node. (If my understanding is
>       correct)
> 
> I think this gets some reason, since we want to minimize the impact to
> userland.
> 
> While let's see what user probably use this syscall. Since from the man page,
> we never told the return value could be positive, the number of non-migrated
> pages, user would think only 0 means a successful migration and all other
> cases are failure. Then user probably handle negative and positive return
> value the same way, like (!err).
> 
> If my guess is true, return a negative error value for this case could
> minimize the impact to userland here.
>    1. Preserve the semantic of move_pages(2): 0 means success, negative means
>       some error and needs extra handling.
>    2. Trivial change to the man page.
>    3. Suppose no change to users.

Do you have any actual proposal we can discuss? I suspect we are going
in circles here. Sure both ways are possible. The disucssion we are
having here is which behavior makes more sense. The interface is and has
been in the past very awkward. Some corner cases have been fixed some
new created. While I am not happy about the later we should finally land
with some decision.
-- 
Michal Hocko
SUSE Labs
