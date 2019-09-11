Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC427AFD35
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 14:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbfIKM4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 08:56:30 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45203 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbfIKM43 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 08:56:29 -0400
Received: by mail-ed1-f65.google.com with SMTP id f19so20490325eds.12
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 05:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ncentric-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=V6qV3bOzzEvIS363kFb3i622G7Da90Zr+m9RlztlQz0=;
        b=OGIP6BkqIQ41pySk7YLMJpoXQg0olNRmuXnNu1N+TUxEO3SqI3tpTAyPJm7leP7z9C
         TGCbnKVgXPQy/YTtYWQ6NFX2v2j4M53+2vHXwTDnW2TjSCq+C0ubY2HmLlBhj5fpkquH
         +Dx64s6AfxRt0JqmPoZgZTnzS14Yai8k5sBgM2n5wDNcoszYuBLphhnwqWrTyBOY9Yfo
         bfIIPvAGGHCVn9Ch8dVg3ezJub8dr4bjCGfmIZJobV1vrtE+dzqJJhtlifdgSLwJQbAp
         3gNuxQpUzCM0lmbXQPd0hUrFJnVTg1B3R+jaX2vIjt88xiEedLyDnqaDoD6j4ow7YjrE
         8glA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V6qV3bOzzEvIS363kFb3i622G7Da90Zr+m9RlztlQz0=;
        b=i43/UD97lu0DGAfWWPMxeAE32MuFSMMoNZch4GeFP2fdBLQOcKiPi8pUMVoCumI0x4
         cNDWnaFdcvaP2MjxKtRSS3YecZOkBUa1sEy5jwt6BlpI2HAz4lXlsbANAtlLVIg3XqYK
         +vy4R43k5jm00QGIqbGduTVqj1pix9PjIvQNDk8qR7syJFpLFn1KHWAS9WSSaWw+1Dl3
         qod/uUD+jPaUxXBIYhWM0h8nnSbvcsB+HxapN+lQklCzd5IPbDByIfJKXMzQKFwKeQfr
         gflgFSc9NeORzfxLl9ymK/ONZfoY/FCXJZqW9hM74Z8Ce8u6ZWZ60hfs2fF4B2u4jR4I
         eWCw==
X-Gm-Message-State: APjAAAXf1lVWNSgWMRJAD04ye3OxB8IT6Ks9BFTAvjDssc4vOBrydUmC
        Uutkyh5IFE7FqBW+YQY9T+0G5A==
X-Google-Smtp-Source: APXvYqyToAaQhVoEOV3y3M2lWJkWg0uWSlDyUiZmvnWHhMwzaKIuzTStSdEa6Scouayou1LxRs2f6g==
X-Received: by 2002:a17:907:2161:: with SMTP id rl1mr28632821ejb.142.1568206587904;
        Wed, 11 Sep 2019 05:56:27 -0700 (PDT)
Received: from kvdp-BRIX.cmb.citymesh.com (d515300d8.static.telenet.be. [81.83.0.216])
        by smtp.gmail.com with ESMTPSA id h11sm4133864edq.74.2019.09.11.05.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 05:56:27 -0700 (PDT)
From:   Koen Vandeputte <koen.vandeputte@ncentric.com>
To:     linux-mips@linux-mips.org
Cc:     Koen Vandeputte <koen.vandeputte@ncentric.com>,
        Felix Fietkau <nbd@nbd.name>, Gabor Juhos <juhosg@freemail.hu>,
        James Hogan <jhogan@kernel.org>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>, stable@vger.kernel.org
Subject: [PATCH v2] MIPS: ath79: Fix potentially missed IRQ handling during dispatch
Date:   Wed, 11 Sep 2019 14:55:44 +0200
Message-Id: <20190911125544.8137-1-koen.vandeputte@ncentric.com>
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

V2:
- fix copy/paste error in code due to rebasing


 arch/mips/ath79/irq.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/mips/ath79/irq.c b/arch/mips/ath79/irq.c
index 2dfff1f19004..a03a6bcaf6fd 100644
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
 		generic_handle_irq(ATH79_IP2_IRQ(0));
-	} else if (status & AR934X_PCIE_WMAC_INT_WMAC_ALL) {
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

