Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3724513DD
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347988AbhKOT6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:58:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344102AbhKOTXW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DDB261AFB;
        Mon, 15 Nov 2021 18:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002304;
        bh=iiuM/+n5LpH+bqqs1UXF+qa7HvqHwN1rrDwq2XOT/8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0gDchhHv5v4eYKelMptskw/PJLqr+2DeDufqUuC+UK5rv/QBJ7QRPz4aiDDMatdrt
         9bIllf0Fq1CFUWY6AWDl5tAuRgu+ZPrgmaBXXh/FD28+uruOi6SZmqJNec/2ZKM6qD
         +z3+Q2Db9Fr424H5myN/M5U+jnDIfXMYP5jbYeyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 514/917] net: dsa: avoid refcount warnings when ->port_{fdb,mdb}_del returns error
Date:   Mon, 15 Nov 2021 18:00:09 +0100
Message-Id: <20211115165446.198713991@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 232deb3f9567ce37d99b8616a6c07c1fc0436abf ]

At present, when either of ds->ops->port_fdb_del() or ds->ops->port_mdb_del()
return a non-zero error code, we attempt to save the day and keep the
data structure associated with that switchdev object, as the deletion
procedure did not complete.

However, the way in which we do this is suspicious to the checker in
lib/refcount.c, who thinks it is buggy to increment a refcount that
became zero, and that this is indicative of a use-after-free.

Fixes: 161ca59d39e9 ("net: dsa: reference count the MDB entries at the cross-chip notifier level")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 6466d0539af9f..44558fbdc65b3 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -264,7 +264,7 @@ static int dsa_switch_do_mdb_del(struct dsa_switch *ds, int port,
 
 	err = ds->ops->port_mdb_del(ds, port, mdb);
 	if (err) {
-		refcount_inc(&a->refcount);
+		refcount_set(&a->refcount, 1);
 		return err;
 	}
 
@@ -329,7 +329,7 @@ static int dsa_switch_do_fdb_del(struct dsa_switch *ds, int port,
 
 	err = ds->ops->port_fdb_del(ds, port, addr, vid);
 	if (err) {
-		refcount_inc(&a->refcount);
+		refcount_set(&a->refcount, 1);
 		return err;
 	}
 
-- 
2.33.0



