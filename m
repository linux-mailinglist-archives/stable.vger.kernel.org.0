Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4876919170
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfEIS4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728610AbfEISyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:54:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED88921874;
        Thu,  9 May 2019 18:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428078;
        bh=TrsCv4X+srLAoldA3mYhQ14ChS4WwApmMwIhZqlsT6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uD/1wLrXvTgI/PUM2UiHt6kXnD8vPNQXiLPVa8EwRedZN7OZ/yiJiK2TTMy9pRB5
         +N/59HON8GyoE4s0/gPYOcK3UICzDIyt63z7/AC5dJs0BArRl1B8aQ2tNwUnr2EDeT
         4OEhN/8i+FYwCRr+tn7NwZG7Khn+IpyIpnC5SVc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Silvio Cesare <silvio.cesare@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Will Deacon <will.deacon@arm.com>, Greg KH <greg@kroah.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.1 18/30] scsi: lpfc: change snprintf to scnprintf for possible overflow
Date:   Thu,  9 May 2019 20:42:50 +0200
Message-Id: <20190509181254.863376696@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181250.417203112@linuxfoundation.org>
References: <20190509181250.417203112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Silvio Cesare <silvio.cesare@gmail.com>

commit e7f7b6f38a44697428f5a2e7c606de028df2b0e3 upstream.

Change snprintf to scnprintf. There are generally two cases where using
snprintf causes problems.

1) Uses of size += snprintf(buf, SIZE - size, fmt, ...)
In this case, if snprintf would have written more characters than what the
buffer size (SIZE) is, then size will end up larger than SIZE. In later
uses of snprintf, SIZE - size will result in a negative number, leading
to problems. Note that size might already be too large by using
size = snprintf before the code reaches a case of size += snprintf.

2) If size is ultimately used as a length parameter for a copy back to user
space, then it will potentially allow for a buffer overflow and information
disclosure when size is greater than SIZE. When the size is used to index
the buffer directly, we can have memory corruption. This also means when
size = snprintf... is used, it may also cause problems since size may become
large.  Copying to userspace is mitigated by the HARDENED_USERCOPY kernel
configuration.

The solution to these issues is to use scnprintf which returns the number of
characters actually written to the buffer, so the size variable will never
exceed SIZE.

Signed-off-by: Silvio Cesare <silvio.cesare@gmail.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_attr.c    |  196 ++++++++--------
 drivers/scsi/lpfc/lpfc_ct.c      |   12 
 drivers/scsi/lpfc/lpfc_debugfs.c |  474 +++++++++++++++++++--------------------
 drivers/scsi/lpfc/lpfc_debugfs.h |    6 
 4 files changed, 349 insertions(+), 339 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -114,7 +114,7 @@ static ssize_t
 lpfc_drvr_version_show(struct device *dev, struct device_attribute *attr,
 		       char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, LPFC_MODULE_DESC "\n");
