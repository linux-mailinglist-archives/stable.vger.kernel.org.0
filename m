Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46679179E95
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 05:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgCEE1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 23:27:08 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:55765 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgCEE1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 23:27:08 -0500
X-Originating-IP: 159.89.7.238
Received: from [10.55.55.2] (unknown [159.89.7.238])
        (Authenticated sender: cengiz@kernel.wtf)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id C1ACE1C0007;
        Thu,  5 Mar 2020 04:27:03 +0000 (UTC)
From:   Cengiz Can <cengiz@kernel.wtf>
To:     Ming Lei <tom.leiming@gmail.com>
CC:     Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bjorn Helgaas <helgaas@kernel.org>, Jan Kara <jack@suse.cz>,
        "linux-block" <linux-block@vger.kernel.org>,
        stable <stable@vger.kernel.org>, <tristmd@gmail.com>
Date:   Thu, 05 Mar 2020 07:27:02 +0300
Message-ID: <170a8f261f0.2bfa.85c738e3968116fc5c0dc2de74002084@kernel.wtf>
In-Reply-To: <CACVXFVNe4dLFyhaP9BKyR4bdS+zpskFLttPfQMDY0O5RvE0GMA@mail.gmail.com>
References: <20200302220639.GA2393@dhcp-10-100-145-180.wdl.wdc.com>
 <20200303110731.65552-1-cengiz@kernel.wtf>
 <CACVXFVNe4dLFyhaP9BKyR4bdS+zpskFLttPfQMDY0O5RvE0GMA@mail.gmail.com>
User-Agent: AquaMail/1.23.0-1556 (build: 102300002)
Subject: Re: [PATCH] blktrace: Protect q->blk_trace with RCU
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On March 5, 2020 04:51:51 Ming Lei <tom.leiming@gmail.com> wrote:

> On Tue, Mar 3, 2020 at 8:37 PM Cengiz Can <cengiz@kernel.wtf> wrote:
>>
>> Added a reassignment into the NULL check block to fix the issue.
>>
>> Fixes: c780e86dd48 ("blktrace: Protect q->blk_trace with RCU")
>>
>> Signed-off-by: Cengiz Can <cengiz@kernel.wtf>
>> ---
>> kernel/trace/blktrace.c | 4 +++-
>> 1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
>> index 4560878f0bac..29ea88f10b87 100644
>> --- a/kernel/trace/blktrace.c
>> +++ b/kernel/trace/blktrace.c
>> @@ -1896,8 +1896,10 @@ static ssize_t sysfs_blk_trace_attr_store(struct 
>> device *dev,
>> }
>>
>> ret = 0;
>> -       if (bt == NULL)
>> +       if (bt == NULL) {
>>        ret = blk_trace_setup_queue(q, bdev);
>> +               bt = q->blk_trace;
>
> I'd suggest to use the following line for avoiding RCU warning:
>
>   bt = rcu_dereference_protected(q->blk_trace,
>                                       lockdep_is_held(&q->blk_trace_mutex));
>
> Otherwise, the patch looks fine for me:

Thank you.

Please kindly see v2.

>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
>
> Thanks,
> Ming Lei



