Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B421578A8
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbgBJNJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:09:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729399AbgBJMjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:20 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C24E720733;
        Mon, 10 Feb 2020 12:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338359;
        bh=OR8aHjYil6DSiTAuNKe4AkTAl8Dsbgx1++0yiXkrjtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKuZwNW/+6mxNJg66PMgk8CB3d1vBGfhI944029nT8OSg1yBIJ+fSgctDoe6o0aXy
         DR7bh1EHhWlle8fLlcLBL/ekto/9yjfHYyh0SAfMoABSr3SxcpVye5xmkq8Xgn6XZ0
         OFebrnD/pcuZatx/nfjRrsUOXDsmtEv1BQ50Y3gI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 002/367] bnxt_en: Move devlink_register before registering netdev
Date:   Mon, 10 Feb 2020 04:28:35 -0800
Message-Id: <20200210122423.996838240@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit cda2cab0771183932d6ba73c5ac63bb63decdadf ]

Latest kernels get the phys_port_name via devlink, if
ndo_get_phys_port_name is not defined. To provide the phys_port_name
correctly, register devlink before registering netdev.

Also call devlink_port_type_eth_set() after registering netdev as
devlink port updates the netdev structure and notifies user.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |   12 ++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |    1 -
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11433,9 +11433,9 @@ static void bnxt_remove_one(struct pci_d
 		bnxt_sriov_disable(bp);
 
 	bnxt_dl_fw_reporters_destroy(bp, true);
-	bnxt_dl_unregister(bp);
 	pci_disable_pcie_error_reporting(pdev);
 	unregister_netdev(dev);
+	bnxt_dl_unregister(bp);
 	bnxt_shutdown_tc(bp);
 	bnxt_cancel_sp_work(bp);
 	bp->sp_event = 0;
@@ -11905,11 +11905,14 @@ static int bnxt_init_one(struct pci_dev
 		bnxt_init_tc(bp);
 	}
 
+	bnxt_dl_register(bp);
+
 	rc = register_netdev(dev);
 	if (rc)
-		goto init_err_cleanup_tc;
+		goto init_err_cleanup;
 
-	bnxt_dl_register(bp);
+	if (BNXT_PF(bp))
+		devlink_port_type_eth_set(&bp->dl_port, bp->dev);
 	bnxt_dl_fw_reporters_create(bp);
 
 	netdev_info(dev, "%s found at mem %lx, node addr %pM\n",
@@ -11919,7 +11922,8 @@ static int bnxt_init_one(struct pci_dev
 
 	return 0;
 
-init_err_cleanup_tc:
+init_err_cleanup:
+	bnxt_dl_unregister(bp);
 	bnxt_shutdown_tc(bp);
 	bnxt_clear_int_mode(bp);
 
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -526,7 +526,6 @@ int bnxt_dl_register(struct bnxt *bp)
 		netdev_err(bp->dev, "devlink_port_register failed");
 		goto err_dl_param_unreg;
 	}
-	devlink_port_type_eth_set(&bp->dl_port, bp->dev);
 
 	rc = devlink_port_params_register(&bp->dl_port, bnxt_dl_port_params,
 					  ARRAY_SIZE(bnxt_dl_port_params));


