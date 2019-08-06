Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F224C83D08
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfHFVzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfHFVzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:55:23 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 592302173C;
        Tue,  6 Aug 2019 21:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565128522;
        bh=CPWKcAELCTCKzC1m7jwsP+d5ONXblTt+WK1aiO484xM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0r+sWLR9ZD7bnHHN9EYSbjhQYoEEsCDOBx9roAgwcRsmL9bBRQ7hLn82dsaH+1sI0
         6KwL1dOT1OabEHxS/hnMZztDF/tk9CZ+fJQj8NhFs1xiNLobD2v7g4SqCfqemt/EOs
         BHvPyAUurYFlfp1C12SQAWot6dpO33FncoPjSP4I=
Date:   Tue, 6 Aug 2019 17:55:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, gregkh@google.com, groeck@chromium.org,
        phil.turnbull@oracle.com, pablo@netfilter.org, davem@davemloft.net
Subject: Re: eda3fc50daa9 ("netfilter: nfnetlink_acct: validate NFACCT_QUOTA
 parameter")
Message-ID: <20190806215521.GM17747@sasha-vm>
References: <20190806163254.GA176933@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190806163254.GA176933@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 09:32:55AM -0700, Zubin Mithra wrote:
>Hello,
>
>Syzkaller has triggered a GPF when fuzzing a 4.4 kernel with the following stacktrace.
>
>Call Trace:
> [<ffffffff823d9bfe>] nla_get_be64 include/net/netlink.h:1130 [inline]
> [<ffffffff823d9bfe>] nfnl_acct_new+0x3ae/0x720 net/netfilter/nfnetlink_acct.c:111
> [<ffffffff823d81c7>] nfnetlink_rcv_msg+0xa27/0xc30 net/netfilter/nfnetlink.c:215
> [<ffffffff823c7ebf>] netlink_rcv_skb+0xdf/0x2f0 net/netlink/af_netlink.c:2361
> [<ffffffff823d6e89>] nfnetlink_rcv+0x939/0x1000 net/netfilter/nfnetlink.c:479
> [<ffffffff823c6974>] netlink_unicast_kernel net/netlink/af_netlink.c:1277 [inline]
> [<ffffffff823c6974>] netlink_unicast+0x474/0x7c0 net/netlink/af_netlink.c:1303
> [<ffffffff823c7461>] netlink_sendmsg+0x7a1/0xc50 net/netlink/af_netlink.c:1859
> [<ffffffff82239fe5>] sock_sendmsg_nosec net/socket.c:627 [inline]
> [<ffffffff82239fe5>] sock_sendmsg+0xd5/0x110 net/socket.c:637
> [<ffffffff8223da67>] ___sys_sendmsg+0x767/0x890 net/socket.c:1964
> [<ffffffff822405db>] __sys_sendmsg+0xbb/0x150 net/socket.c:1998
> [<ffffffff822406a2>] SYSC_sendmsg net/socket.c:2009 [inline]
> [<ffffffff822406a2>] SyS_sendmsg+0x32/0x50 net/socket.c:2005
> [<ffffffff82a44e67>] entry_SYSCALL_64_fastpath+0x1e/0xa0
>RIP  [<ffffffff81d4931c>] nla_memcpy+0x2c/0xa0 lib/nlattr.c:279
>
>Could the following patch be applied in order to v4.4.y? It is present in v4.9.y.
>* eda3fc50daa9 ("netfilter: nfnetlink_acct: validate NFACCT_QUOTA parameter")
>
>Tests run:
>* Syzkaller reproducer
>* Chrome OS tryjobs

Queued up for 4.4, thanks.

--
Thanks,
Sasha
