Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F162C8E94
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 21:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgK3T7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 14:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388354AbgK3T7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 14:59:39 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57960C0613D6;
        Mon, 30 Nov 2020 11:58:59 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kjpK5-0003Q5-Vg; Mon, 30 Nov 2020 20:58:58 +0100
Date:   Mon, 30 Nov 2020 20:58:57 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Yuri Lipnesh <yuri.lipnesh@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: System crash on Ubuntu 18, in netlink code when using iptables /
 netfilter
Message-ID: <20201130195857.GM2730@breakpoint.cc>
References: <B37EABB8-355F-4A05-9BF3-1119D1E0470D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B37EABB8-355F-4A05-9BF3-1119D1E0470D@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Yuri Lipnesh <yuri.lipnesh@gmail.com> wrote:
> Linux system crashed
> 
> [    0.000000] Linux version 5.4.0-54-generic (buildd@lcy01-amd64-008) (gcc version 7.5.0 (Ubuntu 7.5.0-3ubuntu1~18.04)) #60~18.04.1-Ubuntu SMP Fri Nov 6 17:25:16 UTC 2020 (Ubuntu 5.4.0-54.60~18.04.1-generic 5.4.65)
> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.4.0-54-generic root=UUID=11885fd3-b840-4c9b-a500-532c73ac952a ro find_preseed=/preseed.cfg auto noprompt priority=critical locale=en_US quiet crashkernel=512M-:192M
> 
> …
> [  156.321147] TCP: eth0: Driver has suspect GRO implementation, TCP performance may be compromised.
> [  177.519159] general protection fault: 0000 [#1] SMP PTI
> [  177.519737] CPU: 5 PID: 18484 Comm: worker-1 Kdump: loaded Not tainted 5.4.0-54-generic #60~18.04.1-Ubuntu
> [  177.519742] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 02/27/2020
> [  177.519814] RIP: 0010:dev_hard_start_xmit+0x38/0x200
> [  177.519827] Code: 55 41 54 53 48 83 ec 20 48 85 ff 48 89 55 c8 48 89 4d b8 0f 84 c1 01 00 00 48 8d 86 90 00 00 00 48 89 fb 49 89 f4 48 89 45 c0 <4c> 8b 2b 48 c7 c0 d0 f2 04 8f 48 c7 03 00 00 00 00 48 8b 00 4d 85
> [  177.519829] RSP: 0018:ffffbc6d0609b5e8 EFLAGS: 00010286
> [  177.519833] RAX: 0000000000000000 RBX: dead000000000100 RCX: ffff95cf4bcfe800
> [  177.519835] RDX: 0000000000000000 RSI: ffff95cf4bcfe800 RDI: 0000000000000286
> [  177.519837] RBP: ffffbc6d0609b630 R08: ffff95cf6a190ec8 R09: ffff95cf4a2f7438
> [  177.519839] R10: ffffbc6d0609b6d0 R11: ffff95cf49d4d180 R12: ffff95cf51a5f000
> [  177.519841] R13: dead000000000100 R14: 000000000000009c R15: ffff95d02996b400
> [  177.519844] FS:  00007ff394cdfb20(0000) GS:ffff95d035d40000(0000) knlGS:0000000000000000
> [  177.519846] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  177.519848] CR2: 00007fb4a9c2d000 CR3: 00000001049fa004 CR4: 00000000003606e0
> [  177.519908] Call Trace:
> [  177.519917]  __dev_queue_xmit+0x719/0x920
> [  177.519930]  ? ctnetlink_conntrack_event+0x8c/0x5e0 [nf_conntrack_netlink]

Can you reproduce this on 5.7 or later, or with following patches
backported to 5.4.y?

 dd3cc111f2e3220ddc9c4ab17f13dc97759b5163
 119e52e664c57d5f7c0174dc2b3a296b1e40591d
 af370ab36fcd19f04e3408c402608e7e56e6f188
 28f715b9e6dd7cbf07c2aea913fea7c87a56a3b5

The series fixed nfqueue reference counting.
