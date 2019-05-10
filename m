Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19ACF1A3C0
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 22:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfEJULA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 16:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbfEJULA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 16:11:00 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6078217F9;
        Fri, 10 May 2019 20:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557519058;
        bh=TVvQBGxSnCqd9Q3agQYOjsP7mTy+BgkQEq3DjPGMWAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SyJDZZ/PtOqjT47JZQREfaxMvGoiPXq7CaMSCpDWH9bgn/ELLdfkmbVAYXntFFYOu
         zeJmqzA+Lk1zsZoiyeWMMbIP1ogcmZmcF9aDtmTQMSxuRRLxDIGHT/lsUPth8cmV5S
         iXLX504CQ/xNkpslHaU6MxEDbcbijfFyFYku2sew=
Date:   Fri, 10 May 2019 16:10:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        groeck@chromium.org, fruggeri@arista.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net
Subject: Re: [PATCH v4.14.y] netfilter: compat: initialize all fields in
 xt_init
Message-ID: <20190510201057.GA14410@sasha-vm>
References: <20190510161930.182336-1-zsm@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190510161930.182336-1-zsm@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 10, 2019 at 09:19:30AM -0700, Zubin Mithra wrote:
>From: Francesco Ruggeri <fruggeri@arista.com>
>
>commit 8d29d16d21342a0c86405d46de0c4ac5daf1760f upstream
>
>If a non zero value happens to be in xt[NFPROTO_BRIDGE].cur at init
>time, the following panic can be caused by running
>
>% ebtables -t broute -F BROUTING
>
>from a 32-bit user level on a 64-bit kernel. This patch replaces
>kmalloc_array with kcalloc when allocating xt.
>
>[  474.680846] BUG: unable to handle kernel paging request at 0000000009600920
>[  474.687869] PGD 2037006067 P4D 2037006067 PUD 2038938067 PMD 0
>[  474.693838] Oops: 0000 [#1] SMP
>[  474.697055] CPU: 9 PID: 4662 Comm: ebtables Kdump: loaded Not tainted 4.19.17-11302235.AroraKernelnext.fc18.x86_64 #1
>[  474.707721] Hardware name: Supermicro X9DRT/X9DRT, BIOS 3.0 06/28/2013
>[  474.714313] RIP: 0010:xt_compat_calc_jump+0x2f/0x63 [x_tables]
>[  474.720201] Code: 40 0f b6 ff 55 31 c0 48 6b ff 70 48 03 3d dc 45 00 00 48 89 e5 8b 4f 6c 4c 8b 47 60 ff c9 39 c8 7f 2f 8d 14 08 d1 fa 48 63 fa <41> 39 34 f8 4c 8d 0c fd 00 00 00 00 73 05 8d 42 01 eb e1 76 05 8d
>[  474.739023] RSP: 0018:ffffc9000943fc58 EFLAGS: 00010207
>[  474.744296] RAX: 0000000000000000 RBX: ffffc90006465000 RCX: 0000000002580249
>[  474.751485] RDX: 00000000012c0124 RSI: fffffffff7be17e9 RDI: 00000000012c0124
>[  474.758670] RBP: ffffc9000943fc58 R08: 0000000000000000 R09: ffffffff8117cf8f
>[  474.765855] R10: ffffc90006477000 R11: 0000000000000000 R12: 0000000000000001
>[  474.773048] R13: 0000000000000000 R14: ffffc9000943fcb8 R15: ffffc9000943fcb8
>[  474.780234] FS:  0000000000000000(0000) GS:ffff88a03f840000(0063) knlGS:00000000f7ac7700
>[  474.788612] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
>[  474.794632] CR2: 0000000009600920 CR3: 0000002037422006 CR4: 00000000000606e0
>[  474.802052] Call Trace:
>[  474.804789]  compat_do_replace+0x1fb/0x2a3 [ebtables]
>[  474.810105]  compat_do_ebt_set_ctl+0x69/0xe6 [ebtables]
>[  474.815605]  ? try_module_get+0x37/0x42
>[  474.819716]  compat_nf_setsockopt+0x4f/0x6d
>[  474.824172]  compat_ip_setsockopt+0x7e/0x8c
>[  474.828641]  compat_raw_setsockopt+0x16/0x3a
>[  474.833220]  compat_sock_common_setsockopt+0x1d/0x24
>[  474.838458]  __compat_sys_setsockopt+0x17e/0x1b1
>[  474.843343]  ? __check_object_size+0x76/0x19a
>[  474.847960]  __ia32_compat_sys_socketcall+0x1cb/0x25b
>[  474.853276]  do_fast_syscall_32+0xaf/0xf6
>[  474.857548]  entry_SYSENTER_compat+0x6b/0x7a
>
>Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
>Acked-by: Florian Westphal <fw@strlen.de>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>Signed-off-by: Zubin Mithra <zsm@chromium.org>
>---
>Notes:
>* Syzkaller triggered a GPF in xt_compat_calc_jump with the following
>stacktrace when fuzzing a 4.14 kernel.
>Call Trace:
> compat_do_replace+0x5e3/0x7d0 net/bridge/netfilter/ebtables.c:2334
> compat_do_ebt_set_ctl+0x264/0x2e2 net/bridge/netfilter/ebtables.c:2383
> compat_nf_sockopt net/netfilter/nf_sockopt.c:144 [inline]
> compat_nf_setsockopt+0x90/0x130 net/netfilter/nf_sockopt.c:156
> compat_ip_setsockopt net/ipv4/ip_sockglue.c:1281 [inline]
> compat_ip_setsockopt+0xb5/0xf0 net/ipv4/ip_sockglue.c:1262
> inet_csk_compat_setsockopt+0x9e/0x130 net/ipv4/inet_connection_sock.c:1047
> compat_tcp_setsockopt+0x45/0x80 net/ipv4/tcp.c:2816
> compat_sock_common_setsockopt+0xb9/0x150 net/core/sock.c:3017
> C_SYSC_setsockopt net/compat.c:404 [inline]
> compat_SyS_setsockopt+0x14a/0x390 net/compat.c:387
> do_syscall_32_irqs_on arch/x86/entry/common.c:349 [inline]
> do_fast_syscall_32+0x3b4/0xc90 arch/x86/entry/common.c:412
> entry_SYSENTER_compat+0x84/0x96 arch/x86/entry/entry_64_compat.S:139
>
>* This patch resolves a conflict that arises when applying the original
>upstream commit. The conflict arises as the following upstream commit is
>not present in v4.14.y.
>    6da2ec56059c ("treewide: kmalloc() -> kmalloc_array()")
>
>* This commit is present in linux-4.19.y
>
>* Tests run: Chrome OS tryjobs, Syzkaller reproducer

Queued for 3.18-4.14, thank you!

--
Thanks,
Sasha
