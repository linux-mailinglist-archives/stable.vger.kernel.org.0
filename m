Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086B7230A78
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 14:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbgG1MmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 08:42:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:58624 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729379AbgG1MmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jul 2020 08:42:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0ADA6AD18;
        Tue, 28 Jul 2020 12:42:30 +0000 (UTC)
Subject: Re: [PATCH 1/2] nvme-tcp: use sendpage_ok() to check page for
 kernel_sendpage()
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     philipp.reisner@linbit.com, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        hch@lst.de, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jan Kara <jack@suse.com>,
        Jens Axboe <axboe@kernel.dk>,
        Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>,
        Vlastimil Babka <vbabka@suse.com>, stable@vger.kernel.org
References: <20200726135224.107516-1-colyli@suse.de>
 <f6cf7563-9d8c-baa8-e8e7-e41f9b13e787@grimberg.me>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <5697358d-2f61-d63f-eee7-c9af346771eb@suse.de>
Date:   Tue, 28 Jul 2020 20:42:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f6cf7563-9d8c-baa8-e8e7-e41f9b13e787@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020/7/28 01:25, Sagi Grimberg wrote:
> 
> 
> On 7/26/20 6:52 AM, Coly Li wrote:
>> Currently nvme_tcp_try_send_data() doesn't use kernel_sendpage() to
>> send slab pages. But for pages allocated by __get_free_pages() without
>> __GFP_COMP, which also have refcount as 0, they are still sent by
>> kernel_sendpage() to remote end, this is problematic.
>>
>> When bcache uses a remote NVMe SSD via nvme-over-tcp as its cache
>> device, writing meta data e.g. cache_set->disk_buckets to remote SSD may
>> trigger a kernel panic due to the above problem. Bcause the meta data
>> pages for cache_set->disk_buckets are allocated by __get_free_pages()
>> without __GFP_COMP.
>>
>> This problem should be fixed both in upper layer driver (bcache) and
>> nvme-over-tcp code. This patch fixes the nvme-over-tcp code by checking
>> whether the page refcount is 0, if yes then don't use kernel_sendpage()
>> and call sock_no_sendpage() to send the page into network stack.
>>
>> Such check is done by macro sendpage_ok() in this patch, which is defined
>> in include/linux/net.h as,
>>     (!PageSlab(page) && page_count(page) >= 1)
>> If sendpage_ok() returns false, sock_no_sendpage() will handle the page
>> other than kernel_sendpage().
>>
>> The code comments in this patch is copied and modified from drbd where
>> the similar problem already gets solved by Philipp Reisner. This is the
>> best code comment including my own version.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Jan Kara <jack@suse.com>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>
>> Cc: Philipp Reisner <philipp.reisner@linbit.com>
>> Cc: Sagi Grimberg <sagi@grimberg.me>
>> Cc: Vlastimil Babka <vbabka@suse.com>
>> Cc: stable@vger.kernel.org
>> ---
>> Changelog:
>> v3: introduce a more common name sendpage_ok() for the open coded check
>> v2: fix typo in patch subject.
>> v1: the initial version.
>>
>>   drivers/nvme/host/tcp.c | 13 +++++++++++--
>>   include/linux/net.h     |  2 ++
>>   2 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
>> index 79ef2b8e2b3c..f9952f6d94b9 100644
>> --- a/drivers/nvme/host/tcp.c
>> +++ b/drivers/nvme/host/tcp.c
>> @@ -887,8 +887,17 @@ static int nvme_tcp_try_send_data(struct
>> nvme_tcp_request *req)
>>           else
>>               flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
>>   -        /* can't zcopy slab pages */
>> -        if (unlikely(PageSlab(page))) {
>> +        /*
>> +         * e.g. XFS meta- & log-data is in slab pages, or bcache meta
>> +         * data pages, or other high order pages allocated by
>> +         * __get_free_pages() without __GFP_COMP, which have a
>> page_count
>> +         * of 0 and/or have PageSlab() set. We cannot use send_page for
>> +         * those, as that does get_page(); put_page(); and would cause
>> +         * either a VM_BUG directly, or __page_cache_release a page that
>> +         * would actually still be referenced by someone, leading to
>> some
>> +         * obscure delayed Oops somewhere else.
>> +         */
> 
> I was hoping that this comment would move to the helper as well.
> 

Sure, I will do that.


> Agree with Christoph comment as well.

I will move the inline sendpage_ok() to a separated patch.

Coly Li
