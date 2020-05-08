Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B769F1CAF93
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbgEHMmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728951AbgEHMmc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:42:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8A6D21835;
        Fri,  8 May 2020 12:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941751;
        bh=92GMJ3vVz3kng28dkVP2FXCoZkRYgHbQffs0xOz9nSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvEngcWYIHYMEzos8SN9sOKXwRzDHk/jc5BxWClC2jpx/4soH50Be42lh48rSNdln
         KI42KhDUSBqUhph2wHQQXjgZCmvP6bMxHZXgITBTwYGYqLto+9hHz+H6qXIUAkNU30
         Ao/ZRQRgRVaYNso85lcW0hxpxpqnW5Y4OztYl5+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Rivshin <drivshin@allworx.com>,
        Nicolas Chauvet <kwizart@gmail.com>,
        Andrew Goodbody <andrew.goodbody@cambrionix.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 158/312] drivers: net: cpsw: dont ignore phy-mode if phy-handle is used
Date:   Fri,  8 May 2020 14:32:29 +0200
Message-Id: <20200508123135.567401154@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rivshin <drivshin@allworx.com>

commit ae092b5bded24d5dc7dae0e0aef4669c169ce874 upstream.

The phy-mode emac property was only being processed in the phy_id
or fixed-link cases. However if phy-handle was specified instead,
an error message would complain about the lack of phy_id or
fixed-link, and then jump past the of_get_phy_mode(). This would
result in the PHY mode defaulting to MII, regardless of what the
devicetree specified.

Fixes: 9e42f715264f ("drivers: net: cpsw: add phy-handle parsing")
Signed-off-by: David Rivshin <drivshin@allworx.com>
Tested-by: Nicolas Chauvet <kwizart@gmail.com>
Tested-by: Andrew Goodbody <andrew.goodbody@cambrionix.com>
Reviewed-by: Mugunthan V N <mugunthanvnm@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/ti/cpsw.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2060,7 +2060,11 @@ static int cpsw_probe_dt(struct cpsw_pla
 		slave_data->phy_node = of_parse_phandle(slave_node,
 							"phy-handle", 0);
 		parp = of_get_property(slave_node, "phy_id", &lenp);
-		if (of_phy_is_fixed_link(slave_node)) {
+		if (slave_data->phy_node) {
+			dev_dbg(&pdev->dev,
+				"slave[%d] using phy-handle=\"%s\"\n",
+				i, slave_data->phy_node->full_name);
+		} else if (of_phy_is_fixed_link(slave_node)) {
 			struct device_node *phy_node;
 			struct phy_device *phy_dev;
 
@@ -2097,7 +2101,9 @@ static int cpsw_probe_dt(struct cpsw_pla
 				 PHY_ID_FMT, mdio->name, phyid);
 			put_device(&mdio->dev);
 		} else {
-			dev_err(&pdev->dev, "No slave[%d] phy_id or fixed-link property\n", i);
+			dev_err(&pdev->dev,
+				"No slave[%d] phy_id, phy-handle, or fixed-link property\n",
+				i);
 			goto no_phy_slave;
 		}
 		slave_data->phy_if = of_get_phy_mode(slave_node);


