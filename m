Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36953499AE5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574105AbiAXVri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:47:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58780 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456978AbiAXVki (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:40:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A68686146A;
        Mon, 24 Jan 2022 21:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707C8C340E4;
        Mon, 24 Jan 2022 21:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060437;
        bh=y08BoJsvT23llfRHmxQAYEFNIoccmXlZdRTEGoZXIFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ie96XdMQ08jK0+N3kPicPgaMJxrWeGGNi3ub5E5iI7IyNxTafQkv8n3wDNgPTfLer
         endsri4wfhmc/LgqMiqb5vFI+23fs4cA4V+Mv0In0dlpJKHn/JyW9PH6ePwFOC/1E0
         Fm9Uf+TJMk/kfzn1wdqyIxiDUbUVFNhPjXQ6APX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 0948/1039] net/fsl: xgmac_mdio: Fix incorrect iounmap when removing module
Date:   Mon, 24 Jan 2022 19:45:37 +0100
Message-Id: <20220124184157.157800630@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -331,9 +331,10 @@ err_ioremap:
 static int xgmac_mdio_remove(struct platform_device *pdev)
 {
 	struct mii_bus *bus = platform_get_drvdata(pdev);
+	struct mdio_fsl_priv *priv = bus->priv;
 
 	mdiobus_unregister(bus);
-	iounmap(bus->priv);
+	iounmap(priv->mdio_base);
 	mdiobus_free(bus);
 
 	return 0;


