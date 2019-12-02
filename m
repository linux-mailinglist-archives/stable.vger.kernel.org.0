Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD4A10E8E3
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfLBKbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:11 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33238 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbfLBKbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:11 -0500
Received: by mail-wm1-f68.google.com with SMTP id y23so10390822wma.0
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=g1aRXdZIL7DyaMdVPCxZFmg5TXh5yLg89o9u2qBK/18=;
        b=M/LUdfYXDFOh+XWQ9Rid95XqG8HePYh04/nxkU3XAUPvAuFwwGmgoLU5b53xU6nLr0
         DhunGG5IXWEzdT3cvCyC0/RcaycOyy6ZsMyAJCmem6ZQkXLMMcYsSuzezVR9jePR2LOO
         T+BiIIb9JfisxP0zSXTIBZeEVUBMrDEyWiVtYM2RBqL8tZpFQ4GhIQpdFGGijRMHCyNL
         nciSJ1vOxoUdR4XC1Js7PQLgQvjz89edO+QsPYRqrSXeZBf7PqQfh4HKO1cs0zytCEZF
         DtjT41hnHzuRnkan42rRHCHJFhAed5P/hKUCZxDDxF1JUTaof+Vp5i8Olylj3W9h7So6
         dtsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g1aRXdZIL7DyaMdVPCxZFmg5TXh5yLg89o9u2qBK/18=;
        b=iit6GvCHvCOapXNXE7IPfmjVOvR6llasOmlaE9rlwMpButuqHHdMjzYF3R51khTvV2
         sWF0Tt6urPvEcYUM9rD5Mq3S5Z7PDCGay7thKPCaIRvyZdJ1WokHlLFcY8L2PsQaUzPu
         VL5C8TvDzAuj79kSDYbWFBG9FhQqMGJg6Kpw9XqDMYWODetc6mQ3Iy7rlaF0Ha2m7NrW
         jGOB9KUqBv/BA9sKugBttWpa5NRfrmm47MiSSg9XGrHx4PIUA02T91+r7Kb7jQeH62XS
         gczMTXCtoaQFySdPbTCWauBc1tTbRvqYOeKeXAL4MXeIh50xJZ/ZZncda0IVg7aQs0Lg
         5v2A==
X-Gm-Message-State: APjAAAUxFrDZyWEFxhROnV/+Az7UgKSqVpfnIO85qw+aZLWya4Xk/jcb
        cjWr02VJG62RM09osaDJjWGtpdOqMgI=
X-Google-Smtp-Source: APXvYqxbY7iK+AW3Ny4Ea7fo8vNB26LBVz5cN3KvdyMjGw6rnDQUCpidYb/eTnEddyHDjXRIBbBYUA==
X-Received: by 2002:a1c:7d92:: with SMTP id y140mr26772766wmc.145.1575282668811;
        Mon, 02 Dec 2019 02:31:08 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:08 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 05/15] net: macb: Fix SUBNS increment and increase resolution
Date:   Mon,  2 Dec 2019 10:30:40 +0000
Message-Id: <20191202103050.2668-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202103050.2668-1-lee.jones@linaro.org>
References: <20191202103050.2668-1-lee.jones@linaro.org>
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
index 9bbaad9f3d63..efb44d5ab021 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -499,7 +499,11 @@
 
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
index a6dc47edc4cf..8f912de44def 100644
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

