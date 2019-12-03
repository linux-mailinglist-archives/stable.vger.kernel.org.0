Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A75111EB1
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbfLCWvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:51:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729952AbfLCWvu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:51:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D850F2084F;
        Tue,  3 Dec 2019 22:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413510;
        bh=pLdwTcVv4nJzrMhSx9V+PXwEcP0b77bICeFw26wTwJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trNuNh57daJ7yDcVUh8mrMiIFKHX9Qz8RCA9mOaQOHJ1XSeNx4xG9owPU55X61Bvk
         C4L3LuL82isfPoKzCmPAZQfCwCq14PXh/tojWN9e0jDoQbuoMtlnQ8OfA1TjZIIxfv
         b++COHlzERDeYegF172x0UondyLf7w13ElehRN6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bakker <xc-racer2@live.ca>,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 155/321] Bluetooth: hci_bcm: Handle specific unknown packets after firmware loading
Date:   Tue,  3 Dec 2019 23:33:41 +0100
Message-Id: <20191203223435.209741772@linuxfoundation.org>
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

From: Jonathan Bakker <xc-racer2@live.ca>

[ Upstream commit 22bba80500fdf624a7cfbb65fdfa97a038ae224d ]

The Broadcom controller on aries S5PV210 boards sends out a couple of
unknown packets after the firmware is loaded.  This will cause
logging of errors such as:
	Bluetooth: hci0: Frame reassembly failed (-84)

This is probably also the case with other boards, as there are related
Android userspace patches for custom ROMs such as
https://review.lineageos.org/#/c/LineageOS/android_system_bt/+/142721/
Since this appears to be intended behaviour, treated them as diagnostic
packets.

Note that this is another variant of commit 01d5e44ace8a
("Bluetooth: hci_bcm: Handle empty packet after firmware loading")

Signed-off-by: Jonathan Bakker <xc-racer2@live.ca>
Signed-off-by: Paweł Chmiel <pawel.mikolaj.chmiel@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_bcm.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
index aa6b7ed9fdf12..59e5fc5eec8f8 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -51,6 +51,12 @@
 #define BCM_LM_DIAG_PKT 0x07
 #define BCM_LM_DIAG_SIZE 63
 
+#define BCM_TYPE49_PKT 0x31
+#define BCM_TYPE49_SIZE 0
+
+#define BCM_TYPE52_PKT 0x34
+#define BCM_TYPE52_SIZE 0
+
 #define BCM_AUTOSUSPEND_DELAY	5000 /* default autosleep delay */
 
 /**
@@ -564,12 +570,28 @@ finalize:
 	.lsize = 0, \
 	.maxlen = BCM_NULL_SIZE
 
+#define BCM_RECV_TYPE49 \
+	.type = BCM_TYPE49_PKT, \
+	.hlen = BCM_TYPE49_SIZE, \
+	.loff = 0, \
+	.lsize = 0, \
+	.maxlen = BCM_TYPE49_SIZE
+
+#define BCM_RECV_TYPE52 \
+	.type = BCM_TYPE52_PKT, \
+	.hlen = BCM_TYPE52_SIZE, \
+	.loff = 0, \
+	.lsize = 0, \
+	.maxlen = BCM_TYPE52_SIZE
+
 static const struct h4_recv_pkt bcm_recv_pkts[] = {
 	{ H4_RECV_ACL,      .recv = hci_recv_frame },
 	{ H4_RECV_SCO,      .recv = hci_recv_frame },
 	{ H4_RECV_EVENT,    .recv = hci_recv_frame },
 	{ BCM_RECV_LM_DIAG, .recv = hci_recv_diag  },
 	{ BCM_RECV_NULL,    .recv = hci_recv_diag  },
+	{ BCM_RECV_TYPE49,  .recv = hci_recv_diag  },
+	{ BCM_RECV_TYPE52,  .recv = hci_recv_diag  },
 };
 
 static int bcm_recv(struct hci_uart *hu, const void *data, int count)
-- 
2.20.1



