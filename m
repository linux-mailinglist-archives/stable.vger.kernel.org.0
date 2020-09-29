Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA1127C5AD
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgI2Lhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730225AbgI2Lhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3055A23AA3;
        Tue, 29 Sep 2020 11:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379341;
        bh=Xa7/DEZY6eKJkhsU1HYPKjFgFi2VUFJlKyNB2k76rTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bzvjim7J9eIi+AK7ai6zY50yvEOY3q2ivooNBiTFJfv9KXGmyfncHpf6T9IAUYXoS
         gLursiLh0CM/+RziM7oo4n8YZ7PnjD4w4DkRexamRqrzT8zdaGp0rz+h19Tj34/XS7
         oEtl4qXFGBwp8UJdQqSpx5geb9AJd735K1pAHR6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 118/388] scsi: lpfc: Fix coverity errors in fmdi attribute handling
Date:   Tue, 29 Sep 2020 12:57:29 +0200
Message-Id: <20200929110016.188293990@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
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
index 4a09f21cb235f..e672fa9e842c9 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2056,8 +2056,8 @@ lpfc_fdmi_hba_attr_wwnn(struct lpfc_vport *vport, struct lpfc_fdmi_attr_def *ad)
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fc_sparam.nodeName,
 	       sizeof(struct lpfc_name));
@@ -2073,8 +2073,8 @@ lpfc_fdmi_hba_attr_manufacturer(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	/* This string MUST be consistent with other FC platforms
 	 * supported by Broadcom.
@@ -2098,8 +2098,8 @@ lpfc_fdmi_hba_attr_sn(struct lpfc_vport *vport, struct lpfc_fdmi_attr_def *ad)
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, phba->SerialNumber,
 		sizeof(ae->un.AttrString));
@@ -2120,8 +2120,8 @@ lpfc_fdmi_hba_attr_model(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, phba->ModelName,
 		sizeof(ae->un.AttrString));
@@ -2141,8 +2141,8 @@ lpfc_fdmi_hba_attr_description(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, phba->ModelDesc,
 		sizeof(ae->un.AttrString));
@@ -2164,8 +2164,8 @@ lpfc_fdmi_hba_attr_hdw_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t i, j, incr, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	/* Convert JEDEC ID to ascii for hardware version */
 	incr = vp->rev.biuRev;
@@ -2194,8 +2194,8 @@ lpfc_fdmi_hba_attr_drvr_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, lpfc_release_version,
 		sizeof(ae->un.AttrString));
