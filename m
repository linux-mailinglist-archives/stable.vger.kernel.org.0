Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5801845111F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbhKOTBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:01:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243482AbhKOS7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:59:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0068061501;
        Mon, 15 Nov 2021 18:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000010;
        bh=XHVhq33OzfZ/PCXHt0bPKXB7E4f6kJvU7cteLaZ8tKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FmB10ie1XbfPbJMS+DUivfx7Qga2vRpNOSc0cGFOGeOYDV6xg3V/tGioRK1P/dr8y
         oXqs4iczuZ/YjRzK/aD8HNIB+mgo2HJHTUl/hI5DogacEhfAQV3DCGOG6E5jTxMrSC
         XX03vqY92p4oA76/Dwg4/a61ITn1FF8SeaVku0kU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 505/849] net: dsa: avoid refcount warnings when ->port_{fdb,mdb}_del returns error
Date:   Mon, 15 Nov 2021 17:59:48 +0100
Message-Id: <20211115165437.369808186@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 9ef9125713321..41f62c3ab9671 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -243,7 +243,7 @@ static int dsa_switch_do_mdb_del(struct dsa_switch *ds, int port,
 
 	err = ds->ops->port_mdb_del(ds, port, mdb);
 	if (err) {
-		refcount_inc(&a->refcount);
+		refcount_set(&a->refcount, 1);
 		return err;
 	}
 
@@ -308,7 +308,7 @@ static int dsa_switch_do_fdb_del(struct dsa_switch *ds, int port,
 
 	err = ds->ops->port_fdb_del(ds, port, addr, vid);
 	if (err) {
-		refcount_inc(&a->refcount);
+		refcount_set(&a->refcount, 1);
 		return err;
 	}
 
-- 
2.33.0



