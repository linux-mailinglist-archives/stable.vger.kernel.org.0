Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70D435FDF0
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 00:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235032AbhDNWjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 18:39:45 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:38944 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbhDNWjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 18:39:42 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id EAE9892009E; Thu, 15 Apr 2021 00:39:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id E7F6892009C;
        Thu, 15 Apr 2021 00:39:17 +0200 (CEST)
Date:   Thu, 15 Apr 2021 00:39:17 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 3/5] scsi: Provide for avoiding trailing allocation length
 with VPD inquiries
In-Reply-To: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2104141541090.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Allow SCSI hosts to request avoiding trailing allocation length with VPD 
inquiries, and use the mechanism to work around an issue with at least 
some BusLogic MultiMaster host bus adapters and observed with the BT-958 
model specifically where issuing commands that return less data than 
provided for causes fatal failures:

scsi host0: BusLogic BT-958
scsi 0:0:0:0: Direct-Access     IBM      DDYS-T18350M     SA5A PQ: 0 ANSI: 3
scsi 0:0:1:0: Direct-Access     SEAGATE  ST336607LW       0006 PQ: 0 ANSI: 3
scsi 0:0:5:0: Direct-Access     IOMEGA   ZIP 100          E.08 PQ: 0 ANSI: 2
sd 0:0:1:0: [sdb] 71687372 512-byte logical blocks: (36.7 GB/34.2 GiB)
sd 0:0:0:0: [sda] 35843670 512-byte logical blocks: (18.4 GB/17.1 GiB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:5:0: [sdc] Attached SCSI removable disk
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
scsi0: *** BusLogic BT-958 Initialized Successfully ***
scsi0: *** BusLogic BT-958 Initialized Successfully ***
scsi0: *** BusLogic BT-958 Initialized Successfully ***
scsi0: *** BusLogic BT-958 Initialized Successfully ***
sd 0:0:0:0: Device offlined - not ready after error recovery
sd 0:0:1:0: Device offlined - not ready after error recovery
sd 0:0:0:0: scsi_vpd_inquiry(0): buf[64] => -5
sd 0:0:1:0: scsi_vpd_inquiry(0): buf[64] => -5
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:1:0: [sdb] Attached SCSI disk
VFS: Cannot open root device "802" or unknown-block(8,2): error -6

(here and elsewhere reported with some instrumentation added so as to 
show the causing requests and with irrelevant messages filtered out).

As already observed back in 2003 and worked around in smartmontools at 
least some versions of BusLogic firmware such as 5.07B are unable to 
handle such commands, but it is possible to request enough data first 
for the length of the data response to be determined and then reissue 
the same command with the allocation length matching the response 
expected.

It is what this change does on a host-by-host basis, by providing a flag 
for individual HBA drivers to enable this workaround, currently set by 
the BusLogic driver, and then issuing these double calls as requested, 
which then produce results as expected:

sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:1:0: scsi_vpd_inquiry(0): buf[64] => 13
sd 0:0:0:0: scsi_vpd_inquiry(0): buf[64] => 7
 sdb: sdb1 sdb2
sd 0:0:1:0: scsi_vpd_inquiry(0): buf[64] => 13
sd 0:0:1:0: [sdb] Attached SCSI disk
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
sd 0:0:0:0: scsi_vpd_inquiry(0): buf[64] => 7
sd 0:0:0:0: [sda] Attached SCSI disk
EXT4-fs (sda2): mounting ext2 file system using the ext4 subsystem
EXT4-fs (sda2): mounted filesystem without journal. Opts: (null). Quota mode: disabled.
VFS: Mounted root (ext2 filesystem) readonly on device 8:2.

The minimum request size of 4 for the repeated call has been chosen to 
match one required for a successful return from `scsi_vpd_inquiry'.

Interestingly enough it has only started triggering with not so recent 
commit af73623f5f10 ("[SCSI] sd: Reduce buffer size for vpd request") 
that decreased the allocation length for the originating request from 
512 down to 64.  Previously the request was rejected outright by the 
respective targets as invalid and therefore did not trigger the issue 
with MultiMaster firmware as that would only happen for a command that 
succeeded but produced less data than provided for:

scsi0: CCB #36 Target 0: Result 2 Host Adapter Status 00 Target Status 02
scsi0: CDB    12 01 00 02 00 00
scsi0: Sense  70 00 05 00 00 00 00 18 00 00 00 00 24 00 00 C0 00 03 00 [...]
sd 0:0:0:0: scsi_vpd_inquiry(0): buf[512] => -5
scsi0: CCB #37 Target 1: Result 2 Host Adapter Status 00 Target Status 02
scsi0: CDB    12 01 00 02 00 00
scsi0: Sense  70 00 05 00 00 00 00 0A 00 00 00 00 24 00 01 C9 00 03 00 [...]
sd 0:0:1:0: scsi_vpd_inquiry(0): buf[512] => -5

(here with the buffer size set back to 512, the `BusLogic=TraceErrors' 
parameter and trailing sense data zeros trimmed for brevity).  Note the 
sense key of 0x5 returned denoting an illegal request even for page 0.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 881a256d84e6 ("[SCSI] Add VPD helper")
Cc: stable@vger.kernel.org # v2.6.30+
---
 drivers/scsi/BusLogic.c  |    1 +
 drivers/scsi/scsi.c      |   24 +++++++++++++++++++++---
 include/scsi/scsi_host.h |    3 +++
 3 files changed, 25 insertions(+), 3 deletions(-)

