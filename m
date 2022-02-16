Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97F54B832E
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 09:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbiBPIo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 03:44:29 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiBPIo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 03:44:29 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0974016EAB1;
        Wed, 16 Feb 2022 00:44:16 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nKFv4-00018D-Q4; Wed, 16 Feb 2022 09:44:14 +0100
Message-ID: <d45e38db-205f-3400-af09-aa0bb1624975@leemhuis.info>
Date:   Wed, 16 Feb 2022 09:44:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: [regression, stable] Re: Bug 215562 - BUG: unable to handle page
 fault in cache_reap (fwd from bugzilla)
Content-Language: en-BS
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <062f4a59-2d41-9a6f-8c7c-42fc5773e282@leemhuis.info>
In-Reply-To: <062f4a59-2d41-9a6f-8c7c-42fc5773e282@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1645001057;3fd313f4;
X-HE-SMSGID: 1nKFv4-00018D-Q4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking. Top-posting
for once, to make this easy accessible to everyone.

Below issue that started to happen between v5.10.80..v5.10.90 was
recently reported to bugzilla, but the reporter didn't even get a single
reply afaics. Could somebody maybe take a look? Bisection is likely no
easy in this case, so a few tips to narrow down the area to search might
help a lot here.

https://bugzilla.kernel.org/show_bug.cgi?id=215562

Ciao, Thorsten