+	return scnprintf(buf, PAGE_SIZE, LPFC_MODULE_DESC "\n");
 }
 
 /**
@@ -134,9 +134,9 @@ lpfc_enable_fip_show(struct device *dev,
 	struct lpfc_hba   *phba = vport->phba;
 
 	if (phba->hba_flag & HBA_FIP_SUPPORT)
-		return snprintf(buf, PAGE_SIZE, "1\n");
+		return scnprintf(buf, PAGE_SIZE, "1\n");
 	else
-		return snprintf(buf, PAGE_SIZE, "0\n");
+		return scnprintf(buf, PAGE_SIZE, "0\n");
 }
 
 static ssize_t
@@ -564,14 +564,15 @@ lpfc_bg_info_show(struct device *dev, st
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	if (phba->cfg_enable_bg)
+	if (phba->cfg_enable_bg) {
 		if (phba->sli3_options & LPFC_SLI3_BG_ENABLED)
-			return snprintf(buf, PAGE_SIZE, "BlockGuard Enabled\n");
+			return scnprintf(buf, PAGE_SIZE,
+					"BlockGuard Enabled\n");
 		else
-			return snprintf(buf, PAGE_SIZE,
+			return scnprintf(buf, PAGE_SIZE,
 					"BlockGuard Not Supported\n");
-	else
-			return snprintf(buf, PAGE_SIZE,
+	} else
+		return scnprintf(buf, PAGE_SIZE,
 					"BlockGuard Disabled\n");
 }
 
@@ -583,7 +584,7 @@ lpfc_bg_guard_err_show(struct device *de
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
+	return scnprintf(buf, PAGE_SIZE, "%llu\n",
 			(unsigned long long)phba->bg_guard_err_cnt);
 }
 
@@ -595,7 +596,7 @@ lpfc_bg_apptag_err_show(struct device *d
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
+	return scnprintf(buf, PAGE_SIZE, "%llu\n",
 			(unsigned long long)phba->bg_apptag_err_cnt);
 }
 
@@ -607,7 +608,7 @@ lpfc_bg_reftag_err_show(struct device *d
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
+	return scnprintf(buf, PAGE_SIZE, "%llu\n",
 			(unsigned long long)phba->bg_reftag_err_cnt);
 }
 
@@ -625,7 +626,7 @@ lpfc_info_show(struct device *dev, struc
 {
 	struct Scsi_Host *host = class_to_shost(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",lpfc_info(host));
+	return scnprintf(buf, PAGE_SIZE, "%s\n", lpfc_info(host));
 }
 
 /**
@@ -644,7 +645,7 @@ lpfc_serialnum_show(struct device *dev,
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",phba->SerialNumber);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", phba->SerialNumber);
 }
 
 /**
@@ -666,7 +667,7 @@ lpfc_temp_sensor_show(struct device *dev
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-	return snprintf(buf, PAGE_SIZE, "%d\n",phba->temp_sensor_support);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", phba->temp_sensor_support);
 }
 
 /**
@@ -685,7 +686,7 @@ lpfc_modeldesc_show(struct device *dev,
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",phba->ModelDesc);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", phba->ModelDesc);
 }
 
 /**
@@ -704,7 +705,7 @@ lpfc_modelname_show(struct device *dev,
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",phba->ModelName);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", phba->ModelName);
 }
 
 /**
@@ -723,7 +724,7 @@ lpfc_programtype_show(struct device *dev
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",phba->ProgramType);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", phba->ProgramType);
 }
 
 /**
@@ -741,7 +742,7 @@ lpfc_mlomgmt_show(struct device *dev, st
 	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
+	return scnprintf(buf, PAGE_SIZE, "%d\n",
 		(phba->sli.sli_flag & LPFC_MENLO_MAINT));
 }
 
@@ -761,7 +762,7 @@ lpfc_vportnum_show(struct device *dev, s
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%s\n",phba->Port);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", phba->Port);
 }
 
 /**
@@ -789,10 +790,10 @@ lpfc_fwrev_show(struct device *dev, stru
 	sli_family = phba->sli4_hba.pc_sli4_params.sli_family;
 
 	if (phba->sli_rev < LPFC_SLI_REV4)
-		len = snprintf(buf, PAGE_SIZE, "%s, sli-%d\n",
+		len = scnprintf(buf, PAGE_SIZE, "%s, sli-%d\n",
 			       fwrev, phba->sli_rev);
 	else
-		len = snprintf(buf, PAGE_SIZE, "%s, sli-%d:%d:%x\n",
+		len = scnprintf(buf, PAGE_SIZE, "%s, sli-%d:%d:%x\n",
 			       fwrev, phba->sli_rev, if_type, sli_family);
 
 	return len;
@@ -816,7 +817,7 @@ lpfc_hdw_show(struct device *dev, struct
 	lpfc_vpd_t *vp = &phba->vpd;
 
 	lpfc_jedec_to_ascii(vp->rev.biuRev, hdw);
-	return snprintf(buf, PAGE_SIZE, "%s\n", hdw);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", hdw);
 }
 
 /**
@@ -837,10 +838,11 @@ lpfc_option_rom_version_show(struct devi
 	char fwrev[FW_REV_STR_SIZE];
 
 	if (phba->sli_rev < LPFC_SLI_REV4)
-		return snprintf(buf, PAGE_SIZE, "%s\n", phba->OptionROMVersion);
+		return scnprintf(buf, PAGE_SIZE, "%s\n",
+				phba->OptionROMVersion);
 
 	lpfc_decode_firmware_rev(phba, fwrev, 1);
-	return snprintf(buf, PAGE_SIZE, "%s\n", fwrev);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", fwrev);
 }
 
 /**
@@ -871,20 +873,20 @@ lpfc_link_state_show(struct device *dev,
 	case LPFC_LINK_DOWN:
 	case LPFC_HBA_ERROR:
 		if (phba->hba_flag & LINK_DISABLED)
-			len += snprintf(buf + len, PAGE_SIZE-len,
+			len += scnprintf(buf + len, PAGE_SIZE-len,
 				"Link Down - User disabled\n");
 		else
-			len += snprintf(buf + len, PAGE_SIZE-len,
+			len += scnprintf(buf + len, PAGE_SIZE-len,
 				"Link Down\n");
 		break;
 	case LPFC_LINK_UP:
 	case LPFC_CLEAR_LA:
 	case LPFC_HBA_READY:
-		len += snprintf(buf + len, PAGE_SIZE-len, "Link Up - ");
+		len += scnprintf(buf + len, PAGE_SIZE-len, "Link Up - ");
 
 		switch (vport->port_state) {
 		case LPFC_LOCAL_CFG_LINK:
-			len += snprintf(buf + len, PAGE_SIZE-len,
+			len += scnprintf(buf + len, PAGE_SIZE-len,
 					"Configuring Link\n");
 			break;
 		case LPFC_FDISC:
@@ -894,38 +896,40 @@ lpfc_link_state_show(struct device *dev,
 		case LPFC_NS_QRY:
 		case LPFC_BUILD_DISC_LIST:
 		case LPFC_DISC_AUTH:
-			len += snprintf(buf + len, PAGE_SIZE - len,
+			len += scnprintf(buf + len, PAGE_SIZE - len,
 					"Discovery\n");
 			break;
 		case LPFC_VPORT_READY:
-			len += snprintf(buf + len, PAGE_SIZE - len, "Ready\n");
+			len += scnprintf(buf + len, PAGE_SIZE - len,
+					"Ready\n");
 			break;
 
 		case LPFC_VPORT_FAILED:
-			len += snprintf(buf + len, PAGE_SIZE - len, "Failed\n");
+			len += scnprintf(buf + len, PAGE_SIZE - len,
+					"Failed\n");
 			break;
 
 		case LPFC_VPORT_UNKNOWN:
-			len += snprintf(buf + len, PAGE_SIZE - len,
+			len += scnprintf(buf + len, PAGE_SIZE - len,
 					"Unknown\n");
 			break;
 		}
 		if (phba->sli.sli_flag & LPFC_MENLO_MAINT)
-			len += snprintf(buf + len, PAGE_SIZE-len,
+			len += scnprintf(buf + len, PAGE_SIZE-len,
 					"   Menlo Maint Mode\n");
 		else if (phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 			if (vport->fc_flag & FC_PUBLIC_LOOP)
-				len += snprintf(buf + len, PAGE_SIZE-len,
+				len += scnprintf(buf + len, PAGE_SIZE-len,
 						"   Public Loop\n");
 			else
-				len += snprintf(buf + len, PAGE_SIZE-len,
+				len += scnprintf(buf + len, PAGE_SIZE-len,
 						"   Private Loop\n");
 		} else {
 			if (vport->fc_flag & FC_FABRIC)
-				len += snprintf(buf + len, PAGE_SIZE-len,
+				len += scnprintf(buf + len, PAGE_SIZE-len,
 						"   Fabric\n");
 			else
-				len += snprintf(buf + len, PAGE_SIZE-len,
+				len += scnprintf(buf + len, PAGE_SIZE-len,
 						"   Point-2-Point\n");
 		}
 	}
@@ -937,28 +941,28 @@ lpfc_link_state_show(struct device *dev,
 		struct lpfc_trunk_link link = phba->trunk_link;
 
 		if (bf_get(lpfc_conf_trunk_port0, &phba->sli4_hba))
-			len += snprintf(buf + len, PAGE_SIZE - len,
+			len += scnprintf(buf + len, PAGE_SIZE - len,
 				"Trunk port 0: Link %s %s\n",
 				(link.link0.state == LPFC_LINK_UP) ?
 				 "Up" : "Down. ",
 				trunk_errmsg[link.link0.fault]);
 
 		if (bf_get(lpfc_conf_trunk_port1, &phba->sli4_hba))
-			len += snprintf(buf + len, PAGE_SIZE - len,
+			len += scnprintf(buf + len, PAGE_SIZE - len,
 				"Trunk port 1: Link %s %s\n",
 				(link.link1.state == LPFC_LINK_UP) ?
 				 "Up" : "Down. ",
 				trunk_errmsg[link.link1.fault]);
 
 		if (bf_get(lpfc_conf_trunk_port2, &phba->sli4_hba))
-			len += snprintf(buf + len, PAGE_SIZE - len,
+			len += scnprintf(buf + len, PAGE_SIZE - len,
 				"Trunk port 2: Link %s %s\n",
 				(link.link2.state == LPFC_LINK_UP) ?
 				 "Up" : "Down. ",
 				trunk_errmsg[link.link2.fault]);
 
 		if (bf_get(lpfc_conf_trunk_port3, &phba->sli4_hba))
-			len += snprintf(buf + len, PAGE_SIZE - len,
+			len += scnprintf(buf + len, PAGE_SIZE - len,
 				"Trunk port 3: Link %s %s\n",
 				(link.link3.state == LPFC_LINK_UP) ?
 				 "Up" : "Down. ",
@@ -986,15 +990,15 @@ lpfc_sli4_protocol_show(struct device *d
 	struct lpfc_hba *phba = vport->phba;
 
 	if (phba->sli_rev < LPFC_SLI_REV4)
-		return snprintf(buf, PAGE_SIZE, "fc\n");
+		return scnprintf(buf, PAGE_SIZE, "fc\n");
 
 	if (phba->sli4_hba.lnk_info.lnk_dv == LPFC_LNK_DAT_VAL) {
 		if (phba->sli4_hba.lnk_info.lnk_tp == LPFC_LNK_TYPE_GE)
-			return snprintf(buf, PAGE_SIZE, "fcoe\n");
+			return scnprintf(buf, PAGE_SIZE, "fcoe\n");
 		if (phba->sli4_hba.lnk_info.lnk_tp == LPFC_LNK_TYPE_FC)
-			return snprintf(buf, PAGE_SIZE, "fc\n");
+			return scnprintf(buf, PAGE_SIZE, "fc\n");
 	}
-	return snprintf(buf, PAGE_SIZE, "unknown\n");
+	return scnprintf(buf, PAGE_SIZE, "unknown\n");
 }
 
 /**
@@ -1014,7 +1018,7 @@ lpfc_oas_supported_show(struct device *d
 	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
+	return scnprintf(buf, PAGE_SIZE, "%d\n",
 			phba->sli4_hba.pc_sli4_params.oas_supported);
 }
 
@@ -1072,7 +1076,7 @@ lpfc_num_discovered_ports_show(struct de
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
+	return scnprintf(buf, PAGE_SIZE, "%d\n",
 			vport->fc_map_cnt + vport->fc_unmap_cnt);
 }
 
@@ -1586,7 +1590,7 @@ lpfc_nport_evt_cnt_show(struct device *d
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", phba->nport_event_cnt);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", phba->nport_event_cnt);
 }
 
 int
@@ -1675,7 +1679,7 @@ lpfc_board_mode_show(struct device *dev,
 	else
 		state = "online";
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", state);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", state);
 }
 
 /**
@@ -1901,8 +1905,8 @@ lpfc_max_rpi_show(struct device *dev, st
 	uint32_t cnt;
 
 	if (lpfc_get_hba_info(phba, NULL, NULL, &cnt, NULL, NULL, NULL))
-		return snprintf(buf, PAGE_SIZE, "%d\n", cnt);
-	return snprintf(buf, PAGE_SIZE, "Unknown\n");
+		return scnprintf(buf, PAGE_SIZE, "%d\n", cnt);
+	return scnprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
 /**
@@ -1929,8 +1933,8 @@ lpfc_used_rpi_show(struct device *dev, s
 	uint32_t cnt, acnt;
 
 	if (lpfc_get_hba_info(phba, NULL, NULL, &cnt, &acnt, NULL, NULL))
-		return snprintf(buf, PAGE_SIZE, "%d\n", (cnt - acnt));
-	return snprintf(buf, PAGE_SIZE, "Unknown\n");
+		return scnprintf(buf, PAGE_SIZE, "%d\n", (cnt - acnt));
+	return scnprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
 /**
@@ -1957,8 +1961,8 @@ lpfc_max_xri_show(struct device *dev, st
 	uint32_t cnt;
 
 	if (lpfc_get_hba_info(phba, &cnt, NULL, NULL, NULL, NULL, NULL))
-		return snprintf(buf, PAGE_SIZE, "%d\n", cnt);
-	return snprintf(buf, PAGE_SIZE, "Unknown\n");
+		return scnprintf(buf, PAGE_SIZE, "%d\n", cnt);
+	return scnprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
 /**
@@ -1985,8 +1989,8 @@ lpfc_used_xri_show(struct device *dev, s
 	uint32_t cnt, acnt;
 
 	if (lpfc_get_hba_info(phba, &cnt, &acnt, NULL, NULL, NULL, NULL))
-		return snprintf(buf, PAGE_SIZE, "%d\n", (cnt - acnt));
-	return snprintf(buf, PAGE_SIZE, "Unknown\n");
+		return scnprintf(buf, PAGE_SIZE, "%d\n", (cnt - acnt));
+	return scnprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
 /**
@@ -2013,8 +2017,8 @@ lpfc_max_vpi_show(struct device *dev, st
 	uint32_t cnt;
 
 	if (lpfc_get_hba_info(phba, NULL, NULL, NULL, NULL, &cnt, NULL))
-		return snprintf(buf, PAGE_SIZE, "%d\n", cnt);
-	return snprintf(buf, PAGE_SIZE, "Unknown\n");
+		return scnprintf(buf, PAGE_SIZE, "%d\n", cnt);
+	return scnprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
 /**
@@ -2041,8 +2045,8 @@ lpfc_used_vpi_show(struct device *dev, s
 	uint32_t cnt, acnt;
 
 	if (lpfc_get_hba_info(phba, NULL, NULL, NULL, NULL, &cnt, &acnt))
-		return snprintf(buf, PAGE_SIZE, "%d\n", (cnt - acnt));
-	return snprintf(buf, PAGE_SIZE, "Unknown\n");
+		return scnprintf(buf, PAGE_SIZE, "%d\n", (cnt - acnt));
+	return scnprintf(buf, PAGE_SIZE, "Unknown\n");
 }
 
 /**
@@ -2067,10 +2071,10 @@ lpfc_npiv_info_show(struct device *dev,
 	struct lpfc_hba   *phba = vport->phba;
 
 	if (!(phba->max_vpi))
-		return snprintf(buf, PAGE_SIZE, "NPIV Not Supported\n");
+		return scnprintf(buf, PAGE_SIZE, "NPIV Not Supported\n");
 	if (vport->port_type == LPFC_PHYSICAL_PORT)
-		return snprintf(buf, PAGE_SIZE, "NPIV Physical\n");
-	return snprintf(buf, PAGE_SIZE, "NPIV Virtual (VPI %d)\n", vport->vpi);
+		return scnprintf(buf, PAGE_SIZE, "NPIV Physical\n");
+	return scnprintf(buf, PAGE_SIZE, "NPIV Virtual (VPI %d)\n", vport->vpi);
 }
 
 /**
@@ -2092,7 +2096,7 @@ lpfc_poll_show(struct device *dev, struc
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%#x\n", phba->cfg_poll);
+	return scnprintf(buf, PAGE_SIZE, "%#x\n", phba->cfg_poll);
 }
 
 /**
@@ -2196,7 +2200,7 @@ lpfc_fips_level_show(struct device *dev,
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", phba->fips_level);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", phba->fips_level);
 }
 
 /**
@@ -2215,7 +2219,7 @@ lpfc_fips_rev_show(struct device *dev,
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", phba->fips_spec_rev);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", phba->fips_spec_rev);
 }
 
 /**
@@ -2234,7 +2238,7 @@ lpfc_dss_show(struct device *dev, struct
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%s - %sOperational\n",
+	return scnprintf(buf, PAGE_SIZE, "%s - %sOperational\n",
 			(phba->cfg_enable_dss) ? "Enabled" : "Disabled",
 			(phba->sli3_options & LPFC_SLI3_DSS_ENABLED) ?
 				"" : "Not ");
@@ -2263,7 +2267,7 @@ lpfc_sriov_hw_max_virtfn_show(struct dev
 	uint16_t max_nr_virtfn;
 
 	max_nr_virtfn = lpfc_sli_sriov_nr_virtfn_get(phba);
-	return snprintf(buf, PAGE_SIZE, "%d\n", max_nr_virtfn);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", max_nr_virtfn);
 }
 
 static inline bool lpfc_rangecheck(uint val, uint min, uint max)
@@ -2323,7 +2327,7 @@ lpfc_##attr##_show(struct device *dev, s
 	struct Scsi_Host  *shost = class_to_shost(dev);\
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
 	struct lpfc_hba   *phba = vport->phba;\
-	return snprintf(buf, PAGE_SIZE, "%d\n",\
+	return scnprintf(buf, PAGE_SIZE, "%d\n",\
 			phba->cfg_##attr);\
 }
 
@@ -2351,7 +2355,7 @@ lpfc_##attr##_show(struct device *dev, s
 	struct lpfc_hba   *phba = vport->phba;\
 	uint val = 0;\
 	val = phba->cfg_##attr;\
-	return snprintf(buf, PAGE_SIZE, "%#x\n",\
+	return scnprintf(buf, PAGE_SIZE, "%#x\n",\
 			phba->cfg_##attr);\
 }
 
@@ -2487,7 +2491,7 @@ lpfc_##attr##_show(struct device *dev, s
 { \
 	struct Scsi_Host  *shost = class_to_shost(dev);\
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
-	return snprintf(buf, PAGE_SIZE, "%d\n", vport->cfg_##attr);\
+	return scnprintf(buf, PAGE_SIZE, "%d\n", vport->cfg_##attr);\
 }
 
 /**
@@ -2512,7 +2516,7 @@ lpfc_##attr##_show(struct device *dev, s
 { \
 	struct Scsi_Host  *shost = class_to_shost(dev);\
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
-	return snprintf(buf, PAGE_SIZE, "%#x\n", vport->cfg_##attr);\
+	return scnprintf(buf, PAGE_SIZE, "%#x\n", vport->cfg_##attr);\
 }
 
 /**
@@ -2784,7 +2788,7 @@ lpfc_soft_wwpn_show(struct device *dev,
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+	return scnprintf(buf, PAGE_SIZE, "0x%llx\n",
 			(unsigned long long)phba->cfg_soft_wwpn);
 }
 
@@ -2881,7 +2885,7 @@ lpfc_soft_wwnn_show(struct device *dev,
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
-	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+	return scnprintf(buf, PAGE_SIZE, "0x%llx\n",
 			(unsigned long long)phba->cfg_soft_wwnn);
 }
 
@@ -2947,7 +2951,7 @@ lpfc_oas_tgt_show(struct device *dev, st
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
-	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+	return scnprintf(buf, PAGE_SIZE, "0x%llx\n",
 			wwn_to_u64(phba->cfg_oas_tgt_wwpn));
 }
 
@@ -3015,7 +3019,7 @@ lpfc_oas_priority_show(struct device *de
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", phba->cfg_oas_priority);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", phba->cfg_oas_priority);
 }
 
 /**
@@ -3078,7 +3082,7 @@ lpfc_oas_vpt_show(struct device *dev, st
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
-	return snprintf(buf, PAGE_SIZE, "0x%llx\n",
+	return scnprintf(buf, PAGE_SIZE, "0x%llx\n",
 			wwn_to_u64(phba->cfg_oas_vpt_wwpn));
 }
 
@@ -3149,7 +3153,7 @@ lpfc_oas_lun_state_show(struct device *d
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", phba->cfg_oas_lun_state);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", phba->cfg_oas_lun_state);
 }
 
 /**
@@ -3213,7 +3217,7 @@ lpfc_oas_lun_status_show(struct device *
 	if (!(phba->cfg_oas_flags & OAS_LUN_VALID))
 		return -EFAULT;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", phba->cfg_oas_lun_status);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", phba->cfg_oas_lun_status);
 }
 static DEVICE_ATTR(lpfc_xlane_lun_status, S_IRUGO,
 		   lpfc_oas_lun_status_show, NULL);
@@ -3365,7 +3369,7 @@ lpfc_oas_lun_show(struct device *dev, st
 	if (oas_lun != NOT_OAS_ENABLED_LUN)
 		phba->cfg_oas_flags |= OAS_LUN_VALID;
 
-	len += snprintf(buf + len, PAGE_SIZE-len, "0x%llx", oas_lun);
+	len += scnprintf(buf + len, PAGE_SIZE-len, "0x%llx", oas_lun);
 
 	return len;
 }
@@ -3499,7 +3503,7 @@ lpfc_iocb_hw_show(struct device *dev, st
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_hba   *phba = ((struct lpfc_vport *) shost->hostdata)->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", phba->iocb_max);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", phba->iocb_max);
 }
 
 static DEVICE_ATTR(iocb_hw, S_IRUGO,
@@ -3511,7 +3515,7 @@ lpfc_txq_hw_show(struct device *dev, str
 	struct lpfc_hba   *phba = ((struct lpfc_vport *) shost->hostdata)->phba;
 	struct lpfc_sli_ring *pring = lpfc_phba_elsring(phba);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
+	return scnprintf(buf, PAGE_SIZE, "%d\n",
 			pring ? pring->txq_max : 0);
 }
 
@@ -3525,7 +3529,7 @@ lpfc_txcmplq_hw_show(struct device *dev,
 	struct lpfc_hba   *phba = ((struct lpfc_vport *) shost->hostdata)->phba;
 	struct lpfc_sli_ring *pring = lpfc_phba_elsring(phba);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
+	return scnprintf(buf, PAGE_SIZE, "%d\n",
 			pring ? pring->txcmplq_max : 0);
 }
 
@@ -3561,7 +3565,7 @@ lpfc_nodev_tmo_show(struct device *dev,
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",	vport->cfg_devloss_tmo);
+	return scnprintf(buf, PAGE_SIZE, "%d\n",	vport->cfg_devloss_tmo);
 }
 
 /**
@@ -5169,12 +5173,12 @@ lpfc_fcp_cpu_map_show(struct device *dev
 
 	switch (phba->cfg_fcp_cpu_map) {
 	case 0:
-		len += snprintf(buf + len, PAGE_SIZE-len,
+		len += scnprintf(buf + len, PAGE_SIZE-len,
 				"fcp_cpu_map: No mapping (%d)\n",
 				phba->cfg_fcp_cpu_map);
 		return len;
 	case 1:
-		len += snprintf(buf + len, PAGE_SIZE-len,
+		len += scnprintf(buf + len, PAGE_SIZE-len,
 				"fcp_cpu_map: HBA centric mapping (%d): "
 				"%d of %d CPUs online from %d possible CPUs\n",
 				phba->cfg_fcp_cpu_map, num_online_cpus(),
@@ -5188,12 +5192,12 @@ lpfc_fcp_cpu_map_show(struct device *dev
 		cpup = &phba->sli4_hba.cpu_map[phba->sli4_hba.curr_disp_cpu];
 
 		if (!cpu_present(phba->sli4_hba.curr_disp_cpu))
-			len += snprintf(buf + len, PAGE_SIZE - len,
+			len += scnprintf(buf + len, PAGE_SIZE - len,
 					"CPU %02d not present\n",
 					phba->sli4_hba.curr_disp_cpu);
 		else if (cpup->irq == LPFC_VECTOR_MAP_EMPTY) {
 			if (cpup->hdwq == LPFC_VECTOR_MAP_EMPTY)
-				len += snprintf(
+				len += scnprintf(
 					buf + len, PAGE_SIZE - len,
 					"CPU %02d hdwq None "
 					"physid %d coreid %d ht %d\n",
@@ -5201,7 +5205,7 @@ lpfc_fcp_cpu_map_show(struct device *dev
 					cpup->phys_id,
 					cpup->core_id, cpup->hyper);
 			else
-				len += snprintf(
+				len += scnprintf(
 					buf + len, PAGE_SIZE - len,
 					"CPU %02d EQ %04d hdwq %04d "
 					"physid %d coreid %d ht %d\n",
@@ -5210,7 +5214,7 @@ lpfc_fcp_cpu_map_show(struct device *dev
 					cpup->core_id, cpup->hyper);
 		} else {
 			if (cpup->hdwq == LPFC_VECTOR_MAP_EMPTY)
-				len += snprintf(
+				len += scnprintf(
 					buf + len, PAGE_SIZE - len,
 					"CPU %02d hdwq None "
 					"physid %d coreid %d ht %d IRQ %d\n",
@@ -5218,7 +5222,7 @@ lpfc_fcp_cpu_map_show(struct device *dev
 					cpup->phys_id,
 					cpup->core_id, cpup->hyper, cpup->irq);
 			else
-				len += snprintf(
+				len += scnprintf(
 					buf + len, PAGE_SIZE - len,
 					"CPU %02d EQ %04d hdwq %04d "
 					"physid %d coreid %d ht %d IRQ %d\n",
@@ -5233,7 +5237,7 @@ lpfc_fcp_cpu_map_show(struct device *dev
 		if (phba->sli4_hba.curr_disp_cpu <
 				phba->sli4_hba.num_possible_cpu &&
 				(len >= (PAGE_SIZE - 64))) {
-			len += snprintf(buf + len,
+			len += scnprintf(buf + len,
 					PAGE_SIZE - len, "more...\n");
 			break;
 		}
@@ -5753,10 +5757,10 @@ lpfc_sg_seg_cnt_show(struct device *dev,
 	struct lpfc_hba   *phba = vport->phba;
 	int len;
 
-	len = snprintf(buf, PAGE_SIZE, "SGL sz: %d  total SGEs: %d\n",
+	len = scnprintf(buf, PAGE_SIZE, "SGL sz: %d  total SGEs: %d\n",
 		       phba->cfg_sg_dma_buf_size, phba->cfg_total_seg_cnt);
 
-	len += snprintf(buf + len, PAGE_SIZE, "Cfg: %d  SCSI: %d  NVME: %d\n",
+	len += scnprintf(buf + len, PAGE_SIZE, "Cfg: %d  SCSI: %d  NVME: %d\n",
 			phba->cfg_sg_seg_cnt, phba->cfg_scsi_seg_cnt,
 			phba->cfg_nvme_seg_cnt);
 	return len;
@@ -6755,7 +6759,7 @@ lpfc_show_rport_##field (struct device *
 {									\
 	struct fc_rport *rport = transport_class_to_rport(dev);		\
 	struct lpfc_rport_data *rdata = rport->hostdata;		\
-	return snprintf(buf, sz, format_string,				\
+	return scnprintf(buf, sz, format_string,			\
 		(rdata->target) ? cast rdata->target->field : 0);	\
 }
 
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1430,7 +1430,7 @@ lpfc_vport_symbolic_port_name(struct lpf
 	 * Name object.  NPIV is not in play so this integer
 	 * value is sufficient and unique per FC-ID.
 	 */
