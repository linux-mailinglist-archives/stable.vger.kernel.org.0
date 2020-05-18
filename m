Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAA21D8064
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbgERRjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:39:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728822AbgERRjb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:39:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD22C207C4;
        Mon, 18 May 2020 17:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823571;
        bh=jptbGf47UtxIe6X7zV5uYiSn+4FsyqIgKhShjmDJwR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F73lNmLkmqr9AxJelr+GIkFWpOJ5turZS4pvF/5rORvAlR468Js+OnuCt0zAFHI87
         HW1USDxms9oi4AVp3JlHLkcbRbrgp3XZ32AjeTwrfjGoZatCsQC2/b18OHMFuJKq0z
         jFmV4YQVa1aHw8MGUz1biMnIKiWX+d5ss8zHWzT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>,
        David Ahern <dsa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 35/86] net: handle no dst on skb in icmp6_send
Date:   Mon, 18 May 2020 19:36:06 +0200
Message-Id: <20200518173457.623138564@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsa@cumulusnetworks.com>

commit 79dc7e3f1cd323be4c81aa1a94faa1b3ed987fb2 upstream.

Andrey reported the following while fuzzing the kernel with syzkaller:

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] SMP KASAN
Modules linked in:
CPU: 0 PID: 3859 Comm: a.out Not tainted 4.9.0-rc6+ #429
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
task: ffff8800666d4200 task.stack: ffff880067348000
RIP: 0010:[<ffffffff833617ec>]  [<ffffffff833617ec>]
icmp6_send+0x5fc/0x1e30 net/ipv6/icmp.c:451
RSP: 0018:ffff88006734f2c0  EFLAGS: 00010206
RAX: ffff8800666d4200 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000000018
RBP: ffff88006734f630 R08: ffff880064138418 R09: 0000000000000003
R10: dffffc0000000000 R11: 0000000000000005 R12: 0000000000000000
R13: ffffffff84e7e200 R14: ffff880064138484 R15: ffff8800641383c0
FS:  00007fb3887a07c0(0000) GS:ffff88006cc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 000000006b040000 CR4: 00000000000006f0
Stack:
 ffff8800666d4200 ffff8800666d49f8 ffff8800666d4200 ffffffff84c02460
 ffff8800666d4a1a 1ffff1000ccdaa2f ffff88006734f498 0000000000000046
 ffff88006734f440 ffffffff832f4269 ffff880064ba7456 0000000000000000
Call Trace:
 [<ffffffff83364ddc>] icmpv6_param_prob+0x2c/0x40 net/ipv6/icmp.c:557
 [<     inline     >] ip6_tlvopt_unknown net/ipv6/exthdrs.c:88
 [<ffffffff83394405>] ip6_parse_tlv+0x555/0x670 net/ipv6/exthdrs.c:157
 [<ffffffff8339a759>] ipv6_parse_hopopts+0x199/0x460 net/ipv6/exthdrs.c:663
 [<ffffffff832ee773>] ipv6_rcv+0xfa3/0x1dc0 net/ipv6/ip6_input.c:191
 ...

icmp6_send / icmpv6_send is invoked for both rx and tx paths. In both
cases the dst->dev should be preferred for determining the L3 domain
if the dst has been set on the skb. Fallback to the skb->dev if it has
not. This covers the case reported here where icmp6_send is invoked on
Rx before the route lookup.

Fixes: 5d41ce29e ("net: icmp6_send should use dst dev to determine L3 domain")
Reported-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: David Ahern <dsa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/icmp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -445,8 +445,10 @@ static void icmp6_send(struct sk_buff *s
 
 	if (__ipv6_addr_needs_scope_id(addr_type))
 		iif = skb->dev->ifindex;
-	else
-		iif = l3mdev_master_ifindex(skb_dst(skb)->dev);
+	else {
+		dst = skb_dst(skb);
+		iif = l3mdev_master_ifindex(dst ? dst->dev : skb->dev);
+	}
 
 	/*
 	 *	Must not send error if the source does not uniquely


