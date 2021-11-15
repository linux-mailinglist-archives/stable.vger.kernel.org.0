Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3C64510A0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242967AbhKOSva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242624AbhKOSs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:48:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F52E6329D;
        Mon, 15 Nov 2021 18:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999705;
        bh=f/8THE4RcO4/2/29D7zCxbuC67bwsTjjV+F5IOSAYxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2CPSSRXpkOFeMQJ6TbuGKPT78CJIXLXjhqJek4MAWe0TiliopRX0Ue8h1QuIwRO4N
         Wyp81ZOmQlIaGu6xfphAUkfRe8RFWZcCOAO+BYvu7ajMWsCsTJT+S5q5orcVcIoNRi
         CT+tzJAWOrd4M0vReJy7IHWKAwLeW6d4i6pOHycc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 360/849] bnxt_en: Check devlink allocation and registration status
Date:   Mon, 15 Nov 2021 17:57:23 +0100
Message-Id: <20211115165432.413908522@linuxfoundation.org>
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

[ Upstream commit e624c70e1131e145bd0510b8a700b5e2d112e377 ]

devlink is a software interface that doesn't depend on any hardware
capabilities. The failure in SW means memory issues, wrong parameters,
programmer error e.t.c.

Like any other such interface in the kernel, the returned status of
devlink APIs should be checked and propagated further and not ignored.

Fixes: 4ab0c6a8ffd7 ("bnxt_en: add support to enable VF-representors")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  5 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 13 ++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h | 13 -------------
 3 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f20b57b8cd70e..6bbf99e9273d5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13359,7 +13359,9 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	bnxt_inv_fw_health_reg(bp);
-	bnxt_dl_register(bp);
+	rc = bnxt_dl_register(bp);
+	if (rc)
+		goto init_err_dl;
 
 	rc = register_netdev(dev);
 	if (rc)
@@ -13379,6 +13381,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 init_err_cleanup:
 	bnxt_dl_unregister(bp);
+init_err_dl:
 	bnxt_shutdown_tc(bp);
 	bnxt_clear_int_mode(bp);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index bb228619ec641..56ee46fae0ac6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -133,7 +133,7 @@ void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 {
 	struct bnxt_fw_health *health = bp->fw_health;
 
-	if (!bp->dl || !health)
+	if (!health)
 		return;
 
 	if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET) || health->fw_reset_reporter)
@@ -187,7 +187,7 @@ void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all)
 {
 	struct bnxt_fw_health *health = bp->fw_health;
 
-	if (!bp->dl || !health)
+	if (!health)
 		return;
 
 	if ((all || !(bp->fw_cap & BNXT_FW_CAP_HOT_RESET)) &&
@@ -744,6 +744,7 @@ static void bnxt_dl_params_unregister(struct bnxt *bp)
 int bnxt_dl_register(struct bnxt *bp)
 {
 	struct devlink_port_attrs attrs = {};
+	struct bnxt_dl *bp_dl;
 	struct devlink *dl;
 	int rc;
 
@@ -756,7 +757,9 @@ int bnxt_dl_register(struct bnxt *bp)
 		return -ENOMEM;
 	}
 
-	bnxt_link_bp_to_dl(bp, dl);
+	bp->dl = dl;
+	bp_dl = devlink_priv(dl);
+	bp_dl->bp = bp;
 
 	/* Add switchdev eswitch mode setting, if SRIOV supported */
 	if (pci_find_ext_capability(bp->pdev, PCI_EXT_CAP_ID_SRIOV) &&
@@ -794,7 +797,6 @@ err_dl_port_unreg:
 err_dl_unreg:
 	devlink_unregister(dl);
 err_dl_free:
-	bnxt_link_bp_to_dl(bp, NULL);
 	devlink_free(dl);
 	return rc;
 }
@@ -803,9 +805,6 @@ void bnxt_dl_unregister(struct bnxt *bp)
 {
 	struct devlink *dl = bp->dl;
 
-	if (!dl)
-		return;
-
 	if (BNXT_PF(bp)) {
 		bnxt_dl_params_unregister(bp);
 		devlink_port_unregister(&bp->dl_port);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index d22cab5d6856a..365f1e50f5959 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -20,19 +20,6 @@ static inline struct bnxt *bnxt_get_bp_from_dl(struct devlink *dl)
 	return ((struct bnxt_dl *)devlink_priv(dl))->bp;
 }
 
-/* To clear devlink pointer from bp, pass NULL dl */
-static inline void bnxt_link_bp_to_dl(struct bnxt *bp, struct devlink *dl)
-{
-	bp->dl = dl;
-
-	/* add a back pointer in dl to bp */
-	if (dl) {
-		struct bnxt_dl *bp_dl = devlink_priv(dl);
-
-		bp_dl->bp = bp;
-	}
-}
-
 #define NVM_OFF_MSIX_VEC_PER_PF_MAX	108
 #define NVM_OFF_MSIX_VEC_PER_PF_MIN	114
 #define NVM_OFF_IGNORE_ARI		164
-- 
2.33.0



