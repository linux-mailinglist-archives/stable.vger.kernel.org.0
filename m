Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE723C46AD
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbhGLG1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235302AbhGLG03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:26:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10749610CD;
        Mon, 12 Jul 2021 06:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071013;
        bh=C2lxa0E2qiKn9TVub/oUlZwd/41KksUPig9rK1OTwNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b2jDVblzX6JxOsfpSMuMVTdMY10UeuihjGXRDc43FJjuf42Mx3Tzg3qmraJYV0dat
         igSCmsgcVE3STdXXSZNtLK6eE+51fMCrUi3icED2JTtmi2Xttkagg0eKKv9O29VnLh
         Y3/UiwYKYCGkLbXSFN+hlXBlcLchUe19wWvsAy/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Liu Shixin <liushixin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 210/348] netlabel: Fix memory leak in netlbl_mgmt_add_common
Date:   Mon, 12 Jul 2021 08:09:54 +0200
Message-Id: <20210712060729.439855068@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index e7a25fbfaf8b..a92ed37d0922 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -76,6 +76,7 @@ static const struct nla_policy netlbl_mgmt_genl_policy[NLBL_MGMT_A_MAX + 1] = {
 static int netlbl_mgmt_add_common(struct genl_info *info,
 				  struct netlbl_audit *audit_info)
 {
+	void *pmap = NULL;
 	int ret_val = -EINVAL;
 	struct netlbl_domaddr_map *addrmap = NULL;
 	struct cipso_v4_doi *cipsov4 = NULL;
@@ -175,6 +176,7 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 			ret_val = -ENOMEM;
 			goto add_free_addrmap;
 		}
+		pmap = map;
 		map->list.addr = addr->s_addr & mask->s_addr;
 		map->list.mask = mask->s_addr;
 		map->list.valid = 1;
@@ -183,10 +185,8 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 			map->def.cipso = cipsov4;
 
 		ret_val = netlbl_af4list_add(&map->list, &addrmap->list4);
-		if (ret_val != 0) {
-			kfree(map);
-			goto add_free_addrmap;
-		}
+		if (ret_val != 0)
+			goto add_free_map;
 
 		entry->family = AF_INET;
 		entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
@@ -223,6 +223,7 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 			ret_val = -ENOMEM;
 			goto add_free_addrmap;
 		}
+		pmap = map;
 		map->list.addr = *addr;
 		map->list.addr.s6_addr32[0] &= mask->s6_addr32[0];
 		map->list.addr.s6_addr32[1] &= mask->s6_addr32[1];
@@ -235,10 +236,8 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 			map->def.calipso = calipso;
 
 		ret_val = netlbl_af6list_add(&map->list, &addrmap->list6);
-		if (ret_val != 0) {
-			kfree(map);
-			goto add_free_addrmap;
-		}
+		if (ret_val != 0)
+			goto add_free_map;
 
 		entry->family = AF_INET6;
 		entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
@@ -248,10 +247,12 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
 
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



