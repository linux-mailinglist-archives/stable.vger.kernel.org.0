Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB0E302ADE
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731368AbhAYSzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:55:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731365AbhAYSzH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 671DF224D4;
        Mon, 25 Jan 2021 18:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600866;
        bh=/3m6V8VVoxS5MugNHj2VXzbuJkQSHoQ4GThF+RLfz+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqTR5ypcIhyeis68j6xbsO8xLdVyUon7Y8A+kpt+cBFOCpgMm0ow6W46fT3uYhg5W
         7UzQS3rRx0u7LM85xNO38WQ1BJtxrdxTw6+lzuQk989JDtzFjwFBrFWReaEXukC6qR
         8ZJ+1Wdx66vzUTDZiP15BaMBb4wSj7e0Xgt2h/dU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alban Bedel <alban.bedel@aerq.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 181/199] net: mscc: ocelot: Fix multicast to the CPU port
Date:   Mon, 25 Jan 2021 19:40:03 +0100
Message-Id: <20210125183223.828129419@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alban Bedel <alban.bedel@aerq.com>

commit 584b7cfcdc7d6d416a9d6fece9516764bd977d2e upstream.

Multicast entries in the MAC table use the high bits of the MAC
address to encode the ports that should get the packets. But this port
mask does not work for the CPU port, to receive these packets on the
CPU port the MAC_CPU_COPY flag must be set.

Because of this IPv6 was effectively not working because neighbor
solicitations were never received. This was not apparent before commit
9403c158 (net: mscc: ocelot: support IPv4, IPv6 and plain Ethernet mdb
entries) as the IPv6 entries were broken so all incoming IPv6
multicast was then treated as unknown and flooded on all ports.

To fix this problem rework the ocelot_mact_learn() to set the
MAC_CPU_COPY flag when a multicast entry that target the CPU port is
added. For this we have to read back the ports endcoded in the pseudo
MAC address by the caller. It is not a very nice design but that avoid
changing the callers and should make backporting easier.

Signed-off-by: Alban Bedel <alban.bedel@aerq.com>
Fixes: 9403c158b872 ("net: mscc: ocelot: support IPv4, IPv6 and plain Ethernet mdb entries")
Link: https://lore.kernel.org/r/20210119140638.203374-1-alban.bedel@aerq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mscc/ocelot.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -60,14 +60,27 @@ int ocelot_mact_learn(struct ocelot *oce
 		      const unsigned char mac[ETH_ALEN],
 		      unsigned int vid, enum macaccess_entry_type type)
 {
+	u32 cmd = ANA_TABLES_MACACCESS_VALID |
+		ANA_TABLES_MACACCESS_DEST_IDX(port) |
+		ANA_TABLES_MACACCESS_ENTRYTYPE(type) |
+		ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_LEARN);
+	unsigned int mc_ports;
+
+	/* Set MAC_CPU_COPY if the CPU port is used by a multicast entry */
+	if (type == ENTRYTYPE_MACv4)
+		mc_ports = (mac[1] << 8) | mac[2];
+	else if (type == ENTRYTYPE_MACv6)
+		mc_ports = (mac[0] << 8) | mac[1];
+	else
+		mc_ports = 0;
+
+	if (mc_ports & BIT(ocelot->num_phys_ports))
+		cmd |= ANA_TABLES_MACACCESS_MAC_CPU_COPY;
+
 	ocelot_mact_select(ocelot, mac, vid);
 
 	/* Issue a write command */
-	ocelot_write(ocelot, ANA_TABLES_MACACCESS_VALID |
-			     ANA_TABLES_MACACCESS_DEST_IDX(port) |
-			     ANA_TABLES_MACACCESS_ENTRYTYPE(type) |
-			     ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_LEARN),
-			     ANA_TABLES_MACACCESS);
+	ocelot_write(ocelot, cmd, ANA_TABLES_MACACCESS);
 
 	return ocelot_mact_wait_for_completion(ocelot);
 }


