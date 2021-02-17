Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C5C31DA01
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 14:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhBQNNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 08:13:33 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:36735 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230473AbhBQNN1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 08:13:27 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UOq-Xju_1613567558;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UOq-Xju_1613567558)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 17 Feb 2021 21:12:38 +0800
Subject: Re: [PATCH 1/3] virtio-blk: close udev startup race condition as
 default groups
From:   JeffleXu <jefflexu@linux.alibaba.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com,
        Hannes Reinecke <hare@suse.de>
References: <20210207114656.32141-1-jefflexu@linux.alibaba.com>
 <20210207114656.32141-2-jefflexu@linux.alibaba.com>
 <YB/Vgb4y4Dts0Y2G@kroah.com>
 <f466aacc-f9ca-49ca-0da8-16dc045c9000@linux.alibaba.com>
Message-ID: <6046ceef-061c-d93f-b6a1-2ce2483bec3c@linux.alibaba.com>
Date:   Wed, 17 Feb 2021 21:12:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <f466aacc-f9ca-49ca-0da8-16dc045c9000@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

Would you please evaluate if these should be fixed in stable tree, at
least for the virtio-blk scenario [1] ?

[1] commit e982c4d0a29b1d61fbe7716a8dcf8984936d6730 ("virtio-blk:
modernize sysfs attribute creation")

On 2/8/21 9:40 AM, JeffleXu wrote:
> 
> 
> On 2/7/21 7:56 PM, Greg KH wrote:
>> On Sun, Feb 07, 2021 at 07:46:54PM +0800, Jeffle Xu wrote:
>>> commit fef912bf860e8e7e48a2bfb978a356bba743a8b7 upstream.
>>> commit e982c4d0a29b1d61fbe7716a8dcf8984936d6730 upstream.
>>>
>>> Similar to commit 9e07f4e24379 ("zram: close udev startup race condition
>>> as default groups"), this is a merge of [1, 2], since [1] may be too
>>> large size to be merged into -stable tree.
>>
>> Why is it too big?
>>
>>> This issue has been introduced since v2.6.36 by [3].
>>>
>>> [1] fef912bf860e, block: genhd: add 'groups' argument to device_add_disk
>>> [2] e982c4d0a29b, virtio-blk: modernize sysfs attribute creation
>>> [3] a5eb9e4ff18a, virtio_blk: Add 'serial' attribute to virtio-blk devices (v2)
>>
>> What userspace tools are now hitting this issue?  If it's a real
>> problem, let's take the real commits, right?
>>
>> Same for the other patches in this series.
>>
> 
> udevd hits this issue. systemd-udevd is responsible for creating
> symlinks, such as '/dev/disk/by-id/XXXX' when receiving KOBJ_ADD uevent
> from kernel space. For virtio-blk devices, udevd will read
> '/sys/devices/pciXXXX/block/serial' to acquire the corresponding serial
> id of the virtio-blk device.
> 
> Without this fixing patch, '/sys/devices/pciXXXX/block/serial' is
> created after the KOBJ_ADD uevent. Thus when udevd received KOBJ_ADD
> uevent, it may find that '/sys/devices/pciXXXX/block/serial' doesn't
> exist at that time, and finally failed to create '/dev/disk/by-id/XXXX'
> symlink.
> 
> I found several similar posts on internet, complaining
> '/dev/disk/by-id/XXXX' is not created for virtio-blk devices. This issue
> indeed is caused by some sort of race condition. I also found that
> systemd-239 doesn't have this issue, while systemd-219 has. But we
> didn't find the exact fixing commit for this issue for systemd-239 though.
> 

-- 
Thanks,
Jeffle
