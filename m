Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4CCAE6198
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 09:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfJ0IXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 04:23:17 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:45617 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726002AbfJ0IXR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 04:23:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 32791334;
        Sun, 27 Oct 2019 04:23:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 27 Oct 2019 04:23:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=L3dJlj
        TX7dsm9sMWpgt241q8UYVzsAe/udKmP0Or9g8=; b=mIUHY+FYTtAfziv229pWX4
        o7TDdmPDjwCwM7Bp95zaCLEfjPMRlsGOapUWWe0Y2mnLPY0OL3o3FppVJlxwvSth
        FXaTMFgB3Av9VXWDP/mHhTR2HofY+/MJT+kfDSO7AIJXl079+YPrDglA/FuOS1fV
        KiDtIPTKnTEGnoTw0Kjmzb/Bxr+R/SfrgKhchVuFkj1DIzt53yoVHhipEqH4Rx1D
        58O3Oj8lOXSbSFbDEg9zipVKkMhZpbwg2ysMOuvy7ZkcJdTzQ/R2daTiO5ZKUAxk
        D5gwBpO/7xRZqlpPeTHBJCBw3Rji5LlpNhULdlmpry4+v16j1UOrJxoLePyt2rjA
        ==
X-ME-Sender: <xms:81O1XW2OxJtNhBPOnHfwjrfV7hieDuwCdnUzO2lYcw6cXBnFkKQg9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrleeigdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:81O1XdM0GHfD06dTgyBTaEtwNI_IExs7oQApQNPdFhKpMFH2cfe8Dw>
    <xmx:81O1Xb7OjGoaIv8Op_70beI7hyzJvaqKKQ1nWWjJ_YMfmfhU-siPAA>
    <xmx:81O1XSZXvP0hXlV-7QCBEOE3cBFLA61dbm2RPncALayjie28H34OBQ>
    <xmx:81O1XZYnEnUWxu-Tlc3aVsk04xnhi1zgkb4vem4o3ufWLUJ4Q66mZw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 655FCD6005B;
        Sun, 27 Oct 2019 04:23:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: zfcp: fix reaction on bit error threshold notification" failed to apply to 4.14-stable tree
To:     maier@linux.ibm.com, bblock@linux.ibm.com, jremus@linux.ibm.com,
        martin.petersen@oracle.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Oct 2019 09:22:34 +0100
Message-ID: <15721645544387@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2190168aaea42c31bff7b9a967e7b045f07df095 Mon Sep 17 00:00:00 2001
From: Steffen Maier <maier@linux.ibm.com>
Date: Tue, 1 Oct 2019 12:49:49 +0200
Subject: [PATCH] scsi: zfcp: fix reaction on bit error threshold notification

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
Cc: <stable@vger.kernel.org> #2.6.30+
Link: https://lore.kernel.org/r/20191001104949.42810-1-maier@linux.ibm.com
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 296bbc3c4606..cf63916814cc 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -27,6 +27,11 @@
 
 struct kmem_cache *zfcp_fsf_qtcb_cache;
 
+static bool ber_stop = true;
+module_param(ber_stop, bool, 0600);
+MODULE_PARM_DESC(ber_stop,
+		 "Shuts down FCP devices for FCP channels that report a bit-error count in excess of its threshold (default on)");
+
 static void zfcp_fsf_request_timeout_handler(struct timer_list *t)
 {
 	struct zfcp_fsf_req *fsf_req = from_timer(fsf_req, t, timer);
@@ -236,10 +241,15 @@ static void zfcp_fsf_status_read_handler(struct zfcp_fsf_req *req)
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