linux-buslogic-get-vpd-page-buffer.diff
Index: linux-macro-ide/drivers/scsi/BusLogic.c
===================================================================
--- linux-macro-ide.orig/drivers/scsi/BusLogic.c
+++ linux-macro-ide/drivers/scsi/BusLogic.c
@@ -2301,6 +2301,7 @@ static void __init blogic_inithoststruct
 	host->sg_tablesize = adapter->drvr_sglimit;
 	host->unchecked_isa_dma = adapter->need_bouncebuf;
 	host->cmd_per_lun = adapter->untag_qdepth;
+	host->no_trailing_allocation_length = true;
 }
 
 /*
Index: linux-macro-ide/drivers/scsi/scsi.c
===================================================================
--- linux-macro-ide.orig/drivers/scsi/scsi.c
+++ linux-macro-ide/drivers/scsi/scsi.c
@@ -346,8 +346,19 @@ int scsi_get_vpd_page(struct scsi_device
 	if (sdev->skip_vpd_pages)
 		goto fail;
 
-	/* Ask for all the pages supported by this device */
-	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
+	/*
+	 * Ask for all the pages supported by this device.  Determine the
+	 * actual data length first if so required by the host, e.g.
+	 * BusLogic BT-958.
+	 */
+	if (sdev->host->no_trailing_allocation_length) {
+		result = scsi_vpd_inquiry(sdev, buf, 0, min(4, buf_len));
+		if (result < 4)
+			goto fail;
+	} else {
+		result = buf_len;
+	}
+	result = scsi_vpd_inquiry(sdev, buf, 0, min(result, buf_len));
 	if (result < 4)
 		goto fail;
 
@@ -366,7 +377,14 @@ int scsi_get_vpd_page(struct scsi_device
 	goto fail;
 
  found:
-	result = scsi_vpd_inquiry(sdev, buf, page, buf_len);
+	if (sdev->host->no_trailing_allocation_length) {
+		result = scsi_vpd_inquiry(sdev, buf, page, min(4, buf_len));
+		if (result < 4)
+			goto fail;
+	} else {
+		result = buf_len;
+	}
+	result = scsi_vpd_inquiry(sdev, buf, page, min(result, buf_len));
 	if (result < 0)
 		goto fail;
 
Index: linux-macro-ide/include/scsi/scsi_host.h
===================================================================
--- linux-macro-ide.orig/include/scsi/scsi_host.h
+++ linux-macro-ide/include/scsi/scsi_host.h
@@ -653,6 +653,9 @@ struct Scsi_Host {
 	/* The transport requires the LUN bits NOT to be stored in CDB[1] */
 	unsigned no_scsi2_lun_in_cdb:1;
 
+	/* Allocation length must not exceed actual data length. */
+	unsigned no_trailing_allocation_length:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
