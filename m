Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3D23E810C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbhHJRzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235073AbhHJRwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4564D6128C;
        Tue, 10 Aug 2021 17:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617401;
        bh=1FUdKICor+Mn+DvDtJsxVUxXx0H8Pf0AYLAO4DR84xE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=va314uVPYeO8LkTBYWp2qqfu8rd6Vdwz7KG00bHeovWnDcjhezX2JIwk35DL9lj9U
         K5TMkiGOJdjhJoFoaHqQOvSi44pXToBZfSWkgYXR1bzlfG+UnTYZnwTc6bMbhCh8P0
         TY1fzwW24YctAYbvLkydmQkhN1XFHvydQ2YLnUkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 043/175] net: dsa: sja1105: ignore the FDB entry for unknown multicast when adding a new address
Date:   Tue, 10 Aug 2021 19:29:11 +0200
Message-Id: <20210810173002.367399861@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 728db843df88753aeb7224314807a203afa8eb32 ]

Currently, when sja1105pqrs_fdb_add() is called for a host-joined IPv6
MDB entry such as 33:33:00:00:00:6a, the search for that address will
return the FDB entry for SJA1105_UNKNOWN_MULTICAST, which has a
destination MAC of 01:00:00:00:00:00 and a mask of 01:00:00:00:00:00.
It returns that entry because, well, it matches, in the sense that
unknown multicast is supposed by design to match it...

But the issue is that we then proceed to overwrite this entry with the
one for our precise host-joined multicast address, and the unknown
multicast entry is no longer there - unknown multicast is now flooded to
the same group of ports as broadcast, which does not look up the FDB.

To solve this problem, we should ignore searches that return the unknown
multicast address as the match, and treat them as "no match" which will
result in the entry being installed to hardware.

For this to work properly, we need to put the result of the FDB search
in a temporary variable in order to avoid overwriting the l2_lookup
entry we want to program. The l2_lookup entry returned by the search
might not have the same set of DESTPORTS and not even the same MACADDR
as the entry we're trying to add.

Fixes: 4d9423549501 ("net: dsa: sja1105: offload bridge port flags to device")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 5e88632e10b9..edc9462c6d4e 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1446,14 +1446,19 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 	}
 	l2_lookup.destports = BIT(port);
 
+	tmp = l2_lookup;
+
 	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
-					 SJA1105_SEARCH, &l2_lookup);
-	if (rc == 0) {
+					 SJA1105_SEARCH, &tmp);
+	if (rc == 0 && tmp.index != SJA1105_MAX_L2_LOOKUP_COUNT - 1) {
 		/* Found a static entry and this port is already in the entry's
 		 * port mask => job done
 		 */
-		if ((l2_lookup.destports & BIT(port)) && l2_lookup.lockeds)
+		if ((tmp.destports & BIT(port)) && tmp.lockeds)
 			return 0;
+
+		l2_lookup = tmp;
+
 		/* l2_lookup.index is populated by the switch in case it
 		 * found something.
 		 */
-- 
2.30.2