-	n = snprintf(symbol, size, "%d", vport->phba->brd_no);
+	n = scnprintf(symbol, size, "%d", vport->phba->brd_no);
 	return n;
 }
 
@@ -1444,26 +1444,26 @@ lpfc_vport_symbolic_node_name(struct lpf
 
 	lpfc_decode_firmware_rev(vport->phba, fwrev, 0);
 
-	n = snprintf(symbol, size, "Emulex %s", vport->phba->ModelName);
+	n = scnprintf(symbol, size, "Emulex %s", vport->phba->ModelName);
 	if (size < n)
 		return n;
 
-	n += snprintf(symbol + n, size - n, " FV%s", fwrev);
+	n += scnprintf(symbol + n, size - n, " FV%s", fwrev);
 	if (size < n)
 		return n;
 
-	n += snprintf(symbol + n, size - n, " DV%s.",
+	n += scnprintf(symbol + n, size - n, " DV%s.",
 		      lpfc_release_version);
 	if (size < n)
 		return n;
 
-	n += snprintf(symbol + n, size - n, " HN:%s.",
+	n += scnprintf(symbol + n, size - n, " HN:%s.",
 		      init_utsname()->nodename);
 	if (size < n)
 		return n;
 
 	/* Note :- OS name is "Linux" */
-	n += snprintf(symbol + n, size - n, " OS:%s\n",
+	n += scnprintf(symbol + n, size - n, " OS:%s\n",
 		      init_utsname()->sysname);
 	return n;
 }
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -170,7 +170,7 @@ lpfc_debugfs_disc_trc_data(struct lpfc_v
 		snprintf(buffer,
 			LPFC_DEBUG_TRC_ENTRY_SIZE, "%010d:%010d ms:%s\n",
 			dtp->seq_cnt, ms, dtp->fmt);
-		len +=  snprintf(buf+len, size-len, buffer,
+		len +=  scnprintf(buf+len, size-len, buffer,
 			dtp->data1, dtp->data2, dtp->data3);
 	}
 	for (i = 0; i < index; i++) {
@@ -181,7 +181,7 @@ lpfc_debugfs_disc_trc_data(struct lpfc_v
 		snprintf(buffer,
 			LPFC_DEBUG_TRC_ENTRY_SIZE, "%010d:%010d ms:%s\n",
 			dtp->seq_cnt, ms, dtp->fmt);
-		len +=  snprintf(buf+len, size-len, buffer,
+		len +=  scnprintf(buf+len, size-len, buffer,
 			dtp->data1, dtp->data2, dtp->data3);
 	}
 
@@ -236,7 +236,7 @@ lpfc_debugfs_slow_ring_trc_data(struct l
 		snprintf(buffer,
 			LPFC_DEBUG_TRC_ENTRY_SIZE, "%010d:%010d ms:%s\n",
 			dtp->seq_cnt, ms, dtp->fmt);
-		len +=  snprintf(buf+len, size-len, buffer,
+		len +=  scnprintf(buf+len, size-len, buffer,
 			dtp->data1, dtp->data2, dtp->data3);
 	}
 	for (i = 0; i < index; i++) {
@@ -247,7 +247,7 @@ lpfc_debugfs_slow_ring_trc_data(struct l
 		snprintf(buffer,
 			LPFC_DEBUG_TRC_ENTRY_SIZE, "%010d:%010d ms:%s\n",
 			dtp->seq_cnt, ms, dtp->fmt);
-		len +=  snprintf(buf+len, size-len, buffer,
+		len +=  scnprintf(buf+len, size-len, buffer,
 			dtp->data1, dtp->data2, dtp->data3);
 	}
 
@@ -307,7 +307,7 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hb
 
 	i = lpfc_debugfs_last_hbq;
 
-	len +=  snprintf(buf+len, size-len, "HBQ %d Info\n", i);
+	len +=  scnprintf(buf+len, size-len, "HBQ %d Info\n", i);
 
 	hbqs =  &phba->hbqs[i];
 	posted = 0;
@@ -315,21 +315,21 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hb
 		posted++;
 
 	hip =  lpfc_hbq_defs[i];
-	len +=  snprintf(buf+len, size-len,
+	len +=  scnprintf(buf+len, size-len,
 		"idx:%d prof:%d rn:%d bufcnt:%d icnt:%d acnt:%d posted %d\n",
 		hip->hbq_index, hip->profile, hip->rn,
 		hip->buffer_count, hip->init_count, hip->add_count, posted);
 
 	raw_index = phba->hbq_get[i];
 	getidx = le32_to_cpu(raw_index);
-	len +=  snprintf(buf+len, size-len,
+	len +=  scnprintf(buf+len, size-len,
 		"entries:%d bufcnt:%d Put:%d nPut:%d localGet:%d hbaGet:%d\n",
 		hbqs->entry_count, hbqs->buffer_count, hbqs->hbqPutIdx,
 		hbqs->next_hbqPutIdx, hbqs->local_hbqGetIdx, getidx);
 
 	hbqe = (struct lpfc_hbq_entry *) phba->hbqs[i].hbq_virt;
 	for (j=0; j<hbqs->entry_count; j++) {
-		len +=  snprintf(buf+len, size-len,
+		len +=  scnprintf(buf+len, size-len,
 			"%03d: %08x %04x %05x ", j,
 			le32_to_cpu(hbqe->bde.addrLow),
 			le32_to_cpu(hbqe->bde.tus.w),
@@ -341,14 +341,16 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hb
 		low = hbqs->hbqPutIdx - posted;
 		if (low >= 0) {
 			if ((j >= hbqs->hbqPutIdx) || (j < low)) {
-				len +=  snprintf(buf+len, size-len, "Unused\n");
+				len +=  scnprintf(buf + len, size - len,
+						"Unused\n");
 				goto skipit;
 			}
 		}
 		else {
 			if ((j >= hbqs->hbqPutIdx) &&
 				(j < (hbqs->entry_count+low))) {
-				len +=  snprintf(buf+len, size-len, "Unused\n");
+				len +=  scnprintf(buf + len, size - len,
+						"Unused\n");
 				goto skipit;
 			}
 		}
@@ -358,7 +360,7 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hb
 			hbq_buf = container_of(d_buf, struct hbq_dmabuf, dbuf);
 			phys = ((uint64_t)hbq_buf->dbuf.phys & 0xffffffff);
 			if (phys == le32_to_cpu(hbqe->bde.addrLow)) {
-				len +=  snprintf(buf+len, size-len,
+				len +=  scnprintf(buf+len, size-len,
 					"Buf%d: %p %06x\n", i,
 					hbq_buf->dbuf.virt, hbq_buf->tag);
 				found = 1;
@@ -367,7 +369,7 @@ lpfc_debugfs_hbqinfo_data(struct lpfc_hb
 			i++;
 		}
 		if (!found) {
-			len +=  snprintf(buf+len, size-len, "No DMAinfo?\n");
+			len +=  scnprintf(buf+len, size-len, "No DMAinfo?\n");
 		}
 skipit:
 		hbqe++;
@@ -413,14 +415,14 @@ lpfc_debugfs_commonxripools_data(struct
 			break;
 		qp = &phba->sli4_hba.hdwq[lpfc_debugfs_last_xripool];
 
-		len +=  snprintf(buf + len, size - len, "HdwQ %d Info ", i);
+		len += scnprintf(buf + len, size - len, "HdwQ %d Info ", i);
 		spin_lock_irqsave(&qp->abts_scsi_buf_list_lock, iflag);
 		spin_lock(&qp->abts_nvme_buf_list_lock);
 		spin_lock(&qp->io_buf_list_get_lock);
 		spin_lock(&qp->io_buf_list_put_lock);
 		out = qp->total_io_bufs - (qp->get_io_bufs + qp->put_io_bufs +
 			qp->abts_scsi_io_bufs + qp->abts_nvme_io_bufs);
-		len +=  snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				 "tot:%d get:%d put:%d mt:%d "
 				 "ABTS scsi:%d nvme:%d Out:%d\n",
 			qp->total_io_bufs, qp->get_io_bufs, qp->put_io_bufs,
@@ -612,9 +614,9 @@ lpfc_debugfs_lockstat_data(struct lpfc_h
 			break;
 		qp = &phba->sli4_hba.hdwq[lpfc_debugfs_last_lock];
 
-		len +=  snprintf(buf + len, size - len, "HdwQ %03d Lock ", i);
+		len += scnprintf(buf + len, size - len, "HdwQ %03d Lock ", i);
 		if (phba->cfg_xri_rebalancing) {
-			len +=  snprintf(buf + len, size - len,
+			len += scnprintf(buf + len, size - len,
 					 "get_pvt:%d mv_pvt:%d "
 					 "mv2pub:%d mv2pvt:%d "
 					 "put_pvt:%d put_pub:%d wq:%d\n",
@@ -626,7 +628,7 @@ lpfc_debugfs_lockstat_data(struct lpfc_h
 					 qp->lock_conflict.free_pub_pool,
 					 qp->lock_conflict.wq_access);
 		} else {
-			len +=  snprintf(buf + len, size - len,
+			len += scnprintf(buf + len, size - len,
 					 "get:%d put:%d free:%d wq:%d\n",
 					 qp->lock_conflict.alloc_xri_get,
 					 qp->lock_conflict.alloc_xri_put,
@@ -678,7 +680,7 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
 	off = 0;
 	spin_lock_irq(&phba->hbalock);
 
-	len +=  snprintf(buf+len, size-len, "HBA SLIM\n");
+	len +=  scnprintf(buf+len, size-len, "HBA SLIM\n");
 	lpfc_memcpy_from_slim(buffer,
 		phba->MBslimaddr + lpfc_debugfs_last_hba_slim_off, 1024);
 
@@ -692,7 +694,7 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
 
 	i = 1024;
 	while (i > 0) {
-		len +=  snprintf(buf+len, size-len,
+		len +=  scnprintf(buf+len, size-len,
 		"%08x: %08x %08x %08x %08x %08x %08x %08x %08x\n",
 		off, *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4),
 		*(ptr+5), *(ptr+6), *(ptr+7));
@@ -736,11 +738,11 @@ lpfc_debugfs_dumpHostSlim_data(struct lp
 	off = 0;
 	spin_lock_irq(&phba->hbalock);
 
-	len +=  snprintf(buf+len, size-len, "SLIM Mailbox\n");
+	len +=  scnprintf(buf+len, size-len, "SLIM Mailbox\n");
 	ptr = (uint32_t *)phba->slim2p.virt;
 	i = sizeof(MAILBOX_t);
 	while (i > 0) {
-		len +=  snprintf(buf+len, size-len,
+		len +=  scnprintf(buf+len, size-len,
 		"%08x: %08x %08x %08x %08x %08x %08x %08x %08x\n",
 		off, *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4),
 		*(ptr+5), *(ptr+6), *(ptr+7));
@@ -749,11 +751,11 @@ lpfc_debugfs_dumpHostSlim_data(struct lp
 		off += (8 * sizeof(uint32_t));
 	}
 
-	len +=  snprintf(buf+len, size-len, "SLIM PCB\n");
+	len +=  scnprintf(buf+len, size-len, "SLIM PCB\n");
 	ptr = (uint32_t *)phba->pcb;
 	i = sizeof(PCB_t);
 	while (i > 0) {
-		len +=  snprintf(buf+len, size-len,
+		len +=  scnprintf(buf+len, size-len,
 		"%08x: %08x %08x %08x %08x %08x %08x %08x %08x\n",
 		off, *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4),
 		*(ptr+5), *(ptr+6), *(ptr+7));
@@ -766,7 +768,7 @@ lpfc_debugfs_dumpHostSlim_data(struct lp
 		for (i = 0; i < 4; i++) {
 			pgpp = &phba->port_gp[i];
 			pring = &psli->sli3_ring[i];
-			len +=  snprintf(buf+len, size-len,
+			len +=  scnprintf(buf+len, size-len,
 					 "Ring %d: CMD GetInx:%d "
 					 "(Max:%d Next:%d "
 					 "Local:%d flg:x%x)  "
@@ -783,7 +785,7 @@ lpfc_debugfs_dumpHostSlim_data(struct lp
 		word1 = readl(phba->CAregaddr);
 		word2 = readl(phba->HSregaddr);
 		word3 = readl(phba->HCregaddr);
-		len +=  snprintf(buf+len, size-len, "HA:%08x CA:%08x HS:%08x "
+		len +=  scnprintf(buf+len, size-len, "HA:%08x CA:%08x HS:%08x "
 				 "HC:%08x\n", word0, word1, word2, word3);
 	}
 	spin_unlock_irq(&phba->hbalock);
@@ -821,12 +823,12 @@ lpfc_debugfs_nodelist_data(struct lpfc_v
 	cnt = (LPFC_NODELIST_SIZE / LPFC_NODELIST_ENTRY_SIZE);
 	outio = 0;
 
-	len += snprintf(buf+len, size-len, "\nFCP Nodelist Entries ...\n");
+	len += scnprintf(buf+len, size-len, "\nFCP Nodelist Entries ...\n");
 	spin_lock_irq(shost->host_lock);
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		iocnt = 0;
 		if (!cnt) {
-			len +=  snprintf(buf+len, size-len,
+			len +=  scnprintf(buf+len, size-len,
 				"Missing Nodelist Entries\n");
 			break;
 		}
@@ -864,63 +866,63 @@ lpfc_debugfs_nodelist_data(struct lpfc_v
 		default:
 			statep = "UNKNOWN";
 		}
-		len += snprintf(buf+len, size-len, "%s DID:x%06x ",
+		len += scnprintf(buf+len, size-len, "%s DID:x%06x ",
 				statep, ndlp->nlp_DID);
-		len += snprintf(buf+len, size-len,
+		len += scnprintf(buf+len, size-len,
 				"WWPN x%llx ",
 				wwn_to_u64(ndlp->nlp_portname.u.wwn));
-		len += snprintf(buf+len, size-len,
+		len += scnprintf(buf+len, size-len,
 				"WWNN x%llx ",
 				wwn_to_u64(ndlp->nlp_nodename.u.wwn));
 		if (ndlp->nlp_flag & NLP_RPI_REGISTERED)
-			len += snprintf(buf+len, size-len, "RPI:%03d ",
+			len += scnprintf(buf+len, size-len, "RPI:%03d ",
 					ndlp->nlp_rpi);
 		else
-			len += snprintf(buf+len, size-len, "RPI:none ");
-		len +=  snprintf(buf+len, size-len, "flag:x%08x ",
+			len += scnprintf(buf+len, size-len, "RPI:none ");
+		len +=  scnprintf(buf+len, size-len, "flag:x%08x ",
 			ndlp->nlp_flag);
 		if (!ndlp->nlp_type)
-			len += snprintf(buf+len, size-len, "UNKNOWN_TYPE ");
+			len += scnprintf(buf+len, size-len, "UNKNOWN_TYPE ");
 		if (ndlp->nlp_type & NLP_FC_NODE)
-			len += snprintf(buf+len, size-len, "FC_NODE ");
+			len += scnprintf(buf+len, size-len, "FC_NODE ");
 		if (ndlp->nlp_type & NLP_FABRIC) {
-			len += snprintf(buf+len, size-len, "FABRIC ");
+			len += scnprintf(buf+len, size-len, "FABRIC ");
 			iocnt = 0;
 		}
 		if (ndlp->nlp_type & NLP_FCP_TARGET)
-			len += snprintf(buf+len, size-len, "FCP_TGT sid:%d ",
+			len += scnprintf(buf+len, size-len, "FCP_TGT sid:%d ",
 				ndlp->nlp_sid);
 		if (ndlp->nlp_type & NLP_FCP_INITIATOR)
-			len += snprintf(buf+len, size-len, "FCP_INITIATOR ");
+			len += scnprintf(buf+len, size-len, "FCP_INITIATOR ");
 		if (ndlp->nlp_type & NLP_NVME_TARGET)
-			len += snprintf(buf + len,
+			len += scnprintf(buf + len,
 					size - len, "NVME_TGT sid:%d ",
 					NLP_NO_SID);
 		if (ndlp->nlp_type & NLP_NVME_INITIATOR)
-			len += snprintf(buf + len,
+			len += scnprintf(buf + len,
 					size - len, "NVME_INITIATOR ");
-		len += snprintf(buf+len, size-len, "usgmap:%x ",
+		len += scnprintf(buf+len, size-len, "usgmap:%x ",
 			ndlp->nlp_usg_map);
-		len += snprintf(buf+len, size-len, "refcnt:%x",
+		len += scnprintf(buf+len, size-len, "refcnt:%x",
 			kref_read(&ndlp->kref));
 		if (iocnt) {
 			i = atomic_read(&ndlp->cmd_pending);
-			len += snprintf(buf + len, size - len,
+			len += scnprintf(buf + len, size - len,
 					" OutIO:x%x Qdepth x%x",
 					i, ndlp->cmd_qdepth);
 			outio += i;
 		}
-		len += snprintf(buf + len, size - len, "defer:%x ",
+		len += scnprintf(buf + len, size - len, "defer:%x ",
 			ndlp->nlp_defer_did);
-		len +=  snprintf(buf+len, size-len, "\n");
+		len +=  scnprintf(buf+len, size-len, "\n");
 	}
 	spin_unlock_irq(shost->host_lock);
 
-	len += snprintf(buf + len, size - len,
+	len += scnprintf(buf + len, size - len,
 			"\nOutstanding IO x%x\n",  outio);
 
 	if (phba->nvmet_support && phba->targetport && (vport == phba->pport)) {
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"\nNVME Targetport Entry ...\n");
 
 		/* Port state is only one of two values for now. */
@@ -928,18 +930,18 @@ lpfc_debugfs_nodelist_data(struct lpfc_v
 			statep = "REGISTERED";
 		else
 			statep = "INIT";
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"TGT WWNN x%llx WWPN x%llx State %s\n",
 				wwn_to_u64(vport->fc_nodename.u.wwn),
 				wwn_to_u64(vport->fc_portname.u.wwn),
 				statep);
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"    Targetport DID x%06x\n",
 				phba->targetport->port_id);
 		goto out_exit;
 	}
 
-	len += snprintf(buf + len, size - len,
+	len += scnprintf(buf + len, size - len,
 				"\nNVME Lport/Rport Entries ...\n");
 
 	localport = vport->localport;
@@ -954,11 +956,11 @@ lpfc_debugfs_nodelist_data(struct lpfc_v
 	else
 		statep = "UNKNOWN ";
 
-	len += snprintf(buf + len, size - len,
+	len += scnprintf(buf + len, size - len,
 			"Lport DID x%06x PortState %s\n",
 			localport->port_id, statep);
 
-	len += snprintf(buf + len, size - len, "\tRport List:\n");
+	len += scnprintf(buf + len, size - len, "\tRport List:\n");
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		/* local short-hand pointer. */
 		spin_lock(&phba->hbalock);
@@ -985,32 +987,32 @@ lpfc_debugfs_nodelist_data(struct lpfc_v
 		}
 
 		/* Tab in to show lport ownership. */
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"\t%s Port ID:x%06x ",
 				statep, nrport->port_id);
-		len += snprintf(buf + len, size - len, "WWPN x%llx ",
+		len += scnprintf(buf + len, size - len, "WWPN x%llx ",
 				nrport->port_name);
-		len += snprintf(buf + len, size - len, "WWNN x%llx ",
+		len += scnprintf(buf + len, size - len, "WWNN x%llx ",
 				nrport->node_name);
 
 		/* An NVME rport can have multiple roles. */
 		if (nrport->port_role & FC_PORT_ROLE_NVME_INITIATOR)
-			len +=  snprintf(buf + len, size - len,
+			len +=  scnprintf(buf + len, size - len,
 					 "INITIATOR ");
 		if (nrport->port_role & FC_PORT_ROLE_NVME_TARGET)
-			len +=  snprintf(buf + len, size - len,
+			len +=  scnprintf(buf + len, size - len,
 					 "TARGET ");
 		if (nrport->port_role & FC_PORT_ROLE_NVME_DISCOVERY)
-			len +=  snprintf(buf + len, size - len,
+			len +=  scnprintf(buf + len, size - len,
 					 "DISCSRVC ");
 		if (nrport->port_role & ~(FC_PORT_ROLE_NVME_INITIATOR |
 					  FC_PORT_ROLE_NVME_TARGET |
 					  FC_PORT_ROLE_NVME_DISCOVERY))
-			len +=  snprintf(buf + len, size - len,
+			len +=  scnprintf(buf + len, size - len,
 					 "UNKNOWN ROLE x%x",
 					 nrport->port_role);
 		/* Terminate the string. */
-		len +=  snprintf(buf + len, size - len, "\n");
+		len +=  scnprintf(buf + len, size - len, "\n");
 	}
 
 	spin_unlock_irq(shost->host_lock);
@@ -1049,35 +1051,35 @@ lpfc_debugfs_nvmestat_data(struct lpfc_v
 		if (!phba->targetport)
 			return len;
 		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"\nNVME Targetport Statistics\n");
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"LS: Rcv %08x Drop %08x Abort %08x\n",
 				atomic_read(&tgtp->rcv_ls_req_in),
 				atomic_read(&tgtp->rcv_ls_req_drop),
 				atomic_read(&tgtp->xmt_ls_abort));
 		if (atomic_read(&tgtp->rcv_ls_req_in) !=
 		    atomic_read(&tgtp->rcv_ls_req_out)) {
-			len += snprintf(buf + len, size - len,
+			len += scnprintf(buf + len, size - len,
 					"Rcv LS: in %08x != out %08x\n",
 					atomic_read(&tgtp->rcv_ls_req_in),
 					atomic_read(&tgtp->rcv_ls_req_out));
 		}
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"LS: Xmt %08x Drop %08x Cmpl %08x\n",
 				atomic_read(&tgtp->xmt_ls_rsp),
 				atomic_read(&tgtp->xmt_ls_drop),
 				atomic_read(&tgtp->xmt_ls_rsp_cmpl));
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"LS: RSP Abort %08x xb %08x Err %08x\n",
 				atomic_read(&tgtp->xmt_ls_rsp_aborted),
 				atomic_read(&tgtp->xmt_ls_rsp_xb_set),
 				atomic_read(&tgtp->xmt_ls_rsp_error));
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"FCP: Rcv %08x Defer %08x Release %08x "
 				"Drop %08x\n",
 				atomic_read(&tgtp->rcv_fcp_cmd_in),
@@ -1087,13 +1089,13 @@ lpfc_debugfs_nvmestat_data(struct lpfc_v
 
 		if (atomic_read(&tgtp->rcv_fcp_cmd_in) !=
 		    atomic_read(&tgtp->rcv_fcp_cmd_out)) {
-			len += snprintf(buf + len, size - len,
+			len += scnprintf(buf + len, size - len,
 					"Rcv FCP: in %08x != out %08x\n",
 					atomic_read(&tgtp->rcv_fcp_cmd_in),
 					atomic_read(&tgtp->rcv_fcp_cmd_out));
 		}
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"FCP Rsp: read %08x readrsp %08x "
 				"write %08x rsp %08x\n",
 				atomic_read(&tgtp->xmt_fcp_read),
@@ -1101,31 +1103,31 @@ lpfc_debugfs_nvmestat_data(struct lpfc_v
 				atomic_read(&tgtp->xmt_fcp_write),
 				atomic_read(&tgtp->xmt_fcp_rsp));
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"FCP Rsp Cmpl: %08x err %08x drop %08x\n",
 				atomic_read(&tgtp->xmt_fcp_rsp_cmpl),
 				atomic_read(&tgtp->xmt_fcp_rsp_error),
 				atomic_read(&tgtp->xmt_fcp_rsp_drop));
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"FCP Rsp Abort: %08x xb %08x xricqe  %08x\n",
 				atomic_read(&tgtp->xmt_fcp_rsp_aborted),
 				atomic_read(&tgtp->xmt_fcp_rsp_xb_set),
 				atomic_read(&tgtp->xmt_fcp_xri_abort_cqe));
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"ABORT: Xmt %08x Cmpl %08x\n",
 				atomic_read(&tgtp->xmt_fcp_abort),
 				atomic_read(&tgtp->xmt_fcp_abort_cmpl));
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"ABORT: Sol %08x  Usol %08x Err %08x Cmpl %08x",
 				atomic_read(&tgtp->xmt_abort_sol),
 				atomic_read(&tgtp->xmt_abort_unsol),
 				atomic_read(&tgtp->xmt_abort_rsp),
 				atomic_read(&tgtp->xmt_abort_rsp_error));
 
-		len +=  snprintf(buf + len, size - len, "\n");
+		len +=  scnprintf(buf + len, size - len, "\n");
 
 		cnt = 0;
 		spin_lock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
@@ -1136,7 +1138,7 @@ lpfc_debugfs_nvmestat_data(struct lpfc_v
 		}
 		spin_unlock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
 		if (cnt) {
-			len += snprintf(buf + len, size - len,
+			len += scnprintf(buf + len, size - len,
 					"ABORT: %d ctx entries\n", cnt);
 			spin_lock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
 			list_for_each_entry_safe(ctxp, next_ctxp,
@@ -1144,7 +1146,7 @@ lpfc_debugfs_nvmestat_data(struct lpfc_v
 				    list) {
 				if (len >= (size - LPFC_DEBUG_OUT_LINE_SZ))
 					break;
-				len += snprintf(buf + len, size - len,
+				len += scnprintf(buf + len, size - len,
 						"Entry: oxid %x state %x "
 						"flag %x\n",
 						ctxp->oxid, ctxp->state,
@@ -1158,7 +1160,7 @@ lpfc_debugfs_nvmestat_data(struct lpfc_v
 		tot += atomic_read(&tgtp->xmt_fcp_release);
 		tot = atomic_read(&tgtp->rcv_fcp_cmd_in) - tot;
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"IO_CTX: %08x  WAIT: cur %08x tot %08x\n"
 				"CTX Outstanding %08llx\n",
 				phba->sli4_hba.nvmet_xri_cnt,
@@ -1176,10 +1178,10 @@ lpfc_debugfs_nvmestat_data(struct lpfc_v
 		if (!lport)
 			return len;
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"\nNVME HDWQ Statistics\n");
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"LS: Xmt %016x Cmpl %016x\n",
 				atomic_read(&lport->fc4NvmeLsRequests),
 				atomic_read(&lport->fc4NvmeLsCmpls));
@@ -1199,20 +1201,20 @@ lpfc_debugfs_nvmestat_data(struct lpfc_v
 			if (i >= 32)
 				continue;
 
-			len += snprintf(buf + len, PAGE_SIZE - len,
+			len += scnprintf(buf + len, PAGE_SIZE - len,
 					"HDWQ (%d): Rd %016llx Wr %016llx "
 					"IO %016llx ",
 					i, data1, data2, data3);
-			len += snprintf(buf + len, PAGE_SIZE - len,
+			len += scnprintf(buf + len, PAGE_SIZE - len,
 					"Cmpl %016llx OutIO %016llx\n",
 					tot, ((data1 + data2 + data3) - tot));
 		}
-		len += snprintf(buf + len, PAGE_SIZE - len,
+		len += scnprintf(buf + len, PAGE_SIZE - len,
 				"Total FCP Cmpl %016llx Issue %016llx "
 				"OutIO %016llx\n",
 				totin, totout, totout - totin);
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"LS Xmt Err: Abrt %08x Err %08x  "
 				"Cmpl Err: xb %08x Err %08x\n",
 				atomic_read(&lport->xmt_ls_abort),
@@ -1220,7 +1222,7 @@ lpfc_debugfs_nvmestat_data(struct lpfc_v
 				atomic_read(&lport->cmpl_ls_xb),
 				atomic_read(&lport->cmpl_ls_err));
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"FCP Xmt Err: noxri %06x nondlp %06x "
 				"qdepth %06x wqerr %06x err %06x Abrt %06x\n",
 				atomic_read(&lport->xmt_fcp_noxri),
@@ -1230,7 +1232,7 @@ lpfc_debugfs_nvmestat_data(struct lpfc_v
 				atomic_read(&lport->xmt_fcp_err),
 				atomic_read(&lport->xmt_fcp_abort));
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				"FCP Cmpl Err: xb %08x Err %08x\n",
 				atomic_read(&lport->cmpl_fcp_xb),
 				atomic_read(&lport->cmpl_fcp_err));
@@ -1322,58 +1324,58 @@ lpfc_debugfs_nvmektime_data(struct lpfc_
 
 	if (phba->nvmet_support == 0) {
 		/* NVME Initiator */
-		len += snprintf(buf + len, PAGE_SIZE - len,
+		len += scnprintf(buf + len, PAGE_SIZE - len,
 				"ktime %s: Total Samples: %lld\n",
 				(phba->ktime_on ?  "Enabled" : "Disabled"),
 				phba->ktime_data_samples);
 		if (phba->ktime_data_samples == 0)
 			return len;
 
-		len += snprintf(
+		len += scnprintf(
 			buf + len, PAGE_SIZE - len,
 			"Segment 1: Last NVME Cmd cmpl "
 			"done -to- Start of next NVME cnd (in driver)\n");
-		len += snprintf(
+		len += scnprintf(
 			buf + len, PAGE_SIZE - len,
 			"avg:%08lld min:%08lld max %08lld\n",
 			div_u64(phba->ktime_seg1_total,
 				phba->ktime_data_samples),
 			phba->ktime_seg1_min,
 			phba->ktime_seg1_max);
-		len += snprintf(
+		len += scnprintf(
 			buf + len, PAGE_SIZE - len,
 			"Segment 2: Driver start of NVME cmd "
 			"-to- Firmware WQ doorbell\n");
-		len += snprintf(
+		len += scnprintf(
 			buf + len, PAGE_SIZE - len,
 			"avg:%08lld min:%08lld max %08lld\n",
 			div_u64(phba->ktime_seg2_total,
 				phba->ktime_data_samples),
 			phba->ktime_seg2_min,
 			phba->ktime_seg2_max);
-		len += snprintf(
+		len += scnprintf(
 			buf + len, PAGE_SIZE - len,
 			"Segment 3: Firmware WQ doorbell -to- "
 			"MSI-X ISR cmpl\n");
-		len += snprintf(
+		len += scnprintf(
 			buf + len, PAGE_SIZE - len,
 			"avg:%08lld min:%08lld max %08lld\n",
 			div_u64(phba->ktime_seg3_total,
 				phba->ktime_data_samples),
 			phba->ktime_seg3_min,
 			phba->ktime_seg3_max);
-		len += snprintf(
+		len += scnprintf(
 			buf + len, PAGE_SIZE - len,
 			"Segment 4: MSI-X ISR cmpl -to- "
 			"NVME cmpl done\n");
-		len += snprintf(
+		len += scnprintf(
 			buf + len, PAGE_SIZE - len,
 			"avg:%08lld min:%08lld max %08lld\n",
 			div_u64(phba->ktime_seg4_total,
 				phba->ktime_data_samples),
 			phba->ktime_seg4_min,
 			phba->ktime_seg4_max);
-		len += snprintf(
+		len += scnprintf(
 			buf + len, PAGE_SIZE - len,
 			"Total IO avg time: %08lld\n",
 			div_u64(phba->ktime_seg1_total +
@@ -1385,7 +1387,7 @@ lpfc_debugfs_nvmektime_data(struct lpfc_
 	}
 
 	/* NVME Target */
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"ktime %s: Total Samples: %lld %lld\n",
 			(phba->ktime_on ? "Enabled" : "Disabled"),
 			phba->ktime_data_samples,
@@ -1393,46 +1395,46 @@ lpfc_debugfs_nvmektime_data(struct lpfc_
 	if (phba->ktime_data_samples == 0)
 		return len;
 
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"Segment 1: MSI-X ISR Rcv cmd -to- "
 			"cmd pass to NVME Layer\n");
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
 			div_u64(phba->ktime_seg1_total,
 				phba->ktime_data_samples),
 			phba->ktime_seg1_min,
 			phba->ktime_seg1_max);
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"Segment 2: cmd pass to NVME Layer- "
 			"-to- Driver rcv cmd OP (action)\n");
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
 			div_u64(phba->ktime_seg2_total,
 				phba->ktime_data_samples),
 			phba->ktime_seg2_min,
 			phba->ktime_seg2_max);
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"Segment 3: Driver rcv cmd OP -to- "
 			"Firmware WQ doorbell: cmd\n");
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
 			div_u64(phba->ktime_seg3_total,
 				phba->ktime_data_samples),
 			phba->ktime_seg3_min,
 			phba->ktime_seg3_max);
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"Segment 4: Firmware WQ doorbell: cmd "
 			"-to- MSI-X ISR for cmd cmpl\n");
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
 			div_u64(phba->ktime_seg4_total,
 				phba->ktime_data_samples),
 			phba->ktime_seg4_min,
 			phba->ktime_seg4_max);
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"Segment 5: MSI-X ISR for cmd cmpl "
 			"-to- NVME layer passed cmd done\n");
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
 			div_u64(phba->ktime_seg5_total,
 				phba->ktime_data_samples),
@@ -1440,10 +1442,10 @@ lpfc_debugfs_nvmektime_data(struct lpfc_
 			phba->ktime_seg5_max);
 
 	if (phba->ktime_status_samples == 0) {
-		len += snprintf(buf + len, PAGE_SIZE-len,
+		len += scnprintf(buf + len, PAGE_SIZE-len,
 				"Total: cmd received by MSI-X ISR "
 				"-to- cmd completed on wire\n");
-		len += snprintf(buf + len, PAGE_SIZE-len,
+		len += scnprintf(buf + len, PAGE_SIZE-len,
 				"avg:%08lld min:%08lld "
 				"max %08lld\n",
 				div_u64(phba->ktime_seg10_total,
@@ -1453,46 +1455,46 @@ lpfc_debugfs_nvmektime_data(struct lpfc_
 		return len;
 	}
 
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"Segment 6: NVME layer passed cmd done "
 			"-to- Driver rcv rsp status OP\n");
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
 			div_u64(phba->ktime_seg6_total,
 				phba->ktime_status_samples),
 			phba->ktime_seg6_min,
 			phba->ktime_seg6_max);
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"Segment 7: Driver rcv rsp status OP "
 			"-to- Firmware WQ doorbell: status\n");
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
 			div_u64(phba->ktime_seg7_total,
 				phba->ktime_status_samples),
 			phba->ktime_seg7_min,
 			phba->ktime_seg7_max);
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"Segment 8: Firmware WQ doorbell: status"
 			" -to- MSI-X ISR for status cmpl\n");
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
 			div_u64(phba->ktime_seg8_total,
 				phba->ktime_status_samples),
 			phba->ktime_seg8_min,
 			phba->ktime_seg8_max);
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"Segment 9: MSI-X ISR for status cmpl  "
 			"-to- NVME layer passed status done\n");
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
 			div_u64(phba->ktime_seg9_total,
 				phba->ktime_status_samples),
 			phba->ktime_seg9_min,
 			phba->ktime_seg9_max);
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"Total: cmd received by MSI-X ISR -to- "
 			"cmd completed on wire\n");
-	len += snprintf(buf + len, PAGE_SIZE-len,
+	len += scnprintf(buf + len, PAGE_SIZE-len,
 			"avg:%08lld min:%08lld max %08lld\n",
 			div_u64(phba->ktime_seg10_total,
 				phba->ktime_status_samples),
@@ -1527,7 +1529,7 @@ lpfc_debugfs_nvmeio_trc_data(struct lpfc
 		(phba->nvmeio_trc_size - 1);
 	skip = phba->nvmeio_trc_output_idx;
 
-	len += snprintf(buf + len, size - len,
+	len += scnprintf(buf + len, size - len,
 			"%s IO Trace %s: next_idx %d skip %d size %d\n",
 			(phba->nvmet_support ? "NVME" : "NVMET"),
 			(state ? "Enabled" : "Disabled"),
@@ -1549,18 +1551,18 @@ lpfc_debugfs_nvmeio_trc_data(struct lpfc
 		if (!dtp->fmt)
 			continue;
 
-		len +=  snprintf(buf + len, size - len, dtp->fmt,
+		len +=  scnprintf(buf + len, size - len, dtp->fmt,
 			dtp->data1, dtp->data2, dtp->data3);
 
 		if (phba->nvmeio_trc_output_idx >= phba->nvmeio_trc_size) {
 			phba->nvmeio_trc_output_idx = 0;
-			len += snprintf(buf + len, size - len,
+			len += scnprintf(buf + len, size - len,
 					"Trace Complete\n");
 			goto out;
 		}
 
 		if (len >= (size - LPFC_DEBUG_OUT_LINE_SZ)) {
-			len += snprintf(buf + len, size - len,
+			len += scnprintf(buf + len, size - len,
 					"Trace Continue (%d of %d)\n",
 					phba->nvmeio_trc_output_idx,
 					phba->nvmeio_trc_size);
@@ -1578,18 +1580,18 @@ lpfc_debugfs_nvmeio_trc_data(struct lpfc
 		if (!dtp->fmt)
 			continue;
 
-		len +=  snprintf(buf + len, size - len, dtp->fmt,
+		len +=  scnprintf(buf + len, size - len, dtp->fmt,
 			dtp->data1, dtp->data2, dtp->data3);
 
 		if (phba->nvmeio_trc_output_idx >= phba->nvmeio_trc_size) {
 			phba->nvmeio_trc_output_idx = 0;
-			len += snprintf(buf + len, size - len,
+			len += scnprintf(buf + len, size - len,
 					"Trace Complete\n");
 			goto out;
 		}
 
 		if (len >= (size - LPFC_DEBUG_OUT_LINE_SZ)) {
-			len += snprintf(buf + len, size - len,
+			len += scnprintf(buf + len, size - len,
 					"Trace Continue (%d of %d)\n",
 					phba->nvmeio_trc_output_idx,
 					phba->nvmeio_trc_size);
@@ -1597,7 +1599,7 @@ lpfc_debugfs_nvmeio_trc_data(struct lpfc
 		}
 	}
 
-	len += snprintf(buf + len, size - len,
+	len += scnprintf(buf + len, size - len,
 			"Trace Done\n");
 out:
 	return len;
@@ -1627,17 +1629,17 @@ lpfc_debugfs_cpucheck_data(struct lpfc_v
 	uint32_t tot_rcv;
 	uint32_t tot_cmpl;
 
-	len += snprintf(buf + len, PAGE_SIZE - len,
+	len += scnprintf(buf + len, PAGE_SIZE - len,
 			"CPUcheck %s ",
 			(phba->cpucheck_on & LPFC_CHECK_NVME_IO ?
 				"Enabled" : "Disabled"));
 	if (phba->nvmet_support) {
-		len += snprintf(buf + len, PAGE_SIZE - len,
+		len += scnprintf(buf + len, PAGE_SIZE - len,
 				"%s\n",
 				(phba->cpucheck_on & LPFC_CHECK_NVMET_RCV ?
 					"Rcv Enabled\n" : "Rcv Disabled\n"));
 	} else {
-		len += snprintf(buf + len, PAGE_SIZE - len, "\n");
+		len += scnprintf(buf + len, PAGE_SIZE - len, "\n");
 	}
 	max_cnt = size - LPFC_DEBUG_OUT_LINE_SZ;
 
@@ -1658,7 +1660,7 @@ lpfc_debugfs_cpucheck_data(struct lpfc_v
 		if (!tot_xmt && !tot_cmpl && !tot_rcv)
 			continue;
 
-		len += snprintf(buf + len, PAGE_SIZE - len,
+		len += scnprintf(buf + len, PAGE_SIZE - len,
 				"HDWQ %03d: ", i);
 		for (j = 0; j < LPFC_CHECK_CPU_CNT; j++) {
 			/* Only display non-zero counters */
@@ -1667,22 +1669,22 @@ lpfc_debugfs_cpucheck_data(struct lpfc_v
 			    !qp->cpucheck_rcv_io[j])
 				continue;
 			if (phba->nvmet_support) {
-				len += snprintf(buf + len, PAGE_SIZE - len,
+				len += scnprintf(buf + len, PAGE_SIZE - len,
 						"CPU %03d: %x/%x/%x ", j,
 						qp->cpucheck_rcv_io[j],
 						qp->cpucheck_xmt_io[j],
 						qp->cpucheck_cmpl_io[j]);
 			} else {
-				len += snprintf(buf + len, PAGE_SIZE - len,
+				len += scnprintf(buf + len, PAGE_SIZE - len,
 						"CPU %03d: %x/%x ", j,
 						qp->cpucheck_xmt_io[j],
 						qp->cpucheck_cmpl_io[j]);
 			}
 		}
-		len += snprintf(buf + len, PAGE_SIZE - len,
+		len += scnprintf(buf + len, PAGE_SIZE - len,
 				"Total: %x\n", tot_xmt);
 		if (len >= max_cnt) {
-			len += snprintf(buf + len, PAGE_SIZE - len,
+			len += scnprintf(buf + len, PAGE_SIZE - len,
 					"Truncated ...\n");
 			return len;
 		}
@@ -2258,28 +2260,29 @@ lpfc_debugfs_dif_err_read(struct file *f
 	int cnt = 0;
 
 	if (dent == phba->debug_writeGuard)
-		cnt = snprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_wgrd_cnt);
+		cnt = scnprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_wgrd_cnt);
 	else if (dent == phba->debug_writeApp)
-		cnt = snprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_wapp_cnt);
+		cnt = scnprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_wapp_cnt);
 	else if (dent == phba->debug_writeRef)
-		cnt = snprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_wref_cnt);
+		cnt = scnprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_wref_cnt);
 	else if (dent == phba->debug_readGuard)
-		cnt = snprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_rgrd_cnt);
+		cnt = scnprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_rgrd_cnt);
 	else if (dent == phba->debug_readApp)
-		cnt = snprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_rapp_cnt);
+		cnt = scnprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_rapp_cnt);
 	else if (dent == phba->debug_readRef)
-		cnt = snprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_rref_cnt);
+		cnt = scnprintf(cbuf, 32, "%u\n", phba->lpfc_injerr_rref_cnt);
 	else if (dent == phba->debug_InjErrNPortID)
-		cnt = snprintf(cbuf, 32, "0x%06x\n", phba->lpfc_injerr_nportid);
+		cnt = scnprintf(cbuf, 32, "0x%06x\n",
+				phba->lpfc_injerr_nportid);
 	else if (dent == phba->debug_InjErrWWPN) {
 		memcpy(&tmp, &phba->lpfc_injerr_wwpn, sizeof(struct lpfc_name));
 		tmp = cpu_to_be64(tmp);
-		cnt = snprintf(cbuf, 32, "0x%016llx\n", tmp);
+		cnt = scnprintf(cbuf, 32, "0x%016llx\n", tmp);
 	} else if (dent == phba->debug_InjErrLBA) {
 		if (phba->lpfc_injerr_lba == (sector_t)(-1))
-			cnt = snprintf(cbuf, 32, "off\n");
+			cnt = scnprintf(cbuf, 32, "off\n");
 		else
-			cnt = snprintf(cbuf, 32, "0x%llx\n",
+			cnt = scnprintf(cbuf, 32, "0x%llx\n",
 				 (uint64_t) phba->lpfc_injerr_lba);
 	} else
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -3224,17 +3227,17 @@ lpfc_idiag_pcicfg_read(struct file *file
 	switch (count) {
 	case SIZE_U8: /* byte (8 bits) */
 		pci_read_config_byte(pdev, where, &u8val);
-		len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
 				"%03x: %02x\n", where, u8val);
 		break;
 	case SIZE_U16: /* word (16 bits) */
 		pci_read_config_word(pdev, where, &u16val);
-		len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
 				"%03x: %04x\n", where, u16val);
 		break;
 	case SIZE_U32: /* double word (32 bits) */
 		pci_read_config_dword(pdev, where, &u32val);
-		len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
 				"%03x: %08x\n", where, u32val);
 		break;
 	case LPFC_PCI_CFG_BROWSE: /* browse all */
@@ -3254,25 +3257,25 @@ pcicfg_browse:
 	offset = offset_label;
 
 	/* Read PCI config space */
-	len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
 			"%03x: ", offset_label);
 	while (index > 0) {
 		pci_read_config_dword(pdev, offset, &u32val);
-		len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
 				"%08x ", u32val);
 		offset += sizeof(uint32_t);
 		if (offset >= LPFC_PCI_CFG_SIZE) {
-			len += snprintf(pbuffer+len,
+			len += scnprintf(pbuffer+len,
 					LPFC_PCI_CFG_SIZE-len, "\n");
 			break;
 		}
 		index -= sizeof(uint32_t);
 		if (!index)
-			len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
+			len += scnprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
 					"\n");
 		else if (!(index % (8 * sizeof(uint32_t)))) {
 			offset_label += (8 * sizeof(uint32_t));
-			len += snprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
+			len += scnprintf(pbuffer+len, LPFC_PCI_CFG_SIZE-len,
 					"\n%03x: ", offset_label);
 		}
 	}
@@ -3543,7 +3546,7 @@ lpfc_idiag_baracc_read(struct file *file
 	if (acc_range == SINGLE_WORD) {
 		offset_run = offset;
 		u32val = readl(mem_mapped_bar + offset_run);
-		len += snprintf(pbuffer+len, LPFC_PCI_BAR_RD_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_PCI_BAR_RD_BUF_SIZE-len,
 				"%05x: %08x\n", offset_run, u32val);
 	} else
 		goto baracc_browse;
@@ -3557,35 +3560,35 @@ baracc_browse:
 	offset_run = offset_label;
 
 	/* Read PCI bar memory mapped space */
-	len += snprintf(pbuffer+len, LPFC_PCI_BAR_RD_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_PCI_BAR_RD_BUF_SIZE-len,
 			"%05x: ", offset_label);
 	index = LPFC_PCI_BAR_RD_SIZE;
 	while (index > 0) {
 		u32val = readl(mem_mapped_bar + offset_run);
-		len += snprintf(pbuffer+len, LPFC_PCI_BAR_RD_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_PCI_BAR_RD_BUF_SIZE-len,
 				"%08x ", u32val);
 		offset_run += sizeof(uint32_t);
 		if (acc_range == LPFC_PCI_BAR_BROWSE) {
 			if (offset_run >= bar_size) {
-				len += snprintf(pbuffer+len,
+				len += scnprintf(pbuffer+len,
 					LPFC_PCI_BAR_RD_BUF_SIZE-len, "\n");
 				break;
 			}
 		} else {
 			if (offset_run >= offset +
 			    (acc_range * sizeof(uint32_t))) {
-				len += snprintf(pbuffer+len,
+				len += scnprintf(pbuffer+len,
 					LPFC_PCI_BAR_RD_BUF_SIZE-len, "\n");
 				break;
 			}
 		}
 		index -= sizeof(uint32_t);
 		if (!index)
-			len += snprintf(pbuffer+len,
+			len += scnprintf(pbuffer+len,
 					LPFC_PCI_BAR_RD_BUF_SIZE-len, "\n");
 		else if (!(index % (8 * sizeof(uint32_t)))) {
 			offset_label += (8 * sizeof(uint32_t));
-			len += snprintf(pbuffer+len,
+			len += scnprintf(pbuffer+len,
 					LPFC_PCI_BAR_RD_BUF_SIZE-len,
 					"\n%05x: ", offset_label);
 		}
@@ -3758,19 +3761,19 @@ __lpfc_idiag_print_wq(struct lpfc_queue
 	if (!qp)
 		return len;
 
-	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+	len += scnprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"\t\t%s WQ info: ", wqtype);
-	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+	len += scnprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"AssocCQID[%04d]: WQ-STAT[oflow:x%x posted:x%llx]\n",
 			qp->assoc_qid, qp->q_cnt_1,
 			(unsigned long long)qp->q_cnt_4);
-	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+	len += scnprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"\t\tWQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
 			"HST-IDX[%04d], PRT-IDX[%04d], NTFI[%03d]",
 			qp->queue_id, qp->entry_count,
 			qp->entry_size, qp->host_index,
 			qp->hba_index, qp->notify_interval);
-	len +=  snprintf(pbuffer + len,
+	len +=  scnprintf(pbuffer + len,
 			LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
 	return len;
 }
@@ -3810,21 +3813,22 @@ __lpfc_idiag_print_cq(struct lpfc_queue
 	if (!qp)
 		return len;
 
-	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+	len += scnprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"\t%s CQ info: ", cqtype);
-	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+	len += scnprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"AssocEQID[%02d]: CQ STAT[max:x%x relw:x%x "
 			"xabt:x%x wq:x%llx]\n",
 			qp->assoc_qid, qp->q_cnt_1, qp->q_cnt_2,
 			qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
-	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+	len += scnprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"\tCQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
 			"HST-IDX[%04d], NTFI[%03d], PLMT[%03d]",
 			qp->queue_id, qp->entry_count,
 			qp->entry_size, qp->host_index,
 			qp->notify_interval, qp->max_proc_limit);
 
-	len +=  snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
+	len +=  scnprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+			"\n");
 
 	return len;
 }
@@ -3836,19 +3840,19 @@ __lpfc_idiag_print_rqpair(struct lpfc_qu
 	if (!qp || !datqp)
 		return len;
 
-	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+	len += scnprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"\t\t%s RQ info: ", rqtype);
-	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+	len += scnprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"AssocCQID[%02d]: RQ-STAT[nopost:x%x nobuf:x%x "
 			"posted:x%x rcv:x%llx]\n",
 			qp->assoc_qid, qp->q_cnt_1, qp->q_cnt_2,
 			qp->q_cnt_3, (unsigned long long)qp->q_cnt_4);
-	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+	len += scnprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"\t\tHQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
 			"HST-IDX[%04d], PRT-IDX[%04d], NTFI[%03d]\n",
 			qp->queue_id, qp->entry_count, qp->entry_size,
 			qp->host_index, qp->hba_index, qp->notify_interval);
-	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+	len += scnprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"\t\tDQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
 			"HST-IDX[%04d], PRT-IDX[%04d], NTFI[%03d]\n",
 			datqp->queue_id, datqp->entry_count,
@@ -3927,18 +3931,19 @@ __lpfc_idiag_print_eq(struct lpfc_queue
 	if (!qp)
 		return len;
 
-	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+	len += scnprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"\n%s EQ info: EQ-STAT[max:x%x noE:x%x "
 			"cqe_proc:x%x eqe_proc:x%llx eqd %d]\n",
 			eqtype, qp->q_cnt_1, qp->q_cnt_2, qp->q_cnt_3,
 			(unsigned long long)qp->q_cnt_4, qp->q_mode);
-	len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+	len += scnprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
 			"EQID[%02d], QE-CNT[%04d], QE-SZ[%04d], "
 			"HST-IDX[%04d], NTFI[%03d], PLMT[%03d], AFFIN[%03d]",
 			qp->queue_id, qp->entry_count, qp->entry_size,
 			qp->host_index, qp->notify_interval,
 			qp->max_proc_limit, qp->chann);
-	len +=  snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len, "\n");
+	len +=  scnprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
+			"\n");
 
 	return len;
 }
@@ -3991,9 +3996,10 @@ lpfc_idiag_queinfo_read(struct file *fil
 		if (phba->lpfc_idiag_last_eq >= phba->cfg_hdw_queue)
 			phba->lpfc_idiag_last_eq = 0;
 
-		len += snprintf(pbuffer + len, LPFC_QUE_INFO_GET_BUF_SIZE - len,
-					"HDWQ %d out of %d HBA HDWQs\n",
-					x, phba->cfg_hdw_queue);
+		len += scnprintf(pbuffer + len,
+				 LPFC_QUE_INFO_GET_BUF_SIZE - len,
+				 "HDWQ %d out of %d HBA HDWQs\n",
+				 x, phba->cfg_hdw_queue);
 
 		/* Fast-path EQ */
 		qp = phba->sli4_hba.hdwq[x].hba_eq;
@@ -4075,7 +4081,7 @@ lpfc_idiag_queinfo_read(struct file *fil
 	return simple_read_from_buffer(buf, nbytes, ppos, pbuffer, len);
 
 too_big:
-	len +=  snprintf(pbuffer + len,
+	len +=  scnprintf(pbuffer + len,
 		LPFC_QUE_INFO_GET_BUF_SIZE - len, "Truncated ...\n");
 out:
 	spin_unlock_irq(&phba->hbalock);
@@ -4131,22 +4137,22 @@ lpfc_idiag_queacc_read_qe(char *pbuffer,
 		return 0;
 
 	esize = pque->entry_size;
-	len += snprintf(pbuffer+len, LPFC_QUE_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_QUE_ACC_BUF_SIZE-len,
 			"QE-INDEX[%04d]:\n", index);
 
 	offset = 0;
 	pentry = pque->qe[index].address;
 	while (esize > 0) {
-		len += snprintf(pbuffer+len, LPFC_QUE_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_QUE_ACC_BUF_SIZE-len,
 				"%08x ", *pentry);
 		pentry++;
 		offset += sizeof(uint32_t);
 		esize -= sizeof(uint32_t);
 		if (esize > 0 && !(offset % (4 * sizeof(uint32_t))))
-			len += snprintf(pbuffer+len,
+			len += scnprintf(pbuffer+len,
 					LPFC_QUE_ACC_BUF_SIZE-len, "\n");
 	}
-	len += snprintf(pbuffer+len, LPFC_QUE_ACC_BUF_SIZE-len, "\n");
+	len += scnprintf(pbuffer+len, LPFC_QUE_ACC_BUF_SIZE-len, "\n");
 
 	return len;
 }
@@ -4526,27 +4532,27 @@ lpfc_idiag_drbacc_read_reg(struct lpfc_h
 
 	switch (drbregid) {
 	case LPFC_DRB_EQ:
-		len += snprintf(pbuffer + len, LPFC_DRB_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer + len, LPFC_DRB_ACC_BUF_SIZE-len,
 				"EQ-DRB-REG: 0x%08x\n",
 				readl(phba->sli4_hba.EQDBregaddr));
 		break;
 	case LPFC_DRB_CQ:
-		len += snprintf(pbuffer + len, LPFC_DRB_ACC_BUF_SIZE - len,
+		len += scnprintf(pbuffer + len, LPFC_DRB_ACC_BUF_SIZE - len,
 				"CQ-DRB-REG: 0x%08x\n",
 				readl(phba->sli4_hba.CQDBregaddr));
 		break;
 	case LPFC_DRB_MQ:
-		len += snprintf(pbuffer+len, LPFC_DRB_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_DRB_ACC_BUF_SIZE-len,
 				"MQ-DRB-REG:   0x%08x\n",
 				readl(phba->sli4_hba.MQDBregaddr));
 		break;
 	case LPFC_DRB_WQ:
-		len += snprintf(pbuffer+len, LPFC_DRB_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_DRB_ACC_BUF_SIZE-len,
 				"WQ-DRB-REG:   0x%08x\n",
 				readl(phba->sli4_hba.WQDBregaddr));
 		break;
 	case LPFC_DRB_RQ:
-		len += snprintf(pbuffer+len, LPFC_DRB_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_DRB_ACC_BUF_SIZE-len,
 				"RQ-DRB-REG:   0x%08x\n",
 				readl(phba->sli4_hba.RQDBregaddr));
 		break;
@@ -4736,37 +4742,37 @@ lpfc_idiag_ctlacc_read_reg(struct lpfc_h
 
 	switch (ctlregid) {
 	case LPFC_CTL_PORT_SEM:
-		len += snprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
 				"Port SemReg:   0x%08x\n",
 				readl(phba->sli4_hba.conf_regs_memmap_p +
 				      LPFC_CTL_PORT_SEM_OFFSET));
 		break;
 	case LPFC_CTL_PORT_STA:
-		len += snprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
 				"Port StaReg:   0x%08x\n",
 				readl(phba->sli4_hba.conf_regs_memmap_p +
 				      LPFC_CTL_PORT_STA_OFFSET));
 		break;
 	case LPFC_CTL_PORT_CTL:
-		len += snprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
 				"Port CtlReg:   0x%08x\n",
 				readl(phba->sli4_hba.conf_regs_memmap_p +
 				      LPFC_CTL_PORT_CTL_OFFSET));
 		break;
 	case LPFC_CTL_PORT_ER1:
-		len += snprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
 				"Port Er1Reg:   0x%08x\n",
 				readl(phba->sli4_hba.conf_regs_memmap_p +
 				      LPFC_CTL_PORT_ER1_OFFSET));
 		break;
 	case LPFC_CTL_PORT_ER2:
-		len += snprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
 				"Port Er2Reg:   0x%08x\n",
 				readl(phba->sli4_hba.conf_regs_memmap_p +
 				      LPFC_CTL_PORT_ER2_OFFSET));
 		break;
 	case LPFC_CTL_PDEV_CTL:
-		len += snprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_CTL_ACC_BUF_SIZE-len,
 				"PDev CtlReg:   0x%08x\n",
 				readl(phba->sli4_hba.conf_regs_memmap_p +
 				      LPFC_CTL_PDEV_CTL_OFFSET));
@@ -4959,13 +4965,13 @@ lpfc_idiag_mbxacc_get_setup(struct lpfc_
 	mbx_dump_cnt = idiag.cmd.data[IDIAG_MBXACC_DPCNT_INDX];
 	mbx_word_cnt = idiag.cmd.data[IDIAG_MBXACC_WDCNT_INDX];
 
-	len += snprintf(pbuffer+len, LPFC_MBX_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_MBX_ACC_BUF_SIZE-len,
 			"mbx_dump_map: 0x%08x\n", mbx_dump_map);
-	len += snprintf(pbuffer+len, LPFC_MBX_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_MBX_ACC_BUF_SIZE-len,
 			"mbx_dump_cnt: %04d\n", mbx_dump_cnt);
-	len += snprintf(pbuffer+len, LPFC_MBX_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_MBX_ACC_BUF_SIZE-len,
 			"mbx_word_cnt: %04d\n", mbx_word_cnt);
-	len += snprintf(pbuffer+len, LPFC_MBX_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_MBX_ACC_BUF_SIZE-len,
 			"mbx_mbox_cmd: 0x%02x\n", mbx_mbox_cmd);
 
 	return len;
@@ -5114,35 +5120,35 @@ lpfc_idiag_extacc_avail_get(struct lpfc_
 {
 	uint16_t ext_cnt, ext_size;
 
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\nAvailable Extents Information:\n");
 
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\tPort Available VPI extents: ");
 	lpfc_sli4_get_avail_extnt_rsrc(phba, LPFC_RSC_TYPE_FCOE_VPI,
 				       &ext_cnt, &ext_size);
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"Count %3d, Size %3d\n", ext_cnt, ext_size);
 
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\tPort Available VFI extents: ");
 	lpfc_sli4_get_avail_extnt_rsrc(phba, LPFC_RSC_TYPE_FCOE_VFI,
 				       &ext_cnt, &ext_size);
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"Count %3d, Size %3d\n", ext_cnt, ext_size);
 
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\tPort Available RPI extents: ");
 	lpfc_sli4_get_avail_extnt_rsrc(phba, LPFC_RSC_TYPE_FCOE_RPI,
 				       &ext_cnt, &ext_size);
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"Count %3d, Size %3d\n", ext_cnt, ext_size);
 
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\tPort Available XRI extents: ");
 	lpfc_sli4_get_avail_extnt_rsrc(phba, LPFC_RSC_TYPE_FCOE_XRI,
 				       &ext_cnt, &ext_size);
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"Count %3d, Size %3d\n", ext_cnt, ext_size);
 
 	return len;
@@ -5166,55 +5172,55 @@ lpfc_idiag_extacc_alloc_get(struct lpfc_
 	uint16_t ext_cnt, ext_size;
 	int rc;
 
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\nAllocated Extents Information:\n");
 
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\tHost Allocated VPI extents: ");
 	rc = lpfc_sli4_get_allocated_extnts(phba, LPFC_RSC_TYPE_FCOE_VPI,
 					    &ext_cnt, &ext_size);
 	if (!rc)
-		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 				"Port %d Extent %3d, Size %3d\n",
 				phba->brd_no, ext_cnt, ext_size);
 	else
-		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 				"N/A\n");
 
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\tHost Allocated VFI extents: ");
 	rc = lpfc_sli4_get_allocated_extnts(phba, LPFC_RSC_TYPE_FCOE_VFI,
 					    &ext_cnt, &ext_size);
 	if (!rc)
-		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 				"Port %d Extent %3d, Size %3d\n",
 				phba->brd_no, ext_cnt, ext_size);
 	else
-		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 				"N/A\n");
 
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\tHost Allocated RPI extents: ");
 	rc = lpfc_sli4_get_allocated_extnts(phba, LPFC_RSC_TYPE_FCOE_RPI,
 					    &ext_cnt, &ext_size);
 	if (!rc)
-		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 				"Port %d Extent %3d, Size %3d\n",
 				phba->brd_no, ext_cnt, ext_size);
 	else
-		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 				"N/A\n");
 
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\tHost Allocated XRI extents: ");
 	rc = lpfc_sli4_get_allocated_extnts(phba, LPFC_RSC_TYPE_FCOE_XRI,
 					    &ext_cnt, &ext_size);
 	if (!rc)
-		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 				"Port %d Extent %3d, Size %3d\n",
 				phba->brd_no, ext_cnt, ext_size);
 	else
-		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 				"N/A\n");
 
 	return len;
@@ -5238,49 +5244,49 @@ lpfc_idiag_extacc_drivr_get(struct lpfc_
 	struct lpfc_rsrc_blks *rsrc_blks;
 	int index;
 
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\nDriver Extents Information:\n");
 
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\tVPI extents:\n");
 	index = 0;
 	list_for_each_entry(rsrc_blks, &phba->lpfc_vpi_blk_list, list) {
-		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 				"\t\tBlock %3d: Start %4d, Count %4d\n",
 				index, rsrc_blks->rsrc_start,
 				rsrc_blks->rsrc_size);
 		index++;
 	}
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\tVFI extents:\n");
 	index = 0;
 	list_for_each_entry(rsrc_blks, &phba->sli4_hba.lpfc_vfi_blk_list,
 			    list) {
-		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 				"\t\tBlock %3d: Start %4d, Count %4d\n",
 				index, rsrc_blks->rsrc_start,
 				rsrc_blks->rsrc_size);
 		index++;
 	}
 
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\tRPI extents:\n");
 	index = 0;
 	list_for_each_entry(rsrc_blks, &phba->sli4_hba.lpfc_rpi_blk_list,
 			    list) {
-		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 				"\t\tBlock %3d: Start %4d, Count %4d\n",
 				index, rsrc_blks->rsrc_start,
 				rsrc_blks->rsrc_size);
 		index++;
 	}
 
-	len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+	len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 			"\tXRI extents:\n");
 	index = 0;
 	list_for_each_entry(rsrc_blks, &phba->sli4_hba.lpfc_xri_blk_list,
 			    list) {
-		len += snprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
+		len += scnprintf(pbuffer+len, LPFC_EXT_ACC_BUF_SIZE-len,
 				"\t\tBlock %3d: Start %4d, Count %4d\n",
 				index, rsrc_blks->rsrc_start,
 				rsrc_blks->rsrc_size);
@@ -5706,11 +5712,11 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct l
 				if (i != 0)
 					pr_err("%s\n", line_buf);
 				len = 0;
-				len += snprintf(line_buf+len,
+				len += scnprintf(line_buf+len,
 						LPFC_MBX_ACC_LBUF_SZ-len,
 						"%03d: ", i);
 			}
-			len += snprintf(line_buf+len, LPFC_MBX_ACC_LBUF_SZ-len,
+			len += scnprintf(line_buf+len, LPFC_MBX_ACC_LBUF_SZ-len,
 					"%08x ", (uint32_t)*pword);
 			pword++;
 		}
@@ -5773,11 +5779,11 @@ lpfc_idiag_mbxacc_dump_issue_mbox(struct
 					pr_err("%s\n", line_buf);
 				len = 0;
 				memset(line_buf, 0, LPFC_MBX_ACC_LBUF_SZ);
-				len += snprintf(line_buf+len,
+				len += scnprintf(line_buf+len,
 						LPFC_MBX_ACC_LBUF_SZ-len,
 						"%03d: ", i);
 			}
-			len += snprintf(line_buf+len, LPFC_MBX_ACC_LBUF_SZ-len,
+			len += scnprintf(line_buf+len, LPFC_MBX_ACC_LBUF_SZ-len,
 					"%08x ",
 					((uint32_t)*pword) & 0xffffffff);
 			pword++;
@@ -5796,18 +5802,18 @@ lpfc_idiag_mbxacc_dump_issue_mbox(struct
 					pr_err("%s\n", line_buf);
 				len = 0;
 				memset(line_buf, 0, LPFC_MBX_ACC_LBUF_SZ);
-				len += snprintf(line_buf+len,
+				len += scnprintf(line_buf+len,
 						LPFC_MBX_ACC_LBUF_SZ-len,
 						"%03d: ", i);
 			}
 			for (j = 0; j < 4; j++) {
-				len += snprintf(line_buf+len,
+				len += scnprintf(line_buf+len,
 						LPFC_MBX_ACC_LBUF_SZ-len,
 						"%02x",
 						((uint8_t)*pbyte) & 0xff);
 				pbyte++;
 			}
-			len += snprintf(line_buf+len,
+			len += scnprintf(line_buf+len,
 					LPFC_MBX_ACC_LBUF_SZ-len, " ");
 		}
 		if ((i - 1) % 8)
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -348,7 +348,7 @@ lpfc_debug_dump_qe(struct lpfc_queue *q,
 	pword = q->qe[idx].address;
 
 	len = 0;
-	len += snprintf(line_buf+len, LPFC_LBUF_SZ-len, "QE[%04d]: ", idx);
+	len += scnprintf(line_buf+len, LPFC_LBUF_SZ-len, "QE[%04d]: ", idx);
 	if (qe_word_cnt > 8)
 		printk(KERN_ERR "%s\n", line_buf);
 
@@ -359,11 +359,11 @@ lpfc_debug_dump_qe(struct lpfc_queue *q,
 			if (qe_word_cnt > 8) {
 				len = 0;
 				memset(line_buf, 0, LPFC_LBUF_SZ);
-				len += snprintf(line_buf+len, LPFC_LBUF_SZ-len,
+				len += scnprintf(line_buf+len, LPFC_LBUF_SZ-len,
 						"%03d: ", i);
 			}
 		}
-		len += snprintf(line_buf+len, LPFC_LBUF_SZ-len, "%08x ",
+		len += scnprintf(line_buf+len, LPFC_LBUF_SZ-len, "%08x ",
 				((uint32_t)*pword) & 0xffffffff);
 		pword++;
 	}


