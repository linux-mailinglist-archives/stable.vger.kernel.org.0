Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7E91CB008
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgEHMi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728392AbgEHMi3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C1DD215A4;
        Fri,  8 May 2020 12:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941508;
        bh=HtAlnOxTGMMbXf2P/Ebbon4rvFqbPeouOq6lAsxCsWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIyFCbVRSFkpv65rkSokPHcT+fOURbSlNcCwDG/G/gr302pLm0zyyG+I3NUrpUV+8
         anoQI1JVILUVpBEPLXOAxaTCg55Vv7tHP/lwokEP3ntMfG2G3uMX11Oudh0SPSJ1EO
         REe/NQOQpc3EbuEwPm0AtwoM3khdr94LInySVs6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jurgens <danielj@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 058/312] net/mlx4_core: Do not BUG_ON during reset when PCI is offline
Date:   Fri,  8 May 2020 14:30:49 +0200
Message-Id: <20200508123128.637654294@linuxfoundation.org>
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

From: Daniel Jurgens <danielj@mellanox.com>

commit 22e3817e6c8301dc0520b855c8a2d764580e719c upstream.

The PCI channel could go offline during reset due to EEH.  Don't bug on in
this case, the error is recoverable.

Fixes: f6bc11e42646 ('net/mlx4_core: Enhance the catas flow to support device reset')
Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/catas.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/catas.c
+++ b/drivers/net/ethernet/mellanox/mlx4/catas.c
@@ -182,10 +182,17 @@ void mlx4_enter_error_state(struct mlx4_
 		err = mlx4_reset_slave(dev);
 	else
 		err = mlx4_reset_master(dev);
-	BUG_ON(err != 0);
 
+	if (!err) {
+		mlx4_err(dev, "device was reset successfully\n");
+	} else {
+		/* EEH could have disabled the PCI channel during reset. That's
+		 * recoverable and the PCI error flow will handle it.
+		 */
+		if (!pci_channel_offline(dev->persist->pdev))
+			BUG_ON(1);
+	}
 	dev->persist->state |= MLX4_DEVICE_STATE_INTERNAL_ERROR;
-	mlx4_err(dev, "device was reset successfully\n");
 	mutex_unlock(&persist->device_state_mutex);
 
 	/* At that step HW was already reset, now notify clients */


