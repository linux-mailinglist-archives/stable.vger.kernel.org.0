Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6783CA60D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhGOSp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237453AbhGOSp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:45:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06D99613D0;
        Thu, 15 Jul 2021 18:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374582;
        bh=mXq+D5n8t1MSq7Aod/WKwhOaGNS0BnG5M7UDmPbRTjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEfUb9CEIhV6OeDWAkaCR6Vhk0HgkPy+G22pYycYV1ZP8KNBRkp+hgYwa3uboHIVk
         2JVKmCNPSiFqMwHeVKiy+3Ny0YhB155MHnh0fza6K4OAFwGcfQkBmaXtTWW80Y7fqt
         kBeUep+CVUM8lY94FqM5YE+yvyVE5QHT4NJvKQHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/122] sfc: error code if SRIOV cannot be disabled
Date:   Thu, 15 Jul 2021 20:38:26 +0200
Message-Id: <20210715182504.905288442@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit 1ebe4feb8b442884f5a28d2437040096723dd1ea ]

If SRIOV cannot be disabled during device removal or module unloading,
return error code so it can be logged properly in the calling function.

Note that this can only happen if any VF is currently attached to a
guest using Xen, but not with vfio/KVM. Despite that in that case the
VFs won't work properly with PF removed and/or the module unloaded, I
have let it as is because I don't know what side effects may have
changing it, and also it seems to be the same that other drivers are
doing in this situation.

In the case of being called during SRIOV reconfiguration, the behavior
hasn't changed because the function is called with force=false.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10_sriov.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 695e3508b4d8..e7c6aa29d323 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -403,12 +403,17 @@ fail1:
 	return rc;
 }
 
+/* Disable SRIOV and remove VFs
+ * If some VFs are attached to a guest (using Xen, only) nothing is
+ * done if force=false, and vports are freed if force=true (for the non
+ * attachedc ones, only) but SRIOV is not disabled and VFs are not
+ * removed in either case.
+ */
 static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 {
 	struct pci_dev *dev = efx->pci_dev;
-	unsigned int vfs_assigned = 0;
-
-	vfs_assigned = pci_vfs_assigned(dev);
+	unsigned int vfs_assigned = pci_vfs_assigned(dev);
+	int rc = 0;
 
 	if (vfs_assigned && !force) {
 		netif_info(efx, drv, efx->net_dev, "VFs are assigned to guests; "
@@ -418,10 +423,12 @@ static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 
 	if (!vfs_assigned)
 		pci_disable_sriov(dev);
+	else
+		rc = -EBUSY;
 
 	efx_ef10_sriov_free_vf_vswitching(efx);
 	efx->vf_count = 0;
-	return 0;
+	return rc;
 }
 
 int efx_ef10_sriov_configure(struct efx_nic *efx, int num_vfs)
-- 
2.30.2



