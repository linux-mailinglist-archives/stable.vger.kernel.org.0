Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415A53ED54C
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238754AbhHPNKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236703AbhHPNJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A7F7632C7;
        Mon, 16 Aug 2021 13:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119263;
        bh=j65LFZcnaL+oxjIsEqTB15YmQVSRu/G2T0ohIKt3HxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3jD1s2NC8wRzceVqYPwJ91Tmg6RfPi67jQqnCoCAHDfM/YvU6nBuh9foORvU/PEl
         3uSYICYe3UP/m8Ol1IFqoAwaeEl0PPPIZBwGlrRhEm4QKSfv4zQSsQiCnG5WHMoFbh
         LNw+nqfb6H/srm95N7qKAZUnFXORGPa3P4nWQTPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 55/96] net: dsa: lan9303: fix broken backpressure in .port_fdb_dump
Date:   Mon, 16 Aug 2021 15:02:05 +0200
Message-Id: <20210816125436.789886918@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit ada2fee185d8145afb89056558bb59545b9dbdd0 ]

rtnl_fdb_dump() has logic to split a dump of PF_BRIDGE neighbors into
multiple netlink skbs if the buffer provided by user space is too small
(one buffer will typically handle a few hundred FDB entries).

When the current buffer becomes full, nlmsg_put() in
dsa_slave_port_fdb_do_dump() returns -EMSGSIZE and DSA saves the index
of the last dumped FDB entry, returns to rtnl_fdb_dump() up to that
point, and then the dump resumes on the same port with a new skb, and
FDB entries up to the saved index are simply skipped.

Since dsa_slave_port_fdb_do_dump() is pointed to by the "cb" passed to
drivers, then drivers must check for the -EMSGSIZE error code returned
by it. Otherwise, when a netlink skb becomes full, DSA will no longer
save newly dumped FDB entries to it, but the driver will continue
dumping. So FDB entries will be missing from the dump.

Fix the broken backpressure by propagating the "cb" return code and
allow rtnl_fdb_dump() to restart the FDB dump with a new skb.

Fixes: ab335349b852 ("net: dsa: lan9303: Add port_fast_age and port_fdb_dump methods")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lan9303-core.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index aa1142d6a9f5..dcf1fc89451f 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -557,12 +557,12 @@ static int lan9303_alr_make_entry_raw(struct lan9303 *chip, u32 dat0, u32 dat1)
 	return 0;
 }
 
-typedef void alr_loop_cb_t(struct lan9303 *chip, u32 dat0, u32 dat1,
-			   int portmap, void *ctx);
+typedef int alr_loop_cb_t(struct lan9303 *chip, u32 dat0, u32 dat1,
+			  int portmap, void *ctx);
 
-static void lan9303_alr_loop(struct lan9303 *chip, alr_loop_cb_t *cb, void *ctx)
+static int lan9303_alr_loop(struct lan9303 *chip, alr_loop_cb_t *cb, void *ctx)
 {
-	int i;
+	int ret = 0, i;
 
 	mutex_lock(&chip->alr_mutex);
 	lan9303_write_switch_reg(chip, LAN9303_SWE_ALR_CMD,
@@ -582,13 +582,17 @@ static void lan9303_alr_loop(struct lan9303 *chip, alr_loop_cb_t *cb, void *ctx)
 						LAN9303_ALR_DAT1_PORT_BITOFFS;
 		portmap = alrport_2_portmap[alrport];
 
-		cb(chip, dat0, dat1, portmap, ctx);
+		ret = cb(chip, dat0, dat1, portmap, ctx);
+		if (ret)
+			break;
 
 		lan9303_write_switch_reg(chip, LAN9303_SWE_ALR_CMD,
 					 LAN9303_ALR_CMD_GET_NEXT);
 		lan9303_write_switch_reg(chip, LAN9303_SWE_ALR_CMD, 0);
 	}
 	mutex_unlock(&chip->alr_mutex);
+
+	return ret;
 }
 
 static void alr_reg_to_mac(u32 dat0, u32 dat1, u8 mac[6])
@@ -606,18 +610,20 @@ struct del_port_learned_ctx {
 };
 
 /* Clear learned (non-static) entry on given port */
-static void alr_loop_cb_del_port_learned(struct lan9303 *chip, u32 dat0,
-					 u32 dat1, int portmap, void *ctx)
+static int alr_loop_cb_del_port_learned(struct lan9303 *chip, u32 dat0,
+					u32 dat1, int portmap, void *ctx)
 {
 	struct del_port_learned_ctx *del_ctx = ctx;
 	int port = del_ctx->port;
 
 	if (((BIT(port) & portmap) == 0) || (dat1 & LAN9303_ALR_DAT1_STATIC))
-		return;
+		return 0;
 
 	/* learned entries has only one port, we can just delete */
 	dat1 &= ~LAN9303_ALR_DAT1_VALID; /* delete entry */
 	lan9303_alr_make_entry_raw(chip, dat0, dat1);
+
+	return 0;
 }
 
 struct port_fdb_dump_ctx {
@@ -626,19 +632,19 @@ struct port_fdb_dump_ctx {
 	dsa_fdb_dump_cb_t *cb;
 };
 
-static void alr_loop_cb_fdb_port_dump(struct lan9303 *chip, u32 dat0,
-				      u32 dat1, int portmap, void *ctx)
+static int alr_loop_cb_fdb_port_dump(struct lan9303 *chip, u32 dat0,
+				     u32 dat1, int portmap, void *ctx)
 {
 	struct port_fdb_dump_ctx *dump_ctx = ctx;
 	u8 mac[ETH_ALEN];
 	bool is_static;
 
 	if ((BIT(dump_ctx->port) & portmap) == 0)
-		return;
+		return 0;
 
 	alr_reg_to_mac(dat0, dat1, mac);
 	is_static = !!(dat1 & LAN9303_ALR_DAT1_STATIC);
-	dump_ctx->cb(mac, 0, is_static, dump_ctx->data);
+	return dump_ctx->cb(mac, 0, is_static, dump_ctx->data);
 }
 
 /* Set a static ALR entry. Delete entry if port_map is zero */
@@ -1210,9 +1216,7 @@ static int lan9303_port_fdb_dump(struct dsa_switch *ds, int port,
 	};
 
 	dev_dbg(chip->dev, "%s(%d)\n", __func__, port);
-	lan9303_alr_loop(chip, alr_loop_cb_fdb_port_dump, &dump_ctx);
-
-	return 0;
+	return lan9303_alr_loop(chip, alr_loop_cb_fdb_port_dump, &dump_ctx);
 }
 
 static int lan9303_port_mdb_prepare(struct dsa_switch *ds, int port,
-- 
2.30.2



