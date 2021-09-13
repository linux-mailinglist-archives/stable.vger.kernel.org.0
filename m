Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E495408EC5
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242507AbhIMNgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:36:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242972AbhIMNeh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:34:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70E3061221;
        Mon, 13 Sep 2021 13:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539610;
        bh=jnUz3WBMv0JybVg3eiXs/+qckOwE0fCjdeXvU0eza/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWPN972chQ0bxRE6lTVcldE6JEkyTNJ57HBjQvqsySQ/rXpYLBVBzOPT6q0f+XVUy
         MLL4wF8TNRBNtyBVJkm3obcmQuSKPqhrbX0jSM0TQYHO6clvD3xORGW3q1im7q70ka
         Adl0RqsDboL/3IZ0W5V/52W1uZXiMEsCn7FeFZUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/236] ionic: cleanly release devlink instance
Date:   Mon, 13 Sep 2021 15:13:15 +0200
Message-Id: <20210913131103.411286092@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit c2255ff47768c94a0ebc3968f007928bb47ea43b ]

The failure to register devlink will leave the system with dangled
devlink resource, which is not cleaned if devlink_port_register() fails.

In order to remove access to ".registered" field of struct devlink_port,
require both devlink_register and devlink_port_register to success and
check it through device pointer.

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Acked-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/pensando/ionic/ionic_devlink.c    | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 51d64718ed9f..3d94064c685d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -91,20 +91,20 @@ int ionic_devlink_register(struct ionic *ionic)
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	devlink_port_attrs_set(&ionic->dl_port, &attrs);
 	err = devlink_port_register(dl, &ionic->dl_port, 0);
-	if (err)
+	if (err) {
 		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
-	else
-		devlink_port_type_eth_set(&ionic->dl_port,
-					  ionic->lif->netdev);
+		devlink_unregister(dl);
+		return err;
+	}
 
-	return err;
+	devlink_port_type_eth_set(&ionic->dl_port, ionic->lif->netdev);
+	return 0;
 }
 
 void ionic_devlink_unregister(struct ionic *ionic)
 {
 	struct devlink *dl = priv_to_devlink(ionic);
 
-	if (ionic->dl_port.registered)
-		devlink_port_unregister(&ionic->dl_port);
+	devlink_port_unregister(&ionic->dl_port);
 	devlink_unregister(dl);
 }
-- 
2.30.2



