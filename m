Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3033D5ED3
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbhGZPLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:11:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236032AbhGZPHh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:07:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC5C260F91;
        Mon, 26 Jul 2021 15:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314485;
        bh=45Udfe7fiAaoQ6vJ+LucgS5GOYADfhz+KNkpo81+UqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtHdJXlDi3wRepiq05VbB/WNgEuGSMnEo26NoEKyOlsvN8cMk6MMZ6tHcuCuveikn
         DhmIJ/gXO+T1G/as5Vr6q4dQvzZ6cvgwvWm2zrjjApcnYpoupzVoERl/2OBU5irpCt
         0BArkDK+iRcrb2JK3FgeHAJZxmp7UBD/ZIDLuKus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 28/82] net: qcom/emac: fix UAF in emac_remove
Date:   Mon, 26 Jul 2021 17:38:28 +0200
Message-Id: <20210726153829.077309371@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
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
@@ -765,12 +765,13 @@ static int emac_remove(struct platform_d
 
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
 


