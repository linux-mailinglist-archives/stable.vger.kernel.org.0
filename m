Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1C4112E8CD
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 17:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgABQkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 11:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbgABQkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 11:40:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA1E4206E6;
        Thu,  2 Jan 2020 16:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577983205;
        bh=c+82fZGOsuyJwp6ZEsnIjsNnXYCMwy89FFBRu9fmbJM=;
        h=Subject:To:From:Date:From;
        b=MhnfZ/YzcdeUR9JItpc8uhQT5ThsiPJMTT2fW1SnDobUH/JDN+KDfd1/LgaDjqjxt
         1XAIwnvA2XqpSQBRuai9G5Gu/ejsLgBg9x6zB1OME2xkOnT1OeA1b8QlLrlJOa5Au0
         C/3HMnMESYaprS4LxiacrmscBdmrSxLj9IG46RlE=
Subject: patch "USB-PD tcpm: bad warning+size, PPS adapters" added to usb-linus
To:     dgilbert@interlog.com, gregkh@linuxfoundation.org,
        linux@roeck-us.net, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 02 Jan 2020 17:40:02 +0100
Message-ID: <157798320250159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB-PD tcpm: bad warning+size, PPS adapters

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c215e48e97d232249a33849fc46fc50311043e11 Mon Sep 17 00:00:00 2001
From: Douglas Gilbert <dgilbert@interlog.com>
Date: Sun, 29 Dec 2019 22:35:44 -0500
Subject: USB-PD tcpm: bad warning+size, PPS adapters

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


