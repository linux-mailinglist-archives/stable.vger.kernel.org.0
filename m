Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDDC7114A60
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 02:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfLFBMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 20:12:05 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:58155 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbfLFBMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 20:12:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=yang.shi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Tk4mbZG_1575594719;
Received: from US-143344MP.local(mailfrom:yang.shi@linux.alibaba.com fp:SMTPD_---0Tk4mbZG_1575594719)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Dec 2019 09:12:02 +0800
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
To:     Qian Cai <cai@lca.pw>, John Hubbard <jhubbard@nvidia.com>
Cc:     fabecassis@nvidia.com, mhocko@suse.com, cl@linux.com,
        vbabka@suse.cz, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <22b5bfde-45be-95bd-5c98-2ab13302c107@nvidia.com>
 <D0A99204-A60F-428E-B77A-63DBCD7103F4@lca.pw>
From:   Yang Shi <yang.shi@linux.alibaba.com>
Message-ID: <9588b886-7ced-6502-67f0-0eb623045903@linux.alibaba.com>
Date:   Thu, 5 Dec 2019 17:11:58 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:52.0)
 Gecko/20100101 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <D0A99204-A60F-428E-B77A-63DBCD7103F4@lca.pw>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/5/19 4:19 PM, Qian Cai wrote:
>
>> On Dec 5, 2019, at 7:04 PM, John Hubbard <jhubbard@nvidia.com> wrote:
>>
>> Felix's code is not random test code. It's code he wrote and he expected it to work.
> Sure, but could he show a bit detail if the kernel will start to behavior as expected like what was written in the manpage to return ENOENT in this case, why is it not acceptable? i.e., why is it important to depend on the broken behavior?


I think I found the root cause. It did return -ENOENT when the syscall 
was introduced (my first impression was wrong), but the behavior was 
changed since 2.6.28 by commit e78bbfa82624 ("mm: stop returning -ENOENT 
from sys_move_pages() if nothing got migrated"). The full commit log is 
as below:

Author: Brice Goglin <Brice.Goglin@inria.fr>
Date:   Sat Oct 18 20:27:15 2008 -0700

     mm: stop returning -ENOENT from sys_move_pages() if nothing got 
migrated

     A patchset reworking sys_move_pages().  It removes the possibly large
     vmalloc by using multiple chunks when migrating large buffers. It also
     dramatically increases the throughput for large buffers since the 
lookup
     in new_page_node() is now limited to a single chunk, causing the 
quadratic
     complexity to have a much slower impact.  There is no need to use any
     radix-tree-like structure to improve this lookup.

     sys_move_pages() duration on a 4-quadcore-opteron 2347HE (1.9Gz),
     migrating between nodes #2 and #3:

             length          move_pages (us)         move_pages+patch (us)
             4kB             126                     98
             40kB            198                     168
             400kB           963                     937
             4MB             12503                   11930
             40MB            246867                  11848

     Patches #1 and #4 are the important ones:
     1) stop returning -ENOENT from sys_move_pages() if nothing got migrated
     2) don't vmalloc a huge page_to_node array for do_pages_stat()
     3) extract do_pages_move() out of sys_move_pages()
     4) rework do_pages_move() to work on page_sized chunks
     5) move_pages: no need to set pp->page to ZERO_PAGE(0) by default

     This patch:

     There is no point in returning -ENOENT from sys_move_pages() if all 
pages
     were already on the right node, while we return 0 if only 1 page 
was not.
     Most application don't know where their pages are allocated, so 
it's not
     an error to try to migrate them anyway.

     Just return 0 and let the status array in user-space be checked if the
     application needs details.

     It will make the upcoming chunked-move_pages() support much easier.

     Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
     Acked-by: Christoph Lameter <cl@linux-foundation.org>
     Cc: Nick Piggin <nickpiggin@yahoo.com.au>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


So the behavior was changed in kernel intentionally but never reflected 
in the manpage. I will propose a patch to fix the document.
