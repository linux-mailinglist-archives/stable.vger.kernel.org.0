Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB33A5EEE51
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 09:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbiI2HEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 03:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235025AbiI2HDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 03:03:44 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B3C13199E;
        Thu, 29 Sep 2022 00:03:37 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1odna3-0001iF-A2; Thu, 29 Sep 2022 09:03:35 +0200
Message-ID: <9e3a4bf9-c909-d6aa-28c8-5fbbea9f5ae3@leemhuis.info>
Date:   Thu, 29 Sep 2022 09:03:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: significant drop fio IOPS performance on v5.10 #forregzbot
Content-Language: en-US, de-DE
To:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <357ace228adf4e859df5e9f3f4f18b49@amazon.com>
 <1cdc68e6a98d4e93a95be5d887bcc75d@amazon.com>
 <5c819c9d6190452f9b10bb78a72cb47f@amazon.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <5c819c9d6190452f9b10bb78a72cb47f@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1664435017;c1245439;
X-HE-SMSGID: 1odna3-0001iF-A2
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TWIMC: this mail is primarily send for documentation purposes and for
regzbot, my Linux kernel regression tracking bot. These mails usually
contain '#forregzbot' in the subject, to make them easy to spot and filter.

[TLDR: I'm adding this regression report to the list of tracked
regressions; all text from me you find below is based on a few templates
paragraphs you might have encountered already already in similar form.]

Hi, this is your Linux kernel regression tracker.

On 28.09.22 08:07, Lu, Davina wrote:
> 
> Hello,
> 
> I was profiling the 5.10 kernel and comparing it to 4.14.  On a system with 64 virtual CPUs and 256 GiB of RAM, I am observing a significant drop in IO performance. Using the following FIO with the script "sudo ftest_write.sh <dev_name>" in attachment, I saw FIO iops result drop from 22K to less than 1K. 
> The script simply does: mount a the EXT4 16GiB volume with max IOPS 64000K, mounting option is " -o noatime,nodiratime,data=ordered", then run fio with 2048 fio wring thread with 28800000 file size with { --name=16kb_rand_write_only_2048_jobs --directory=/rdsdbdata1 --rw=randwrite --ioengine=sync --buffered=1 --bs=16k --max-jobs=2048 --numjobs=2048 --runtime=60 --time_based --thread --filesize=28800000 --fsync=1 --group_reporting }.
> 
> My analyzing is that the degradation is introduce by commit {244adf6426ee31a83f397b700d964cff12a247d3} and the issue is the contention on rsv_conversion_wq.  The simplest option is to increase the journal size, but that introduces more operational complexity.  Another option is to add the following change in attachment "allow more ext4-rsv-conversion workqueue.patch"
> 
> From 27e1b0e14275a281b3529f6a60c7b23a81356751 Mon Sep 17 00:00:00 2001
> From: davinalu <davinalu@amazon.com>
> Date: Fri, 23 Sep 2022 00:43:53 +0000
> Subject: [PATCH] allow more ext4-rsv-conversion workqueue to speedup fio  writing
> ---
>  fs/ext4/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c index a0af833f7da7..6b34298cdc3b 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4963,7 +4963,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>          * concurrency isn't really necessary.  Limit it to 1.
>          */
>         EXT4_SB(sb)->rsv_conversion_wq =
> -               alloc_workqueue("ext4-rsv-conversion", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
> +               alloc_workqueue("ext4-rsv-conversion", WQ_MEM_RECLAIM | 
> + WQ_UNBOUND | __WQ_ORDERED, 0);
>         if (!EXT4_SB(sb)->rsv_conversion_wq) {
>                 printk(KERN_ERR "EXT4-fs: failed to create workqueue\n");
>                 ret = -ENOMEM;
> 
> My thought is: If the max_active is 1, it means the "__WQ_ORDERED" combined with WQ_UNBOUND setting, based on alloc_workqueue(). So I added it .
> I am not sure should we need "__WQ_ORDERED" or not? without "__WQ_ORDERED" it looks also work at my testbed, but I added since not much fio TP difference on my testbed result with/out "__WQ_ORDERED".
> 
> From My understanding and observation: with dioread_unlock and delay_alloc both enabled,  the  bio_endio() and ext4_writepages() will trigger this work queue to ext4_do_flush_completed_IO(). Looks like the work queue is an one-by-one updating: at EXT4 extend.c io_end->list_vec  list only have one io_end_vec each time. So if the BIO has high performance, and we have only one thread to do EXT4 flush will be an bottleneck here. The "ext4-rsv-conversion" this workqueue is mainly for update the EXT4_IO_END_UNWRITTEN extend block(only exist on dioread_unlock and delay_alloc options are set) and extend status  if I understand correctly here. Am  I correct?
> 
> This works on my test system and passes xfstests, but  will this cause any corruption on ext4 extends blocks updates, not even sure about the journal transaction updates either?
> Can you tell me what I will break if this change is made?

Thanks for the report. To be sure below issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
tracking bot:

#regzbot ^introduced 244adf6426ee31a8
#regzbot title ext4: significant drop  fio IOPS performance on v5.10
#regzbot backburner: performance regression introduced a while ago that
will take some time to get analyzed and fixed
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply -- ideally with also
telling regzbot about it, as explained here:
https://linux-regtracking.leemhuis.info/tracked-regression/

Reminder for developers: When fixing the issue, add 'Link:' tags
pointing to the report (the mail this one replies to), as explained for
in the Linux kernel's documentation; above webpage explains why this is
important for tracked regressions.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
