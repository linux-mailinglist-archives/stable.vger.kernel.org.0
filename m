Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC553CD7CA
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242010AbhGSOS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241588AbhGSOSC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:18:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1C6D6113B;
        Mon, 19 Jul 2021 14:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706721;
        bh=7cf9s0WJLknvqbvhZ3mFo260NRJ5Qby36RhCgiPJq5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ekpBsyH4e6QUKkfTZI5HZ6Vnr26VJWsLMZUyby+6e1ML96tHvdrmlifO5a8ktKHc
         71A3I/v8bSC//88jp/tSYqY7NyNUkNEnkWudSLKshJYqBRwPiOqYjdtDvWjA5Tv9WY
         qDN8D7E8H7p9D95uoLFjc4m5NkGy3SzSY+qYye2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Liu Shixin <liushixin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 068/188] netlabel: Fix memory leak in netlbl_mgmt_add_common
Date:   Mon, 19 Jul 2021 16:50:52 +0200
Message-Id: <20210719144928.849804703@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit b8f6b0522c298ae9267bd6584e19b942a0636910 ]

Hulk Robot reported memory leak in netlbl_mgmt_add_common.
The problem is non-freed map in case of netlbl_domhsh_add() failed.

BUG: memory leak
unreferenced object 0xffff888100ab7080 (size 96):
  comm "syz-executor537", pid 360, jiffies 4294862456 (age 22.678s)
  hex dump (first 32 bytes):
    05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01  ................
  backtrace:
    [<0000000008b40026>] netlbl_mgmt_add_common.isra.0+0xb2a/0x1b40
    [<000000003be10950>] netlbl_mgmt_add+0x271/0x3c0
    [<00000000c70487ed>] genl_family_rcv_msg_doit.isra.0+0x20e/0x320
    [<000000001f2ff614>] genl_rcv_msg+0x2bf/0x4f0
    [<0000000089045792>] netlink_rcv_skb+0x134/0x3d0
    [<0000000020e96fdd>] genl_rcv+0x24/0x40
    [<0000000042810c66>] netlink_unicast+0x4a0/0x6a0
    [<000000002e1659f0>] netlink_sendmsg+0x789/0xc70
    [<000000006e43415f>] sock_sendmsg+0x139/0x170
    [<00000000680a73d7>] ____sys_sendmsg+0x658/0x7d0
    [<0000000065cbb8af>] ___sys_sendmsg+0xf8/0x170
    [<0000000019932b6c>] __sys_sendmsg+0xd3/0x190
    [<00000000643ac172>] do_syscall_64+0x37/0x90
    [<000000009b79d6dc>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 63c416887437 ("netlabel: Add network address selectors to the NetLabel/LSM domain mapping")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlabel/netlabel_mgmt.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index 13f777f20995..5f1218dc9162 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -92,6 +92,7 @@ static const struct nla_policy netlbl_mgmt_genl_policy[NLBL_MGMT_A_MAX + 1] = {
 static int netlbl_mgmt_add_common(struct genl_info *info,
 				  struct netlbl_audit *audit_info)
 {
+	void *pmap = NULL;
 	int ret_val = -EINVAL;
 	struct netlbl_domaddr_map *addrmap = NULL;
 	struct cipso_v4_doi *cipsov4 = NULL;
@@ -165,6 +166,7 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 			ret_val = -ENOMEM;
 			goto add_free_addrmap;
 		}
+		pmap = map;
 		map->list.addr = addr->s_addr & mask->s_addr;
 		map->list.mask = mask->s_addr;
 		map->list.valid = 1;
@@ -173,10 +175,8 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 			map->def.cipso = cipsov4;
 
 		ret_val = netlbl_af4list_add(&map->list, &addrmap->list4);
-		if (ret_val != 0) {
-			kfree(map);
-			goto add_free_addrmap;
-		}
+		if (ret_val != 0)
+			goto add_free_map;
 
 		entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
 		entry->def.addrsel = addrmap;
@@ -212,6 +212,7 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 			ret_val = -ENOMEM;
 			goto add_free_addrmap;
 		}
+		pmap = map;
 		map->list.addr = *addr;
 		map->list.addr.s6_addr32[0] &= mask->s6_addr32[0];
 		map->list.addr.s6_addr32[1] &= mask->s6_addr32[1];
@@ -222,10 +223,8 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 		map->def.type = entry->def.type;
 
 		ret_val = netlbl_af6list_add(&map->list, &addrmap->list6);
-		if (ret_val != 0) {
-			kfree(map);
-			goto add_free_addrmap;
-		}
+		if (ret_val != 0)
+			goto add_free_map;
 
 		entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
 		entry->def.addrsel = addrmap;
@@ -234,10 +233,12 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 
 	ret_val = netlbl_domhsh_add(entry, audit_info);
 	if (ret_val != 0)
-		goto add_free_addrmap;
+		goto add_free_map;
 
 	return 0;
 
+add_free_map:
+	kfree(pmap);
 add_free_addrmap:
 	kfree(addrmap);
 add_doi_put_def:
-- 
2.30.2



