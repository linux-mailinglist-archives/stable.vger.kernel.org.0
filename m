Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A362E88E24
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfHJUwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:52:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54124 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726573AbfHJUnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-00053i-Os; Sat, 10 Aug 2019 21:43:48 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-0003bS-1a; Sat, 10 Aug 2019 21:43:46 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jens Remus" <jremus@linux.ibm.com>,
        "Steffen Maier" <maier@linux.ibm.com>,
        "Benjamin Block" <bblock@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.968303007@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 050/157] scsi: zfcp: fix rport unblock if deleted
 SCSI devices on Scsi_Host
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Maier <maier@linux.ibm.com>

commit fe67888fc007a76b81e37da23ce5bd8fb95890b0 upstream.

An already deleted SCSI device can exist on the Scsi_Host and remain there
because something still holds a reference.  A new SCSI device with the same
H:C:T:L and FCP device, target port WWPN, and FCP LUN can be created.  When
we try to unblock an rport, we still find the deleted SCSI device and
return early because the zfcp_scsi_dev of that SCSI device is not
ZFCP_STATUS_COMMON_UNBLOCKED. Hence we miss to unblock the rport, even if
the new proper SCSI device would be in good state.

Therefore, skip deleted SCSI devices when iterating the sdevs of the shost.
[cf. __scsi_device_lookup{_by_target}() or scsi_device_get()]

The following abbreviated trace sequence can indicate such problem:

Area           : REC
Tag            : ersfs_3
LUN            : 0x4045400300000000
WWPN           : 0x50050763031bd327
LUN status     : 0x40000000     not ZFCP_STATUS_COMMON_UNBLOCKED
Ready count    : n		not incremented yet
Running count  : 0x00000000
ERP want       : 0x01
ERP need       : 0xc1		ZFCP_ERP_ACTION_NONE

Area           : REC
Tag            : ersfs_3
LUN            : 0x4045400300000000
WWPN           : 0x50050763031bd327
LUN status     : 0x41000000
Ready count    : n+1
Running count  : 0x00000000
ERP want       : 0x01
ERP need       : 0x01

...

Area           : REC
Level          : 4		only with increased trace level
Tag            : ertru_l
LUN            : 0x4045400300000000
WWPN           : 0x50050763031bd327
LUN status     : 0x40000000
Request ID     : 0x0000000000000000
ERP status     : 0x01800000
ERP step       : 0x1000
ERP action     : 0x01
ERP count      : 0x00

NOT followed by a trace record with tag "scpaddy"
for WWPN 0x50050763031bd327.

Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Fixes: 6f2ce1c6af37 ("scsi: zfcp: fix rport unblock race with LUN recovery")
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/scsi/zfcp_erp.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -1313,6 +1313,9 @@ static void zfcp_erp_try_rport_unblock(s
 		struct zfcp_scsi_dev *zsdev = sdev_to_zfcp(sdev);
 		int lun_status;
 
+		if (sdev->sdev_state == SDEV_DEL ||
+		    sdev->sdev_state == SDEV_CANCEL)
+			continue;
 		if (zsdev->port != port)
 			continue;
 		/* LUN under port of interest */

