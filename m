Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE8D44B99
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 21:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbfFMTFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 15:05:52 -0400
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:36525 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727298AbfFMTFw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 15:05:52 -0400
Received: from [4.30.142.84] (helo=srivatsab-a01.vmware.com)
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1hbV2i-0007Iv-Mi; Thu, 13 Jun 2019 15:05:48 -0400
Subject: Re: CFQ idling kills I/O performance on ext4 with blkio cgroup
 controller
To:     Jan Kara <jack@suse.cz>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        linux-fsdevel@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        linux-ext4@vger.kernel.org, cgroups@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, amakhalov@vmware.com,
        anishs@vmware.com, srivatsab@vmware.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stable <stable@vger.kernel.org>
References: <a04368ba-f1d5-8f2c-1279-a685a137d024@csail.mit.edu>
 <E270AD92-943E-4529-8158-AB480D6D9DF8@linaro.org>
 <5b71028c-72f0-73dd-0cd5-f28ff298a0a3@csail.mit.edu>
 <FFA44D26-75FF-4A8E-A331-495349BE5FFC@linaro.org>
 <0d6e3c02-1952-2177-02d7-10ebeb133940@csail.mit.edu>
 <7B74A790-BD98-412B-ADAB-3B513FB1944E@linaro.org>
 <6a6f4aa4-fc95-f132-55b2-224ff52bd2d8@csail.mit.edu>
 <7c5e9d11-4a3d-7df4-c1e6-7c95919522ab@csail.mit.edu>
 <20190612130446.GD14578@quack2.suse.cz>
 <dd32ed59-a543-fc76-9a9a-2462f0119270@csail.mit.edu>
 <20190613082053.GD26505@quack2.suse.cz>
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Message-ID: <f30aaec1-d629-1c82-50da-16b2eaea16c5@csail.mit.edu>
Date:   Thu, 13 Jun 2019 12:05:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613082053.GD26505@quack2.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/19 1:20 AM, Jan Kara wrote:
> On Wed 12-06-19 12:36:53, Srivatsa S. Bhat wrote:
>>
>> [ Adding Greg to CC ]
>>
>> On 6/12/19 6:04 AM, Jan Kara wrote:
>>> On Tue 11-06-19 15:34:48, Srivatsa S. Bhat wrote:
>>>> On 6/2/19 12:04 AM, Srivatsa S. Bhat wrote:
>>>>> On 5/30/19 3:45 AM, Paolo Valente wrote:
>>>>>>
>>>> [...]
>>>>>> At any rate, since you pointed out that you are interested in
>>>>>> out-of-the-box performance, let me complete the context: in case
>>>>>> low_latency is left set, one gets, in return for this 12% loss,
>>>>>> a) at least 1000% higher responsiveness, e.g., 1000% lower start-up
>>>>>> times of applications under load [1];
>>>>>> b) 500-1000% higher throughput in multi-client server workloads, as I
>>>>>> already pointed out [2].
>>>>>>
>>>>>
>>>>> I'm very happy that you could solve the problem without having to
>>>>> compromise on any of the performance characteristics/features of BFQ!
>>>>>
>>>>>
>>>>>> I'm going to prepare complete patches.  In addition, if ok for you,
>>>>>> I'll report these results on the bug you created.  Then I guess we can
>>>>>> close it.
>>>>>>
>>>>>
>>>>> Sounds great!
>>>>>
>>>>
>>>> Hi Paolo,
>>>>
>>>> Hope you are doing great!
>>>>
>>>> I was wondering if you got a chance to post these patches to LKML for
>>>> review and inclusion... (No hurry, of course!)
>>>>
>>>> Also, since your fixes address the performance issues in BFQ, do you
>>>> have any thoughts on whether they can be adapted to CFQ as well, to
>>>> benefit the older stable kernels that still support CFQ?
>>>
>>> Since CFQ doesn't exist in current upstream kernel anymore, I seriously
>>> doubt you'll be able to get any performance improvements for it in the
>>> stable kernels...
>>>
>>
>> I suspected as much, but that seems unfortunate though. The latest LTS
>> kernel is based on 4.19, which still supports CFQ. It would have been
>> great to have a process to address significant issues on older
>> kernels too.
> 
> Well, you could still tune the performance difference by changing
> slice_idle and group_idle tunables for CFQ (in
> /sys/block/<device>/queue/iosched/).  Changing these to lower values will
> reduce the throughput loss when switching between cgroups at the cost of
> lower accuracy of enforcing configured IO proportions among cgroups.
> 

Good point, and seems fair enough, thank you!

Regards,
Srivatsa
VMware Photon OS
