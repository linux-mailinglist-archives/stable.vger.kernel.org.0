Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEB53FDC98
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245663AbhIAMv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346410AbhIAMuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:50:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37C8B611C2;
        Wed,  1 Sep 2021 12:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500096;
        bh=0rzdbB/9aZc3a0ybYkaty3lEVv01xxaRqF55lbJ0qnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgERuG2lwmLQj2T/tM2mEfYnjUZngBPNLkXpGLfKmr40BkSLJRJ8Xy07BomKhVlJy
         DMVQWiPZT/tpT58Eb43/NpMTsGc/FOJeKUEp3USLsfhQjct17SxEj0Xt8HqlCkEx64
         NZKgbYA5uycaqhxV3aX2EhfBTbUN3RbjinFps900=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 068/113] net: stmmac: fix kernel panic due to NULL pointer dereference of plat->est
Date:   Wed,  1 Sep 2021 14:28:23 +0200
Message-Id: <20210901122304.253560070@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@linux.intel.com>

[ Upstream commit 82a44ae113b7b35850f4542f0443fcab221e376a ]

In the case of taprio offload is not enabled, the error handling path
causes a kernel crash due to kernel NULL pointer deference.

Fix this by adding check for NULL before attempt to access 'plat->est'
on the mutex_lock() call.

The following kernel panic is observed without this patch:

RIP: 0010:mutex_lock+0x10/0x20
Call Trace:
tc_setup_taprio+0x482/0x560 [stmmac]
kmem_cache_alloc_trace+0x13f/0x490
taprio_disable_offload.isra.0+0x9d/0x180 [sch_taprio]
taprio_destroy+0x6c/0x100 [sch_taprio]
qdisc_create+0x2e5/0x4f0
tc_modify_qdisc+0x126/0x740
rtnetlink_rcv_msg+0x12b/0x380
_raw_spin_lock_irqsave+0x19/0x40
_raw_spin_unlock_irqrestore+0x18/0x30
create_object+0x212/0x340
rtnl_calcit.isra.0+0x110/0x110
netlink_rcv_skb+0x50/0x100
netlink_unicast+0x191/0x230
netlink_sendmsg+0x243/0x470
sock_sendmsg+0x5e/0x60
____sys_sendmsg+0x20b/0x280
copy_msghdr_from_user+0x5c/0x90
__mod_memcg_state+0x87/0xf0
 ___sys_sendmsg+0x7c/0xc0
lru_cache_add+0x7f/0xa0
_raw_spin_unlock+0x16/0x30
wp_page_copy+0x449/0x890
handle_mm_fault+0x921/0xfc0
__sys_sendmsg+0x59/0xa0
do_syscall_64+0x33/0x40
entry_SYSCALL_64_after_hwframe+0x44/0xa9
---[ end trace b1f19b24368a96aa ]---

Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index fb5207dcbcaa..c7554db2962f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -870,11 +870,13 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	return 0;
 
 disable:
-	mutex_lock(&priv->plat->est->lock);
-	priv->plat->est->enable = false;
-	stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
-			     priv->plat->clk_ptp_rate);
-	mutex_unlock(&priv->plat->est->lock);
+	if (priv->plat->est) {
+		mutex_lock(&priv->plat->est->lock);
+		priv->plat->est->enable = false;
+		stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
+				     priv->plat->clk_ptp_rate);
+		mutex_unlock(&priv->plat->est->lock);
+	}
 
 	priv->plat->fpe_cfg->enable = false;
 	stmmac_fpe_configure(priv, priv->ioaddr,
-- 
2.30.2



