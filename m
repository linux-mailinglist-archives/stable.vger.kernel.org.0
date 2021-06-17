Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D24D3ABF56
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 01:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhFQX2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 19:28:34 -0400
Received: from mail.klausen.dk ([157.90.24.29]:53242 "EHLO mail.klausen.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233003AbhFQX2d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Jun 2021 19:28:33 -0400
X-Greylist: delayed 4444 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jun 2021 19:28:33 EDT
Subject: Re: [PATCH] loop: Fix missing discard support when using
 LOOP_CONFIGURE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=klausen.dk; s=dkim;
        t=1623972380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vbn0+3h5DgI8ES1Iq5xmrf83w+go5eMbfDrACNi+IXI=;
        b=EEWCeGBCComITFZI0wjYvj4fzKKJPD21r1GbCyHZzX/yBTQlPh1EBQxjkJ0QQfWNsvaXT1
        CbpEfu0vIK5DQu4oEsdBjAjh6sg6ZJDUyO+MTwZYninaAZs3QWWzJlj06ZZRx3xkQzZiLj
        zIFOPvDFu1p6qyRCsJGd0jImD71exHg=
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Martijn Coenen <maco@android.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20210617221158.7045-1-kristian@klausen.dk>
 <YMvUw3E51fvezQN/@T590>
From:   Kristian Klausen <kristian@klausen.dk>
Message-ID: <8445d1b6-0118-37d4-c927-3b7e6ff480ea@klausen.dk>
Date:   Fri, 18 Jun 2021 01:26:19 +0200
MIME-Version: 1.0
In-Reply-To: <YMvUw3E51fvezQN/@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.06.2021 01.03, Ming Lei wrote:
> On Fri, Jun 18, 2021 at 12:11:57AM +0200, Kristian Klausen wrote:
>
> Commit log?

I will try to come up with a commit message. AFAIU the missing call to 
loop_config_discard() causes the block device to report "no discard 
support" (best-case) or stale/incorrect discard support (ex: if the loop 
device was configured with LOOP_SET_STATUS(64) and later LOOP_CONFIGURE).

>
>> Cc: <stable@vger.kernel.org> # 5.8.x-
>> Fixes: 3448914e8cc5 ("loop: Add LOOP_CONFIGURE ioctl")
>> Signed-off-by: Kristian Klausen <kristian@klausen.dk>
>> ---
>> Tested like so (without the patch):
>> losetup 2.37<= uses LOOP_CONFIGURE instead of LOOP_SET_STATUS64[1]
>>
>> # fallocate -l100M disk.img
>> # rmmod loop
>> # losetup --version
>> losetup from util-linux 2.36.2
>> # losetup --find --show disk.img
>> /dev/loop0
>> # grep '' /sys/devices/virtual/block/loop0/queue/*discard*
>> /sys/devices/virtual/block/loop0/queue/discard_granularity:4096
>> /sys/devices/virtual/block/loop0/queue/discard_max_bytes:4294966784
>> /sys/devices/virtual/block/loop0/queue/discard_max_hw_bytes:4294966784
>> /sys/devices/virtual/block/loop0/queue/discard_zeroes_data:0
>> /sys/devices/virtual/block/loop0/queue/max_discard_segments:1
>> # losetup -d /dev/loop0
>> # [update util-linux]
>> # losetup --version
>> losetup from util-linux 2.37
>> # rmmod loop
>> # losetup --find --show disk.img
>> /dev/loop0
>> # grep '' /sys/devices/virtual/block/loop0/queue/*discard*
>> /sys/devices/virtual/block/loop0/queue/discard_granularity:0
>> /sys/devices/virtual/block/loop0/queue/discard_max_bytes:0
>> /sys/devices/virtual/block/loop0/queue/discard_max_hw_bytes:0
>> /sys/devices/virtual/block/loop0/queue/discard_zeroes_data:0
>> /sys/devices/virtual/block/loop0/queue/max_discard_segments:1
>>
>>
>> With the patch applied:
>>
>> # losetup --version
>> losetup from util-linux 2.37
>> # rmmod loop
>> # losetup --find --show disk.img
>> /dev/loop0
>> # grep '' /sys/devices/virtual/block/loop0/queue/*discard*
>> /sys/devices/virtual/block/loop0/queue/discard_granularity:4096
>> /sys/devices/virtual/block/loop0/queue/discard_max_bytes:4294966784
>> /sys/devices/virtual/block/loop0/queue/discard_max_hw_bytes:4294966784
>> /sys/devices/virtual/block/loop0/queue/discard_zeroes_data:0
>> /sys/devices/virtual/block/loop0/queue/max_discard_segments:1
>>
>> [1] https://github.com/karelzak/util-linux/pull/1152
>>
>>   drivers/block/loop.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
>> index 76e12f3482a9..ec957f6d8a49 100644
>> --- a/drivers/block/loop.c
>> +++ b/drivers/block/loop.c
>> @@ -1168,6 +1168,8 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
>>   	if (partscan)
>>   		lo->lo_disk->flags &= ~GENHD_FL_NO_PART_SCAN;
>>   
>> +	loop_config_discard(lo);
>> +
> It could be better to move loop_config_discard() around
> loop_update_rotational/loop_update_dio(), then we setup everything
> before updating loop as Lo_bound.

I will move it before loop_update_rotational().

>
> Otherwise, this patch looks fine.
>
>
> Thanks,
> Ming
>

