Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1053A02DC
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbhFHTLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235020AbhFHTHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:07:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D72C1613DF;
        Tue,  8 Jun 2021 18:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178024;
        bh=4hzoAdGgJOqf3nKZ34CIR3j3mzrlfvsy+RzqY+pz7vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndpGSAQ62+TzIVvFO6PlJj5DCbVs7XPqE2Eb99hSKBkKsTwaqPWAgN/S4g2bXALLz
         pRM3bZ4KYrJdT9vf8RUt2SBBqW0UbzkgC3TH2Wuv3g85rWYEQgW0e4ju/GMp4jT94D
         7sRYopsBrkPEaWE5HZuSRC9VyphF72f8atOKZbjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+e562383183e4b1766930@syzkaller.appspotmail.com
Subject: [PATCH 5.12 015/161] ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service
Date:   Tue,  8 Jun 2021 20:25:45 +0200
Message-Id: <20210608175945.976126321@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 56e4ee82e850026d71223262c07df7d6af3bd872 ]

syzbot reported memory leak [1] when adding service with
HASHED flag. We should ignore this flag both from sockopt
and netlink provided data, otherwise the service is not
hashed and not visible while releasing resources.

[1]
BUG: memory leak
unreferenced object 0xffff888115227800 (size 512):
  comm "syz-executor263", pid 8658, jiffies 4294951882 (age 12.560s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff83977188>] kmalloc include/linux/slab.h:556 [inline]
    [<ffffffff83977188>] kzalloc include/linux/slab.h:686 [inline]
    [<ffffffff83977188>] ip_vs_add_service+0x598/0x7c0 net/netfilter/ipvs/ip_vs_ctl.c:1343
    [<ffffffff8397d770>] do_ip_vs_set_ctl+0x810/0xa40 net/netfilter/ipvs/ip_vs_ctl.c:2570
    [<ffffffff838449a8>] nf_setsockopt+0x68/0xa0 net/netfilter/nf_sockopt.c:101
    [<ffffffff839ae4e9>] ip_setsockopt+0x259/0x1ff0 net/ipv4/ip_sockglue.c:1435
    [<ffffffff839fa03c>] raw_setsockopt+0x18c/0x1b0 net/ipv4/raw.c:857
    [<ffffffff83691f20>] __sys_setsockopt+0x1b0/0x360 net/socket.c:2117
    [<ffffffff836920f2>] __do_sys_setsockopt net/socket.c:2128 [inline]
    [<ffffffff836920f2>] __se_sys_setsockopt net/socket.c:2125 [inline]
    [<ffffffff836920f2>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2125
    [<ffffffff84350efa>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-and-tested-by: syzbot+e562383183e4b1766930@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index d45dbcba8b49..c25097092a06 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1367,7 +1367,7 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 	ip_vs_addr_copy(svc->af, &svc->addr, &u->addr);
 	svc->port = u->port;
 	svc->fwmark = u->fwmark;
-	svc->flags = u->flags;
+	svc->flags = u->flags & ~IP_VS_SVC_F_HASHED;
 	svc->timeout = u->timeout * HZ;
 	svc->netmask = u->netmask;
 	svc->ipvs = ipvs;
-- 
2.30.2



