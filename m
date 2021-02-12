Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F65B3198A3
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 04:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229467AbhBLDO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 22:14:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhBLDO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 22:14:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2D4464DB2;
        Fri, 12 Feb 2021 03:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613099657;
        bh=pHK+ewlOJt9vDOvOtyapA8TtTWhPlac8i4JGB6Iekhc=;
        h=From:To:Cc:Subject:Date:From;
        b=BRissRnGVDvGFOzxz9jH+Zs8MsVyBXa/qUx0yO8W/kir7hLJmCpvXTNzcfG34+WcQ
         l6tK0Ho/jB9m/NDrjc6RnSKzx3tMVIR5moQTgZiJOTQhAJUTVLvtRK1KIgDvn1AZwD
         siHLI/r1D+Wj0NQHpqigXsy9OjKWHl5nqbMHQ70iZCxJ+f/fUsbffmIwQ2pJ04nlx3
         0pS0UEIMot4J1zEshxfXIPnH04x715yrc5GJw2NQ5erS7l8Qb8GuvCUTTax/0bH2+c
         zg21IWnnbJfjvFYLY9kG4zXQynZ4Wy8I+cHOF25QPkCFa/pYxIoqI5O38EMarsGDLN
         VKQIBbwLklBIg==
From:   Stephen Boyd <sboyd@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] spmi: spmi-pmic-arb: Fix hw_irq overflow
Date:   Thu, 11 Feb 2021 19:14:17 -0800
Message-Id: <20210212031417.3148936-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraman Narayanamurthy <subbaram@codeaurora.org>

Currently, when handling the SPMI summary interrupt, the hw_irq
number is calculated based on SID, Peripheral ID, IRQ index and
APID. This is then passed to irq_find_mapping() to see if a
mapping exists for this hw_irq and if available, invoke the
interrupt handler. Since the IRQ index uses an "int" type, hw_irq
which is of unsigned long data type can take a large value when
SID has its MSB set to 1 and the type conversion happens. Because
of this, irq_find_mapping() returns 0 as there is no mapping
for this hw_irq. This ends up invoking cleanup_irq() as if
the interrupt is spurious whereas it is actually a valid
interrupt. Fix this by using the proper data type (u32) for id.

Cc: stable@vger.kernel.org
Signed-off-by: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
Link: https://lore.kernel.org/r/1612812784-26369-1-git-send-email-subbaram@codeaurora.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---

This is the only patch I've queued up this cycle for spmi.

 drivers/spmi/spmi-pmic-arb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index de844b412110..bbbd311eda03 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2012-2015, 2017, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2012-2015, 2017, 2021, The Linux Foundation. All rights reserved.
  */
 #include <linux/bitmap.h>
 #include <linux/delay.h>
@@ -505,8 +505,7 @@ static void cleanup_irq(struct spmi_pmic_arb *pmic_arb, u16 apid, int id)
 static void periph_interrupt(struct spmi_pmic_arb *pmic_arb, u16 apid)
 {
 	unsigned int irq;
-	u32 status;
-	int id;
+	u32 status, id;
 	u8 sid = (pmic_arb->apid_data[apid].ppid >> 8) & 0xF;
 	u8 per = pmic_arb->apid_data[apid].ppid & 0xFF;
 
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

