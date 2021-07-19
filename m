Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3008F3CD880
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243194AbhGSOWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242714AbhGSOVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:21:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EC896120D;
        Mon, 19 Jul 2021 15:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706917;
        bh=VcW/ruN3c54Clx8FuvHi1OftTDyPfLkLXkAtK2a+IpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etgz16Wqrc0SyDotSLkU2SC/cG0Bvg6dl/m1W1I1f6v/D8q+r+KDvmdxnuHl+Ah6B
         YPmX7krHkgInbudt7VjoIhP1L6pMim7UZw70B/Msx8pj75WyvIXOD5HKw4RGp7LAzA
         4cRWbVtAOf8nAU6yj3lVTazTjhUMkrIQ46a58Yjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 116/188] sfc: error code if SRIOV cannot be disabled
Date:   Mon, 19 Jul 2021 16:51:40 +0200
Message-Id: <20210719144940.077105979@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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
index b3c27331b374..8fce0c819a4b 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -378,12 +378,17 @@ fail1:
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
@@ -393,10 +398,12 @@ static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 
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



