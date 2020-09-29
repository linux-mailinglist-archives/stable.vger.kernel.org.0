Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6963227C3D1
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgI2LIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:08:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728514AbgI2LIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:08:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11DD421D7D;
        Tue, 29 Sep 2020 11:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377723;
        bh=tnTeM6pgkSAwiDsc/PLCPBQFlTO4JwVZxv36avTpRv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rgle5759cOz7hQO+hET4mc9Mgxi/1ALcY7fZpPSnwgxQ3hDVqqRZ9zN86q9pzysPG
         G/+5NQfsBbX1aAT0UUxHUvbY2AC8RZyQNASmMkywbaNKkjxlY/LUJFk/R51A+RPs64
         aFHR/Y2V35LtYg7c8sUXNisfqrQKJjwF2l5TELpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 048/121] scsi: lpfc: Fix coverity errors in fmdi attribute handling
Date:   Tue, 29 Sep 2020 12:59:52 +0200
Message-Id: <20200929105932.569029030@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 4cb9e1ddaa145be9ed67b6a7de98ca705a43f998 ]

Coverity reported a memory corruption error for the fdmi attributes
routines:

  CID 15768 [Memory Corruption] Out-of-bounds access on FDMI

Sloppy coding of the fmdi structures. In both the lpfc_fdmi_attr_def and
lpfc_fdmi_reg_port_list structures, a field was placed at the start of
payload that may have variable content. The field was given an arbitrary
type (uint32_t). The code then uses the field name to derive an address,
which it used in things such as memset and memcpy. The memset sizes or
memcpy lengths were larger than the arbitrary type, thus coverity reported
an error.

Fix by replacing the arbitrary fields with the real field structures
describing the payload.

Link: https://lore.kernel.org/r/20200128002312.16346-8-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_ct.c | 137 ++++++++++++++++++------------------
 drivers/scsi/lpfc/lpfc_hw.h |  36 +++++-----
 2 files changed, 85 insertions(+), 88 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 52afbcff362f9..b7940fffca637 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1541,8 +1541,8 @@ lpfc_fdmi_hba_attr_wwnn(struct lpfc_vport *vport, struct lpfc_fdmi_attr_def *ad)
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fc_sparam.nodeName,
 	       sizeof(struct lpfc_name));
@@ -1558,8 +1558,8 @@ lpfc_fdmi_hba_attr_manufacturer(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	/* This string MUST be consistent with other FC platforms
 	 * supported by Broadcom.
@@ -1583,8 +1583,8 @@ lpfc_fdmi_hba_attr_sn(struct lpfc_vport *vport, struct lpfc_fdmi_attr_def *ad)
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, phba->SerialNumber,
 		sizeof(ae->un.AttrString));
@@ -1605,8 +1605,8 @@ lpfc_fdmi_hba_attr_model(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, phba->ModelName,
 		sizeof(ae->un.AttrString));
@@ -1626,8 +1626,8 @@ lpfc_fdmi_hba_attr_description(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, phba->ModelDesc,
 		sizeof(ae->un.AttrString));
@@ -1649,8 +1649,8 @@ lpfc_fdmi_hba_attr_hdw_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t i, j, incr, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	/* Convert JEDEC ID to ascii for hardware version */
 	incr = vp->rev.biuRev;
@@ -1679,8 +1679,8 @@ lpfc_fdmi_hba_attr_drvr_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, lpfc_release_version,
 		sizeof(ae->un.AttrString));
