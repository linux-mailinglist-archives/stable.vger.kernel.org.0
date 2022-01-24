Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B406498963
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344012AbiAXSzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344191AbiAXSxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:53:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2406EC06176A;
        Mon, 24 Jan 2022 10:53:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC3D4B8121F;
        Mon, 24 Jan 2022 18:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC749C340E8;
        Mon, 24 Jan 2022 18:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050386;
        bh=FIqYHvH6IqcIa7qor3u4vpchq2nShExahI2dprWf424=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKrsa0gEhQEMYAuxOPM2+zhjDzPRpCoszb6SBUORiwAvEaawA+6UvQSVRAp1nfqGi
         pcYAghX617Ng3b5poJGpdbZtomydyrRVGSJxTolgxO3enm89ZWAuP7aePI99hxXzBN
         5DhlrHPoE5ebCTGi09J5a5dycZhzFmU/urlAXDE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 102/114] net/fsl: xgmac_mdio: Fix incorrect iounmap when removing module
Date:   Mon, 24 Jan 2022 19:43:17 +0100
Message-Id: <20220124183930.260689505@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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
@@ -304,9 +304,10 @@ err_ioremap:
 static int xgmac_mdio_remove(struct platform_device *pdev)
 {
 	struct mii_bus *bus = platform_get_drvdata(pdev);
+	struct mdio_fsl_priv *priv = bus->priv;
 
 	mdiobus_unregister(bus);
-	iounmap(bus->priv);
+	iounmap(priv->mdio_base);
 	mdiobus_free(bus);
 
 	return 0;


