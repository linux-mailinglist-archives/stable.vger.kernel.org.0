Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15B93D5DD8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbhGZPEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235881AbhGZPEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:04:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 563EF60F38;
        Mon, 26 Jul 2021 15:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314270;
        bh=n6jiL23Q+L1hav3FAKRwnIHYylGOQvbVMf708t4Qc+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ve1eIEhVM8HcS7PyUrCsjG9nlxnn9a3OuLoKICyJR+846UkTlxv5g6f12wBKN87GA
         CIUIEfmgc+lYX9Wil/rYjGXaZ7DDivbkhVVm875TmbXwFw7rQizdhFF3O7HTKZLLNY
         gMx5ouoXf9Xh19M0PjdQwmqwUsWUbgodmoEn0ilA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 19/60] net: qcom/emac: fix UAF in emac_remove
Date:   Mon, 26 Jul 2021 17:38:33 +0200
Message-Id: <20210726153825.474663644@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit ad297cd2db8953e2202970e9504cab247b6c7cb4 upstream.

adpt is netdev private data and it cannot be
used after free_netdev() call. Using adpt after free_netdev()
can cause UAF bug. Fix it by moving free_netdev() at the end of the
function.

Fixes: 54e19bc74f33 ("net: qcom/emac: do not use devm on internal phy pdev")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qualcomm/emac/emac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -746,12 +746,13 @@ static int emac_remove(struct platform_d
 	if (!has_acpi_companion(&pdev->dev))
 		put_device(&adpt->phydev->mdio.dev);
 	mdiobus_unregister(adpt->mii_bus);
-	free_netdev(netdev);
 
 	if (adpt->phy.digital)
 		iounmap(adpt->phy.digital);
 	iounmap(adpt->phy.base);
 
+	free_netdev(netdev);
+
 	return 0;
 }
 


