Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 113E01B6C0
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 15:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbfEMNJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 09:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbfEMNJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 09:09:19 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE68D2084E;
        Mon, 13 May 2019 13:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557752958;
        bh=KkqV3CLkW9DHGPmOz1StcnAUfjD+S3y9+yxgb3uPnoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SscWy4668nXYSqxL+8MfdysR79LlzGGhXYGhD0inJHqgry8Ngg4m2Cx8FyvKRWC1b
         6p7widJk5L08+t3cVG62MJIfB5s46aM5yfgLWBHnQs79wNUWWlHfdLiAUtcZj8NwGV
         cuUUXY8fMwFoz5CUKdxYIKLCrp2v1yqohT5CErso=
Date:   Mon, 13 May 2019 09:09:16 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     Eric Wheeler <stable@lists.ewheeler.net>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "open list:BFQ I/O SCHEDULER" <linux-block@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Eric Wheeler <bfq@linux.ewheeler.net>, stable@vger.kernel.org
Subject: Re: [PATCH] bfq: backport: update internal depth state when queue
 depth changes
Message-ID: <20190513130916.GB11972@sasha-vm>
References: <1557510992-18506-1-git-send-email-stable@lists.ewheeler.net>
 <20190510201855.GB14410@sasha-vm>
 <20190513070337.GB26553@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190513070337.GB26553@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 09:03:37AM +0200, Greg KH wrote:
>On Fri, May 10, 2019 at 04:18:55PM -0400, Sasha Levin wrote:
>> On Fri, May 10, 2019 at 10:56:32AM -0700, Eric Wheeler wrote:
>> > From: Jens Axboe <axboe@kernel.dk>
>> >
>> > commit 77f1e0a52d26242b6c2dba019f6ebebfb9ff701e upstream
>> >
>> > A previous commit moved the shallow depth and BFQ depth map calculations
>> > to be done at init time, moving it outside of the hotter IO path. This
>> > potentially causes hangs if the users changes the depth of the scheduler
>> > map, by writing to the 'nr_requests' sysfs file for that device.
>> >
>> > Add a blk-mq-sched hook that allows blk-mq to inform the scheduler if
>> > the depth changes, so that the scheduler can update its internal state.
>> >
>> > Signed-off-by: Eric Wheeler <bfq@linux.ewheeler.net>
>> > Tested-by: Kai Krakow <kai@kaishome.de>
>> > Reported-by: Paolo Valente <paolo.valente@linaro.org>
>> > Fixes: f0635b8a416e ("bfq: calculate shallow depths at init time")
>> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> > Cc: stable@vger.kernel.org
>>
>> I wasn't clear on what was backported here, so I've queued the upstream
>> version on 4.19 and 4.14, it doesn't seem to be relevant to older
>> branches.
>
>I only see this added to the 5.0 and 4.19 queues, did you forget to push
>the 4.14 update?

Sorry, I meant to say that I applied it to 5.0 and 4.19. The patch it
fixes, f0635b8a416e ("bfq: calculate shallow depths at init time"),
isn't in 4.14 nor was it backported there by us.

--
Thanks,
Sasha
