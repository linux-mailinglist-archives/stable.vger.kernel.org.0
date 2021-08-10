Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E5A3E817C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhHJSAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:00:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236726AbhHJR5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:57:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E4A06139D;
        Tue, 10 Aug 2021 17:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617528;
        bh=W9XTF6OkJnuGwFbAjAdi2UgWQggT2Vvl8WCSX8YxYWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVrwRtPfBCbVq/Nr/uSu1xfVEQDSJds/iwM53Lu4LyfjTS1ob6NpHi85P5zwwq7mb
         ljD34ENR7E9fpCibYPbKWkG4QmVaCe+k7iI8S0076u3bgAshR5VeyQmqEqUWCYGJhC
         pzOJS5SSdoS99wParRl4GfEPsjUUAqx2wUwE50fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 065/175] net: ethernet: ti: am65-cpsw: fix crash in am65_cpsw_port_offload_fwd_mark_update()
Date:   Tue, 10 Aug 2021 19:29:33 +0200
Message-Id: <20210810173003.081740849@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit ae03d189bae306e1e00aa631feee090ebda6cf63 ]

The am65_cpsw_port_offload_fwd_mark_update() causes NULL exception crash
when there is at least one disabled port and any other port added to the
bridge first time.

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000858
pc : am65_cpsw_port_offload_fwd_mark_update+0x54/0x68
lr : am65_cpsw_netdevice_event+0x8c/0xf0
Call trace:
am65_cpsw_port_offload_fwd_mark_update+0x54/0x68
notifier_call_chain+0x54/0x98
raw_notifier_call_chain+0x14/0x20
call_netdevice_notifiers_info+0x34/0x78
__netdev_upper_dev_link+0x1c8/0x290
netdev_master_upper_dev_link+0x1c/0x28
br_add_if+0x3f0/0x6d0 [bridge]

Fix it by adding proper check for port->ndev != NULL.

Fixes: 2934db9bcb30 ("net: ti: am65-cpsw-nuss: Add netdevice notifiers")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 718539cdd2f2..67a08cbba859 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2060,8 +2060,12 @@ static void am65_cpsw_port_offload_fwd_mark_update(struct am65_cpsw_common *comm
 
 	for (i = 1; i <= common->port_num; i++) {
 		struct am65_cpsw_port *port = am65_common_get_port(common, i);
-		struct am65_cpsw_ndev_priv *priv = am65_ndev_to_priv(port->ndev);
+		struct am65_cpsw_ndev_priv *priv;
 
+		if (!port->ndev)
+			continue;
+
+		priv = am65_ndev_to_priv(port->ndev);
 		priv->offload_fwd_mark = set_val;
 	}
 }
-- 
2.30.2



