Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F11499ABF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378707AbiAXVqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456634AbiAXVjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480A1C0417D1;
        Mon, 24 Jan 2022 12:25:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 109DBB8121C;
        Mon, 24 Jan 2022 20:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3772EC340E8;
        Mon, 24 Jan 2022 20:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055909;
        bh=1HJTEdJbsETCywUzoAM7MoH5oDIbZRr8IH9m9qAdEXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wTJtQ3hYqOAWfbkDg0PIKzYuFXjniqjFTSCAL+6XY3uWPKjNt8T7F4wHmOkyHDPHr
         JIze8UJ6rsX5KsbtU9kFG2t6zEt5L/5QqXKLUDEMR7LRe8KXpeAMFWXoAUihfZEhyZ
         aUZeHhYptoHx8k/HYrRrbRxzBe859vj7vTwyH0Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 307/846] net: dsa: fix incorrect function pointer check for MRP ring roles
Date:   Mon, 24 Jan 2022 19:37:04 +0100
Message-Id: <20220124184111.499495647@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit ff91e1b68490b97c18c649b769618815eb945f11 ]

The cross-chip notifier boilerplate code meant to check the presence of
ds->ops->port_mrp_add_ring_role before calling it, but checked
ds->ops->port_mrp_add instead, before calling
ds->ops->port_mrp_add_ring_role.

Therefore, a driver which implements one operation but not the other
would trigger a NULL pointer dereference.

There isn't any such driver in DSA yet, so there is no reason to
backport the change. Issue found through code inspection.

Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Fixes: c595c4330da0 ("net: dsa: add MRP support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 44558fbdc65b3..fb69f2f14234e 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -644,7 +644,7 @@ static int
 dsa_switch_mrp_add_ring_role(struct dsa_switch *ds,
 			     struct dsa_notifier_mrp_ring_role_info *info)
 {
-	if (!ds->ops->port_mrp_add)
+	if (!ds->ops->port_mrp_add_ring_role)
 		return -EOPNOTSUPP;
 
 	if (ds->index == info->sw_index)
@@ -658,7 +658,7 @@ static int
 dsa_switch_mrp_del_ring_role(struct dsa_switch *ds,
 			     struct dsa_notifier_mrp_ring_role_info *info)
 {
-	if (!ds->ops->port_mrp_del)
+	if (!ds->ops->port_mrp_del_ring_role)
 		return -EOPNOTSUPP;
 
 	if (ds->index == info->sw_index)
-- 
2.34.1



