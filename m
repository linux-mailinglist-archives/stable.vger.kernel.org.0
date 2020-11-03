Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200142A5545
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388319AbgKCVHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388342AbgKCVHt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:07:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2D12207BC;
        Tue,  3 Nov 2020 21:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437667;
        bh=etcV+UXLV/zln4LlNdKqT0jAuZ2p6sIfPoGh2eAn/UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0B8IT7/jjx8FzMWD6AFjAw8YyVUjVl8kXS7FkFGjvqQ8n/ykJEdncUnBMdFOiRqi
         SDlJ4wbybm5bTOP5oPzDx9kyFJxZ5Aiy0rdkegoq/qFJ0TNo2AW8u06JvTKvbLm3M9
         aVN3y5pHKaKmdwyhWzuUQ158xFNmPy337XrLIVdA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 126/191] scsi: mptfusion: Fix null pointer dereferences in mptscsih_remove()
Date:   Tue,  3 Nov 2020 21:36:58 +0100
Message-Id: <20201103203244.982182765@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 2f4843b172c2c0360ee7792ad98025fae7baefde upstream.

The mptscsih_remove() function triggers a kernel oops if the Scsi_Host
pointer (ioc->sh) is NULL, as can be seen in this syslog:

 ioc0: LSI53C1030 B2: Capabilities={Initiator,Target}
 Begin: Waiting for root file system ...
 scsi host2: error handler thread failed to spawn, error = -4
 mptspi: ioc0: WARNING - Unable to register controller with SCSI subsystem
 Backtrace:
  [<000000001045b7cc>] mptspi_probe+0x248/0x3d0 [mptspi]
  [<0000000040946470>] pci_device_probe+0x1ac/0x2d8
  [<0000000040add668>] really_probe+0x1bc/0x988
  [<0000000040ade704>] driver_probe_device+0x160/0x218
  [<0000000040adee24>] device_driver_attach+0x160/0x188
  [<0000000040adef90>] __driver_attach+0x144/0x320
  [<0000000040ad7c78>] bus_for_each_dev+0xd4/0x158
  [<0000000040adc138>] driver_attach+0x4c/0x80
  [<0000000040adb3ec>] bus_add_driver+0x3e0/0x498
  [<0000000040ae0130>] driver_register+0xf4/0x298
  [<00000000409450c4>] __pci_register_driver+0x78/0xa8
  [<000000000007d248>] mptspi_init+0x18c/0x1c4 [mptspi]

This patch adds the necessary NULL-pointer checks.  Successfully tested on
a HP C8000 parisc workstation with buggy SCSI drives.

Link: https://lore.kernel.org/r/20201022090005.GA9000@ls3530.fritz.box
Cc: <stable@vger.kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/message/fusion/mptscsih.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1174,8 +1174,10 @@ mptscsih_remove(struct pci_dev *pdev)
 	MPT_SCSI_HOST		*hd;
 	int sz1;
 
-	if((hd = shost_priv(host)) == NULL)
-		return;
+	if (host == NULL)
+		hd = NULL;
+	else
+		hd = shost_priv(host);
 
 	mptscsih_shutdown(pdev);
 
@@ -1191,14 +1193,15 @@ mptscsih_remove(struct pci_dev *pdev)
 	    "Free'd ScsiLookup (%d) memory\n",
 	    ioc->name, sz1));
 
-	kfree(hd->info_kbuf);
+	if (hd)
+		kfree(hd->info_kbuf);
 
 	/* NULL the Scsi_Host pointer
 	 */
 	ioc->sh = NULL;
 
-	scsi_host_put(host);
-
+	if (host)
+		scsi_host_put(host);
 	mpt_detach(pdev);
 
 }


