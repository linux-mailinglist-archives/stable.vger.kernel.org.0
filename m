Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A884510A1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242668AbhKOSvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:51:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242458AbhKOSs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:48:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C9546329B;
        Mon, 15 Nov 2021 18:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999708;
        bh=Y695iH+0jygos0itHvIOP2xaiEJKzjyF02IOCOG6U6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0J4t4Uu2Iu7fjwHw4BSfrrKy0gSvgA62P0sAYBq5THeRi1uKOJBshK6wSpXpTyay
         T2ghd8tI1fnhokUm0gCVoYHruOK3dGu+vhMADvuaVpljP7uu+PFW4WZ1GRV5QIsNvd
         zt7ZD3nKoYvAXfJVxiic1w72h2DJ4nq65bm2Tryk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 361/849] qed: Dont ignore devlink allocation failures
Date:   Mon, 15 Nov 2021 17:57:24 +0100
Message-Id: <20211115165432.451714988@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit e6a54d6f221301347aaf9d83bb1f23129325c1c5 ]

devlink is a software interface that doesn't depend on any hardware
capabilities. The failure in SW means memory issues, wrong parameters,
programmer error e.t.c.

Like any other such interface in the kernel, the returned status of
devlink APIs should be checked and propagated further and not ignored.

Fixes: 755f982bb1ff ("qed/qede: make devlink survive recovery")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_main.c | 12 +++++-------
 drivers/scsi/qedf/qedf_main.c                |  2 ++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 1c7f9ed6f1c19..826780e5aa49a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1184,19 +1184,17 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
 		edev->devlink = qed_ops->common->devlink_register(cdev);
 		if (IS_ERR(edev->devlink)) {
 			DP_NOTICE(edev, "Cannot register devlink\n");
+			rc = PTR_ERR(edev->devlink);
 			edev->devlink = NULL;
-			/* Go on, we can live without devlink */
+			goto err3;
 		}
 	} else {
 		struct net_device *ndev = pci_get_drvdata(pdev);
+		struct qed_devlink *qdl;
 
 		edev = netdev_priv(ndev);
-
-		if (edev->devlink) {
-			struct qed_devlink *qdl = devlink_priv(edev->devlink);
-
-			qdl->cdev = cdev;
-		}
+		qdl = devlink_priv(edev->devlink);
+		qdl->cdev = cdev;
 		edev->cdev = cdev;
 		memset(&edev->stats, 0, sizeof(edev->stats));
 		memcpy(&edev->dev_info, &dev_info, sizeof(dev_info));
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 42d0d941dba5c..94ee08fab46a5 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3416,7 +3416,9 @@ retry_probe:
 		qedf->devlink = qed_ops->common->devlink_register(qedf->cdev);
 		if (IS_ERR(qedf->devlink)) {
 			QEDF_ERR(&qedf->dbg_ctx, "Cannot register devlink\n");
+			rc = PTR_ERR(qedf->devlink);
 			qedf->devlink = NULL;
+			goto err2;
 		}
 	}
 
-- 
2.33.0