On 03.02.22 16:03, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker speaking.
> 
> There is a regression in bugzilla.kernel.org I'd like to add to the
> tracking:
> 
> #regzbot introduced: v5.10.80..v5.10.90
> #regzbot from: Patrick Schaaf <kernelorg@bof.de>
> #regzbot title: mm: unable to handle page fault in cache_reap
> #regzbot link: https://bugzilla.kernel.org/show_bug.cgi?id=215562
> 
> Quote:
> 
>> We've been running self-built 5.10.x kernels on DL380 hosts for quite a while, also inside the VMs there.
>>
>> With I think 5.10.90 three weeks or so back, we experienced a lockup upon umounting a larger, dirty filesystem on the host side, unfortunately without capturing a backtrace back then.
>>
>> Today something feeling similar, happened again, on a machine running 5.10.93 both on the host and inside its 10 various VMs.
>>
>> Problem showed shortly (minutes) after shutting down one of the VMs (few hundred GB memory / dataset, VM shutdown was complete already; direct I/O), and then some LVM volume renames, a quick short outside ext4 mount followed by an umount (8 GB volume, probably a few hundred megabyte only to write). Actually monitoring suggests that disk writes were already done about a minute before the onset.
>>
>> What we then experienced, was the following BUG:, followed by one after the other CPU saying goodbye with soft lockup messages over the course of a few minutes; meanwhile there was no more pinging the box, logging in on console, etc. We hard powercycled and it recovered fully.
>>
>> here's the BUG that was logged; if it is useful for someone to see the followup soft lockup messages, tell me + I'll add them.
>>
>> Feb 02 15:22:27 kvm3j kernel: BUG: unable to handle page fault for address: ffffebde00000008
>> Feb 02 15:22:27 kvm3j kernel: #PF: supervisor read access in kernel mode
>> Feb 02 15:22:27 kvm3j kernel: #PF: error_code(0x0000) - not-present page
>> Feb 02 15:22:27 kvm3j kernel: Oops: 0000 [#1] SMP PTI
>> Feb 02 15:22:27 kvm3j kernel: CPU: 7 PID: 39833 Comm: kworker/7:0 Tainted: G          I       5.10.93-kvm #1
>> Feb 02 15:22:27 kvm3j kernel: Hardware name: HP ProLiant DL380p Gen8, BIOS P70 12/20/2013
>> Feb 02 15:22:27 kvm3j kernel: Workqueue: events cache_reap
>> Feb 02 15:22:27 kvm3j kernel: RIP: 0010:free_block.constprop.0+0xc0/0x1f0
>> Feb 02 15:22:27 kvm3j kernel: Code: 4c 8b 16 4c 89 d0 48 01 e8 0f 82 32 01 00 00 4c 89 f2 48 bb 00 00 00 00 00 ea ff ff 48 01 d0 48 c1 e8 0c 48 c1 e0 06 48 01 d8 <48> 8b 50 08 48 8d 4a ff 83 e2 01 48 >
>> Feb 02 15:22:27 kvm3j kernel: RSP: 0018:ffffc9000252bdc8 EFLAGS: 00010086
>> Feb 02 15:22:27 kvm3j kernel: RAX: ffffebde00000000 RBX: ffffea0000000000 RCX: ffff888889141b00
>> Feb 02 15:22:27 kvm3j kernel: RDX: 0000777f80000000 RSI: ffff893d3edf3400 RDI: ffff8881000403c0
>> Feb 02 15:22:27 kvm3j kernel: RBP: 0000000080000000 R08: ffff888100041300 R09: 0000000000000003
>> Feb 02 15:22:27 kvm3j kernel: R10: 0000000000000000 R11: ffff888100041308 R12: dead000000000122
>> Feb 02 15:22:27 kvm3j kernel: R13: dead000000000100 R14: 0000777f80000000 R15: ffff893ed8780d60
>> Feb 02 15:22:27 kvm3j kernel: FS:  0000000000000000(0000) GS:ffff893d3edc0000(0000) knlGS:0000000000000000
>> Feb 02 15:22:27 kvm3j kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> Feb 02 15:22:27 kvm3j kernel: CR2: ffffebde00000008 CR3: 000000048c4aa002 CR4: 00000000001726e0
>> Feb 02 15:22:27 kvm3j kernel: Call Trace:
>> Feb 02 15:22:27 kvm3j kernel:  drain_array_locked.constprop.0+0x2e/0x80
>> Feb 02 15:22:27 kvm3j kernel:  drain_array.constprop.0+0x54/0x70
>> Feb 02 15:22:27 kvm3j kernel:  cache_reap+0x6c/0x100
>> Feb 02 15:22:27 kvm3j kernel:  process_one_work+0x1cf/0x360
>> Feb 02 15:22:27 kvm3j kernel:  worker_thread+0x45/0x3a0
>> Feb 02 15:22:27 kvm3j kernel:  ? process_one_work+0x360/0x360
>> Feb 02 15:22:27 kvm3j kernel:  kthread+0x116/0x130
>> Feb 02 15:22:27 kvm3j kernel:  ? kthread_create_worker_on_cpu+0x40/0x40
>> Feb 02 15:22:27 kvm3j kernel:  ret_from_fork+0x22/0x30
>> Feb 02 15:22:27 kvm3j kernel: Modules linked in: hpilo
>> Feb 02 15:22:27 kvm3j kernel: CR2: ffffebde00000008
>> Feb 02 15:22:27 kvm3j kernel: ---[ end trace ded3153d86a92898 ]---
>> Feb 02 15:22:27 kvm3j kernel: RIP: 0010:free_block.constprop.0+0xc0/0x1f0
>> Feb 02 15:22:27 kvm3j kernel: Code: 4c 8b 16 4c 89 d0 48 01 e8 0f 82 32 01 00 00 4c 89 f2 48 bb 00 00 00 00 00 ea ff ff 48 01 d0 48 c1 e8 0c 48 c1 e0 06 48 01 d8 <48> 8b 50 08 48 8d 4a ff 83 e2 01 48 >
>> Feb 02 15:22:27 kvm3j kernel: RSP: 0018:ffffc9000252bdc8 EFLAGS: 00010086
>> Feb 02 15:22:27 kvm3j kernel: RAX: ffffebde00000000 RBX: ffffea0000000000 RCX: ffff888889141b00
>> Feb 02 15:22:27 kvm3j kernel: RDX: 0000777f80000000 RSI: ffff893d3edf3400 RDI: ffff8881000403c0
>> Feb 02 15:22:27 kvm3j kernel: RBP: 0000000080000000 R08: ffff888100041300 R09: 0000000000000003
>> Feb 02 15:22:27 kvm3j kernel: R10: 0000000000000000 R11: ffff888100041308 R12: dead000000000122
>> Feb 02 15:22:27 kvm3j kernel: R13: dead000000000100 R14: 0000777f80000000 R15: ffff893ed8780d60
>> Feb 02 15:22:27 kvm3j kernel: FS:  0000000000000000(0000) GS:ffff893d3edc0000(0000) knlGS:0000000000000000
>> Feb 02 15:22:27 kvm3j kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> Feb 02 15:22:27 kvm3j kernel: CR2: ffffebde00000008 CR3: 000000048c4aa002 CR4: 00000000001726e0
> 
> Ciao, Thorsten (wearing his 'Linux kernel regression tracker' hat)
> 
> P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
> on my table. I can only look briefly into most of them. Unfortunately
> therefore I sometimes will get things wrong or miss something important.
> I hope that's not the case here; if you think it is, don't hesitate to
> tell me about it in a public reply, that's in everyone's interest.
> 
> BTW, I have no personal interest in this issue, which is tracked using
> regzbot, my Linux kernel regression tracking bot
> (https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
> this mail to get things rolling again and hence don't need to be CC on
> all further activities wrt to this regression.
> 
> ---
> Additional information about regzbot:
> 
> If you want to know more about regzbot, check out its web-interface, the
> getting start guide, and/or the references documentation:
> 
> https://linux-regtracking.leemhuis.info/regzbot/
> https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
> https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md
> 
> The last two documents will explain how you can interact with regzbot
> yourself if your want to.
> 
> Hint for reporters: when reporting a regression it's in your interest to
> tell #regzbot about it in the report, as that will ensure the regression
> gets on the radar of regzbot and the regression tracker. That's in your
> interest, as they will make sure the report won't fall through the
> cracks unnoticed.
> 
> Hint for developers: you normally don't need to care about regzbot once
> it's involved. Fix the issue as you normally would, just remember to
> include a 'Link:' tag to the report in the commit message, as explained
> in Documentation/process/submitting-patches.rst
> That aspect was recently was made more explicit in commit 1f57bd42b77c:
> https://git.kernel.org/linus/1f57bd42b77c
