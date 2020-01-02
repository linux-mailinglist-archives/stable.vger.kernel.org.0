Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA4E12F0D0
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgABWSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:18:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgABWSk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF72D21582;
        Thu,  2 Jan 2020 22:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003519;
        bh=GT98iZjKaCrHRL5l1UxVJ9CxZ/AVP+iKA7RnFMB2bIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyDAOvDar9bR3PwR6lvpChoL+GZgp8jrjznT30+BXLKjGMBhCVHz6hzLAA2zfJZAh
         /LJ6pHj9n6afZJxQwoT4cBZdpY6vb/XtjWEWYsXRwoWvF1tByljsLG4D2p5KYtcNAf
         z/c/0QJ7utcrQAxE0IM3y2wDpw80UV5vA9VcWUSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 175/191] net: dsa: sja1105: Reconcile the meaning of TPID and TPID2 for E/T and P/Q/R/S
Date:   Thu,  2 Jan 2020 23:07:37 +0100
Message-Id: <20200102215848.054114222@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 54fa49ee88138756df0fcf867cb1849904710a8c ]

For first-generation switches (SJA1105E and SJA1105T):
- TPID means C-Tag (typically 0x8100)
- TPID2 means S-Tag (typically 0x88A8)

While for the second generation switches (SJA1105P, SJA1105Q, SJA1105R,
SJA1105S) it is the other way around:
- TPID means S-Tag (typically 0x88A8)
- TPID2 means C-Tag (typically 0x8100)

In other words, E/T tags untagged traffic with TPID, and P/Q/R/S with
TPID2.

So the patch mentioned below fixed VLAN filtering for P/Q/R/S, but broke
it for E/T.

We strive for a common code path for all switches in the family, so just
lie in the static config packing functions that TPID and TPID2 are at
swapped bit offsets than they actually are, for P/Q/R/S. This will make
both switches understand TPID to be ETH_P_8021Q and TPID2 to be
ETH_P_8021AD. The meaning from the original E/T was chosen over P/Q/R/S
because E/T is actually the one with public documentation available
(UM10944.pdf).

Fixes: f9a1a7646c0d ("net: dsa: sja1105: Reverse TPID and TPID2")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c          |    8 ++++----
 drivers/net/dsa/sja1105/sja1105_static_config.c |    7 +++++--
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1560,8 +1560,8 @@ static int sja1105_vlan_filtering(struct
 
 	if (enabled) {
 		/* Enable VLAN filtering. */
-		tpid  = ETH_P_8021AD;
-		tpid2 = ETH_P_8021Q;
+		tpid  = ETH_P_8021Q;
+		tpid2 = ETH_P_8021AD;
 	} else {
 		/* Disable VLAN filtering. */
 		tpid  = ETH_P_SJA1105;
@@ -1570,9 +1570,9 @@ static int sja1105_vlan_filtering(struct
 
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 	general_params = table->entries;
-	/* EtherType used to identify outer tagged (S-tag) VLAN traffic */
-	general_params->tpid = tpid;
 	/* EtherType used to identify inner tagged (C-tag) VLAN traffic */
+	general_params->tpid = tpid;
+	/* EtherType used to identify outer tagged (S-tag) VLAN traffic */
 	general_params->tpid2 = tpid2;
 	/* When VLAN filtering is on, we need to at least be able to
 	 * decode management traffic through the "backup plan".
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -142,6 +142,9 @@ static size_t sja1105et_general_params_e
 	return size;
 }
 
+/* TPID and TPID2 are intentionally reversed so that semantic
+ * compatibility with E/T is kept.
+ */
 static size_t
 sja1105pqrs_general_params_entry_packing(void *buf, void *entry_ptr,
 					 enum packing_op op)
@@ -166,9 +169,9 @@ sja1105pqrs_general_params_entry_packing
 	sja1105_packing(buf, &entry->mirr_port,   141, 139, size, op);
 	sja1105_packing(buf, &entry->vlmarker,    138, 107, size, op);
 	sja1105_packing(buf, &entry->vlmask,      106,  75, size, op);
-	sja1105_packing(buf, &entry->tpid,         74,  59, size, op);
+	sja1105_packing(buf, &entry->tpid2,        74,  59, size, op);
 	sja1105_packing(buf, &entry->ignore2stf,   58,  58, size, op);
-	sja1105_packing(buf, &entry->tpid2,        57,  42, size, op);
+	sja1105_packing(buf, &entry->tpid,         57,  42, size, op);
 	sja1105_packing(buf, &entry->queue_ts,     41,  41, size, op);
 	sja1105_packing(buf, &entry->egrmirrvid,   40,  29, size, op);
 	sja1105_packing(buf, &entry->egrmirrpcp,   28,  26, size, op);


