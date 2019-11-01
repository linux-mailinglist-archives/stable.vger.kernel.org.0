Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93344EBECF
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 08:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbfKAH72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 03:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728769AbfKAH72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Nov 2019 03:59:28 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6DCC208CB;
        Fri,  1 Nov 2019 07:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572595167;
        bh=u1ArBY4X4AHCNAGQiJTNVumMzm9QbEr0Lwt684kDq+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SsPNeg3YJym5jA4Mmh1BCm4a5tRZ83pked0qlQVcmoWFriT0ZXBgPul78TeV25rBz
         EC8goHEzoNQMFCzX7xLD1DTvDqTtIWPfjOebN4QhAVQWTRD6VUDj5/vHyOmY1srzG1
         NkuTaATuJ++/3edVkFzEcsSDejRTmyoumHGPzgEs=
Date:   Fri, 1 Nov 2019 03:48:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        groeck@chromium.org, xiyou.wangcong@gmail.com, davem@davemloft.net
Subject: Re: [v4.14.y] net_sched: check cops->tcf_block in tc_bind_tclass()
Message-ID: <20191101074821.GS1554@sasha-vm>
References: <20191031184259.165183-1-zsm@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191031184259.165183-1-zsm@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 31, 2019 at 11:42:59AM -0700, Zubin Mithra wrote:
>From: Cong Wang <xiyou.wangcong@gmail.com>
>
>commit 8b142a00edcf8422ca48b8de88d286efb500cb53 upstream
>
>At least sch_red and sch_tbf don't implement ->tcf_block()
>while still have a non-zero tc "class".
>
>Instead of adding nop implementations to each of such qdisc's,
>we can just relax the check of cops->tcf_block() in
>tc_bind_tclass(). They don't support TC filter anyway.
>
>Reported-by: syzbot+21b29db13c065852f64b@syzkaller.appspotmail.com
>Cc: Jamal Hadi Salim <jhs@mojatatu.com>
>Cc: Jiri Pirko <jiri@resnulli.us>
>Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
>Signed-off-by: David S. Miller <davem@davemloft.net>
>Signed-off-by: Zubin Mithra <zsm@chromium.org>
>---
>Notes:
>* Syzkaller triggered a NULL pointer dereference with the following
>stacktrace:
> tc_bind_tclass+0x139/0x550 net/sched/sch_api.c:1697
> tc_ctl_tclass+0x9de/0xb30 net/sched/sch_api.c:1831
> rtnetlink_rcv_msg+0x545/0x1010 net/core/rtnetlink.c:4287
> netlink_rcv_skb+0x15e/0x3a0 net/netlink/af_netlink.c:2432
> rtnetlink_rcv+0x22/0x30 net/core/rtnetlink.c:4299
> netlink_unicast_kernel net/netlink/af_netlink.c:1286 [inline]
> netlink_unicast+0x4ac/0x6a0 net/netlink/af_netlink.c:1312
> netlink_sendmsg+0x943/0xec0 net/netlink/af_netlink.c:1877
> sock_sendmsg_nosec net/socket.c:646 [inline]
> sock_sendmsg+0xd5/0x110 net/socket.c:656
> ___sys_sendmsg+0x754/0x890 net/socket.c:2062
> __sys_sendmsg+0xd2/0x1f0 net/socket.c:2096
> C_SYSC_sendmsg net/compat.c:744 [inline]
> compat_SyS_sendmsg+0x2f/0x40 net/compat.c:742
> do_syscall_32_irqs_on arch/x86/entry/common.c:352 [inline]
> do_fast_syscall_32+0x3bb/0xdd1 arch/x86/entry/common.c:415
> entry_SYSENTER_compat+0x84/0x96 arch/x86/entry/entry_64_compat.S:139
>
>* This commit is present in linux-4.19.y.
>
>* Tests run: Chrome OS tryjobs, Syzkaller reproducer

Queued up for 4.14, thank you.

-- 
Thanks,
Sasha
