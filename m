Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 293AD1491BB
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 00:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgAXXTQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 18:19:16 -0500
Received: from mga05.intel.com ([192.55.52.43]:25812 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729147AbgAXXTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 18:19:16 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 15:19:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,359,1574150400"; 
   d="scan'208";a="426771863"
Received: from richard.sh.intel.com (HELO localhost) ([10.239.159.54])
  by fmsmga005.fm.intel.com with ESMTP; 24 Jan 2020 15:19:14 -0800
Date:   Sat, 25 Jan 2020 07:19:26 +0800
From:   Wei Yang <richardw.yang@linux.intel.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Wei Yang <richardw.yang@linux.intel.com>, g@richard.suse.de,
        Yang Shi <yang.shi@linux.alibaba.com>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v2 PATCH] mm: move_pages: report the number of non-attempted
 pages
Message-ID: <20200124231926.GA16638@richard>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
References: <1579736331-85494-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200123032736.GA22196@richard>
 <20200123085526.GH29276@dhcp22.suse.cz>
 <20200123225647.GB29851@richard>
 <20200124064649.GM29276@dhcp22.suse.cz>
 <20200124152642.GB12509@richard>
 <20200124154015.GW29276@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124154015.GW29276@dhcp22.suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 04:40:15PM +0100, Michal Hocko wrote:
>On Fri 24-01-20 23:26:42, Wei Yang wrote:
>> On Fri, Jan 24, 2020 at 07:46:49AM +0100, Michal Hocko wrote:
>> >On Fri 24-01-20 06:56:47, Wei Yang wrote:
>> >> On Thu, Jan 23, 2020 at 09:55:26AM +0100, Michal Hocko wrote:
>> >> >On Thu 23-01-20 11:27:36, Wei Yang wrote:
>> >> >> On Thu, Jan 23, 2020 at 07:38:51AM +0800, Yang Shi wrote:
>> >> >> >Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
>> >> >> >the semantic of move_pages() was changed to return the number of
>> >> >> >non-migrated pages (failed to migration) and the call would be aborted
>> >> >> >immediately if migrate_pages() returns positive value.  But it didn't
>> >> >> >report the number of pages that we even haven't attempted to migrate.
>> >> >> >So, fix it by including non-attempted pages in the return value.
>> >> >> >
>> >> >> 
>> >> >> First, we want to change the semantic of move_pages(2). The return value
>> >> >> indicates the number of pages we didn't managed to migrate?
>> >> >> 
>> >> >> Second, the return value from migrate_pages() doesn't mean the number of pages
>> >> >> we failed to migrate. For example, one -ENOMEM is returned on the first page,
>> >> >> migrate_pages() would return 1. But actually, no page successfully migrated.
>> >> >
>> >> >ENOMEM is considered a permanent failure and as such it is returned by
>> >> >migrate pages (see goto out).
>> >> >
>> >> >> Third, even the migrate_pages() return the exact non-migrate page, we are not
>> >> >> sure those non-migrated pages are at the tail of the list. Because in the last
>> >> >> case in migrate_pages(), it just remove the page from list. It could be a page
>> >> >> in the middle of the list. Then, in userspace, how the return value be
>> >> >> leveraged to determine the valid status? Any page in the list could be the
>> >> >> victim.
>> >> >
>> >> >Yes, I was wrong when stating that the caller would know better which
>> >> >status to check. I misremembered the original patch as it was quite some
>> >> >time ago. While storing the error code would be possible after some
>> >> >massaging of migrate_pages is this really something we deeply care
>> >> >about. The caller can achieve the same by initializing the status array
>> >> >to a non-node number - e.g. -1 - and check based on that.
>> >> >
>> >> 
>> >> So for a user, the best practice is to initialize the status array to -1 and
>> >> check each status to see whether the page is migrated successfully?
>> >
>> >Yes IMO. Just consider -errno return value. You have no way to find out
>> >which pages have been migrated until we reached that error. The
>> >possitive return value would fall into the same case.
>> >
>> >> Then do we need to return the number of non-migrated page? What benefit could
>> >> user get from the number. How about just return an error code to indicate the
>> >> failure? I may miss some point, would you mind giving me a hint?
>> >
>> >This is certainly possible. We can return -EAGAIN if some pages couldn't
>> >be migrated because they are pinned. But please read my previous email
>> >to the very end for arguments why this might cause more problems than it
>> >actually solves.
>> >
>> 
>> Let me put your comment here:
>> 
>>     Because new users could have started depending on it. It
>>     is not all that unlikely that the current implementation would just
>>     work for them because they are migrating a set of pages on to the same
>>     node so the batch would be a single list throughout the whole given
>>     page set.
>> 
>> Your idea is to preserve current semantic, return non-migrated pages number to
>> userspace.
>> 
>> And the reason is:
>> 
>>    1. Users have started depending on it.
>>    2. No real bug reported yet.
>>    3. User always migrate page to the same node. (If my understanding is
>>       correct)
>> 
>> I think this gets some reason, since we want to minimize the impact to
>> userland.
>> 
>> While let's see what user probably use this syscall. Since from the man page,
>> we never told the return value could be positive, the number of non-migrated
>> pages, user would think only 0 means a successful migration and all other
>> cases are failure. Then user probably handle negative and positive return
>> value the same way, like (!err).
>> 
>> If my guess is true, return a negative error value for this case could
>> minimize the impact to userland here.
>>    1. Preserve the semantic of move_pages(2): 0 means success, negative means
>>       some error and needs extra handling.
>>    2. Trivial change to the man page.
>>    3. Suppose no change to users.
>
>Do you have any actual proposal we can discuss? I suspect we are going
>in circles here. Sure both ways are possible. The disucssion we are
>having here is which behavior makes more sense. The interface is and has
>been in the past very awkward. Some corner cases have been fixed some
>new created. While I am not happy about the later we should finally land
>with some decision.

Ok, I found myself may miss some mechanism about the err reporting from kernel
to userland.

  If do_pages_move() returns a negative err, the value would be set into errno
  and actually user just see a return value of -1?

So userland just see two types of return value if kernel comply with man page:

   0 : success
   -1: failure, with reason set into errno

Is my understanding correct? I tried to read the syscall path, but not find
how the negative value is set into errno.

Since our kernel already return a positive value one migration failure, so the
exact return value from move_pages() syscall is:

  > 0: number of non-migrate pages
  0  : success
  -1 : failure, with reason set into errno

Since everything looks good to userland now, we just extend the semantic of
move_pages() to make positive return value an explicit error case.

Is my understanding correct here?

If this is the case, I agree with this fix. It looks the minimal change to
current real world.

>-- 
>Michal Hocko
>SUSE Labs

-- 
Wei Yang
Help you, Help me
