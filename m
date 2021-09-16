Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131DC40E4E9
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347834AbhIPRGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34075 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348561AbhIPRDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:03:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0832061B08;
        Thu, 16 Sep 2021 16:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810046;
        bh=7v8WPcLkYymwYWg0PjuXN815yCO0SB5CuEDstJcHU88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBpLHK1kMGfhEXUTMHevCyv34TnygqtLkSqX/5kdSaBwsxPR/2XRidFo2FAO82+Kd
         OHtb9pRksoXCrwTdHvqce11cPG91zx3pvCh31rMSwo/L721fSVEMe/cquzicrZFQwq
         7OOu7AR+dC2QP36ocEk2p9rw+LNULFpGN9oagpfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.13 351/380] scsi: qla2xxx: Changes to support kdump kernel
Date:   Thu, 16 Sep 2021 18:01:48 +0200
Message-Id: <20210916155815.991759371@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

commit 62e0dec59c1e139dab55aff5aa442adc97804271 upstream.

Avoid allocating firmware dump and only allocate a single queue for a kexec
kernel.

Link: https://lore.kernel.org/r/20210810043720.1137-12-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/blk-mq-pci.h>
 #include <linux/refcount.h>
+#include <linux/crash_dump.h>
 
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -2818,6 +2819,11 @@ qla2x00_probe_one(struct pci_dev *pdev,
 			return ret;
 	}
 
+	if (is_kdump_kernel()) {
+		ql2xmqsupport = 0;
+		ql2xallocfwdump = 0;
+	}
+
 	/* This may fail but that's ok */
 	pci_enable_pcie_error_reporting(pdev);
 


