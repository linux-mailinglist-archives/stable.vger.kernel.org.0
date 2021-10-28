Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E2D43DC4E
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 09:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhJ1Hqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Oct 2021 03:46:45 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:59016 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229788AbhJ1Hqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Oct 2021 03:46:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Utz8PDJ_1635407055;
Received: from B-D1K7ML85-0059.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Utz8PDJ_1635407055)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Oct 2021 15:44:16 +0800
Subject: Re: [PATCH 1/2] ocfs2: Fix data corruption on truncate
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
To:     Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc:     ocfs2-devel@oss.oracle.com, Gang He <ghe@suse.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>, stable@vger.kernel.org
References: <20211025150008.29002-1-jack@suse.cz>
 <20211025151332.11301-1-jack@suse.cz>
 <f8c309cf-ace7-f8c7-33d2-9a5fa39cb21b@linux.alibaba.com>
Message-ID: <7b6b56f5-e040-1d85-d7a7-e43bf2dcc1fe@linux.alibaba.com>
Date:   Thu, 28 Oct 2021 15:44:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f8c309cf-ace7-f8c7-33d2-9a5fa39cb21b@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/28/21 3:09 PM, Joseph Qi wrote:
> Hi Jan,
> 
> On 10/25/21 11:13 PM, Jan Kara wrote:
>> ocfs2_truncate_file() did unmap invalidate page cache pages before
>> zeroing partial tail cluster and setting i_size. Thus some pages could
>> be left (and likely have left if the cluster zeroing happened) in the
>> page cache beyond i_size after truncate finished letting user possibly
>> see stale data once the file was extended again. Also the tail cluster
> 
> I don't quite understand the case. 
> truncate_inode_pages() will truncate pages from new_i_size to i_size,
> and the following ocfs2_orphan_for_truncate() will zero range and then
> update i_size for inode as well as dinode.
> So once truncate finished, how stale data exposing happens? Or do you
> mean a race case between the above two steps?
> 
Or do you mean ocfs2_zero_range_for_truncate() will grab and zero eof
pages? Though it depends on block_write_full_page() to write out, the
pages are zeroed now. Still a little confused...
