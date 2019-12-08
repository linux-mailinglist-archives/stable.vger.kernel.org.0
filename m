Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 646771161F9
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfLHN4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:56:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60356 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726838AbfLHNyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1E-0007fd-I0; Sun, 08 Dec 2019 13:54:40 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1D-0002OC-6O; Sun, 08 Dec 2019 13:54:39 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Chien Nguyen" <chien.nguyen.eb@rvc.renesas.com>,
        "Chris Brandt" <chris.brandt@renesas.com>,
        "Wolfram Sang" <wsa@the-dreams.de>
Date:   Sun, 08 Dec 2019 13:53:31 +0000
Message-ID: <lsq.1575813165.904224616@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 47/72] i2c: riic: Clear NACK in tend isr
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Brandt <chris.brandt@renesas.com>

commit a71e2ac1f32097fbb2beab098687a7a95c84543e upstream.

The NACKF flag should be cleared in INTRIICNAKI interrupt processing as
description in HW manual.

This issue shows up quickly when PREEMPT_RT is applied and a device is
probed that is not plugged in (like a touchscreen controller). The result
is endless interrupts that halt system boot.

Fixes: 310c18a41450 ("i2c: riic: add driver")
Reported-by: Chien Nguyen <chien.nguyen.eb@rvc.renesas.com>
Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/i2c/busses/i2c-riic.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-riic.c
+++ b/drivers/i2c/busses/i2c-riic.c
@@ -212,6 +212,7 @@ static irqreturn_t riic_tend_isr(int irq
 	if (readb(riic->base + RIIC_ICSR2) & ICSR2_NACKF) {
 		/* We got a NACKIE */
 		readb(riic->base + RIIC_ICDRR);	/* dummy read */
+		riic_clear_set_bit(riic, ICSR2_NACKF, 0, RIIC_ICSR2);
 		riic->err = -ENXIO;
 	} else if (riic->bytes_left) {
 		return IRQ_NONE;

