Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20595462773
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbhK2XFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237121AbhK2XFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:05:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195ACC1A1973;
        Mon, 29 Nov 2021 10:37:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 65403CE13BF;
        Mon, 29 Nov 2021 18:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1268FC53FC7;
        Mon, 29 Nov 2021 18:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211062;
        bh=rve1pFVSD3oqbMbPqExgSFeCkbbeOkEcbv5ECu7QmRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5mZflpJPF5i0wl5RiKFTMyNMJ2Y4U9JfhiDqN61uPF2UzwnDZ5/HXbOBoj+RzgnO
         vDVlhXtmOe8iXeb73Indjxp9hOp6oBkp262lejHCNZvKGCRfL+bBEMq3fyfySa3MaD
         gKnr+W0pavlro2jDtEzEeECle8YC6HdkULcho7Wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/179] scsi: mpt3sas: Fix system going into read-only mode
Date:   Mon, 29 Nov 2021 19:18:03 +0100
Message-Id: <20211129181721.868919238@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 91202a01a2fb2b78da3d03811b6d3d973ae426aa ]

While determining the SAS address of a drive, the driver checks whether the
handle number is less than the HBA phy count or not. If the handle number
is less than the HBA phy count then driver assumes that this handle belongs
to HBA and hence it assigns the HBA SAS address.

During IOC firmware downgrade operation, if the number of HBA phys is
reduced and the OS drive's device handle drops below the phy count while
determining the drive's SAS address, the driver ends up using the HBA's SAS
address. This leads to a mismatch of drive's SAS address and hence the
driver unregisters the OS drive and the system goes into read-only mode.

Update the IOC's num_phys to the HBA phy count provided by actual loaded
firmware.

Link: https://lore.kernel.org/r/20211117105058.3505-1-sreekanth.reddy@broadcom.com
Fixes: a5e99fda0172 ("scsi: mpt3sas: Update hba_port objects after host reset")
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  4 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 57 +++++++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index f87c0911f66ad..1b3a44ce65aae 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -142,6 +142,8 @@
 
 #define MPT_MAX_CALLBACKS		32
 
+#define MPT_MAX_HBA_NUM_PHYS		32
+
 #define INTERNAL_CMDS_COUNT		10	/* reserved cmds */
 /* reserved for issuing internally framed scsi io cmds */
 #define INTERNAL_SCSIIO_CMDS_COUNT	3
@@ -798,6 +800,7 @@ struct _sas_phy {
  * @enclosure_handle: handle for this a member of an enclosure
  * @device_info: bitwise defining capabilities of this sas_host/expander
  * @responding: used in _scsih_expander_device_mark_responding
+ * @nr_phys_allocated: Allocated memory for this many count phys
  * @phy: a list of phys that make up this sas_host/expander
  * @sas_port_list: list of ports attached to this sas_host/expander
  * @port: hba port entry containing node's port number info
@@ -813,6 +816,7 @@ struct _sas_node {
 	u16	enclosure_handle;
 	u64	enclosure_logical_id;
 	u8	responding;
+	u8	nr_phys_allocated;
 	struct hba_port *port;
 	struct	_sas_phy *phy;
 	struct list_head sas_port_list;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 1272b5ebea7ae..c1f900c6ea003 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -6406,11 +6406,26 @@ _scsih_sas_port_refresh(struct MPT3SAS_ADAPTER *ioc)
 	int i, j, count = 0, lcount = 0;
 	int ret;
 	u64 sas_addr;
+	u8 num_phys;
 
 	drsprintk(ioc, ioc_info(ioc,
 	    "updating ports for sas_host(0x%016llx)\n",
 	    (unsigned long long)ioc->sas_hba.sas_address));
 
+	mpt3sas_config_get_number_hba_phys(ioc, &num_phys);
+	if (!num_phys) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		return;
+	}
+
+	if (num_phys > ioc->sas_hba.nr_phys_allocated) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+		   __FILE__, __LINE__, __func__);
+		return;
+	}
+	ioc->sas_hba.num_phys = num_phys;
+
 	port_table = kcalloc(ioc->sas_hba.num_phys,
 	    sizeof(struct hba_port), GFP_KERNEL);
 	if (!port_table)
@@ -6611,6 +6626,30 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 			ioc->sas_hba.phy[i].hba_vphy = 1;
 		}
 
+		/*
+		 * Add new HBA phys to STL if these new phys got added as part
+		 * of HBA Firmware upgrade/downgrade operation.
+		 */
+		if (!ioc->sas_hba.phy[i].phy) {
+			if ((mpt3sas_config_get_phy_pg0(ioc, &mpi_reply,
+							&phy_pg0, i))) {
+				ioc_err(ioc, "failure at %s:%d/%s()!\n",
+					__FILE__, __LINE__, __func__);
+				continue;
+			}
+			ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+				MPI2_IOCSTATUS_MASK;
+			if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+				ioc_err(ioc, "failure at %s:%d/%s()!\n",
+					__FILE__, __LINE__, __func__);
+				continue;
+			}
+			ioc->sas_hba.phy[i].phy_id = i;
+			mpt3sas_transport_add_host_phy(ioc,
+				&ioc->sas_hba.phy[i], phy_pg0,
+				ioc->sas_hba.parent_dev);
+			continue;
+		}
 		ioc->sas_hba.phy[i].handle = ioc->sas_hba.handle;
 		attached_handle = le16_to_cpu(sas_iounit_pg0->PhyData[i].
 		    AttachedDevHandle);
@@ -6622,6 +6661,19 @@ _scsih_sas_host_refresh(struct MPT3SAS_ADAPTER *ioc)
 		    attached_handle, i, link_rate,
 		    ioc->sas_hba.phy[i].port);
 	}
+	/*
+	 * Clear the phy details if this phy got disabled as part of
+	 * HBA Firmware upgrade/downgrade operation.
+	 */
+	for (i = ioc->sas_hba.num_phys;
+	     i < ioc->sas_hba.nr_phys_allocated; i++) {
+		if (ioc->sas_hba.phy[i].phy &&
+		    ioc->sas_hba.phy[i].phy->negotiated_linkrate >=
+		    SAS_LINK_RATE_1_5_GBPS)
+			mpt3sas_transport_update_links(ioc,
+				ioc->sas_hba.sas_address, 0, i,
+				MPI2_SAS_NEG_LINK_RATE_PHY_DISABLED, NULL);
+	}
  out:
 	kfree(sas_iounit_pg0);
 }
@@ -6654,7 +6706,10 @@ _scsih_sas_host_add(struct MPT3SAS_ADAPTER *ioc)
 			__FILE__, __LINE__, __func__);
 		return;
 	}
-	ioc->sas_hba.phy = kcalloc(num_phys,
+
+	ioc->sas_hba.nr_phys_allocated = max_t(u8,
+	    MPT_MAX_HBA_NUM_PHYS, num_phys);
+	ioc->sas_hba.phy = kcalloc(ioc->sas_hba.nr_phys_allocated,
 	    sizeof(struct _sas_phy), GFP_KERNEL);
 	if (!ioc->sas_hba.phy) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
-- 
2.33.0



