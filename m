Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15E8613A5EB
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbgANKF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:05:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730242AbgANKF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:05:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5682324679;
        Tue, 14 Jan 2020 10:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996355;
        bh=RBXAiiyvsTUqqMd8QvTDja/F0J5+e2uKRVWGvdJhjRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEFQ9es+YLoIlX5akc0+yB5C3VRWIwOsqwKftJQc8f2gXixuQMZHCSNJvq8D/gnSX
         EU79rDBcGqz/ec28Zba4L65tFBpLeTmotqZjjsxDP5oDAQrTcc1S3rXWaFnY1d9XW1
         FRFlcIKtiyCUo+NXl72vAOppvNAxHn0ijZ4MXBuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 44/78] USB-PD tcpm: bad warning+size, PPS adapters
Date:   Tue, 14 Jan 2020 11:01:18 +0100
Message-Id: <20200114094359.462572888@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Gilbert <dgilbert@interlog.com>

commit c215e48e97d232249a33849fc46fc50311043e11 upstream.

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
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191230033544.1809-1-dgilbert@interlog.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/tcpm/tcpci.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -432,20 +432,30 @@ irqreturn_t tcpci_irq(struct tcpci *tcpc
 
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


