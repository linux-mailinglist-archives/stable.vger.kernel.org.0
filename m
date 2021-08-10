Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118CE3E7F31
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbhHJRhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233965AbhHJRgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:36:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F046610E9;
        Tue, 10 Aug 2021 17:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616931;
        bh=ql3WK06ce4y9XwlSZdJk4v6L9Na7PFGpHvHYh5uojO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B22WRzdByhWvfEOjcklLeCk+WUpYqI9RAkQHiC3XWMIT2DAjMvMEL/HqqowiXUnZv
         85qQPbS18iLkTtre/9qkPlPzimnC7K7ns/z6p+F+MxHhJxoGn2pbIEvPYS8OR9vZM3
         5PHHKvkTTmvqDLtbOuOT+V50MqvYTsXZ6vNi6d5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/85] net: dsa: sja1105: overwrite dynamic FDB entries with static ones in .port_fdb_add
Date:   Tue, 10 Aug 2021 19:29:54 +0200
Message-Id: <20210810172948.913290545@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit e11e865bf84e3c6ea91563ff3e858cfe0e184bd2 ]

The SJA1105 switch family leaves it up to software to decide where
within the FDB to install a static entry, and to concatenate destination
ports for already existing entries (the FDB is also used for multicast
entries), it is not as simple as just saying "please add this entry".

This means we first need to search for an existing FDB entry before
adding a new one. The driver currently manages to fool itself into
thinking that if an FDB entry already exists, there is nothing to be
done. But that FDB entry might be dynamically learned, case in which it
should be replaced with a static entry, but instead it is left alone.

This patch checks the LOCKEDS ("locked/static") bit from found FDB
entries, and lets the code "goto skip_finding_an_index;" if the FDB
entry was not static. So we also need to move the place where we set
LOCKEDS = true, to cover the new case where a dynamic FDB entry existed
but was dynamic.

Fixes: 291d1e72b756 ("net: dsa: sja1105: Add support for FDB and MDB management")
Fixes: 1da73821343c ("net: dsa: sja1105: Add FDB operations for P/Q/R/S series")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 034f1b50ab28..54b77eafdf63 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1007,7 +1007,7 @@ int sja1105et_fdb_add(struct dsa_switch *ds, int port,
 		 * mask? If yes, we need to do nothing. If not, we need
 		 * to rewrite the entry by adding this port to it.
 		 */
-		if (l2_lookup.destports & BIT(port))
+		if ((l2_lookup.destports & BIT(port)) && l2_lookup.lockeds)
 			return 0;
 		l2_lookup.destports |= BIT(port);
 	} else {
@@ -1038,6 +1038,7 @@ int sja1105et_fdb_add(struct dsa_switch *ds, int port,
 						     index, NULL, false);
 		}
 	}
+	l2_lookup.lockeds = true;
 	l2_lookup.index = sja1105et_fdb_index(bin, way);
 
 	rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
@@ -1108,10 +1109,10 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
 					 SJA1105_SEARCH, &l2_lookup);
 	if (rc == 0) {
-		/* Found and this port is already in the entry's
+		/* Found a static entry and this port is already in the entry's
 		 * port mask => job done
 		 */
-		if (l2_lookup.destports & BIT(port))
+		if ((l2_lookup.destports & BIT(port)) && l2_lookup.lockeds)
 			return 0;
 		/* l2_lookup.index is populated by the switch in case it
 		 * found something.
@@ -1134,10 +1135,11 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 		dev_err(ds->dev, "FDB is full, cannot add entry.\n");
 		return -EINVAL;
 	}
-	l2_lookup.lockeds = true;
 	l2_lookup.index = i;
 
 skip_finding_an_index:
+	l2_lookup.lockeds = true;
+
 	rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
 					  l2_lookup.index, &l2_lookup,
 					  true);
-- 
2.30.2



