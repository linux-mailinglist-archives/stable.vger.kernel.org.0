Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 252EA141B27
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 03:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgASCYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 21:24:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:50568 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727403AbgASCYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Jan 2020 21:24:49 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jan 2020 18:24:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,336,1574150400"; 
   d="scan'208";a="219305781"
Received: from richard.sh.intel.com (HELO localhost) ([10.239.159.54])
  by orsmga008.jf.intel.com with ESMTP; 18 Jan 2020 18:24:45 -0800
Date:   Sun, 19 Jan 2020 10:24:56 +0800
From:   Wei Yang <richardw.yang@linux.intel.com>
To:     David Rientjes <rientjes@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org,
        mhocko@kernel.org, vdavydov.dev@gmail.com, ktkhai@virtuozzo.com,
        kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        stable@vger.kernel.org
Subject: Re: [Patch v4] mm: thp: remove the defer list related code since
 this will not happen
Message-ID: <20200119022456.GC9745@richard>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com>
 <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org>
 <alpine.DEB.2.21.2001181525250.27051@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001181525250.27051@chino.kir.corp.google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 18, 2020 at 03:36:06PM -0800, David Rientjes wrote:
>On Sat, 18 Jan 2020, Andrew Morton wrote:
>
>> On Sat, 18 Jan 2020 07:38:36 +0800 Wei Yang <richardw.yang@linux.intel.com> wrote:
>> 
>> > If compound is true, this means it is a PMD mapped THP. Which implies
>> > the page is not linked to any defer list. So the first code chunk will
>> > not be executed.
>> > 
>> > Also with this reason, it would not be proper to add this page to a
>> > defer list. So the second code chunk is not correct.
>> > 
>> > Based on this, we should remove the defer list related code.
>> > 
>> > Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
>> > 
>> > Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
>> > Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> > Cc: <stable@vger.kernel.org>    [5.4+]
>> 
>> This patch is identical to "mm: thp: grab the lock before manipulating
>> defer list", which is rather confusing.  Please let people know when
>> this sort of thing is done.
>> 
>> The earlier changelog mentioned a possible race condition.  This
>> changelog does not.  In fact this changelog fails to provide any
>> description of any userspace-visible runtime effects of the bug. 
>> Please send along such a description for inclusion, as always.
>> 
>
>The locking concern that Wei was originally looking at is no longer an 
>issue because we determined that the code in question could simply be 
>removed.
>
>I think the following can be added to the changelog:
>
>----->o-----
>
>When migrating memcg charges of thp memory, there are two possibilities:
>
> (1) The underlying compound page is mapped by a pmd and thus does is not 
>     on a deferred split queue (it's mapped), or
>
> (2) The compound page is not mapped by a pmd and is awaiting split on a
>     deferred split queue.
>
>The current charge migration implementation does *not* migrate charges for 
>thp memory on the deferred split queue, it only migrates charges for pages 
>that are mapped by a pmd.
>
>Thus, to migrate charges, the underlying compound page cannot be on a 
>deferred split queue; no list manipulation needs to be done in 
>mem_cgroup_move_account().
>
>With the current code, the underlying compound page is moved to the 
>deferred split queue of the memcg its memory is not charged to, so 
>susbequent reclaim will consider these pages for the wrong memcg.  Remove 
>the deferred split queue handling in mem_cgroup_move_account() entirely.
>
>----->o-----
>
>Acked-by: David Rientjes <rientjes@google.com>

Hi David,

The changlog looks awesome to me. Thanks ~

Hi Andrew

I see you queue this in you tree, do I need to rewrite a patch with better
changelog?

-- 
Wei Yang
Help you, Help me
