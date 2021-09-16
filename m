Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3067640E127
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240697AbhIPQ16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240868AbhIPQZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:25:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 220D461250;
        Thu, 16 Sep 2021 16:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809020;
        bh=EYukma/3cUaLYbhuj/YOsFFa6vq8YYgKhLqCA59ZRzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kxv5Zul5x2JQres7QWV+nJVD8XEJwi8uzOye4UBFl3V7wDuwPbEdIZFS8wk1F7i8s
         dHLx23zg8J8tDidFT7kAtm1w69hhFd774KSGjgfysqbwAAYGjunRTz1YcceTk5fsG0
         EfohN7yzTi0TbI1jsNB4jrygj1LA37tE37qIpNQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 283/306] scsi: qla2xxx: Changes to support kdump kernel
Date:   Thu, 16 Sep 2021 18:00:28 +0200
Message-Id: <20210916155803.733269689@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
@@ -2828,6 +2829,11 @@ qla2x00_probe_one(struct pci_dev *pdev,
 			return ret;
 	}
 
+	if (is_kdump_kernel()) {
+		ql2xmqsupport = 0;
+		ql2xallocfwdump = 0;
+	}
+
 	/* This may fail but that's ok */
 	pci_enable_pcie_error_reporting(pdev);
 


