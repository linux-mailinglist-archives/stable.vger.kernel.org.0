Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C876931E44F
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 03:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBRCYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 21:24:13 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:55271 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhBRCYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 21:24:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UOreQUc_1613615007;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UOreQUc_1613615007)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 18 Feb 2021 10:23:28 +0800
Subject: Re: [PATCH 1/3] virtio-blk: close udev startup race condition as
 default groups
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com,
        Hannes Reinecke <hare@suse.de>
References: <20210207114656.32141-1-jefflexu@linux.alibaba.com>
 <20210207114656.32141-2-jefflexu@linux.alibaba.com>
 <YB/Vgb4y4Dts0Y2G@kroah.com>
 <f466aacc-f9ca-49ca-0da8-16dc045c9000@linux.alibaba.com>
 <6046ceef-061c-d93f-b6a1-2ce2483bec3c@linux.alibaba.com>
 <YC0ZjUYhSCawoJ7N@kroah.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <e436dc6e-c265-04aa-b560-84370a4c7cb4@linux.alibaba.com>
Date:   Thu, 18 Feb 2021 10:23:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YC0ZjUYhSCawoJ7N@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/17/21 9:26 PM, Greg KH wrote:
> A: http://en.wikipedia.org/wiki/Top_post
> Q: Were do I find info about this thing called top-posting?
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
> 
> A: No.
> Q: Should I include quotations after my reply?
> 
> http://daringfireball.net/2007/07/on_top

Sorry for the inconvenience. I reply in the topmost because I reply to
the email of myself and want to discuss something overall, i.e. if this
issue needs to be fixed in stable tree.


> On Wed, Feb 17, 2021 at 09:12:38PM +0800, JeffleXu wrote:
>> Hi all,
>>
>> Would you please evaluate if these should be fixed in stable tree, at
>> least for the virtio-blk scenario [1] ?
> 
> What is "these"?

I think I have clarified in the previous mail [1]. And yes it was
already one week ago and the context seems a little confusing here.
Sorry for that. In short, the symlink file '/dev/disk/by-id/XXXX' can't
be created for virtio-blk devices, which could be fixed by [2].

> 
>> [1] commit e982c4d0a29b1d61fbe7716a8dcf8984936d6730 ("virtio-blk:
>> modernize sysfs attribute creation")
> 
> Do you want this backported?

Yes, better to have it backported. I can maintain the fix as a private
patch in my 4.19 repository. I request to backport it into 4.19 stable
tree, bacause I think 4.19 stable tree may also suffers this issue.


>  To where?  

At least 4.19 stable tree, though all code previous 4.20 may also
suffers, since this is fixed in 4.20 upstream.


> Why?

Explained in [1].


> If so, where is the working backport that you have properly tested?

I want to backport the upstream patch (commit fef912bf860e and
e982c4d0a29b).

Sasha ever picked up another patch ([3]) from the same upstream patch
set [4], and manually reorganized a little. The reason is explained in [5].

These two patches (commit fef912bf860e and e982c4d0a29b) could be
directly applied to 4.19 stable tree. But to backport these two patches,
like Sasha said in [5], we need to revert the previous patch that Sasha
backported, and apply the upstream version.

I'm not sure if I shall send the patch (since I'm not the author of the
upstream patch), or the maintainer apply the patch directly.



[1] https://www.spinics.net/lists/stable/msg442203.html
[2] commit e982c4d0a29b1d61fbe7716a8dcf8984936d6730 ("virtio-blk:
modernize sysfs attribute creation")
[3]
https://patchwork.kernel.org/project/linux-block/patch/20180905070053.26239-5-hare@suse.de/
[4]
https://patchwork.kernel.org/project/linux-block/cover/20180905070053.26239-1-hare@suse.de/
[5] https://www.spinics.net/lists/stable/msg442196.html

-- 
Thanks,
Jeffle
