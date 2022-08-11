Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F31A58FC64
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 14:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbiHKMfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 08:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235261AbiHKMfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 08:35:31 -0400
Received: from yamato.tf-network.de (yamato.tf-network.de [93.186.202.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91543B11
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 05:35:06 -0700 (PDT)
Received: from amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221])
        by yamato.tf-network.de (Postfix) with ESMTP id 4M3R8f0PyVz4R4W;
        Thu, 11 Aug 2022 14:34:58 +0200 (CEST)
X-Virus-Scanned: amavisd-new at amavis3.tf-network.de
Received: from smtp.tf-network.de ([93.186.202.221])
        by amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221]) (amavisd-new, port 10024)
        with LMTP id wfyNH4IR8CkL; Thu, 11 Aug 2022 14:34:57 +0200 (CEST)
Received: from data (2a0a-a547-2145-0-8d75-b483-dcce-df26.ipv6dyn.netcologne.de [IPv6:2a0a:a547:2145:0:8d75:b483:dcce:df26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by securesmtp.tf-network.de (Postfix) with ESMTPSA id 4M3R8d0klgz440K;
        Thu, 11 Aug 2022 14:34:57 +0200 (CEST)
From:   "Thomas Deutschmann" <whissi@whissi.de>
To:     <vverma@digitalocean.com>, <song@kernel.org>
Cc:     <stable@vger.kernel.org>, <regressions@lists.linux.dev>
References: <000401d8a746$3eaca200$bc05e600$@whissi.de>
In-Reply-To: <000401d8a746$3eaca200$bc05e600$@whissi.de>
Subject: RE: [REGRESSION] v5.17-rc1+: FIFREEZE ioctl system call hangs
Date:   Thu, 11 Aug 2022 14:34:55 +0200
Message-ID: <000001d8ad7e$c340ad70$49c20850$@whissi.de>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdinPeLiSuKWnymQS2KTlErAfjgbcwGQGaag
Content-Language: de
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

any news on this? Is there anything else you need from me or I can help
with?

Thanks.


-- 
Regards,
Thomas


-----Original Message-----
From: Thomas Deutschmann <whissi@whissi.de> 
Sent: Wednesday, August 3, 2022 4:35 PM
To: vverma@digitalocean.com; song@kernel.org
Cc: stable@vger.kernel.org; regressions@lists.linux.dev
Subject: [REGRESSION] v5.17-rc1+: FIFREEZE ioctl system call hangs

Hi,

while trying to backup a Dell R7525 system running Debian bookworm/testing
using LVM snapshots I noticed that the system will 'freeze' sometimes (not
all the
times) when creating the snapshot.

First I thought this was related to LVM so I created

https://listman.redhat.com/archives/linux-lvm/2022-July/026228.html
(continued at
https://listman.redhat.com/archives/linux-lvm/2022-August/thread.html#26229)

Long story short:

I was even able to reproduce with fsfreeze, see last strace lines

> [...]
> 14471 1659449870.984635 openat(AT_FDCWD, "/var/lib/machines", O_RDONLY) =3
> 14471 1659449870.984658 newfstatat(3, "",
{st_mode=S_IFDIR|0700,st_size=4096, ...}, AT_EMPTY_PATH) = 0
> 14471 1659449870.984678 ioctl(3, FIFREEZE

so I started to bisect kernel and found the following bad commit:

> md: add support for REQ_NOWAIT
> 
> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
> for checking whether a given bdev supports handling of REQ_NOWAIT or not.
> Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and enable
> it for linear target") added support for REQ_NOWAIT for dm. This uses
> a similar approach to incorporate REQ_NOWAIT for md based bios.
> 
> This patch was tested using t/io_uring tool within FIO. A nvme drive
> was partitioned into 2 partitions and a simple raid 0 configuration
> /dev/md0 was created.
> 
> md0 : active raid0 nvme4n1p1[1] nvme4n1p2[0]
>       937423872 blocks super 1.2 512k chunks
> 
> Before patch:
> 
> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
> 
> Running top while the above runs:
> 
> $ ps -eL | grep $(pidof io_uring)
> 
>   38396   38396 pts/2    00:00:00 io_uring
>   38396   38397 pts/2    00:00:15 io_uring
>   38396   38398 pts/2    00:00:13 iou-wrk-38397
> 
> We can see iou-wrk-38397 io worker thread created which gets created
> when io_uring sees that the underlying device (/dev/md0 in this case)
> doesn't support nowait.
> 
> After patch:
> 
> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
> 
> Running top while the above runs:
> 
> $ ps -eL | grep $(pidof io_uring)
> 
>   38341   38341 pts/2    00:10:22 io_uring
>   38341   38342 pts/2    00:10:37 io_uring
> 
> After running this patch, we don't see any io worker thread
> being created which indicated that io_uring saw that the
> underlying device does support nowait. This is the exact behaviour
> noticed on a dm device which also supports nowait.
> 
> For all the other raid personalities except raid0, we would need
> to train pieces which involves make_request fn in order for them
> to correctly handle REQ_NOWAIT.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?i
d=f51d46d0e7cb5b8494aa534d276a9d8915a2443d

After reverting this commit (and follow up commit
0f9650bd838efe5c52f7e5f40c3204ad59f1964d)
v5.18.15 and v5.19 worked for me again.

At this point I still wonder why I experienced the same problem even after I
removed one nvme device from the mdraid array and tested it separately. So
maybe there is another nowait/REQ_NOWAIT problem somewhere. During bisect
I only tested against the mdraid array.


#regzbot introduced: f51d46d0e7cb5b8494aa534d276a9d8915a2443d
#regzbot link:
https://listman.redhat.com/archives/linux-lvm/2022-July/026228.html
#regzbot link:
https://listman.redhat.com/archives/linux-lvm/2022-August/thread.html#26229


-- 
Regards,
Thomas




