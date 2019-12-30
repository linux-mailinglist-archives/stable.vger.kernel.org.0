Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D43C12CC2C
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 04:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfL3Df6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 22:35:58 -0500
Received: from smtp.infotech.no ([82.134.31.41]:59458 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbfL3Df6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 22:35:58 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id C945B204247;
        Mon, 30 Dec 2019 04:35:55 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0AVJGC7Mh64q; Mon, 30 Dec 2019 04:35:48 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 00741204157;
        Mon, 30 Dec 2019 04:35:47 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-usb@vger.kernel.org
Cc:     linux@roeck-us.net, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] USB-PD tcpm: bad warning+size, PPS adapters
Date:   Sun, 29 Dec 2019 22:35:44 -0500
Message-Id: <20191230033544.1809-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Augmented Power Delivery Objects (A)PDO_s are used by USB-C
PD power adapters to advertize the voltages and currents
they support. There can be up to 7 PDO_s but before PPS
(programmable power supply) there were seldom more than 4
or 5. Recently Samsung released an optional PPS 45 Watt power
adapter (EP-TA485) that has 7 PDO_s. It is for the Galaxy 10+
tablet and charges it quicker than the adapter supplied at
purchase. The EP-TA485 causes an overzealous WARN_ON to soil
the log plus it miscalculates the number of bytes to read.

So this bug has been there for some time but goes
undetected for the majority of USB-C PD power adapters on
the market today that have 6 or less PDO_s. That may soon
change as more USB-C PD adapters with PPS come to market.

Tested on a EP-TA485 and an older Lenovo PN: SA10M13950
USB-C 65 Watt adapter (without PPS and has 4 PDO_s) plus
several other PD power adapters.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/usb/typec/tcpm/tcpci.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
index c1f7073a56de..8b4ff9fff340 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -432,20 +432,30 @@ irqreturn_t tcpci_irq(struct tcpci *tcpci)
 
 	if (status & TCPC_ALERT_RX_STATUS) {
 		struct pd_message msg;
-		unsigned int cnt;
+		unsigned int cnt, payload_cnt;
 		u16 header;
 
 		regmap_read(tcpci->regmap, TCPC_RX_BYTE_CNT, &cnt);
+		/*
+		 * 'cnt' corresponds to READABLE_BYTE_COUNT in section 4.4.14
+		 * of the TCPCI spec [Rev 2.0 Ver 1.0 October 2017] and is
+		 * defined in table 4-36 as one greater than the number of
+		 * bytes received. And that number includes the header. So:
+		 */
+		if (cnt > 3)
+			payload_cnt = cnt - (1 + sizeof(msg.header));
+		else
+			payload_cnt = 0;
 
 		tcpci_read16(tcpci, TCPC_RX_HDR, &header);
 		msg.header = cpu_to_le16(header);
 
-		if (WARN_ON(cnt > sizeof(msg.payload)))
-			cnt = sizeof(msg.payload);
+		if (WARN_ON(payload_cnt > sizeof(msg.payload)))
+			payload_cnt = sizeof(msg.payload);
 
-		if (cnt > 0)
+		if (payload_cnt > 0)
 			regmap_raw_read(tcpci->regmap, TCPC_RX_DATA,
-					&msg.payload, cnt);
+					&msg.payload, payload_cnt);
 
 		/* Read complete, clear RX status alert bit */
 		tcpci_write16(tcpci, TCPC_ALERT, TCPC_ALERT_RX_STATUS);
-- 
2.24.1

