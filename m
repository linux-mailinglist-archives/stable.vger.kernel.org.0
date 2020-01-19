Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB31B141B4A
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 03:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbgASC5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 21:57:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:62025 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727403AbgASC5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Jan 2020 21:57:25 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jan 2020 18:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,336,1574150400"; 
   d="scan'208";a="219309692"
Received: from richard.sh.intel.com (HELO localhost) ([10.239.159.54])
  by orsmga008.jf.intel.com with ESMTP; 18 Jan 2020 18:57:22 -0800
Date:   Sun, 19 Jan 2020 10:57:33 +0800
From:   Wei Yang <richardw.yang@linux.intel.com>
To:     Wei Yang <richardw.yang@linux.intel.com>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>, mhocko@suse.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: move_pages: fix the return value if there are
 not-migrated pages
Message-ID: <20200119025733.GG9745@richard>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
References: <1579325203-16405-1-git-send-email-yang.shi@linux.alibaba.com>
 <20200119023720.GD9745@richard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200119023720.GD9745@richard>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 19, 2020 at 10:37:20AM +0800, Wei Yang wrote:
>On Sat, Jan 18, 2020 at 01:26:43PM +0800, Yang Shi wrote:
>>The do_move_pages_to_node() might return > 0 value, the number of pages
>>that are not migrated, then the value will be returned to userspace
>>directly.  But, move_pages() syscall would just return 0 or errno.  So,
>>we need reset the return value to 0 for such case as what pre-v4.17 did.
>>
>>Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
>>Cc: Michal Hocko <mhocko@suse.com>
>>Cc: Wei Yang <richardw.yang@linux.intel.com>
>>Cc: <stable@vger.kernel.org>    [4.17+]
>>Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>>---
>> mm/migrate.c | 5 ++++-
>> 1 file changed, 4 insertions(+), 1 deletion(-)
>>
>>diff --git a/mm/migrate.c b/mm/migrate.c
>>index 86873b6..3e75432 100644
>>--- a/mm/migrate.c
>>+++ b/mm/migrate.c
>>@@ -1659,8 +1659,11 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>> 			goto out_flush;
>> 
>> 		err = do_move_pages_to_node(mm, &pagelist, current_node);
>>-		if (err)
>>+		if (err) {
>>+			if (err > 0)
>>+				err = 0;
>> 			goto out;
>>+		}
>> 		if (i > start) {
>> 			err = store_status(status, start, current_node, i - start);
>> 			if (err)
>>-- 
>>1.8.3.1
>
>
>Hey, I am afraid you missed something. There are three calls of
>do_move_pages_to_node() in do_pages_move(). Why you just handle one return
>value? How about the other two?
>

Well, current logic in do_pages_move() is a little complicated to read.

I did a cleanup to make it easy to read and also friendly to do this fix.

If they look good to you, you could rebase your fix on top of them.

>-- 
>Wei Yang
>Help you, Help me

-- 
Wei Yang
Help you, Help me
