Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87ECD5975BC
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 20:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbiHQS34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 14:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbiHQS3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 14:29:55 -0400
Received: from yamato.tf-network.de (yamato.tf-network.de [93.186.202.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E4B9AFDE
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 11:29:54 -0700 (PDT)
Received: from amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221])
        by yamato.tf-network.de (Postfix) with ESMTP id 4M7GlP0nGjz4Rg8;
        Wed, 17 Aug 2022 20:29:53 +0200 (CEST)
X-Virus-Scanned: amavisd-new at amavis3.tf-network.de
Received: from smtp.tf-network.de ([93.186.202.221])
        by amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221]) (amavisd-new, port 10024)
        with LMTP id rj_E9kK6sgxm; Wed, 17 Aug 2022 20:29:52 +0200 (CEST)
Received: from [10.1.0.10] (xdsl-89-1-142-166.nc.de [89.1.142.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp.tf-network.de (Postfix) with ESMTPSA id 4M7GlN2KN0z442L;
        Wed, 17 Aug 2022 20:29:52 +0200 (CEST)
Message-ID: <701f3fc0-2f0c-a32c-0d41-b489a9a59b99@whissi.de>
Date:   Wed, 17 Aug 2022 20:29:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Subject: Re: [REGRESSION] v5.17-rc1+: FIFREEZE ioctl system call hangs
Content-Language: en-US
From:   Thomas Deutschmann <whissi@whissi.de>
To:     Song Liu <song@kernel.org>, Vishal Verma <vverma@digitalocean.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        Jens Axboe <axboe@kernel.dk>
References: <000401d8a746$3eaca200$bc05e600$@whissi.de>
 <000001d8ad7e$c340ad70$49c20850$@whissi.de>
 <2a2d1075-aa22-8c4d-ca21-274200dce2fc@leemhuis.info>
 <0FBCAB10-545E-45E2-A0C8-D7620817651D@digitalocean.com>
 <CAPhsuW5f9QD+gzJ9eBhn5irsHvrsvkWjSnA4MPaHsQjjLMypXg@mail.gmail.com>
 <43e678ca-3fc3-6c08-f035-2c31a34dd889@whissi.de>
In-Reply-To: <43e678ca-3fc3-6c08-f035-2c31a34dd889@whissi.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-08-17 08:53, Thomas Deutschmann wrote:
> I'll post my results when I finished this bisect session.

I bisected kernel with KV set to "5.16-rc1":

> git bisect start
> # good: [2c85ebc57b3e1817b6ce1a6b703928e113a90442] Linux 5.10
> git bisect good 2c85ebc57b3e1817b6ce1a6b703928e113a90442
> # bad: [8bb7eca972ad531c9b149c0a51ab43a417385813] Linux 5.15
> git bisect bad 8bb7eca972ad531c9b149c0a51ab43a417385813
> # bad: [6bdf2fbc48f104a84606f6165aa8a20d9a7d9074] Merge tag 'nvme-5.13-2021-05-13' of git://git.infradead.org/nvme into block-5.13
> git bisect bad 6bdf2fbc48f104a84606f6165aa8a20d9a7d9074
> # good: [02f9fc286e039d0bef7284fb1200ee755b525bde] Merge tag 'pm-5.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> git bisect good 02f9fc286e039d0bef7284fb1200ee755b525bde
> # bad: [f351f4b63dac127079bbd77da64b2a61c09d522d] usb: xhci-mtk: fix oops when unbind driver
> git bisect bad f351f4b63dac127079bbd77da64b2a61c09d522d
> # good: [28b9aaac4cc5a11485b6f70656e4e9ead590cf5b] Merge tag 'clk-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux
> git bisect good 28b9aaac4cc5a11485b6f70656e4e9ead590cf5b
> # good: [cf64c2a905e0dabcc473ca70baf275fb3a61fac4] Merge branch 'work.sparc32' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
> git bisect good cf64c2a905e0dabcc473ca70baf275fb3a61fac4
> # bad: [ea6be461cbedefaa881711a43f2842aabbd12fd4] Merge tag 'acpi-5.12-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> git bisect bad ea6be461cbedefaa881711a43f2842aabbd12fd4
> # good: [1c9077cdecd027714736e70704da432ee2b946bb] Merge tag 'nfs-for-5.12-1' of git://git.linux-nfs.org/projects/anna/linux-nfs
> git bisect good 1c9077cdecd027714736e70704da432ee2b946bb
> # good: [efba6d3a7c4bb59f0750609fae0f9644d82304b6] Merge tag 'for-5.12/io_uring-2021-02-25' of git://git.kernel.dk/linux-block
> git bisect good efba6d3a7c4bb59f0750609fae0f9644d82304b6
> # bad: [0b311e34d5033fdcca4c9b5f2d9165b3604704d3] Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
> git bisect bad 0b311e34d5033fdcca4c9b5f2d9165b3604704d3
> # good: [5ceabb6078b80a8544ba86d6ee523ad755ae6d5e] Merge branch 'work.misc' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
> git bisect good 5ceabb6078b80a8544ba86d6ee523ad755ae6d5e
> # bad: [3ab6608e66b16159c3a3c2d7015b9c11cd3396c1] Merge tag 'block-5.12-2021-02-27' of git://git.kernel.dk/linux-block
> git bisect bad 3ab6608e66b16159c3a3c2d7015b9c11cd3396c1
> # bad: [e941894eae31b52f0fd9bdb3ce20620afa152f45] io-wq: make buffered file write hashed work map per-ctx
> git bisect bad e941894eae31b52f0fd9bdb3ce20620afa152f45
> # good: [4379bf8bd70b5de6bba7d53015b0c36c57a634ee] io_uring: remove io_identity
> git bisect good 4379bf8bd70b5de6bba7d53015b0c36c57a634ee
> # good: [1c0aa1fae1acb77c5f9917adb0e4cb4500b9f3a6] io_uring: flag new native workers with IORING_FEAT_NATIVE_WORKERS
> git bisect good 1c0aa1fae1acb77c5f9917adb0e4cb4500b9f3a6
> # good: [0100e6bbdbb79404e56939313662b42737026574] arch: ensure parisc/powerpc handle PF_IO_WORKER in copy_thread()
> git bisect good 0100e6bbdbb79404e56939313662b42737026574
> # good: [8b3e78b5955abb98863832453f5c74eca8f53c3a] io-wq: fix races around manager/worker creation and task exit
> git bisect good 8b3e78b5955abb98863832453f5c74eca8f53c3a
> # good: [eb2de9418d56b5e6ebf27bad51dbce3e22ee109b] io-wq: fix race around io_worker grabbing
> git bisect good eb2de9418d56b5e6ebf27bad51dbce3e22ee109b
> # first bad commit: [e941894eae31b52f0fd9bdb3ce20620afa152f45] io-wq: make buffered file write hashed work map per-ctx
> 
> From e941894eae31b52f0fd9bdb3ce20620afa152f45
> From: Jens Axboe
> Date: Fri, 19 Feb 2021 12:33:30 -0700
> Subject: io-wq: make buffered file write hashed work map per-ctx
> 
> Before the io-wq thread change, we maintained a hash work map and lock
> per-node per-ring. That wasn't ideal, as we really wanted it to be per
> ring. But now that we have per-task workers, the hash map ends up being
> just per-task. That'll work just fine for the normal case of having
> one task use a ring, but if you share the ring between tasks, then it's
> considerably worse than it was before.
> 
> Make the hash map per ctx instead, which provides full per-ctx buffered
> write serialization on hashed writes.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e941894eae31b52f0fd9bdb3ce20620afa152f45

But I think this result is misleading.

Like mentioned, the problem I experienced during this bisect session was 
different (not the FIFREEZE ioctl hang). This sounds more like the 
already fixed regressions caused by the commit above, i.e.

- 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=0242f6426ea78fbe3933b44f8c55ae93ec37f6cc

- 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=d3e3c102d107bb84251455a298cf475f24bab995


I will do another round with 2b7196a219bf (good) <-> 5.18 (bad).


-- 
Regards,
Thomas

