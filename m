Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 914E11A5AB
	for <lists+stable@lfdr.de>; Sat, 11 May 2019 02:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfEKAFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 20:05:46 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:32782 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727921AbfEKAFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 20:05:46 -0400
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 May 2019 20:05:45 EDT
Received: from tux.wizards.de (pD9EBF14A.dip0.t-ipconnect.de [217.235.241.74])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 0865E4168C0A;
        Sat, 11 May 2019 01:58:06 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 7A94E6D3233;
        Sat, 11 May 2019 01:58:05 +0200 (CEST)
Subject: Re: [PATCH] bfq: backport: update internal depth state when queue
 depth changes
To:     Eric Wheeler <stable@lists.ewheeler.net>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "open list:BFQ I/O SCHEDULER" <linux-block@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Eric Wheeler <bfq@linux.ewheeler.net>, stable@vger.kernel.org
References: <1557510992-18506-1-git-send-email-stable@lists.ewheeler.net>
 <20190510201855.GB14410@sasha-vm>
 <alpine.LRH.2.11.1905102312220.4789@mx.ewheeler.net>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <a5e71713-3ce6-2888-1658-c973393a01ec@applied-asynchrony.com>
Date:   Sat, 11 May 2019 01:58:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.1905102312220.4789@mx.ewheeler.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/11/19 1:17 AM, Eric Wheeler wrote:
> On Fri, 10 May 2019, Sasha Levin wrote:
> 
>> On Fri, May 10, 2019 at 10:56:32AM -0700, Eric Wheeler wrote:
>>> From: Jens Axboe <axboe@kernel.dk>
>>>
>>> commit 77f1e0a52d26242b6c2dba019f6ebebfb9ff701e upstream
>>>
>>> A previous commit moved the shallow depth and BFQ depth map calculations
>>> to be done at init time, moving it outside of the hotter IO path. This
>>> potentially causes hangs if the users changes the depth of the scheduler
>>> map, by writing to the 'nr_requests' sysfs file for that device.
>>>
>>> Add a blk-mq-sched hook that allows blk-mq to inform the scheduler if
>>> the depth changes, so that the scheduler can update its internal state.
>>>
>>> Signed-off-by: Eric Wheeler <bfq@linux.ewheeler.net>
>>> Tested-by: Kai Krakow <kai@kaishome.de>
>>> Reported-by: Paolo Valente <paolo.valente@linaro.org>
>>> Fixes: f0635b8a416e ("bfq: calculate shallow depths at init time")
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> Cc: stable@vger.kernel.org
>>
>> I wasn't clear on what was backported here, so I've queued the upstream
>> version on 4.19 and 4.14, it doesn't seem to be relevant to older
>> branches.
> 
> 
> Thanks Sasha.  We needed it for 4.19, I wasn't sure how far it would patch
> back so I left the version off.  BFQ was merged in 4.12 iirc, so if it
> patched against 4.14, then 4.19 and 4.14 are the only ones that need it.

It was applied in mainline for 5.1 and also applies fine to 5.0.x, so IMHO
that wouldn't hurt either.

thanks,
Holger
