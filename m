Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3FD4425A9
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 03:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhKBCjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 22:39:20 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:33824 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhKBCjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 22:39:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UufdSBc_1635820602;
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UufdSBc_1635820602)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 02 Nov 2021 10:36:43 +0800
Subject: Re: [PATCH 1/2] ocfs2: Fix data corruption on truncate
To:     Jan Kara <jack@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        ocfs2-devel@oss.oracle.com, Gang He <ghe@suse.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>, stable@vger.kernel.org
References: <20211025150008.29002-1-jack@suse.cz>
 <20211025151332.11301-1-jack@suse.cz>
 <f8c309cf-ace7-f8c7-33d2-9a5fa39cb21b@linux.alibaba.com>
 <20211101113100.GA18487@quack2.suse.cz>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <beb87697-e851-9681-bcc4-0669eb210703@linux.alibaba.com>
Date:   Tue, 2 Nov 2021 10:36:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211101113100.GA18487@quack2.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/1/21 7:31 PM, Jan Kara wrote:
> On Thu 28-10-21 15:09:08, Joseph Qi wrote:
>> Hi Jan,
>>
>> On 10/25/21 11:13 PM, Jan Kara wrote:
>>> ocfs2_truncate_file() did unmap invalidate page cache pages before
>>> zeroing partial tail cluster and setting i_size. Thus some pages could
>>> be left (and likely have left if the cluster zeroing happened) in the
>>> page cache beyond i_size after truncate finished letting user possibly
>>> see stale data once the file was extended again. Also the tail cluster
>>
>> I don't quite understand the case. 
>> truncate_inode_pages() will truncate pages from new_i_size to i_size,
>> and the following ocfs2_orphan_for_truncate() will zero range and then
>> update i_size for inode as well as dinode.
>> So once truncate finished, how stale data exposing happens? Or do you
>> mean a race case between the above two steps?
> 
> Sorry, I was not quite accurate in the above paragraph. There are several
> ways how stale pages in the pagecache can cause problems.
> 
> 1) Because i_size is reduced after truncating page cache, page fault can
> happen after truncating page cache and zeroing pages but before reducing i_size.
> This will in allow user to arbitrarily modify pages that are used for
> writing zeroes into the cluster tail and after file extension these data
> will become visible.
> 
> 2) The tail cluster zeroing in ocfs2_orphan_for_truncate() can actually try
> to write zeroed pages above i_size (e.g. if we have 4k blocksize, 64k
> clustersize, and do truncate(f, 4k) on a 4k file). This will cause exactly
> same problems as already described in commit 5314454ea3f "ocfs2: fix data
> corruption after conversion from inline format".
> 
> Hope it is clearer now.
> 
So the core reason is ocfs2_zero_range_for_truncate() grabs pages and
then zero, right?
I think an alternative way is using zeroout instead of zero pages, which
won't grab pages again.
Anyway, I'm also fine with your way since it is simple.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>


