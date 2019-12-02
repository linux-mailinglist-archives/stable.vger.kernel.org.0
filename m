Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7617310E822
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfLBKDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:03:54 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40110 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfLBKDx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:03:53 -0500
Received: by mail-wm1-f67.google.com with SMTP id t14so4918076wmi.5
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=t0RhdKt1OBlvUr3g8wwSzhDFoSAxtdel5n69P40ulHY=;
        b=Na/B3jcsJKsm/az0jfmMPnonDVOSKgZhjQo16Gamu6TFoGHNesAIJWbw/p0AyHEQbH
         zdvI1NL1m9y0q8LUhDV8g5qjz8NUOTYYPJOT98vSDKZ5lCYuIPXB+tO28JRPkd+s/tIh
         2cIowCRXfXjIta1TzaUJ8GcsFBK8cYxmMTtXkdSuz4D7sJwMMYUNFBY8EO8JOBTWcrWt
         QhNt1UcsSkBk/hMVs2Axi+COX8c4RtqH4xp7wCjvV9Ab4JehxfUPUx7Kz1TMfua5EiV2
         1RDv7DRHsZXSTPZB2teUzI9PX10m2GdfBO7Kvq3BL032OGDm67PtenzuYplL4BGf7Hr1
         BDHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t0RhdKt1OBlvUr3g8wwSzhDFoSAxtdel5n69P40ulHY=;
        b=PJ9dCTlhbSgzYfyJ97+jWmpL/pezjKL5IgeSZT8S42j0iCL4wjo6Dx9C0t9shou8KH
         To1MWGrioHwDcf69EjSFv3kHN9KP6E2ovcTcbzEbyc6y12fuAuCdDiKUMwXOlL739AXN
         Z+e6gaXpvR9nW/87S4AWlWKhPnJHaxWWwWU/hHK96HGRijR6VLsvFZNSBXyMEw1JFM0a
         O+cP6y2XfwARYy1Cu/MjuWcqSFFJPshwYzXUbbqCsfZ2lE9JmkD7eCeP9fGa3oRUGWQp
         VjMEV/nQK4zGKWPNgKF4HlVBvN7q44X/dRN7StWDqCzbf9Ld7pL0v1VwjWmf3a6iXd6d
         JvUQ==
X-Gm-Message-State: APjAAAVmaTHDg0hbIcTBri3XgQHbp8iNBnXALQ6dEysqKgfUXZG7iO8+
        bJYKIS5Z8oEASLIjnl4sD6x/qHGyKxM=
X-Google-Smtp-Source: APXvYqzB6ddC6lgukGlpLOirt2owSYZ1LRaAyT5YdMkXVfRwPNcN7PGNIvhBx1ON7ObjF/RrOedRlQ==
X-Received: by 2002:a7b:c449:: with SMTP id l9mr15362557wmi.150.1575281031363;
        Mon, 02 Dec 2019 02:03:51 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id h8sm22975665wrx.63.2019.12.02.02.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:03:50 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 04/14] net: macb: Fix SUBNS increment and increase resolution
Date:   Mon,  2 Dec 2019 10:03:02 +0000
Message-Id: <20191202100312.1397-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202100312.1397-1-lee.jones@linaro.org>
References: <20191202100312.1397-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

[ Upstream commit 7ad342bc58cc5197cd2f12a3c30b3949528c6d83 ]

The subns increment register has 24 bits as follows:
RegBit[15:0] = Subns[23:8]; RegBit[31:24] = Subns[7:0]

Fix the same in the driver and increase sub ns resolution to the
best capable, 24 bits. This should be the case on all GEM versions
that this PTP driver supports.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/ethernet/cadence/macb.h     | 6 +++++-
 drivers/net/ethernet/cadence/macb_ptp.c | 5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index c93f3a2dc6c1..4c0bcfd1d250 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -457,7 +457,11 @@
 
 /* Bitfields in TISUBN */
 #define GEM_SUBNSINCR_OFFSET			0
-#define GEM_SUBNSINCR_SIZE			16
+#define GEM_SUBNSINCRL_OFFSET			24
+#define GEM_SUBNSINCRL_SIZE			8
+#define GEM_SUBNSINCRH_OFFSET			0
+#define GEM_SUBNSINCRH_SIZE			16
+#define GEM_SUBNSINCR_SIZE			24
 
 /* Bitfields in TI */
 #define GEM_NSINCR_OFFSET			0
diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 678835136bf8..f1f07e9d53f8 100755
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -115,7 +115,10 @@ static int gem_tsu_incr_set(struct macb *bp, struct tsu_incr *incr_spec)
 	 * to take effect.
 	 */
 	spin_lock_irqsave(&bp->tsu_clk_lock, flags);
-	gem_writel(bp, TISUBN, GEM_BF(SUBNSINCR, incr_spec->sub_ns));
+	/* RegBit[15:0] = Subns[23:8]; RegBit[31:24] = Subns[7:0] */
+	gem_writel(bp, TISUBN, GEM_BF(SUBNSINCRL, incr_spec->sub_ns) |
+		   GEM_BF(SUBNSINCRH, (incr_spec->sub_ns >>
+			  GEM_SUBNSINCRL_SIZE)));
 	gem_writel(bp, TI, GEM_BF(NSINCR, incr_spec->ns));
 	spin_unlock_irqrestore(&bp->tsu_clk_lock, flags);
 
-- 
2.24.0

