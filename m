Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC7B5B1ED1
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 15:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiIHN0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 09:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiIHNZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 09:25:43 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B4B80B40
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 06:25:29 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oWHX6-0001tB-0o; Thu, 08 Sep 2022 15:25:28 +0200
Message-ID: <d4cc0b17-24f8-1ded-7495-c4c5e7359d11@leemhuis.info>
Date:   Thu, 8 Sep 2022 15:25:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [REGRESSION] v5.17-rc1+: FIFREEZE ioctl system call hangs
 #forregzbot
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     regressions@lists.linux.dev
Cc:     stable@vger.kernel.org
References: <000401d8a746$3eaca200$bc05e600$@whissi.de>
 <000001d8ad7e$c340ad70$49c20850$@whissi.de>
 <2a2d1075-aa22-8c4d-ca21-274200dce2fc@leemhuis.info>
In-Reply-To: <2a2d1075-aa22-8c4d-ca21-274200dce2fc@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1662643529;0ac97b01;
X-HE-SMSGID: 1oWHX6-0001tB-0o
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TWIMC: this mail is primarily send for documentation purposes and for
regzbot, my Linux kernel regression tracking bot. These mails usually
contain '#forregzbot' in the subject, to make them easy to spot and filter.

#regzbot fixed-by: e053aaf4da56cbf0afb33a0fda4a62188e2c0637

On 15.08.22 12:58, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker. Top-posting for once,
> to make this easily accessible to everyone.
> 
> [CCing Jens, as the top-level maintainer who in this case also reviewed
> the patch that causes this regression.]
> 
> Vishal, Song, what up here? Could you please look into this and at least
> comment on the issue, as it's a regression that was reported more than
> 10 days ago already. Ideally at this point it would be good if the
> regression was fixed already, as explained by "Prioritize work on fixing
> regressions" here:
> https://docs.kernel.org/process/handling-regressions.html#prioritize-work-on-fixing-regressions
> 
> Ciao, Thorsten
> 
> On 11.08.22 14:34, Thomas Deutschmann wrote:
> 
>>
>> Hi,
>>
>> any news on this? Is there anything else you need from me or I can help
>> with?
>>
>> Thanks.
>>
>>
>> -- Regards, Thomas -----Original Message----- From: Thomas Deutschmann
>> <whissi@whissi.de> Sent: Wednesday, August 3, 2022 4:35 PM To:
>> vverma@digitalocean.com; song@kernel.org Cc: stable@vger.kernel.org;
>> regressions@lists.linux.dev Subject: [REGRESSION] v5.17-rc1+: FIFREEZE
>> ioctl system call hangs Hi, while trying to backup a Dell R7525 system
>> running Debian bookworm/testing using LVM snapshots I noticed that the
>> system will 'freeze' sometimes (not all the times) when creating the
>> snapshot. First I thought this was related to LVM so I created
>> https://listman.redhat.com/archives/linux-lvm/2022-July/026228.html
>> (continued at
>> https://listman.redhat.com/archives/linux-lvm/2022-August/thread.html#26229) Long story short: I was even able to reproduce with fsfreeze, see last strace lines
>>> [...]
>>> 14471 1659449870.984635 openat(AT_FDCWD, "/var/lib/machines", O_RDONLY) =3
>>> 14471 1659449870.984658 newfstatat(3, "",
>> {st_mode=S_IFDIR|0700,st_size=4096, ...}, AT_EMPTY_PATH) = 0
>>> 14471 1659449870.984678 ioctl(3, FIFREEZE
>> so I started to bisect kernel and found the following bad commit:
>>
>>> md: add support for REQ_NOWAIT
>>>
>>> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
>>> for checking whether a given bdev supports handling of REQ_NOWAIT or not.
>>> Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable
>>> it for linear target") added support for REQ_NOWAIT for dm. This uses
>>> a similar approach to incorporate REQ_NOWAIT for md based bios.
>>>
>>> This patch was tested using t/io_uring tool within FIO. A nvme drive
>>> was partitioned into 2 partitions and a simple raid 0 configuration
>>> /dev/md0 was created.
>>>
>>> md0 : active raid0 nvme4n1p1[1] nvme4n1p2[0]
>>>       937423872 blocks super 1.2 512k chunks
>>>
>>> Before patch:
>>>
>>> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>>>
>>> Running top while the above runs:
>>>
>>> $ ps -eL | grep $(pidof io_uring)
>>>
>>>   38396   38396 pts/2    00:00:00 io_uring
>>>   38396   38397 pts/2    00:00:15 io_uring
>>>   38396   38398 pts/2    00:00:13 iou-wrk-38397
>>>
>>> We can see iou-wrk-38397 io worker thread created which gets created
>>> when io_uring sees that the underlying device (/dev/md0 in this case)
>>> doesn't support nowait.
>>>
>>> After patch:
>>>
>>> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>>>
>>> Running top while the above runs:
>>>
>>> $ ps -eL | grep $(pidof io_uring)
>>>
>>>   38341   38341 pts/2    00:10:22 io_uring
>>>   38341   38342 pts/2    00:10:37 io_uring
>>>
>>> After running this patch, we don't see any io worker thread
>>> being created which indicated that io_uring saw that the
>>> underlying device does support nowait. This is the exact behaviour
>>> noticed on a dm device which also supports nowait.
>>>
>>> For all the other raid personalities except raid0, we would need
>>> to train pieces which involves make_request fn in order for them
>>> to correctly handle REQ_NOWAIT.
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?i
>> d=f51d46d0e7cb5b8494aa534d276a9d8915a2443d
>>
>> After reverting this commit (and follow up commit
>> 0f9650bd838efe5c52f7e5f40c3204ad59f1964d)
>> v5.18.15 and v5.19 worked for me again.
>>
>> At this point I still wonder why I experienced the same problem even after I
>> removed one nvme device from the mdraid array and tested it separately. So
>> maybe there is another nowait/REQ_NOWAIT problem somewhere. During bisect
>> I only tested against the mdraid array.
>>
>>
>> #regzbot introduced: f51d46d0e7cb5b8494aa534d276a9d8915a2443d
>> #regzbot link:
>> https://listman.redhat.com/archives/linux-lvm/2022-July/026228.html
>> #regzbot link:
>> https://listman.redhat.com/archives/linux-lvm/2022-August/thread.html#26229
>>
>>
>> -- Regards, Thomas
>>
