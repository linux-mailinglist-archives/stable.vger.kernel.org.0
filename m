Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3394499586
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442064AbiAXUwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:52:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47042 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352771AbiAXUsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:48:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9915BB8121C;
        Mon, 24 Jan 2022 20:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A29C340E5;
        Mon, 24 Jan 2022 20:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057319;
        bh=ERIRbiS2BMbugiSm61yle9p3BfoYk6EPM0wTY4DVKkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hH+UoEJUzjlM56j84aA5C3LfKnpfgHgQARlkY40KWrR5ZlAPb9xylI4Fb/JKslcGt
         a+BjNLFnwG+ug0rUtd94wBfv1vsfQhQBsWPjRbc4tkwVHVvdbitR3y5pyLa2Vs5tkg
         ijEz3KMDO9y7MLGVillw6A8IJ2jpbyKohKJ/DvMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 773/846] net/fsl: xgmac_mdio: Fix incorrect iounmap when removing module
Date:   Mon, 24 Jan 2022 19:44:50 +0100
Message-Id: <20220124184127.630868391@linuxfoundation.org>
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

From: Tobias Waldekranz <tobias@waldekranz.com>

commit 3f7c239c7844d2044ed399399d97a5f1c6008e1b upstream.

As reported by sparse: In the remove path, the driver would attempt to
unmap its own priv pointer - instead of the io memory that it mapped
in probe.

Fixes: 9f35a7342cff ("net/fsl: introduce Freescale 10G MDIO driver")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -332,9 +332,10 @@ err_ioremap:
 static int xgmac_mdio_remove(struct platform_device *pdev)
 {
 	struct mii_bus *bus = platform_get_drvdata(pdev);
+	struct mdio_fsl_priv *priv = bus->priv;
 
 	mdiobus_unregister(bus);
-	iounmap(bus->priv);
+	iounmap(priv->mdio_base);
 	mdiobus_free(bus);
 
 	return 0;


