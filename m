Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED80272E36
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgIUQrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbgIUQrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:47:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB6F82389F;
        Mon, 21 Sep 2020 16:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706821;
        bh=WiWAqd2NFS/VpEVznbbvD9dZ0N0TpPY0Rh6YenjeuCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEJM1ndZH5PIUppsqCELyOCFa/gn44fd/xWCTKm3+Xw7+HYVyeAuyNaV23F9vtoLW
         USHQuzzvBi0xTUDF2flTfZw8xUEjT45EuagEhFplVTJw4dPCpUjod7+NECI3DlybkJ
         0IADndU3AEmrntaQe60kTMsBSyijiurKa4db3FJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.8 107/118] s390/pci: fix leak of DMA tables on hard unplug
Date:   Mon, 21 Sep 2020 18:28:39 +0200
Message-Id: <20200921162041.346347826@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit afdf9550e54627fcf4dd609bdc1153059378cdf5 upstream.

commit f606b3ef47c9 ("s390/pci: adapt events for zbus") removed the
zpci_disable_device() call for a zPCI event with PEC 0x0304 because
the device is already deconfigured by the platform.
This however skips the Linux side of the disable in particular it leads
to leaking the DMA tables and bitmaps because zpci_dma_exit_device() is
never called on the device.

If the device transitions to the Reserved state we call zpci_zdev_put()
but zpci_release_device() will not call zpci_disable_device() because
the state of the zPCI function is already ZPCI_FN_STATE_STANDBY.

If the device is put into the Standby state, zpci_disable_device() is
not called and the device is assumed to have been put in Standby through
platform action.
At this point the device may be removed by a subsequent event with PEC
0x0308 or 0x0306 which calls zpci_zdev_put() with the same problem
as above or the device may be configured again in which case
zpci_disable_device() is also not called.

Fix this by calling zpci_disable_device() explicitly for PEC 0x0304 as
before. To make it more clear that zpci_disable_device() may be called,
even if the lower level device has already been disabled by the
platform, add a comment to zpci_disable_device().

Cc: <stable@vger.kernel.org> # 5.8
Fixes: f606b3ef47c9 ("s390/pci: adapt events for zbus")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/pci/pci.c       |    4 ++++
 arch/s390/pci/pci_event.c |    2 ++
 2 files changed, 6 insertions(+)

--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -668,6 +668,10 @@ EXPORT_SYMBOL_GPL(zpci_enable_device);
 int zpci_disable_device(struct zpci_dev *zdev)
 {
 	zpci_dma_exit_device(zdev);
+	/*
+	 * The zPCI function may already be disabled by the platform, this is
+	 * detected in clp_disable_fh() which becomes a no-op.
+	 */
 	return clp_disable_fh(zdev);
 }
 EXPORT_SYMBOL_GPL(zpci_disable_device);
--- a/arch/s390/pci/pci_event.c
+++ b/arch/s390/pci/pci_event.c
@@ -143,6 +143,8 @@ static void __zpci_event_availability(st
 			zpci_remove_device(zdev);
 		}
 
+		zdev->fh = ccdf->fh;
+		zpci_disable_device(zdev);
 		zdev->state = ZPCI_FN_STATE_STANDBY;
 		if (!clp_get_state(ccdf->fid, &state) &&
 		    state == ZPCI_FN_STATE_RESERVED) {


