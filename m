Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E9E8370A
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 18:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732743AbfHFQdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 12:33:00 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:43916 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732809AbfHFQdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 12:33:00 -0400
Received: by mail-pf1-f176.google.com with SMTP id i189so41790419pfg.10
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 09:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=myT4PUUm/azeWz2S7R6qF8WwLvwlCb4UGACP9hRlUxs=;
        b=WqJ8JJIKuXWnjXY5ap2af6nYFmg8/Qhk8Nt701fK4CUYVlOo3op3CsXuLRbHLsdOp5
         ajO9Qw5/54kzlo7eK894FlYP1O1eYTRgpyTt0IxFQwLfKaDKcqD8TjofcSbuGDnxY/Ks
         FGOa2f1OwhIkKqvJyjS8c49A9VJqsVMR8QWEs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=myT4PUUm/azeWz2S7R6qF8WwLvwlCb4UGACP9hRlUxs=;
        b=rHr4Q7lJLBvjv29icN1skkWhzv5mVtPcpAr1vArsArwJWeGPQnfS9KB2ndS3tw4Ew1
         Hk5cvlqt2D5WDi6JwRonLhv+okTrdcyMkCx6X9XKtUBoXHQHo3HAmthDYXaWLpTG40vg
         3CEYehVwZVQi4i4I9vBaNZU4Mw0ap+7eroxtbAOaiVXGASIyXAKFvelTsiDKK0g3noDP
         4iXGnPCpgUeUcYTfphSxvrZc2kgSMC1Bt7nvSQV94rcUQ+L/eRKV7BpXfC/mgXbCnfaT
         8+sSyLT1YhtCo2/KDjRzvTzHRfu9tO5mpznEWMXGmpM8U6ulwZiwn85EONb6WmmDxqNC
         xxJw==
X-Gm-Message-State: APjAAAVL7eSd4c0yl1A4KQ1nQc2YxwAREmaO1ot9gRgNf6yGy5rcUwjr
        lryVX144E9fR2JtEijQP/CObrovUy2GB6g==
X-Google-Smtp-Source: APXvYqzuP4yuTzisFgGWCethQV5BEd1Hj/DoOSzJVF5G36FSLv08TB7DNwTOx4owxUiAuvsfV0rHUA==
X-Received: by 2002:a65:6497:: with SMTP id e23mr3664223pgv.89.1565109179532;
        Tue, 06 Aug 2019 09:32:59 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id p23sm93213206pfn.10.2019.08.06.09.32.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 09:32:58 -0700 (PDT)
Date:   Tue, 6 Aug 2019 09:32:55 -0700
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@google.com, groeck@chromium.org, phil.turnbull@oracle.com,
        pablo@netfilter.org, davem@davemloft.net
Subject: eda3fc50daa9 ("netfilter: nfnetlink_acct: validate NFACCT_QUOTA
 parameter")
Message-ID: <20190806163254.GA176933@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Syzkaller has triggered a GPF when fuzzing a 4.4 kernel with the following stacktrace.

Call Trace:
 [<ffffffff823d9bfe>] nla_get_be64 include/net/netlink.h:1130 [inline]
 [<ffffffff823d9bfe>] nfnl_acct_new+0x3ae/0x720 net/netfilter/nfnetlink_acct.c:111
 [<ffffffff823d81c7>] nfnetlink_rcv_msg+0xa27/0xc30 net/netfilter/nfnetlink.c:215
 [<ffffffff823c7ebf>] netlink_rcv_skb+0xdf/0x2f0 net/netlink/af_netlink.c:2361
 [<ffffffff823d6e89>] nfnetlink_rcv+0x939/0x1000 net/netfilter/nfnetlink.c:479
 [<ffffffff823c6974>] netlink_unicast_kernel net/netlink/af_netlink.c:1277 [inline]
 [<ffffffff823c6974>] netlink_unicast+0x474/0x7c0 net/netlink/af_netlink.c:1303
 [<ffffffff823c7461>] netlink_sendmsg+0x7a1/0xc50 net/netlink/af_netlink.c:1859
 [<ffffffff82239fe5>] sock_sendmsg_nosec net/socket.c:627 [inline]
 [<ffffffff82239fe5>] sock_sendmsg+0xd5/0x110 net/socket.c:637
 [<ffffffff8223da67>] ___sys_sendmsg+0x767/0x890 net/socket.c:1964
 [<ffffffff822405db>] __sys_sendmsg+0xbb/0x150 net/socket.c:1998
 [<ffffffff822406a2>] SYSC_sendmsg net/socket.c:2009 [inline]
 [<ffffffff822406a2>] SyS_sendmsg+0x32/0x50 net/socket.c:2005
 [<ffffffff82a44e67>] entry_SYSCALL_64_fastpath+0x1e/0xa0
RIP  [<ffffffff81d4931c>] nla_memcpy+0x2c/0xa0 lib/nlattr.c:279

Could the following patch be applied in order to v4.4.y? It is present in v4.9.y.
* eda3fc50daa9 ("netfilter: nfnetlink_acct: validate NFACCT_QUOTA parameter")

Tests run:
* Syzkaller reproducer
* Chrome OS tryjobs


Thanks,
- Zubin
