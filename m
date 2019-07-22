Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582406F6C1
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 02:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfGVAjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 20:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfGVAjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 20:39:52 -0400
Received: from localhost (unknown [216.243.17.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 390EC206BF;
        Mon, 22 Jul 2019 00:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563755991;
        bh=4/CB9Ayev5JKrE0XJ4YE64N8BfVO1NLnfPU/tzmyKWQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WScm1ORm+ix420nLZYK26vO4F4umJ40LKSDGPOakSl0fyTreIKkR7EPyUfNsCLg0u
         y0y8WaNpLrv3OLH8z1IvXwlD62ECXecZ7cyMmYFwKEW5ibuiZs+EzcdeAFM5Mbcmfs
         YVTrt0lwB62hI+ONtjKcxfodws8st6L+P9zp/7vg=
Date:   Sun, 21 Jul 2019 20:39:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.2 129/249] blk-iolatency: only account
 submitted bios
Message-ID: <20190722003950.GC1607@sasha-vm>
References: <20190715134655.4076-1-sashal@kernel.org>
 <20190715134655.4076-129-sashal@kernel.org>
 <20190715195806.GA77907@dennisz-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190715195806.GA77907@dennisz-mbp>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 15, 2019 at 03:58:06PM -0400, Dennis Zhou wrote:
>On Mon, Jul 15, 2019 at 09:44:54AM -0400, Sasha Levin wrote:
>> From: Dennis Zhou <dennis@kernel.org>
>>
>> [ Upstream commit a3fb01ba5af066521f3f3421839e501bb2c71805 ]
>>
>> As is, iolatency recognizes done_bio and cleanup as ending paths. If a
>> request is marked REQ_NOWAIT and fails to get a request, the bio is
>> cleaned up via rq_qos_cleanup() and ended in bio_wouldblock_error().
>> This results in underflowing the inflight counter. Fix this by only
>> accounting bios that were actually submitted.
>>
>> Signed-off-by: Dennis Zhou <dennis@kernel.org>
>> Cc: Josef Bacik <josef@toxicpanda.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  block/blk-iolatency.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
>> index d22e61bced86..c91b84bb9d0a 100644
>> --- a/block/blk-iolatency.c
>> +++ b/block/blk-iolatency.c
>> @@ -600,6 +600,10 @@ static void blkcg_iolatency_done_bio(struct rq_qos *rqos, struct bio *bio)
>>  	if (!blkg || !bio_flagged(bio, BIO_TRACKED))
>>  		return;
>>
>> +	/* We didn't actually submit this bio, don't account it. */
>> +	if (bio->bi_status == BLK_STS_AGAIN)
>> +		return;
>> +
>>  	iolat = blkg_to_lat(bio->bi_blkg);
>>  	if (!iolat)
>>  		return;
>> --
>> 2.20.1
>>
>
>Hi Sasha,
>
>If you're going to pick this up, c9b3007feca0 ("blk-iolatency: fix
>STS_AGAIN handling") fixes this patch, so please pick that up too.

I've picked it up, thanks!

--
Thanks,
Sasha
