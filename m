Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFF1111D21
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729763AbfLCWua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:50:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729065AbfLCWu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:50:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9120920865;
        Tue,  3 Dec 2019 22:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413428;
        bh=WxhQkwHJIFJqmiQcam91kuSyvW8HP7Zb7M0NPoHGyNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fgv1OZ+oaF9kO1bzA+CYyzdDbqZp+jOBjN8V9W2Lgba+fUUfz+Gg8g9PF8sEnmHTq
         s3XIqL/Kv5vtZzUME/M5f95saUwv9ZGvnw3ZjBPvYdoOQNUc6PR6MA040mdbOKf5Xb
         BxktVR/+1hCjW534fEtzljx6Z1PuR91Ll5IUKEuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 087/321] s390/zcrypt: make sysfs reset attribute trigger queue reset
Date:   Tue,  3 Dec 2019 23:32:33 +0100
Message-Id: <20191203223431.680575817@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

[ Upstream commit 42a87d4103ae365e18c3be1333592ab583b8ad9d ]

Until now there is no way to reset a AP queue or card. Driving a card
or queue offline and online again does only toggle the 'software'
online state. The only way to trigger a (hardware) reset is by running
hot-unplug/hot-plug for example on the HMC.

This patch makes the queue reset attribute in sysfs writable.
Writing into this attribute triggers a reset on the AP queue's state
machine. So the AP queue is flushed and state machine runs through the
initial states which cause a reset (PQAP(RAPQ)) and a re-registration
to interrupts (PQAP(AQIC)) if available.

The reset sysfs attribute is writable by root only. So only an
administrator is allowed to initiate a reset of AP queues. Please note
that the queue's counter values are left untouched by the reset.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_queue.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/ap_queue.c b/drivers/s390/crypto/ap_queue.c
index 0aa4b3ccc948c..576ac08777c50 100644
--- a/drivers/s390/crypto/ap_queue.c
+++ b/drivers/s390/crypto/ap_queue.c
@@ -14,6 +14,9 @@
 #include <asm/facility.h>
 
 #include "ap_bus.h"
+#include "ap_debug.h"
+
+static void __ap_flush_queue(struct ap_queue *aq);
 
 /**
  * ap_queue_enable_interruption(): Enable interruption on an AP queue.
@@ -541,7 +544,25 @@ static ssize_t reset_show(struct device *dev,
 	return rc;
 }
 
-static DEVICE_ATTR_RO(reset);
+static ssize_t reset_store(struct device *dev,
+			   struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct ap_queue *aq = to_ap_queue(dev);
+
+	spin_lock_bh(&aq->lock);
+	__ap_flush_queue(aq);
+	aq->state = AP_STATE_RESET_START;
+	ap_wait(ap_sm_event(aq, AP_EVENT_POLL));
+	spin_unlock_bh(&aq->lock);
+
+	AP_DBF(DBF_INFO, "reset queue=%02x.%04x triggered by user\n",
+	       AP_QID_CARD(aq->qid), AP_QID_QUEUE(aq->qid));
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(reset);
 
 static ssize_t interrupt_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
-- 
2.20.1



