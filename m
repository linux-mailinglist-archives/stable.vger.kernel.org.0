Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46CE2E63E3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgL1PoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:44:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392018AbgL1NpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:45:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76BFB20738;
        Mon, 28 Dec 2020 13:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163090;
        bh=q3tVlUYuJYwRWgBYZAblJRwHUc87xIiOmQlNyMvFcdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h90uL+O6DhwYCEq8c91+aQqJDyRJ4ZfHjnFsgo9Kg+wGIDl1Byh1OY94qqdee9nNN
         1mzWYrUGrEBK5P8/lqj4DlQx0gnQN5N9ogoklXdImItbX375wisXk7/YxF3rEnDU1z
         cBrMSfcmr8ypqoXyynIqY1Io9o20ODCte2Y9soY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Martin Wilck <mwilck@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/453] scsi: core: Fix VPD LUN ID designator priorities
Date:   Mon, 28 Dec 2020 13:46:14 +0100
Message-Id: <20201228124943.848376874@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 2e4209b3806cda9b89c30fd5e7bfecb7044ec78b ]

The current implementation of scsi_vpd_lun_id() uses the designator length
as an implicit measure of priority. This works most of the time, but not
always. For example, some Hitachi storage arrays return this in VPD 0x83:

VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 24
    designator_type: T10 vendor identification,  code_set: ASCII
    associated with the Addressed logical unit
      vendor id: HITACHI
      vendor specific: 5030C3502025
  Designation descriptor number 2, descriptor length: 6
    designator_type: vendor specific [0x0],  code_set: Binary
    associated with the Target port
      vendor specific: 08 03
  Designation descriptor number 3, descriptor length: 20
    designator_type: NAA,  code_set: Binary
    associated with the Addressed logical unit
      NAA 6, IEEE Company_id: 0x60e8
      Vendor Specific Identifier: 0x7c35000
      Vendor Specific Identifier Extension: 0x30c35000002025
      [0x60060e8007c350000030c35000002025]

The current code would use the first descriptor because it's longer than
the NAA descriptor. But this is wrong, the kernel is supposed to prefer NAA
descriptors over T10 vendor ID. Designator length should only be used to
compare designators of the same type.

This patch addresses the issue by separating designator priority and
length.

Link: https://lore.kernel.org/r/20201029170846.14786-1-mwilck@suse.com
Fixes: 9983bed3907c ("scsi: Add scsi_vpd_lun_id()")
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 126 +++++++++++++++++++++++++++-------------
 1 file changed, 86 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e6944e1cba2ba..b5867e1566f42 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2930,6 +2930,78 @@ void sdev_enable_disk_events(struct scsi_device *sdev)
 }
 EXPORT_SYMBOL(sdev_enable_disk_events);
 
