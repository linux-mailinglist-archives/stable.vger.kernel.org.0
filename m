Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D80111F1F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbfLCWn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:43:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:59614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728894AbfLCWn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:43:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 902D12073C;
        Tue,  3 Dec 2019 22:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413038;
        bh=sBT6wTD9T73l3+h6vWTCUjmO0JeexyDP6JtkHdt/sVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2jSvcTnO9qO6SeYl6rEQ3uoOj7nG+fsKfUijM9OvBA8VACF1PVw/xLAXQYryqxEF
         gmY+A6y3eDJ5HWp6GPzDLnVhvBHpxaJy9O7UlMv2Gq73ReVd7ovryOkQKE4bzGfHg1
         noaddSWDMnMpjJqfhLqMU9OasaGPCXoHhGoo3axg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Lunn <andrew@lunn.ch>,
        David Bauer <mail@david-bauer.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 111/135] mdio_bus: dont use managed reset-controller
Date:   Tue,  3 Dec 2019 23:35:51 +0100
Message-Id: <20191203213041.862025711@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Bauer <mail@david-bauer.net>

[ Upstream commit 32085f25d7b68404055f3525c780142fc72e543f ]

Geert Uytterhoeven reported that using devm_reset_controller_get leads
to a WARNING when probing a reset-controlled PHY. This is because the
device devm_reset_controller_get gets supplied is not actually the
one being probed.

Acquire an unmanaged reset-control as well as free the reset_control on
unregister to fix this.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David Bauer <mail@david-bauer.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mdio_bus.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -66,8 +66,8 @@ static int mdiobus_register_reset(struct
 	struct reset_control *reset = NULL;
 
 	if (mdiodev->dev.of_node)
-		reset = devm_reset_control_get_exclusive(&mdiodev->dev,
-							 "phy");
+		reset = of_reset_control_get_exclusive(mdiodev->dev.of_node,
+						       "phy");
 	if (IS_ERR(reset)) {
 		if (PTR_ERR(reset) == -ENOENT || PTR_ERR(reset) == -ENOTSUPP)
 			reset = NULL;
@@ -111,6 +111,8 @@ int mdiobus_unregister_device(struct mdi
 	if (mdiodev->bus->mdio_map[mdiodev->addr] != mdiodev)
 		return -EINVAL;
 
+	reset_control_put(mdiodev->reset_ctrl);
+
 	mdiodev->bus->mdio_map[mdiodev->addr] = NULL;
 
 	return 0;


