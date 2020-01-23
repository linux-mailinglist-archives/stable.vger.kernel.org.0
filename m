Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA2214741D
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 23:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgAWW4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 17:56:38 -0500
Received: from mga05.intel.com ([192.55.52.43]:11881 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729149AbgAWW4i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 17:56:38 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 14:56:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,355,1574150400"; 
   d="scan'208";a="245541197"
Received: from richard.sh.intel.com (HELO localhost) ([10.239.159.54])
  by orsmga002.jf.intel.com with ESMTP; 23 Jan 2020 14:56:35 -0800
Date:   Fri, 24 Jan 2020 06:56:47 +0800
From:   Wei Yang <richardw.yang@linux.intel.com>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Wei Yang <richardw.yang@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v2 PATCH] mm: move_pages: report the number of non-attempted
 pages
Message-ID: <20200123225647.GB29851@richard>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
References: <1579736331-85494-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200123032736.GA22196@richard>
 <20200123085526.GH29276@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123085526.GH29276@dhcp22.suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 23, 2020 at 09:55:26AM +0100, Michal Hocko wrote:
>On Thu 23-01-20 11:27:36, Wei Yang wrote:
>> On Thu, Jan 23, 2020 at 07:38:51AM +0800, Yang Shi wrote:
>> >Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"),
>> >the semantic of move_pages() was changed to return the number of
>> >non-migrated pages (failed to migration) and the call would be aborted
>> >immediately if migrate_pages() returns positive value.  But it didn't
>> >report the number of pages that we even haven't attempted to migrate.
>> >So, fix it by including non-attempted pages in the return value.
>> >
>> 
>> First, we want to change the semantic of move_pages(2). The return value
>> indicates the number of pages we didn't managed to migrate?
>> 
>> Second, the return value from migrate_pages() doesn't mean the number of pages
>> we failed to migrate. For example, one -ENOMEM is returned on the first page,
>> migrate_pages() would return 1. But actually, no page successfully migrated.
>
>ENOMEM is considered a permanent failure and as such it is returned by
>migrate pages (see goto out).
>
>> Third, even the migrate_pages() return the exact non-migrate page, we are not
>> sure those non-migrated pages are at the tail of the list. Because in the last
>> case in migrate_pages(), it just remove the page from list. It could be a page
>> in the middle of the list. Then, in userspace, how the return value be
>> leveraged to determine the valid status? Any page in the list could be the
>> victim.
>
>Yes, I was wrong when stating that the caller would know better which
>status to check. I misremembered the original patch as it was quite some
>time ago. While storing the error code would be possible after some
>massaging of migrate_pages is this really something we deeply care
>about. The caller can achieve the same by initializing the status array
>to a non-node number - e.g. -1 - and check based on that.
>

So for a user, the best practice is to initialize the status array to -1 and
check each status to see whether the page is migrated successfully?

Then do we need to return the number of non-migrated page? What benefit could
user get from the number. How about just return an error code to indicate the
failure? I may miss some point, would you mind giving me a hint?

>This system call has quite a complex semantic and I am not 100% sure
>what is the right thing to do here. Maybe we do want to continue and try
>to migrate as much as possible on non-fatal migration failures and
>accumulate the number of failed pages while doing so.
>
>The main problem is that we can have an academic discussion but
>the primary question is what do actual users want. A lack of real
>bug reports suggests that nobody has actually noticed this. So I
>would rather keep returning the correct number of non-migrated
>pages. Why? Because new users could have started depending on it. It
>is not all that unlikely that the current implementation would just
>work for them because they are migrating a set of pages on to the same
>node so the batch would be a single list throughout the whole given
>page set.
>-- 
>Michal Hocko
>SUSE Labs

-- 
Wei Yang
Help you, Help me
