Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 461131060B0
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbfKVFvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:51:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728059AbfKVFvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E51120731;
        Fri, 22 Nov 2019 05:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401873;
        bh=HA1qjHd1T3/y1oTFjb4/iw4zfU/8Qyh1cA8GBBjPN5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLeno+aSvAFYCKNgP2M/0I5mi0poslSvgW1t9S7p4WoYOxhyUnRVClaJCysT1611Y
         ewauE9MrXQl4/pSY9Kiz/pLDrQSJot+3VwRxGYDfFx2Hra6x49B2W2nOJjpzRYZjJQ
         sF2mm6owyINWcT5ntM6uAEttR4c80JyH7OaDbG2M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Bakker <xc-racer2@live.ca>,
        =?UTF-8?q?Pawe=C5=82=20Chmiel?= <pawel.mikolaj.chmiel@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 109/219] Bluetooth: hci_bcm: Handle specific unknown packets after firmware loading
Date:   Fri, 22 Nov 2019 00:47:21 -0500
Message-Id: <20191122054911.1750-102-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -564,12 +570,28 @@ static int bcm_setup(struct hci_uart *hu)
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

