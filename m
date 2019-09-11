Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674E8AF89D
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 11:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfIKJOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 05:14:08 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39466 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfIKJOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 05:14:08 -0400
Received: by mail-ed1-f68.google.com with SMTP id u6so19945866edq.6
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 02:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ncentric-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=aWQg3/yTJKoBrmP0ThIO90wcxEVNeVhTCoh4r2Lm1tw=;
        b=XOnuyFwmHlVoZ48TAuHwrPQ35Hmpgoydtj0J2vTGE68aqVZ3DY3DiMq0FDjwjRL9OO
         8MsPpWQi1iAoLfo9hDv4cL54ksbrPnYGxvTHvZ2IKs85oAYBJOPl9gQDskvR8vsnooLf
         olQyZiqANLDyW0nTyv9LYcYBqcdaZaQNMaTZHb9u2uGX5rxiMHqd9jmJo8Ju8f8d5Cor
         05yBPZJ/auOzruM6R+k2SV8gpKCUs/KWrP0HVYWGDJNhREvnefON2TOl8R1cAaG/UyNB
         uq6b9FKO1bnPG0D9DZglol8g3BRG9Ekdns5/kpvhzXBbajkrVNUK/bc65IHdVYBCu/ef
         YIuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aWQg3/yTJKoBrmP0ThIO90wcxEVNeVhTCoh4r2Lm1tw=;
        b=BIUP4NnQ2hqan9AM3YoOMMUdPNkhlwmqhkBzm8BtL2GBYKJO/4ME7J+w5vGuZJJFtc
         VG5ED1F78QDcEojRAyNeMMfMV8UemxwwOaYf4Tr8AfYfcEmUuTt4Y9fQNUKXqnnoJvIa
         enhZowR3g/aXrRmy26XCvC89NPjhacI+UXB7Fv+Ogq5rNgip9DR3m8aZKk5XKOCaoLd+
         Wcdfj7HXTkgzEQNp1GKNkgbgAZzrRitjz8VdNsk0d1XkDanRuq3US/IPxeuM4PLjN004
         yYL8WV9RU2SVe5akO6cbhiW7yXsh1RkrOiAWZShVVNJNx4QA+qHkvDCVfnBonQ+37Lqk
         0V+w==
X-Gm-Message-State: APjAAAU5SlkeMU8tzeWLEzOSl8fuZyq5pzSiYweJPqCx/Velge29vYWL
        2a4RApjaeEYZZrSoebhq19cbmg==
X-Google-Smtp-Source: APXvYqzqjjfW6k5hKGuLWmBQMl8xE+rFpG4mxAG2m2Lbb8j9nSc5cAjS5zolBwY455lKYU7zzXIyrg==
X-Received: by 2002:a50:e614:: with SMTP id y20mr14839086edm.276.1568193245137;
        Wed, 11 Sep 2019 02:14:05 -0700 (PDT)
Received: from kvdp-BRIX.cmb.citymesh.com (d515300d8.static.telenet.be. [81.83.0.216])
        by smtp.gmail.com with ESMTPSA id i53sm2682361eda.33.2019.09.11.02.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 02:14:04 -0700 (PDT)
From:   Koen Vandeputte <koen.vandeputte@ncentric.com>
To:     linux-mips@linux-mips.org
Cc:     Koen Vandeputte <koen.vandeputte@ncentric.com>,
        Felix Fietkau <nbd@nbd.name>, Gabor Juhos <juhosg@freemail.hu>,
        James Hogan <jhogan@kernel.org>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>, stable@vger.kernel.org
Subject: [PATCH] MIPS: ath79: Fix potentially missed IRQ handling during dispatch
Date:   Wed, 11 Sep 2019 11:13:28 +0200
Message-Id: <20190911091328.32043-1-koen.vandeputte@ncentric.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If both interrupts are set in the current implementation
only the 1st will be handled and the 2nd will be skipped
due to the "if else" condition.

Fix this by using the same approach as done for QCA955x
just below it.

Fixes: fce5cc6e0ddc ("MIPS: ath79: add IRQ handling code for AR934X")
Signed-off-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
CC: Felix Fietkau <nbd@nbd.name>
CC: Gabor Juhos <juhosg@freemail.hu>
CC: James Hogan <jhogan@kernel.org>
CC: Paul Burton <paul.burton@mips.com>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: stable@vger.kernel.org # v3.2+
---

NOTE!
The file irq.c got deleted in commit 51fa4f8912c0 ("MIPS: ath79: drop legacy IRQ code")
which was included in 5.0-RC2.

Therefore, the patch below was crafted on
tree: linux-stable
branch: linux-4.19.y

 arch/mips/ath79/irq.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/mips/ath79/irq.c b/arch/mips/ath79/irq.c
index 2dfff1f19004..372431660cc7 100644
--- a/arch/mips/ath79/irq.c
+++ b/arch/mips/ath79/irq.c
@@ -32,15 +32,21 @@ static void ar934x_ip2_irq_dispatch(struct irq_desc *desc)
 	u32 status;
 
 	status = ath79_reset_rr(AR934X_RESET_REG_PCIE_WMAC_INT_STATUS);
+	status &= AR934X_PCIE_WMAC_INT_PCIE_ALL | AR934X_PCIE_WMAC_INT_WMAC_ALL;
+
+	if (status == 0) {
+		spurious_interrupt();
+		return;
+	}
 
 	if (status & AR934X_PCIE_WMAC_INT_PCIE_ALL) {
 		ath79_ddr_wb_flush(3);
-		generic_handle_irq(ATH79_IP2_IRQ(0));
-	} else if (status & AR934X_PCIE_WMAC_INT_WMAC_ALL) {
+		generic_handle_irq(ATH79_IP2_IRQ(0)););
+	}
+
+	if (status & AR934X_PCIE_WMAC_INT_WMAC_ALL) {
 		ath79_ddr_wb_flush(4);
 		generic_handle_irq(ATH79_IP2_IRQ(1));
-	} else {
-		spurious_interrupt();
 	}
 }
 
-- 
2.17.1