@@ -2216,8 +2216,8 @@ lpfc_fdmi_hba_attr_rom_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		lpfc_decode_firmware_rev(phba, ae->un.AttrString, 1);
@@ -2241,8 +2241,8 @@ lpfc_fdmi_hba_attr_fmw_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	lpfc_decode_firmware_rev(phba, ae->un.AttrString, 1);
 	len = strnlen(ae->un.AttrString,
@@ -2261,8 +2261,8 @@ lpfc_fdmi_hba_attr_os_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	snprintf(ae->un.AttrString, sizeof(ae->un.AttrString), "%s %s %s",
 		 init_utsname()->sysname,
@@ -2284,7 +2284,7 @@ lpfc_fdmi_hba_attr_ct_len(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	ae->un.AttrInt =  cpu_to_be32(LPFC_MAX_CT_SIZE);
 	size = FOURBYTES + sizeof(uint32_t);
@@ -2300,8 +2300,8 @@ lpfc_fdmi_hba_attr_symbolic_name(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	len = lpfc_vport_symbolic_node_name(vport,
 				ae->un.AttrString, 256);
@@ -2319,7 +2319,7 @@ lpfc_fdmi_hba_attr_vendor_info(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	/* Nothing is defined for this currently */
 	ae->un.AttrInt =  cpu_to_be32(0);
@@ -2336,7 +2336,7 @@ lpfc_fdmi_hba_attr_num_ports(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	/* Each driver instance corresponds to a single port */
 	ae->un.AttrInt =  cpu_to_be32(1);
@@ -2353,8 +2353,8 @@ lpfc_fdmi_hba_attr_fabric_wwnn(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fabric_nodename,
 	       sizeof(struct lpfc_name));
@@ -2372,8 +2372,8 @@ lpfc_fdmi_hba_attr_bios_ver(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strlcat(ae->un.AttrString, phba->BIOSVersion,
 		sizeof(ae->un.AttrString));
@@ -2393,7 +2393,7 @@ lpfc_fdmi_hba_attr_bios_state(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	/* Driver doesn't have access to this information */
 	ae->un.AttrInt =  cpu_to_be32(0);
@@ -2410,8 +2410,8 @@ lpfc_fdmi_hba_attr_vendor_id(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, "EMULEX",
 		sizeof(ae->un.AttrString));
@@ -2433,8 +2433,8 @@ lpfc_fdmi_port_attr_fc4type(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 32);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	ae->un.AttrTypes[3] = 0x02; /* Type 0x1 - ELS */
 	ae->un.AttrTypes[2] = 0x01; /* Type 0x8 - FCP */
@@ -2459,7 +2459,7 @@ lpfc_fdmi_port_attr_support_speed(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	ae->un.AttrInt = 0;
 	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
@@ -2513,7 +2513,7 @@ lpfc_fdmi_port_attr_speed(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
 		switch (phba->fc_linkspeed) {
@@ -2583,7 +2583,7 @@ lpfc_fdmi_port_attr_max_frame(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	hsp = (struct serv_parm *)&vport->fc_sparam;
 	ae->un.AttrInt = (((uint32_t) hsp->cmn.bbRcvSizeMsb & 0x0F) << 8) |
@@ -2603,8 +2603,8 @@ lpfc_fdmi_port_attr_os_devname(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	snprintf(ae->un.AttrString, sizeof(ae->un.AttrString),
 		 "/sys/class/scsi_host/host%d", shost->host_no);
@@ -2624,8 +2624,8 @@ lpfc_fdmi_port_attr_host_name(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	scnprintf(ae->un.AttrString, sizeof(ae->un.AttrString), "%s",
 		  vport->phba->os_host_name);
@@ -2645,8 +2645,8 @@ lpfc_fdmi_port_attr_wwnn(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0,  sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fc_sparam.nodeName,
 	       sizeof(struct lpfc_name));
@@ -2663,8 +2663,8 @@ lpfc_fdmi_port_attr_wwpn(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0,  sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fc_sparam.portName,
 	       sizeof(struct lpfc_name));
@@ -2681,8 +2681,8 @@ lpfc_fdmi_port_attr_symbolic_name(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	len = lpfc_vport_symbolic_port_name(vport, ae->un.AttrString, 256);
 	len += (len & 3) ? (4 - (len & 3)) : 4;
@@ -2700,7 +2700,7 @@ lpfc_fdmi_port_attr_port_type(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	if (phba->fc_topology == LPFC_TOPOLOGY_LOOP)
 		ae->un.AttrInt =  cpu_to_be32(LPFC_FDMI_PORTTYPE_NLPORT);
 	else
@@ -2718,7 +2718,7 @@ lpfc_fdmi_port_attr_class(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	ae->un.AttrInt = cpu_to_be32(FC_COS_CLASS2 | FC_COS_CLASS3);
 	size = FOURBYTES + sizeof(uint32_t);
 	ad->AttrLen = cpu_to_be16(size);
@@ -2733,8 +2733,8 @@ lpfc_fdmi_port_attr_fabric_wwpn(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0,  sizeof(struct lpfc_name));
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrWWN, &vport->fabric_portname,
 	       sizeof(struct lpfc_name));
@@ -2751,8 +2751,8 @@ lpfc_fdmi_port_attr_active_fc4type(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 32);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	ae->un.AttrTypes[3] = 0x02; /* Type 0x1 - ELS */
 	ae->un.AttrTypes[2] = 0x01; /* Type 0x8 - FCP */
@@ -2775,7 +2775,7 @@ lpfc_fdmi_port_attr_port_state(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	/* Link Up - operational */
 	ae->un.AttrInt =  cpu_to_be32(LPFC_FDMI_PORTSTATE_ONLINE);
 	size = FOURBYTES + sizeof(uint32_t);
@@ -2791,7 +2791,7 @@ lpfc_fdmi_port_attr_num_disc(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	vport->fdmi_num_disc = lpfc_find_map_node(vport);
 	ae->un.AttrInt = cpu_to_be32(vport->fdmi_num_disc);
 	size = FOURBYTES + sizeof(uint32_t);
@@ -2807,7 +2807,7 @@ lpfc_fdmi_port_attr_nportid(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	ae->un.AttrInt =  cpu_to_be32(vport->fc_myDID);
 	size = FOURBYTES + sizeof(uint32_t);
 	ad->AttrLen = cpu_to_be16(size);
@@ -2822,8 +2822,8 @@ lpfc_fdmi_smart_attr_service(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, "Smart SAN Initiator",
 		sizeof(ae->un.AttrString));
@@ -2843,8 +2843,8 @@ lpfc_fdmi_smart_attr_guid(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	memcpy(&ae->un.AttrString, &vport->fc_sparam.nodeName,
 	       sizeof(struct lpfc_name));
@@ -2864,8 +2864,8 @@ lpfc_fdmi_smart_attr_version(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, "Smart SAN Version 2.0",
 		sizeof(ae->un.AttrString));
@@ -2886,8 +2886,8 @@ lpfc_fdmi_smart_attr_model(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t len, size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
-	memset(ae, 0, 256);
+	ae = &ad->AttrValue;
+	memset(ae, 0, sizeof(*ae));
 
 	strncpy(ae->un.AttrString, phba->ModelName,
 		sizeof(ae->un.AttrString));
@@ -2906,7 +2906,7 @@ lpfc_fdmi_smart_attr_port_info(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 
 	/* SRIOV (type 3) is not supported */
 	if (vport->vpi)
@@ -2926,7 +2926,7 @@ lpfc_fdmi_smart_attr_qos(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	ae->un.AttrInt =  cpu_to_be32(0);
 	size = FOURBYTES + sizeof(uint32_t);
 	ad->AttrLen = cpu_to_be16(size);
@@ -2941,7 +2941,7 @@ lpfc_fdmi_smart_attr_security(struct lpfc_vport *vport,
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
 
-	ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+	ae = &ad->AttrValue;
 	ae->un.AttrInt =  cpu_to_be32(1);
 	size = FOURBYTES + sizeof(uint32_t);
 	ad->AttrLen = cpu_to_be16(size);
@@ -3089,7 +3089,8 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			/* Registered Port List */
 			/* One entry (port) per adapter */
 			rh->rpl.EntryCnt = cpu_to_be32(1);
-			memcpy(&rh->rpl.pe, &phba->pport->fc_sparam.portName,
+			memcpy(&rh->rpl.pe.PortName,
+			       &phba->pport->fc_sparam.portName,
 			       sizeof(struct lpfc_name));
 
 			/* point to the HBA attribute block */
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 436cdc8c5ef46..b5642c8725938 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1340,25 +1340,8 @@ struct fc_rdp_res_frame {
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
@@ -1369,7 +1352,13 @@ struct lpfc_fdmi_attr_entry {
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
@@ -1393,13 +1382,20 @@ struct lpfc_fdmi_hba_ident {
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



