Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5B113A4E2
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgANKDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:03:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:58042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgANKDR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:03:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6922B2465B;
        Tue, 14 Jan 2020 10:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996197;
        bh=z+j12MR7yYmLLELtA9jkABUaAXHiSBqS2s/W2w96+MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o+8+edrPj0y2xsTxxHMJvEXwmz+iJopnwCrSJnepYx+Bz/b3OUBiUyEo55JVqjXaY
         7HLvp0Jw0XYZeBxIrflFK8JbPROl3WYbFWAgL2ktAIjWH0qCEqTgxhL9dEGRyqclP6
         pPoI3B6QIrPe2e8y3SgwZVqHns9bAEHDWMBjjqhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.4 02/78] i2c: fix bus recovery stop mode timing
Date:   Tue, 14 Jan 2020 11:00:36 +0100
Message-Id: <20200114094352.828392087@linuxfoundation.org>
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

From: Russell King <rmk+kernel@armlinux.org.uk>

commit cf8ce8b80f8bf9669f6ec4e71e16668430febdac upstream.

The I2C specification states that tsu:sto for standard mode timing must
be at minimum 4us. Pictographically, this is:

SCL: ____/~~~~~~~~~
SDA: _________/~~~~
       ->|    |<- 4us minimum

We are currently waiting 2.5us between asserting SCL and SDA, which is
in violation of the standard. Adjust the timings to ensure that we meet
what is stipulated as the minimum timings to ensure that all devices
correctly interpret the STOP bus transition.

This is more important than trying to generate a square wave with even
duty cycle.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/i2c-core-base.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -186,10 +186,11 @@ int i2c_generic_scl_recovery(struct i2c_
 	 * If we can set SDA, we will always create a STOP to ensure additional
 	 * pulses will do no harm. This is achieved by letting SDA follow SCL
 	 * half a cycle later. Check the 'incomplete_write_byte' fault injector
-	 * for details.
+	 * for details. Note that we must honour tsu:sto, 4us, but lets use 5us
+	 * here for simplicity.
 	 */
 	bri->set_scl(adap, scl);
-	ndelay(RECOVERY_NDELAY / 2);
+	ndelay(RECOVERY_NDELAY);
 	if (bri->set_sda)
 		bri->set_sda(adap, scl);
 	ndelay(RECOVERY_NDELAY / 2);
@@ -211,7 +212,13 @@ int i2c_generic_scl_recovery(struct i2c_
 		scl = !scl;
 		bri->set_scl(adap, scl);
 		/* Creating STOP again, see above */
-		ndelay(RECOVERY_NDELAY / 2);
+		if (scl)  {
+			/* Honour minimum tsu:sto */
+			ndelay(RECOVERY_NDELAY);
+		} else {
+			/* Honour minimum tf and thd:dat */
+			ndelay(RECOVERY_NDELAY / 2);
+		}
 		if (bri->set_sda)
 			bri->set_sda(adap, scl);
 		ndelay(RECOVERY_NDELAY / 2);


