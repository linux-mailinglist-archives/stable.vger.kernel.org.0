Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95203291C2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243393AbhCAUca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:32:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241666AbhCAUZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:25:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 125E265280;
        Mon,  1 Mar 2021 18:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621985;
        bh=1PQ3JsHWo4Nc9LXhJamVs6DwzFWqmCbPJVuiPP5Af5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y13EpKFKa/B5mcxWxAY/8k3VnOJwXcYXrAuYkGK+NwSkzzDOabf2YtomGPQYRUueJ
         t8/Em/rkb6GnhdHPDZQpn3tK33JUOauSvfG1Am9o8dgKebk9TEXrbnOsLPJ+I32cRq
         NJ6f2pMnRXLLLnh5zmfdacZFyFtESOF/5Ss+PgRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.11 715/775] spmi: spmi-pmic-arb: Fix hw_irq overflow
Date:   Mon,  1 Mar 2021 17:14:43 +0100
Message-Id: <20210301161236.681795934@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraman Narayanamurthy <subbaram@codeaurora.org>

commit d19db80a366576d3ffadf2508ed876b4c1faf959 upstream.

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
Link: https://lore.kernel.org/r/20210212031417.3148936-1-sboyd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spmi/spmi-pmic-arb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

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
@@ -505,8 +505,7 @@ static void cleanup_irq(struct spmi_pmic
 static void periph_interrupt(struct spmi_pmic_arb *pmic_arb, u16 apid)
 {
 	unsigned int irq;
-	u32 status;
-	int id;
+	u32 status, id;
 	u8 sid = (pmic_arb->apid_data[apid].ppid >> 8) & 0xF;
 	u8 per = pmic_arb->apid_data[apid].ppid & 0xFF;
 


