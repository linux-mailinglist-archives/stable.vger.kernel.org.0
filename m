Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFED3C4E4D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241889AbhGLHRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243745AbhGLHRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:17:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E951D6144A;
        Mon, 12 Jul 2021 07:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074054;
        bh=kaSrO8KpwTQKzLA0ep5KvQOP/dnweXGHzYOP5oDS/Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0OUAGS9V9lSaZRDZumrqej3KY4Mwcr5yMditOgAZM/d2MYYBusymc/JF6KGcIxJD
         h9M/QZ8LUZUTomYw8TfgPoCFp1oMY3qaad3mvEb+g8zeZWlt5B7i8/DsQJOuBcWMAo
         589+KMGFz6DXXxj8Zb3W3AvRkdvCcj09LMYOKrKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eldar Gasanov <eldargasanov2@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 450/700] net: dsa: mv88e6xxx: Fix adding vlan 0
Date:   Mon, 12 Jul 2021 08:08:53 +0200
Message-Id: <20210712061024.427118567@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eldar Gasanov <eldargasanov2@gmail.com>

[ Upstream commit b8b79c414eca4e9bcab645e02cb92c48db974ce9 ]

8021q module adds vlan 0 to all interfaces when it starts.
When 8021q module is loaded it isn't possible to create bond
with mv88e6xxx interfaces, bonding module dipslay error
"Couldn't add bond vlan ids", because it tries to add vlan 0
to slave interfaces.

There is unexpected behavior in the switch. When a PVID
is assigned to a port the switch changes VID to PVID
in ingress frames with VID 0 on the port. Expected
that the switch doesn't assign PVID to tagged frames
with VID 0. But there isn't a way to change this behavior
in the switch.

Fixes: 57e661aae6a8 ("net: dsa: mv88e6xxx: Link aggregation support")
Signed-off-by: Eldar Gasanov <eldargasanov2@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index e08bf9377140..25363fceb45e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1552,9 +1552,6 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_vtu_entry vlan;
 	int i, err;
 
-	if (!vid)
-		return -EOPNOTSUPP;
-
 	/* DSA and CPU ports have to be members of multiple vlans */
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		return 0;
@@ -1993,6 +1990,9 @@ static int mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	u8 member;
 	int err;
 
+	if (!vlan->vid)
+		return 0;
+
 	err = mv88e6xxx_port_vlan_prepare(ds, port, vlan);
 	if (err)
 		return err;
-- 
2.30.2



