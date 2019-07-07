Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9470616CF
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfGGTnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:43:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57558 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727603AbfGGTiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:11 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz8-0006jU-Va; Sun, 07 Jul 2019 20:38:07 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz6-0005dN-I6; Sun, 07 Jul 2019 20:38:04 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Lubomir Rintel" <lkundrak@v3.sk>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.503602606@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 088/129] serial: 8250_of: assume reg-shift of 2 for
 mrvl,mmp-uart
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lubomir Rintel <lkundrak@v3.sk>

commit f4817843e39ce78aace0195a57d4e8500a65a898 upstream.

There are two other drivers that bind to mrvl,mmp-uart and both of them
assume register shift of 2 bits. There are device trees that lack the
property and rely on that assumption.

If this driver wins the race to bind to those devices, it should behave
the same as the older deprecated driver.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/of_serial.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -93,6 +93,10 @@ static int of_platform_serial_setup(stru
 	if (of_property_read_u32(np, "reg-offset", &prop) == 0)
 		port->mapbase += prop;
 
+	/* Compatibility with the deprecated pxa driver and 8250_pxa drivers. */
+	if (of_device_is_compatible(np, "mrvl,mmp-uart"))
+		port->regshift = 2;
+
 	/* Check for registers offset within the devices address range */
 	if (of_property_read_u32(np, "reg-shift", &prop) == 0)
 		port->regshift = prop;

