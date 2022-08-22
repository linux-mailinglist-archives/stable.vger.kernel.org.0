Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2288159CBB1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 00:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237475AbiHVWoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 18:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiHVWoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 18:44:14 -0400
Received: from yamato.tf-network.de (mailstorage3.tf-network.de [IPv6:2001:4ba0:ffa0:1b::d2:221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD135141B
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 15:44:13 -0700 (PDT)
Received: from amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221])
        by yamato.tf-network.de (Postfix) with ESMTP id 4MBS8W2X8qz4R4W;
        Tue, 23 Aug 2022 00:44:11 +0200 (CEST)
X-Virus-Scanned: amavisd-new at amavis3.tf-network.de
Received: from smtp.tf-network.de ([93.186.202.221])
        by amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221]) (amavisd-new, port 10024)
        with LMTP id 1gn0ZBntGo0E; Tue, 23 Aug 2022 00:44:10 +0200 (CEST)
Received: from [10.1.0.10] (xdsl-213-196-226-148.nc.de [213.196.226.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp.tf-network.de (Postfix) with ESMTPSA id 4MBS8V3jmrz3wff;
        Tue, 23 Aug 2022 00:44:10 +0200 (CEST)
Message-ID: <be8542cf-9b58-8861-11b5-8eeaa08f1421@whissi.de>
Date:   Tue, 23 Aug 2022 00:44:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [REGRESSION] v5.17-rc1+: FIFREEZE ioctl system call hangs
To:     Song Liu <song@kernel.org>
Cc:     Vishal Verma <vverma@digitalocean.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Jens Axboe <axboe@kernel.dk>
References: <000401d8a746$3eaca200$bc05e600$@whissi.de>
 <000001d8ad7e$c340ad70$49c20850$@whissi.de>
 <2a2d1075-aa22-8c4d-ca21-274200dce2fc@leemhuis.info>
 <0FBCAB10-545E-45E2-A0C8-D7620817651D@digitalocean.com>
 <CAPhsuW5f9QD+gzJ9eBhn5irsHvrsvkWjSnA4MPaHsQjjLMypXg@mail.gmail.com>
 <43e678ca-3fc3-6c08-f035-2c31a34dd889@whissi.de>
 <701f3fc0-2f0c-a32c-0d41-b489a9a59b99@whissi.de>
 <0192a465-d75d-c09a-732a-eb2215bf3479@whissi.de>
 <CAPhsuW6yLLcj3GtA+4mUFooQmfGo3cVTYn-xBEY2KuP1wwmQNA@mail.gmail.com>
 <b903abd4-d101-e6a5-06a0-667853286308@whissi.de>
 <4f69659f-7160-7854-0ed5-6867e3eb2edb@whissi.de>
 <CAPhsuW6Bq8rkiCzsWW7bkrCbYYEwFWtKaswOZcXsyk8tu3C5Dg@mail.gmail.com>
Content-Language: en-US
From:   Thomas Deutschmann <whissi@whissi.de>
In-Reply-To: <CAPhsuW6Bq8rkiCzsWW7bkrCbYYEwFWtKaswOZcXsyk8tu3C5Dg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-08-22 23:52, Song Liu wrote:
> Hmm.. I still cannot repro the hang in my test. I have:
> 
> [root@eth50-1 ~]# mount | grep mnt
> /dev/md0 on /root/mnt type ext4 (rw,relatime,stripe=384)
> [root@eth50-1 ~]# lsblk
> NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
> sr0      11:0    1 1024M  0 rom
> vda     253:0    0   32G  0 disk
> ├─vda1  253:1    0    2G  0 part  /boot
> └─vda2  253:2    0   30G  0 part  /
> nvme0n1 259:0    0    4G  0 disk
> └─md0     9:0    0   12G  0 raid5 /root/mnt
> nvme2n1 259:1    0    4G  0 disk
> └─md0     9:0    0   12G  0 raid5 /root/mnt
> nvme3n1 259:2    0    4G  0 disk
> └─md0     9:0    0   12G  0 raid5 /root/mnt
> nvme1n1 259:3    0    4G  0 disk
> └─md0     9:0    0   12G  0 raid5 /root/mnt
> 
> [root@eth50-1 ~]# history
>    381  fio iou/repro.fio
>    382  fsfreeze --freeze /root/mnt
>    383  fsfreeze --unfreeze /root/mnt
>    384  fio iou/repro.fio
>    385  fsfreeze --freeze /root/mnt
>    386  fsfreeze --unfreeze /root/mnt
> ^^^^^^^^^^^^^^ all works fine.
> 
> Did I miss something?

No :(

I am currently not testing against the mdraid but this shouldn't matter.

However, it looks like you don't test on bare metal, do you?

I tried to test on VMware Workstation 16 myself but VMware's nvme 
implementation is currently broken 
(https://github.com/vmware/open-vm-tools/issues/579).


-- 
Regards,
Thomas

