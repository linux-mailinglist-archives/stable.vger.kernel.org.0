Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B388E3AEE2F
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhFUQ0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:26:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231405AbhFUQYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:24:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 241436137D;
        Mon, 21 Jun 2021 16:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292483;
        bh=Ah2kxJ+7L8cQ2VKiuFR3uRjSjkwQOyjmMasE8yuQlAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/pSmwmCNTh2TiZoI654lPRLYoIvisQG6K/MG+3/Rp25dkDagUVwzLL7Nfa2lcGlR
         SWLW9NdSpLV8BeXP3Dq4IV1TezBptWcJaSb2jwjp4RyZg96CyuRRBeX0ZH9gwwqSyx
         xS7PyqhcJTOpPRj0YC4pbaiqXsn8DzfxAdPWlCj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/146] net: ipv4: fix memory leak in netlbl_cipsov4_add_std
Date:   Mon, 21 Jun 2021 18:14:07 +0200
Message-Id: <20210621154911.857465476@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nanyong Sun <sunnanyong@huawei.com>

[ Upstream commit d612c3f3fae221e7ea736d196581c2217304bbbc ]

Reported by syzkaller:
BUG: memory leak
unreferenced object 0xffff888105df7000 (size 64):
comm "syz-executor842", pid 360, jiffies 4294824824 (age 22.546s)
hex dump (first 32 bytes):
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
backtrace:
[<00000000e67ed558>] kmalloc include/linux/slab.h:590 [inline]
[<00000000e67ed558>] kzalloc include/linux/slab.h:720 [inline]
[<00000000e67ed558>] netlbl_cipsov4_add_std net/netlabel/netlabel_cipso_v4.c:145 [inline]
[<00000000e67ed558>] netlbl_cipsov4_add+0x390/0x2340 net/netlabel/netlabel_cipso_v4.c:416
[<0000000006040154>] genl_family_rcv_msg_doit.isra.0+0x20e/0x320 net/netlink/genetlink.c:739
[<00000000204d7a1c>] genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
[<00000000204d7a1c>] genl_rcv_msg+0x2bf/0x4f0 net/netlink/genetlink.c:800
[<00000000c0d6a995>] netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2504
[<00000000d78b9d2c>] genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
[<000000009733081b>] netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
[<000000009733081b>] netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1340
[<00000000d5fd43b8>] netlink_sendmsg+0x789/0xc70 net/netlink/af_netlink.c:1929
[<000000000a2d1e40>] sock_sendmsg_nosec net/socket.c:654 [inline]
[<000000000a2d1e40>] sock_sendmsg+0x139/0x170 net/socket.c:674
[<00000000321d1969>] ____sys_sendmsg+0x658/0x7d0 net/socket.c:2350
[<00000000964e16bc>] ___sys_sendmsg+0xf8/0x170 net/socket.c:2404
[<000000001615e288>] __sys_sendmsg+0xd3/0x190 net/socket.c:2433
[<000000004ee8b6a5>] do_syscall_64+0x37/0x90 arch/x86/entry/common.c:47
[<00000000171c7cee>] entry_SYSCALL_64_after_hwframe+0x44/0xae

The memory of doi_def->map.std pointing is allocated in
netlbl_cipsov4_add_std, but no place has freed it. It should be
freed in cipso_v4_doi_free which frees the cipso DOI resource.

Fixes: 96cb8e3313c7a ("[NetLabel]: CIPSOv4 and Unlabeled packet integration")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/cipso_ipv4.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index be09c7669a79..ca217a6f488f 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -472,6 +472,7 @@ void cipso_v4_doi_free(struct cipso_v4_doi *doi_def)
 		kfree(doi_def->map.std->lvl.local);
 		kfree(doi_def->map.std->cat.cipso);
 		kfree(doi_def->map.std->cat.local);
+		kfree(doi_def->map.std);
 		break;
 	}
 	kfree(doi_def);
-- 
2.30.2



