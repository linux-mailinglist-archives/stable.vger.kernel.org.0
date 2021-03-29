Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939B934CADB
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbhC2Ik1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234553AbhC2Ijc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:39:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08B2C6146B;
        Mon, 29 Mar 2021 08:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007172;
        bh=rMdPAZO0VdX/sO2a6HJ7gbb6NlO6N3a3OAI+2gyIEEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbzKsFWEl6IGiFkGC1lx2uOwA/iftOU8mheNR9ZQsTmfjej5qgPgOWPAjZIAHAG0g
         Pu6VU1OvDaGxISMYy42xNc03CoWN2Vx5+vKnKcnzZEHwpKmewGrHrKOgcETWq4dEVV
         Rl7wiIMhR4x3+LDJTd4e8wkYJATVUWYlkcFDNpfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 247/254] net: dsa: b53: VLAN filtering is global to all users
Date:   Mon, 29 Mar 2021 09:59:23 +0200
Message-Id: <20210329075641.190072836@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit d45c36bafb94e72fdb6dee437279b61b6d97e706 upstream.

The bcm_sf2 driver uses the b53 driver as a library but does not make
usre of the b53_setup() function, this made it fail to inherit the
vlan_filtering_is_global attribute. Fix this by moving the assignment to
b53_switch_alloc() which is used by bcm_sf2.

Fixes: 7228b23e68f7 ("net: dsa: b53: Let DSA handle mismatched VLAN filtering settings")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/b53/b53_common.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1070,13 +1070,6 @@ static int b53_setup(struct dsa_switch *
 			b53_disable_port(ds, port);
 	}
 
-	/* Let DSA handle the case were multiple bridges span the same switch
-	 * device and different VLAN awareness settings are requested, which
-	 * would be breaking filtering semantics for any of the other bridge
-	 * devices. (not hardware supported)
-	 */
-	ds->vlan_filtering_is_global = true;
-
 	return b53_setup_devlink_resources(ds);
 }
 
@@ -2627,6 +2620,13 @@ struct b53_device *b53_switch_alloc(stru
 	ds->configure_vlan_while_not_filtering = true;
 	ds->untag_bridge_pvid = true;
 	dev->vlan_enabled = ds->configure_vlan_while_not_filtering;
+	/* Let DSA handle the case were multiple bridges span the same switch
+	 * device and different VLAN awareness settings are requested, which
+	 * would be breaking filtering semantics for any of the other bridge
+	 * devices. (not hardware supported)
+	 */
+	ds->vlan_filtering_is_global = true;
+
 	mutex_init(&dev->reg_mutex);
 	mutex_init(&dev->stats_mutex);
 


