Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939881F28E3
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgFHX47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731170AbgFHXXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:23:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0F4A20872;
        Mon,  8 Jun 2020 23:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658615;
        bh=4p3kFaNwbjzRd7XMk2dV+c7fRUlfKlHkAbQyxboRuws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMr9AhyIspDlK2o0MbcRPmEnVCvsrfcLOb4VS+bp+JBod4MDUYrGIlKB39t++5MBV
         z1FgPGiRXg4yzIlkfG6MbiD0ZDIyqtu8cxtZUrgT51e/F+U3ATZCw4CYYxr59jHdGZ
         OjEZvjTkCuitiBkKVTeXGHWhfPlNuy4NIgTAnvIA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 041/106] Bluetooth: btbcm: Add 2 missing models to subver tables
Date:   Mon,  8 Jun 2020 19:21:33 -0400
Message-Id: <20200608232238.3368589-41-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit c03ee9af4e07112bd3fc688daca9e654f41eca93 ]

Currently the bcm_uart_subver_ and bcm_usb_subver_table-s lack entries
for the BCM4324B5 and BCM20703A1 chipsets. This makes the code use just
"BCM" as prefix for the filename to pass to request-firmware, making it
harder for users to figure out which firmware they need. This especially
is problematic with the UART attached BCM4324B5 where this leads to the
filename being just "BCM.hcd".

Add the 2 missing devices to subver tables. This has been tested on:

1. A Dell XPS15 9550 where this makes btbcm.c try to load
"BCM20703A1-0a5c-6410.hcd" before it tries to load "BCM-0a5c-6410.hcd".

2. A Thinkpad 8 where this makes btbcm.c try to load
"BCM4324B5.hcd" before it tries to load "BCM.hcd"

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btbcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index e3e4d929e74f..ff6203c331ff 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -324,6 +324,7 @@ static const struct bcm_subver_table bcm_uart_subver_table[] = {
 	{ 0x4103, "BCM4330B1"	},	/* 002.001.003 */
 	{ 0x410e, "BCM43341B0"	},	/* 002.001.014 */
 	{ 0x4406, "BCM4324B3"	},	/* 002.004.006 */
+	{ 0x4606, "BCM4324B5"	},	/* 002.006.006 */
 	{ 0x6109, "BCM4335C0"	},	/* 003.001.009 */
 	{ 0x610c, "BCM4354"	},	/* 003.001.012 */
 	{ 0x2122, "BCM4343A0"	},	/* 001.001.034 */
@@ -334,6 +335,7 @@ static const struct bcm_subver_table bcm_uart_subver_table[] = {
 };
 
 static const struct bcm_subver_table bcm_usb_subver_table[] = {
+	{ 0x2105, "BCM20703A1"	},	/* 001.001.005 */
 	{ 0x210b, "BCM43142A0"	},	/* 001.001.011 */
 	{ 0x2112, "BCM4314A0"	},	/* 001.001.018 */
 	{ 0x2118, "BCM20702A0"	},	/* 001.001.024 */
-- 
2.25.1