+static unsigned char designator_prio(const unsigned char *d)
+{
+	if (d[1] & 0x30)
+		/* not associated with LUN */
+		return 0;
+
+	if (d[3] == 0)
+		/* invalid length */
+		return 0;
+
+	/*
+	 * Order of preference for lun descriptor:
+	 * - SCSI name string
+	 * - NAA IEEE Registered Extended
+	 * - EUI-64 based 16-byte
+	 * - EUI-64 based 12-byte
+	 * - NAA IEEE Registered
+	 * - NAA IEEE Extended
+	 * - EUI-64 based 8-byte
+	 * - SCSI name string (truncated)
+	 * - T10 Vendor ID
+	 * as longer descriptors reduce the likelyhood
+	 * of identification clashes.
+	 */
+
+	switch (d[1] & 0xf) {
+	case 8:
+		/* SCSI name string, variable-length UTF-8 */
+		return 9;
+	case 3:
+		switch (d[4] >> 4) {
+		case 6:
+			/* NAA registered extended */
+			return 8;
+		case 5:
+			/* NAA registered */
+			return 5;
+		case 4:
+			/* NAA extended */
+			return 4;
+		case 3:
+			/* NAA locally assigned */
+			return 1;
+		default:
+			break;
+		}
+		break;
+	case 2:
+		switch (d[3]) {
+		case 16:
+			/* EUI64-based, 16 byte */
+			return 7;
+		case 12:
+			/* EUI64-based, 12 byte */
+			return 6;
+		case 8:
+			/* EUI64-based, 8 byte */
+			return 3;
+		default:
+			break;
+		}
+		break;
+	case 1:
+		/* T10 vendor ID */
+		return 1;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 /**
  * scsi_vpd_lun_id - return a unique device identification
  * @sdev: SCSI device
@@ -2946,7 +3018,7 @@ EXPORT_SYMBOL(sdev_enable_disk_events);
  */
 int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 {
-	u8 cur_id_type = 0xff;
+	u8 cur_id_prio = 0;
 	u8 cur_id_size = 0;
 	const unsigned char *d, *cur_id_str;
 	const struct scsi_vpd *vpd_pg83;
@@ -2959,20 +3031,6 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 		return -ENXIO;
 	}
 
-	/*
-	 * Look for the correct descriptor.
-	 * Order of preference for lun descriptor:
-	 * - SCSI name string
-	 * - NAA IEEE Registered Extended
-	 * - EUI-64 based 16-byte
-	 * - EUI-64 based 12-byte
-	 * - NAA IEEE Registered
-	 * - NAA IEEE Extended
-	 * - T10 Vendor ID
-	 * as longer descriptors reduce the likelyhood
-	 * of identification clashes.
-	 */
-
 	/* The id string must be at least 20 bytes + terminating NULL byte */
 	if (id_len < 21) {
 		rcu_read_unlock();
@@ -2982,8 +3040,9 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 	memset(id, 0, id_len);
 	d = vpd_pg83->data + 4;
 	while (d < vpd_pg83->data + vpd_pg83->len) {
-		/* Skip designators not referring to the LUN */
-		if ((d[1] & 0x30) != 0x00)
+		u8 prio = designator_prio(d);
+
+		if (prio == 0 || cur_id_prio > prio)
 			goto next_desig;
 
 		switch (d[1] & 0xf) {
@@ -2991,28 +3050,19 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 			/* T10 Vendor ID */
 			if (cur_id_size > d[3])
 				break;
-			/* Prefer anything */
-			if (cur_id_type > 0x01 && cur_id_type != 0xff)
-				break;
+			cur_id_prio = prio;
 			cur_id_size = d[3];
 			if (cur_id_size + 4 > id_len)
 				cur_id_size = id_len - 4;
 			cur_id_str = d + 4;
-			cur_id_type = d[1] & 0xf;
 			id_size = snprintf(id, id_len, "t10.%*pE",
 					   cur_id_size, cur_id_str);
 			break;
 		case 0x2:
 			/* EUI-64 */
-			if (cur_id_size > d[3])
-				break;
-			/* Prefer NAA IEEE Registered Extended */
-			if (cur_id_type == 0x3 &&
-			    cur_id_size == d[3])
-				break;
+			cur_id_prio = prio;
 			cur_id_size = d[3];
 			cur_id_str = d + 4;
-			cur_id_type = d[1] & 0xf;
 			switch (cur_id_size) {
 			case 8:
 				id_size = snprintf(id, id_len,
@@ -3030,17 +3080,14 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 						   cur_id_str);
 				break;
 			default:
-				cur_id_size = 0;
 				break;
 			}
 			break;
 		case 0x3:
 			/* NAA */
-			if (cur_id_size > d[3])
-				break;
+			cur_id_prio = prio;
 			cur_id_size = d[3];
 			cur_id_str = d + 4;
-			cur_id_type = d[1] & 0xf;
 			switch (cur_id_size) {
 			case 8:
 				id_size = snprintf(id, id_len,
@@ -3053,26 +3100,25 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 						   cur_id_str);
 				break;
 			default:
-				cur_id_size = 0;
 				break;
 			}
 			break;
 		case 0x8:
 			/* SCSI name string */
-			if (cur_id_size + 4 > d[3])
+			if (cur_id_size > d[3])
 				break;
 			/* Prefer others for truncated descriptor */
-			if (cur_id_size && d[3] > id_len)
-				break;
+			if (d[3] > id_len) {
+				prio = 2;
+				if (cur_id_prio > prio)
+					break;
+			}
+			cur_id_prio = prio;
 			cur_id_size = id_size = d[3];
 			cur_id_str = d + 4;
-			cur_id_type = d[1] & 0xf;
 			if (cur_id_size >= id_len)
 				cur_id_size = id_len - 1;
 			memcpy(id, cur_id_str, cur_id_size);
-			/* Decrease priority for truncated descriptor */
-			if (cur_id_size != id_size)
-				cur_id_size = 6;
 			break;
 		default:
 			break;
-- 
2.27.0