@@ -1701,8 +1701,8 @@ lpfc_fdmi_hba_attr_rom_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		lpfc_decode_firmware_rev(phba, ae->un.AttrString, 1);
@@ -1726,8 +1726,8 @@ lpfc_fdmi_hba_attr_fmw_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	lpfc_decode_firmware_rev(phba, ae->un.AttrString, 1);
 	len = strnlen(ae->un.AttrString,
@@ -1746,8 +1746,8 @@ lpfc_fdmi_hba_attr_os_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	snprintf(ae->un.AttrString, sizeof(ae->un.AttrString), "%s %s %s",
 		 init_utsname()->sysname,
@@ -1769,7 +1769,7 @@ lpfc_fdmi_hba_attr_ct_len(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	ae->un.AttrInt =  cpu_to_be32(LPFC_MAX_CT_SIZE);
 	size = FOURBYTES + sizeof(uint32_t);
@@ -1785,8 +1785,8 @@ lpfc_fdmi_hba_attr_symbolic_name(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	len = lpfc_vport_symbolic_node_name(vport,
 				ae->un.AttrString, 256);
@@ -1804,7 +1804,7 @@ lpfc_fdmi_hba_attr_vendor_info(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	/* Nothing is defined for this currently */
 	ae->un.AttrInt =  cpu_to_be32(0);
@@ -1821,7 +1821,7 @@ lpfc_fdmi_hba_attr_num_ports(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	/* Each driver instance corresponds to a single port */
 	ae->un.AttrInt =  cpu_to_be32(1);
@@ -1838,8 +1838,8 @@ lpfc_fdmi_hba_attr_fabric_wwnn(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fabric_nodename,
 	       sizeof(struct lpfc_name));
@@ -1857,8 +1857,8 @@ lpfc_fdmi_hba_attr_bios_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	lpfc_decode_firmware_rev(phba, ae->un.AttrString, 1);
 	len = strnlen(ae->un.AttrString,
@@ -1877,7 +1877,7 @@ lpfc_fdmi_hba_attr_bios_state(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	/* Driver doesn't have access to this information */
 	ae->un.AttrInt =  cpu_to_be32(0);
@@ -1894,8 +1894,8 @@ lpfc_fdmi_hba_attr_vendor_id(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, "EMULEX",
 		sizeof(ae->un.AttrString));
@@ -1916,8 +1916,8 @@ lpfc_fdmi_port_attr_fc4type(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 32);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	ae->un.AttrTypes[3] = 0x02; /* Type 1 - ELS */
 	ae->un.AttrTypes[2] = 0x01; /* Type 8 - FCP */
@@ -1936,7 +1936,7 @@ lpfc_fdmi_port_attr_support_speed(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	ae->un.AttrInt = 0;
 	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
@@ -1986,7 +1986,7 @@ lpfc_fdmi_port_attr_speed(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
 		switch (phba->fc_linkspeed) {
@@ -2050,7 +2050,7 @@ lpfc_fdmi_port_attr_max_frame(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	hsp = (struct serv_parm *)&vport->fc_sparam;
 	ae->un.AttrInt = (((uint32_t) hsp->cmn.bbRcvSizeMsb) << 8) |
@@ -2070,8 +2070,8 @@ lpfc_fdmi_port_attr_os_devname(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	snprintf(ae->un.AttrString, sizeof(ae->un.AttrString),
 		 "/sys/class/scsi_host/host%d", shost->host_no);
@@ -2091,8 +2091,8 @@ lpfc_fdmi_port_attr_host_name(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	snprintf(ae->un.AttrString, sizeof(ae->un.AttrString), "%s",
 		 init_utsname()->nodename);
@@ -2112,8 +2112,8 @@ lpfc_fdmi_port_attr_wwnn(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0,  sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fc_sparam.nodeName,
 	       sizeof(struct lpfc_name));
@@ -2130,8 +2130,8 @@ lpfc_fdmi_port_attr_wwpn(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0,  sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fc_sparam.portName,
 	       sizeof(struct lpfc_name));
@@ -2148,8 +2148,8 @@ lpfc_fdmi_port_attr_symbolic_name(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	len = lpfc_vport_symbolic_port_name(vport, ae->un.AttrString, 256);
 	len += (len & 3) ? (4 - (len & 3)) : 4;
@@ -2167,7 +2167,7 @@ lpfc_fdmi_port_attr_port_type(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	if (phba->fc_topology == LPFC_TOPOLOGY_LOOP)
 		ae->un.AttrInt =  cpu_to_be32(LPFC_FDMI_PORTTYPE_NLPORT);
 	else
@@ -2185,7 +2185,7 @@ lpfc_fdmi_port_attr_class(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	ae->un.AttrInt = cpu_to_be32(FC_COS_CLASS2 | FC_COS_CLASS3);
 	size = FOURBYTES + sizeof(uint32_t);
 	ad->AttrLen = cpu_to_be16(size);
@@ -2200,8 +2200,8 @@ lpfc_fdmi_port_attr_fabric_wwpn(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0,  sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fabric_portname,
 	       sizeof(struct lpfc_name));
@@ -2218,8 +2218,8 @@ lpfc_fdmi_port_attr_active_fc4type(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 32);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	ae->un.AttrTypes[3] = 0x02; /* Type 1 - ELS */
 	ae->un.AttrTypes[2] = 0x01; /* Type 8 - FCP */
@@ -2237,7 +2237,7 @@ lpfc_fdmi_port_attr_port_state(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	/* Link Up - operational */
 	ae->un.AttrInt =  cpu_to_be32(LPFC_FDMI_PORTSTATE_ONLINE);
 	size = FOURBYTES + sizeof(uint32_t);
@@ -2253,7 +2253,7 @@ lpfc_fdmi_port_attr_num_disc(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	vport->fdmi_num_disc = lpfc_find_map_node(vport);
 	ae->un.AttrInt = cpu_to_be32(vport->fdmi_num_disc);
 	size = FOURBYTES + sizeof(uint32_t);
@@ -2269,7 +2269,7 @@ lpfc_fdmi_port_attr_nportid(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	ae->un.AttrInt =  cpu_to_be32(vport->fc_myDID);
 	size = FOURBYTES + sizeof(uint32_t);
 	ad->AttrLen = cpu_to_be16(size);
@@ -2284,8 +2284,8 @@ lpfc_fdmi_smart_attr_service(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, "Smart SAN Initiator",
 		sizeof(ae->un.AttrString));
@@ -2305,8 +2305,8 @@ lpfc_fdmi_smart_attr_guid(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrString, &vport->fc_sparam.nodeName,
 	       sizeof(struct lpfc_name));
@@ -2326,8 +2326,8 @@ lpfc_fdmi_smart_attr_version(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, "Smart SAN Version 2.0",
 		sizeof(ae->un.AttrString));
@@ -2348,8 +2348,8 @@ lpfc_fdmi_smart_attr_model(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, phba->ModelName,
 		sizeof(ae->un.AttrString));
@@ -2368,7 +2368,7 @@ lpfc_fdmi_smart_attr_port_info(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	/* SRIOV (type 3) is not supported */
 	if (vport->vpi)
@@ -2388,7 +2388,7 @@ lpfc_fdmi_smart_attr_qos(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	ae->un.AttrInt =  cpu_to_be32(0);
 	size = FOURBYTES + sizeof(uint32_t);
 	ad->AttrLen = cpu_to_be16(size);
@@ -2403,7 +2403,7 @@ lpfc_fdmi_smart_attr_security(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	ae->un.AttrInt =  cpu_to_be32(1);
 	size = FOURBYTES + sizeof(uint32_t);
 	ad->AttrLen = cpu_to_be16(size);
@@ -2551,7 +2551,8 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			/* Registered Port List */
 			/* One entry (port) per adapter */
 			rh->rpl.EntryCnt = cpu_to_be32(1);
-			memcpy(&rh->rpl.pe, &phba->pport->fc_sparam.portName,
+			memcpy(&rh->rpl.pe.PortName,
+			       &phba->pport->fc_sparam.portName,
 			       sizeof(struct lpfc_name));
 
 			/* point to the HBA attribute block */
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 3b970d3706008..daab21f940fb8 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1289,25 +1289,8 @@ struct fc_rdp_res_frame {
 /* lpfc_sli_ct_request defines the CT_IU preamble for FDMI commands */
 #define  SLI_CT_FDMI_Subtypes     0x10	/* Management Service Subtype */
 
-/*
- * Registered Port List Format
- */
-struct lpfc_fdmi_reg_port_list {
-	uint32_t EntryCnt;
-	uint32_t pe;		/* Variable-length array */
-};
-
-
 /* Definitions for HBA / Port attribute entries */
 
-struct lpfc_fdmi_attr_def { /* Defined in TLV format */
-	/* Structure is in Big Endian format */
-	uint32_t AttrType:16;
-	uint32_t AttrLen:16;
-	uint32_t AttrValue;  /* Marks start of Value (ATTRIBUTE_ENTRY) */
-};
-
-
 /* Attribute Entry */
 struct lpfc_fdmi_attr_entry {
 	union {
@@ -1318,7 +1301,13 @@ struct lpfc_fdmi_attr_entry {
 	} un;
 };
 
-#define LPFC_FDMI_MAX_AE_SIZE	sizeof(struct lpfc_fdmi_attr_entry)
+struct lpfc_fdmi_attr_def { /* Defined in TLV format */
+	/* Structure is in Big Endian format */
+	uint32_t AttrType:16;
+	uint32_t AttrLen:16;
+	/* Marks start of Value (ATTRIBUTE_ENTRY) */
+	struct lpfc_fdmi_attr_entry AttrValue;
+} __packed;
 
 /*
  * HBA Attribute Block
@@ -1342,13 +1331,20 @@ struct lpfc_fdmi_hba_ident {
 	struct lpfc_name PortName;
 };
 
+/*
+ * Registered Port List Format
+ */
+struct lpfc_fdmi_reg_port_list {
+	uint32_t EntryCnt;
+	struct lpfc_fdmi_port_entry pe;
+} __packed;
+
 /*
  * Register HBA(RHBA)
  */
 struct lpfc_fdmi_reg_hba {
 	struct lpfc_fdmi_hba_ident hi;
-	struct lpfc_fdmi_reg_port_list rpl;	/* variable-length array */
-/* struct lpfc_fdmi_attr_block   ab; */
+	struct lpfc_fdmi_reg_port_list rpl;
 };
 
 /*
-- 
2.25.1



