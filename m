Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C2A59C423
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 18:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbiHVQbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 12:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237073AbiHVQaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 12:30:35 -0400
X-Greylist: delayed 3683 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 Aug 2022 09:30:34 PDT
Received: from yamato.tf-network.de (mailstorage3.tf-network.de [IPv6:2001:4ba0:ffa0:1b::d2:221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9214198D
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 09:30:34 -0700 (PDT)
Received: from amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221])
        by yamato.tf-network.de (Postfix) with ESMTP id 4MBHsN5fF3z442N;
        Mon, 22 Aug 2022 18:30:32 +0200 (CEST)
X-Virus-Scanned: amavisd-new at amavis3.tf-network.de
Received: from smtp.tf-network.de ([93.186.202.221])
        by amavis3.tf-network.de ([IPv6:2001:4ba0:ffa0:1b::d1:221]) (amavisd-new, port 10024)
        with LMTP id rjkh0D8jHqOy; Mon, 22 Aug 2022 18:30:32 +0200 (CEST)
Received: from [10.1.0.10] (xdsl-213-196-226-148.nc.de [213.196.226.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp.tf-network.de (Postfix) with ESMTPSA id 4MBHsN0q2Sz442L;
        Mon, 22 Aug 2022 18:30:32 +0200 (CEST)
Message-ID: <4f69659f-7160-7854-0ed5-6867e3eb2edb@whissi.de>
Date:   Mon, 22 Aug 2022 18:30:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [REGRESSION] v5.17-rc1+: FIFREEZE ioctl system call hangs
Content-Language: en-US
From:   Thomas Deutschmann <whissi@whissi.de>
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
In-Reply-To: <b903abd4-d101-e6a5-06a0-667853286308@whissi.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I can now reproduce using fio:

I looked around in MariaDB issue tracker and found 
https://jira.mariadb.org/browse/MDEV-26674 which lead me to 
https://github.com/MariaDB/server/commit/de7db5517de11a58d57d2a41d0bc6f38b6f92dd8 
-- it's a conditional based on $KV and I hit that kernel regression 
during one of my bisect attempts (see 
https://lore.kernel.org/all/701f3fc0-2f0c-a32c-0d41-b489a9a59b99@whissi.de/).

Setting innodb_use_native_aio=OFF will prevent the problem.

This helped me to find https://github.com/axboe/fio/issues/1195 so I now 
have a working reproducer for fio.

   $ cat reproducer.fio
   [global]
   direct=1
   thread=1
   norandommap=1
   group_reporting=1
   time_based=1
   ioengine=io_uring

   rw=randwrite
   bs=4096
   runtime=20
   numjobs=1
   fixedbufs=1
   hipri=1
   registerfiles=1
   sqthread_poll=1


   [filename0]
   directory=/srv/machines/fio
   size=200M
   iodepth=1
   cpus_allowed=20


...now call fio like "fio reproducer.fio". After one successful fio run, 
fsfreeze will already hang for me.


-- 
Regards,
Thomas
