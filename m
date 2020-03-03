Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C622E177EA6
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgCCRpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:45:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730855AbgCCRpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:45:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD08520CC7;
        Tue,  3 Mar 2020 17:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257506;
        bh=mluRKHVleJz3odTpqYoxkb/BWhkKlkwuyPc0vDOyUm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArtVWcLRjGHPznIgJX8kIyJ0UEEChplAmnreRvw02dVWhaHjRLFR4O30JxYdPZ4uh
         4isXBR6Og81DFKH+2ydl6N2kKB3HNcSh3LwnOAtFWScsTWbi812AoGIYs+fb6xw4uF
         qiVBSTSaYEAKzaHwqjH8mt4oBViKBfoZNvhxQvwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 021/176] ionic: fix fw_status read
Date:   Tue,  3 Mar 2020 18:41:25 +0100
Message-Id: <20200303174306.993690686@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit 68b759a75d6257759d1e37ff13f2d0659baf1112 ]

The fw_status field is only 8 bits, so fix the read.  Also,
we only want to look at the one status bit, to allow for future
use of the other bits, and watch for a bad PCI read.

Fixes: 97ca486592c0 ("ionic: add heartbeat check")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c |   11 +++++++----
 drivers/net/ethernet/pensando/ionic/ionic_if.h  |    1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -103,7 +103,7 @@ int ionic_heartbeat_check(struct ionic *
 {
 	struct ionic_dev *idev = &ionic->idev;
 	unsigned long hb_time;
-	u32 fw_status;
+	u8 fw_status;
 	u32 hb;
 
 	/* wait a little more than one second before testing again */
@@ -111,9 +111,12 @@ int ionic_heartbeat_check(struct ionic *
 	if (time_before(hb_time, (idev->last_hb_time + ionic->watchdog_period)))
 		return 0;
 
-	/* firmware is useful only if fw_status is non-zero */
-	fw_status = ioread32(&idev->dev_info_regs->fw_status);
-	if (!fw_status)
+	/* firmware is useful only if the running bit is set and
+	 * fw_status != 0xff (bad PCI read)
+	 */
+	fw_status = ioread8(&idev->dev_info_regs->fw_status);
+	if (fw_status == 0xff ||
+	    !(fw_status & IONIC_FW_STS_F_RUNNING))
 		return -ENXIO;
 
 	/* early FW has no heartbeat, else FW will return non-zero */
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -2348,6 +2348,7 @@ union ionic_dev_info_regs {
 		u8     version;
 		u8     asic_type;
 		u8     asic_rev;
+#define IONIC_FW_STS_F_RUNNING	0x1
 		u8     fw_status;
 		u32    fw_heartbeat;
 		char   fw_version[IONIC_DEVINFO_FWVERS_BUFLEN];


