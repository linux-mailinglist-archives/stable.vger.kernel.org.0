Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194805969DC
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 08:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiHQGxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 02:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiHQGxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 02:53:53 -0400
Received: from yamato.tf-network.de (yamato.tf-network.de [93.186.202.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FE35C948
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 23:53:51 -0700 (PDT)
Received: from amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221])
        by yamato.tf-network.de (Postfix) with ESMTP id 4M6zJF2t04z4Rg6;
        Wed, 17 Aug 2022 08:53:49 +0200 (CEST)
X-Virus-Scanned: amavisd-new at amavis3.tf-network.de
Received: from smtp.tf-network.de ([93.186.202.221])
        by amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221]) (amavisd-new, port 10024)
        with LMTP id kIgk1_S4t-BQ; Wed, 17 Aug 2022 08:53:48 +0200 (CEST)
Received: from [10.1.0.10] (xdsl-89-1-142-166.nc.de [89.1.142.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp.tf-network.de (Postfix) with ESMTPSA id 4M6zJD3M9gz442N;
        Wed, 17 Aug 2022 08:53:48 +0200 (CEST)
Message-ID: <43e678ca-3fc3-6c08-f035-2c31a34dd889@whissi.de>
Date:   Wed, 17 Aug 2022 08:53:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Subject: Re: [REGRESSION] v5.17-rc1+: FIFREEZE ioctl system call hangs
Content-Language: en-US
To:     Song Liu <song@kernel.org>, Vishal Verma <vverma@digitalocean.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        Jens Axboe <axboe@kernel.dk>
References: <000401d8a746$3eaca200$bc05e600$@whissi.de>
 <000001d8ad7e$c340ad70$49c20850$@whissi.de>
 <2a2d1075-aa22-8c4d-ca21-274200dce2fc@leemhuis.info>
 <0FBCAB10-545E-45E2-A0C8-D7620817651D@digitalocean.com>
 <CAPhsuW5f9QD+gzJ9eBhn5irsHvrsvkWjSnA4MPaHsQjjLMypXg@mail.gmail.com>
From:   Thomas Deutschmann <whissi@whissi.de>
In-Reply-To: <CAPhsuW5f9QD+gzJ9eBhn5irsHvrsvkWjSnA4MPaHsQjjLMypXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2022-08-17 08:19, Song Liu wrote:
> On Mon, Aug 15, 2022 at 8:46 AM Vishal Verma
> <vverma@digitalocean.com> wrote:
>> 
>> Just saw this. I’m trying to understand whether this happens only
>> on md array or individual nvme drives (without any raid) too? The
>> commit you pointed added REQ_NOWAIT for md based arrays, but if it
>> is happening on individual nvme drives then that could point to
>> something with REQ_NOWAIT I think.
> 
> Agreed with this analysis.

I bisected again, this time I tested against the single nvme device.

I did it 2 times, and always ended up with

 > git bisect start
 > # good: [8bb7eca972ad531c9b149c0a51ab43a417385813] Linux 5.15
 > git bisect good 8bb7eca972ad531c9b149c0a51ab43a417385813
 > # bad: [df0cc57e057f18e44dac8e6c18aba47ab53202f9] Linux 5.16
 > git bisect bad df0cc57e057f18e44dac8e6c18aba47ab53202f9
 > # good: [2219b0ceefe835b92a8a74a73fe964aa052742a2] Merge tag 
'soc-5.16' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
 > git bisect good 2219b0ceefe835b92a8a74a73fe964aa052742a2
 > # good: [206825f50f908771934e1fba2bfc2e1f1138b36a] Merge tag 
'mtd/for-5.16' of git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux
 > git bisect good 206825f50f908771934e1fba2bfc2e1f1138b36a
 > # bad: [4e1fddc98d2585ddd4792b5e44433dcee7ece001] tcp_cubic: fix 
spurious Hystart ACK train detections for not-cwnd-limited flows
 > git bisect bad 4e1fddc98d2585ddd4792b5e44433dcee7ece001
 > # good: [dbf49896187fd58c577fa1574a338e4f3672b4b2] Merge branch 
'akpm' (patches from Andrew)
 > git bisect good dbf49896187fd58c577fa1574a338e4f3672b4b2
 > # good: [0ecca62beb12eeb13965ed602905c8bf53ac93d0] Merge tag 
'ceph-for-5.16-rc1' of git://github.com/ceph/ceph-client
 > git bisect good 0ecca62beb12eeb13965ed602905c8bf53ac93d0
 > # bad: [7d5775d49e4a488bc8a07e5abb2b71a4c28aadbb] Merge tag 
'printk-for-5.16-fixup' of 
git://git.kernel.org/pub/scm/linux/kernel/git/printk/linux
 > git bisect bad 7d5775d49e4a488bc8a07e5abb2b71a4c28aadbb
 > # good: [35c8fad4a703fdfa009ed274f80bb64b49314cde] Merge tag 
'perf-tools-for-v5.16-2021-11-13' of 
git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux
 > git bisect good 35c8fad4a703fdfa009ed274f80bb64b49314cde
 > # good: [6ea45c57dc176dde529ab5d7c4b3f20e52a2bd82] Merge tag 
'for-linus' of git://git.armlinux.org.uk/~rmk/linux-arm
 > git bisect good 6ea45c57dc176dde529ab5d7c4b3f20e52a2bd82
 > # bad: [fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf] Linux 5.16-rc1
 > git bisect bad fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf
 > # good: [475c3f599582a34e189f047ed3fb7e90a295ea5b] sh: fix READ/WRITE 
redefinition warnings
 > git bisect good 475c3f599582a34e189f047ed3fb7e90a295ea5b
 > # good: [c3b68c27f58a07130382f3fa6320c3652ad76f15] Merge tag 
'for-5.16/parisc-3' of 
git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux
 > git bisect good c3b68c27f58a07130382f3fa6320c3652ad76f15
 > # good: [4a6b35b3b3f28df81fea931dc77c4c229cbdb5b2] xfs: sync 
xfs_btree_split macros with userspace libxfs
 > git bisect good 4a6b35b3b3f28df81fea931dc77c4c229cbdb5b2
 > # good: [dee2b702bcf067d7b6b62c18bdd060ff0810a800] kconfig: Add 
support for -Wimplicit-fallthrough
 > git bisect good dee2b702bcf067d7b6b62c18bdd060ff0810a800
 > # first bad commit: [fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf] Linux 
5.16-rc1

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf

...but this doesn't make any sense, right?

However, I cannot reproduce with the commit before, i.e. dee2b702bcf0 
didn't freeze during my 10 test runs.
But with fa55b7dcdc (or any later commit), system will freeze on _every_ 
test run?!

I checked out 1bd297988b75 which never failed before, changed Makefile 
to PATCHLEVEL=16 and EXTRAVERSION=-rc1 and guess what: It's now failing, 
too.

So this sounds like some code changes behavior when KV is >=5.16-rc1. Is 
that possible?

Anyway, I started to test v5.10 (with PATCHLEVEL=16 and 
EXTRAVERSION=-rc1 set) which worked so I started another bisect session 
where I named all KV to 5.16-rc1.

I'll post my finding when this session is completed.


> I am not able to reproduce this on 5.19+ kernel. I have:
> 
> [root@eth50-1 ~]# lsblk NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT 
> sr0      11:0    1 1024M  0 rom vda     253:0    0   32G  0 disk 
> ├─vda1  253:1    0    2G  0 part  /boot └─vda2  253:2    0   30G  0
> part  / nvme0n1 259:0    0    4G  0 disk └─md0     9:0    0   12G  0
> raid5 /root/mnt nvme2n1 259:1    0    4G  0 disk └─md0     9:0    0
> 12G  0 raid5 /root/mnt nvme3n1 259:2    0    4G  0 disk └─md0     9:0
> 0   12G  0 raid5 /root/mnt nvme1n1 259:3    0    4G  0 disk └─md0
> 9:0    0   12G  0 raid5 /root/mnt [root@eth50-1 ~]# for x in {1..100}
> ; do fsfreeze --unfreeze /root/mnt ; fsfreeze --freeze /root/mnt ;
> done
> 
> Did I miss something?

Well, your reproducer doesn't work. Like written in my initial mail, 
executing `fsfreeze --freeze...` directly after boot doesn't even fail 
for me. The device/array must have seen some I/O to trigger this.

To be more precise:

During my current bisect session (where I set KV to 5.16-rc1 for all 
kernels), I noticed that my 'reproducer' failed:

To trigger the problem, it is not enough to create random I/O by copying 
some files for example.

I am using mysqld (MariaDB 10.6.8) and restore ~20GB of SQL dumps -- 
somehow this is triggering the problem in a reliable way. The mysqld is 
using O_DIRECT 
(https://mariadb.com/kb/en/innodb-system-variables/#innodb_flush_method) 
-- maybe Direct I/O is the trigger.

This process usually takes ~620s on my test system where I am 
experiencing the problem. After import I called `fsfreeze --freeze ...` 
against the mount point used by mysqld.
When this command did not return (=fsfreeze was hanging), I marked 
revision as bad.

Since setting KV in all kernels to "5.16-rc1" I noticed that the import 
process sometimes "freezed" -- mysqld was still running and responsive 
(that's not the case when fsfreeze hangs for example) and `SHOW 
PROCESSLIST` showed the running imports with still increasing time 
counter. However, no data are read and written anymore. Although 
fsfreeze command works when this happens. Anyway, I marked revisions 
showing this behavior as bad, too.

I'll post my results when I finished this bisect session.


-- 
Regards,
Thomas

