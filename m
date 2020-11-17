Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AA22B6458
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732499AbgKQNqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:46:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732637AbgKQNig (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37952207BC;
        Tue, 17 Nov 2020 13:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620315;
        bh=tVCE+oZ4rEd5jeEd8PY9+vczqoTdd2dWunGCUKCmNB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iqvwdk4hYM0QWAbwa3Nglow4Pn+Uq7iARWjVwWVMJxEk5+aCdqe08VRFGjNfHLF/c
         eZq2VEqh6dF8de7Qbfh9iGImeTcaZYBJHNarIXE703hx8eEdwNzuPbB5LUHgB4nn82
         MfRKDM4TZH1DH/ltQB/IRbd3Pe+KJbUs1m3e1jYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 177/255] nvme: factor out a nvme_configure_metadata helper
Date:   Tue, 17 Nov 2020 14:05:17 +0100
Message-Id: <20201117122147.543419895@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d4609ea8b3d3fb3423f35805843a82774cb4ef2f ]

Factor out a helper from nvme_update_ns_info that configures the
per-namespaces metadata and PI settings.  Also make sure the helpers
clear the flags explicitly instead of all of ->features to allow for
potentially reusing ->features for future non-metadata flags.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 78 ++++++++++++++++++++++++----------------
 1 file changed, 47 insertions(+), 31 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 59040bab5d6fa..be0cec51f5e6d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1946,6 +1946,50 @@ static int nvme_setup_streams_ns(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	return 0;
 }
 
+static int nvme_configure_metadata(struct nvme_ns *ns, struct nvme_id_ns *id)
+{
+	struct nvme_ctrl *ctrl = ns->ctrl;
+
+	/*
+	 * The PI implementation requires the metadata size to be equal to the
+	 * t10 pi tuple size.
+	 */
+	ns->ms = le16_to_cpu(id->lbaf[id->flbas & NVME_NS_FLBAS_LBA_MASK].ms);
+	if (ns->ms == sizeof(struct t10_pi_tuple))
+		ns->pi_type = id->dps & NVME_NS_DPS_PI_MASK;
+	else
+		ns->pi_type = 0;
+
+	ns->features &= ~(NVME_NS_METADATA_SUPPORTED | NVME_NS_EXT_LBAS);
+	if (!ns->ms || !(ctrl->ops->flags & NVME_F_METADATA_SUPPORTED))
+		return 0;
+	if (ctrl->ops->flags & NVME_F_FABRICS) {
+		/*
+		 * The NVMe over Fabrics specification only supports metadata as
+		 * part of the extended data LBA.  We rely on HCA/HBA support to
+		 * remap the separate metadata buffer from the block layer.
+		 */
+		if (WARN_ON_ONCE(!(id->flbas & NVME_NS_FLBAS_META_EXT)))
+			return -EINVAL;
+		if (ctrl->max_integrity_segments)
+			ns->features |=
+				(NVME_NS_METADATA_SUPPORTED | NVME_NS_EXT_LBAS);
+	} else {
+		/*
+		 * For PCIe controllers, we can't easily remap the separate
+		 * metadata buffer from the block layer and thus require a
+		 * separate metadata buffer for block layer metadata/PI support.
+		 * We allow extended LBAs for the passthrough interface, though.
+		 */
+		if (id->flbas & NVME_NS_FLBAS_META_EXT)
+			ns->features |= NVME_NS_EXT_LBAS;
+		else
+			ns->features |= NVME_NS_METADATA_SUPPORTED;
+	}
+
+	return 0;
+}
+
 static void nvme_update_disk_info(struct gendisk *disk,
 		struct nvme_ns *ns, struct nvme_id_ns *id)
 {
@@ -2096,37 +2140,9 @@ static int __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 		return -ENODEV;
 	}
 
-	ns->features = 0;
-	ns->ms = le16_to_cpu(id->lbaf[lbaf].ms);
-	/* the PI implementation requires metadata equal t10 pi tuple size */
-	if (ns->ms == sizeof(struct t10_pi_tuple))
-		ns->pi_type = id->dps & NVME_NS_DPS_PI_MASK;
-	else
-		ns->pi_type = 0;
-
-	if (ns->ms) {
-		/*
-		 * For PCIe only the separate metadata pointer is supported,
-		 * as the block layer supplies metadata in a separate bio_vec
-		 * chain. For Fabrics, only metadata as part of extended data
-		 * LBA is supported on the wire per the Fabrics specification,
-		 * but the HBA/HCA will do the remapping from the separate
-		 * metadata buffers for us.
-		 */
-		if (id->flbas & NVME_NS_FLBAS_META_EXT) {
-			ns->features |= NVME_NS_EXT_LBAS;
-			if ((ctrl->ops->flags & NVME_F_FABRICS) &&
-			    (ctrl->ops->flags & NVME_F_METADATA_SUPPORTED) &&
-			    ctrl->max_integrity_segments)
-				ns->features |= NVME_NS_METADATA_SUPPORTED;
-		} else {
-			if (WARN_ON_ONCE(ctrl->ops->flags & NVME_F_FABRICS))
-				return -EINVAL;
-			if (ctrl->ops->flags & NVME_F_METADATA_SUPPORTED)
-				ns->features |= NVME_NS_METADATA_SUPPORTED;
-		}
-	}
-
+	ret = nvme_configure_metadata(ns, id);
+	if (ret)
+		return ret;
 	nvme_set_chunk_sectors(ns, id);
 	nvme_update_disk_info(disk, ns, id);
 #ifdef CONFIG_NVME_MULTIPATH
-- 
2.27.0



