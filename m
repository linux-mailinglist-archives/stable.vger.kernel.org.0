Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845146D96F5
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 14:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236824AbjDFMU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 08:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjDFMUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 08:20:25 -0400
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB496E82;
        Thu,  6 Apr 2023 05:20:23 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=rongwei.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VfT7z72_1680783614;
Received: from 30.221.129.255(mailfrom:rongwei.wang@linux.alibaba.com fp:SMTPD_---0VfT7z72_1680783614)
          by smtp.aliyun-inc.com;
          Thu, 06 Apr 2023 20:20:19 +0800
Message-ID: <5963a915-00bd-bedc-14f4-abcd0997ae36@linux.alibaba.com>
Date:   Thu, 6 Apr 2023 20:20:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
From:   Rongwei Wang <rongwei.wang@linux.alibaba.com>
Subject: Re: [PATCH v2] mm/swap: fix swap_info_struct race between swapoff and
 get_swap_pages()
To:     Aaron Lu <aaron.lu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     bagasdotme@gmail.com, willy@infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230401221920.57986-1-rongwei.wang@linux.alibaba.com>
 <20230404154716.23058-1-rongwei.wang@linux.alibaba.com>
 <20230404122600.88257a623c7f72e078dcf705@linux-foundation.org>
 <20230406065809.GB64960@ziqianlu-desk2>
Content-Language: en-US
In-Reply-To: <20230406065809.GB64960@ziqianlu-desk2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> It doesn't appear to be the case. For one thing, the problematic code
> that removes the swap device from the avail list without acquiring
> si->lock was there before my commit and my commit didn't change that
> behaviour. For another, I wanted to see if the problem is still there
> without my commit(just to make sure).
>
> I followed Rongwei's description and used stress-ng/swap test together
> with some test progs that does memory allocation then MADVISE(pageout)
> in a loop to reproduce this problem and I can also see the warning like
> below using Linus' master branch as of today, I believe this is the
> problem Rongwei described:
Hi, Aaron, I can sure this is that bug, and the panic will happen when 
CONFIG_PLIST_DEBUG enabled (I'm not sure whether you have enabled it).
>
> [ 1914.518786] ------------[ cut here ]------------
> [ 1914.519049] swap_info 9 in list but !SWP_WRITEOK
> [ 1914.519274] WARNING: CPU: 14 PID: 14307 at mm/swapfile.c:1085 get_swap_pages+0x3b3/0x440
> [ 1914.519660] Modules linked in:
> [ 1914.519811] CPU: 14 PID: 14307 Comm: swap Tainted: G        W          6.3.0-rc5-00032-g99ddf2254feb #5
> [ 1914.520238] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc36 04/01/2014
> [ 1914.520641] RIP: 0010:get_swap_pages+0x3b3/0x440
> [ 1914.520860] Code: 48 8b 4c 24 30 48 c1 e0 3a 4c 09 e0 48 89 01 e8 43 79 96 00 e9 b2 fd ff ff 41 0f be 77 48 48 c7 c78
> [ 1914.521709] RSP: 0018:ffffc9000ba0f838 EFLAGS: 00010282
> [ 1914.521950] RAX: 0000000000000000 RBX: ffff888154411400 RCX: 0000000000000000
> [ 1914.522273] RDX: 0000000000000004 RSI: ffffffff824035cb RDI: 0000000000000001
> [ 1914.522601] RBP: ffff888100d95f68 R08: 0000000000000001 R09: 0000000000000003
> [ 1914.522926] R10: ffffffff82a7a420 R11: ffffffff82a7a420 R12: 0000000000000350
> [ 1914.523249] R13: ffff888100d95da8 R14: ffff888100d95f50 R15: ffff888100d95c00
> [ 1914.523576] FS:  00007f23abea2600(0000) GS:ffff88823b600000(0000) knlGS:0000000000000000
> [ 1914.523942] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1914.524206] CR2: 00007f23abbff000 CR3: 0000000104b86004 CR4: 0000000000770ee0
> [ 1914.524534] PKRU: 55555554
> [ 1914.524661] Call Trace:
> [ 1914.524782]  <TASK>
> [ 1914.524889]  folio_alloc_swap+0xde/0x230
> [ 1914.525076]  add_to_swap+0x36/0xb0
> [ 1914.525242]  shrink_folio_list+0x9ab/0xef0
> [ 1914.525445]  reclaim_folio_list+0x70/0x130
> [ 1914.525644]  reclaim_pages+0x9c/0x1c0
> [ 1914.525819]  madvise_cold_or_pageout_pte_range+0x79f/0xc80
> [ 1914.526073]  walk_pgd_range+0x4d8/0x940
> [ 1914.526255]  ? mt_find+0x15b/0x490
> [ 1914.526426]  __walk_page_range+0x211/0x230
> [ 1914.526619]  walk_page_range+0x17a/0x1e0
> [ 1914.526807]  madvise_pageout+0xef/0x250
>
> And when I reverted my commit on the same branch(needs some manual edits),
> the problem is still there.
>
> Another thing is, I noticed Rongwei mentioned "This problem exists in
> versions after stable 5.10.y." in the changelog while my commit entered
> mainline in v4.14.
>
> So either this problem is always there, i.e. earlier than my commit; or
> this problem is indeed only there after v5.10, then it should be something
> else that triggered it. My qemu refuses to boot v4.14 kernel so I can
> not verify the former yet.

Me too. The oldest kernel that my qemu can run is 4.19.

BTW, I try to replace 'p' with 'si' today, and find there are many areas 
need to be modified, especially inside swapoff() and swapon(). So many 
modifications maybe affect future tracking of code modifications and 
will cost some time to test. So I wanna to ensure whether need I to do 
this. If need, I can continue to do this.


Thanks.

