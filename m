Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE07812212A
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 02:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfLQBAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 20:00:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34566 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbfLQAvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:31 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15F-0003JP-Ul; Tue, 17 Dec 2019 00:51:30 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15E-0005SS-VE; Tue, 17 Dec 2019 00:51:29 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Benjamin Block" <bblock@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Jens Remus" <jremus@linux.ibm.com>,
        "Steffen Maier" <maier@linux.ibm.com>
Date:   Tue, 17 Dec 2019 00:45:49 +0000
Message-ID: <lsq.1576543535.194851928@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 015/136] scsi: zfcp: fix reaction on bit error
 threshold notification
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Maier <maier@linux.ibm.com>

commit 2190168aaea42c31bff7b9a967e7b045f07df095 upstream.

On excessive bit errors for the FCP channel ingress fibre path, the channel
notifies us.  Previously, we only emitted a kernel message and a trace
record.  Since performance can become suboptimal with I/O timeouts due to
bit errors, we now stop using an FCP device by default on channel
notification so multipath on top can timely failover to other paths.  A new
module parameter zfcp.ber_stop can be used to get zfcp old behavior.

User explanation of new kernel message:

 * Description:
 * The FCP channel reported that its bit error threshold has been exceeded.
 * These errors might result from a problem with the physical components
 * of the local fibre link into the FCP channel.
 * The problem might be damage or malfunction of the cable or
 * cable connection between the FCP channel and
 * the adjacent fabric switch port or the point-to-point peer.
 * Find details about the errors in the HBA trace for the FCP device.
 * The zfcp device driver closed down the FCP device
 * to limit the performance impact from possible I/O command timeouts.
 * User action:
 * Check for problems on the local fibre link, ensure that fibre optics are
 * clean and functional, and all cables are properly plugged.
 * After the repair action, you can manually recover the FCP device by
 * writing "0" into its "failed" sysfs attribute.
 * If recovery through sysfs is not possible, set the CHPID of the device
 * offline and back online on the service element.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/r/20191001104949.42810-1-maier@linux.ibm.com
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/scsi/zfcp_fsf.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -20,6 +20,11 @@
 
 struct kmem_cache *zfcp_fsf_qtcb_cache;
 
+static bool ber_stop = true;
+module_param(ber_stop, bool, 0600);
+MODULE_PARM_DESC(ber_stop,
+		 "Shuts down FCP devices for FCP channels that report a bit-error count in excess of its threshold (default on)");
+
 static void zfcp_fsf_request_timeout_handler(unsigned long data)
 {
 	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
@@ -231,10 +236,15 @@ static void zfcp_fsf_status_read_handler
 	case FSF_STATUS_READ_SENSE_DATA_AVAIL:
 		break;
 	case FSF_STATUS_READ_BIT_ERROR_THRESHOLD:
-		dev_warn(&adapter->ccw_device->dev,
-			 "The error threshold for checksum statistics "
-			 "has been exceeded\n");
 		zfcp_dbf_hba_bit_err("fssrh_3", req);
+		if (ber_stop) {
+			dev_warn(&adapter->ccw_device->dev,
+				 "All paths over this FCP device are disused because of excessive bit errors\n");
+			zfcp_erp_adapter_shutdown(adapter, 0, "fssrh_b");
+		} else {
+			dev_warn(&adapter->ccw_device->dev,
+				 "The error threshold for checksum statistics has been exceeded\n");
+		}
 		break;
 	case FSF_STATUS_READ_LINK_DOWN:
 		zfcp_fsf_status_read_link_down(req);

