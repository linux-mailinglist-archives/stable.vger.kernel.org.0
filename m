Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E591C4512
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731468AbgEDSMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731399AbgEDSCx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:02:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74B4D2073E;
        Mon,  4 May 2020 18:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615371;
        bh=YtQEHYARyOrdGFRJN/zgntJn5+hi7Pt8/Yuu+ZrkoMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aaDyd2GXyaK6UgtOkZqINDOBN2egDuChzvEvRYS31KJIiYXzaOSxfrBwPFZTLbqUX
         aXfIGXTrtO2AB4liUdv0r0y8NTae3FiLO5AA0udXZ2C/ns6rvDGDB96Ro3aIq0ncRL
         Ip37mLSU9lXYk3a1igBBGqxHSCdkXOm/VxpF+U/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 12/57] mmc: cqhci: Avoid false "cqhci: CQE stuck on" by not open-coding timeout loop
Date:   Mon,  4 May 2020 19:57:16 +0200
Message-Id: <20200504165457.514098873@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit b1ac62a7ac386d76968af5f374a4a7a82a35fe31 upstream.

Open-coding a timeout loop invariably leads to errors with handling
the timeout properly in one corner case or another.  In the case of
cqhci we might report "CQE stuck on" even if it wasn't stuck on.
You'd just need this sequence of events to happen in cqhci_off():

1. Call ktime_get().
2. Something happens to interrupt the CPU for > 100 us (context switch
   or interrupt).
3. Check time and; set "timed_out" to true since > 100 us.
4. Read CQHCI_CTL.
5. Both "reg & CQHCI_HALT" and "timed_out" are true, so break.
6. Since "timed_out" is true, falsely print the error message.

Rather than fixing the polling loop, use readx_poll_timeout() like
many people do.  This has been time tested to handle the corner cases.

Fixes: a4080225f51d ("mmc: cqhci: support for command queue enabled host")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200413162717.1.Idece266f5c8793193b57a1ddb1066d030c6af8e0@changeid
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/cqhci.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/mmc/host/cqhci.c
+++ b/drivers/mmc/host/cqhci.c
@@ -5,6 +5,7 @@
 #include <linux/delay.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
@@ -343,12 +344,16 @@ static int cqhci_enable(struct mmc_host
 /* CQHCI is idle and should halt immediately, so set a small timeout */
 #define CQHCI_OFF_TIMEOUT 100
 
+static u32 cqhci_read_ctl(struct cqhci_host *cq_host)
+{
+	return cqhci_readl(cq_host, CQHCI_CTL);
+}
+
 static void cqhci_off(struct mmc_host *mmc)
 {
 	struct cqhci_host *cq_host = mmc->cqe_private;
-	ktime_t timeout;
-	bool timed_out;
 	u32 reg;
+	int err;
 
 	if (!cq_host->enabled || !mmc->cqe_on || cq_host->recovery_halt)
 		return;
@@ -358,15 +363,9 @@ static void cqhci_off(struct mmc_host *m
 
 	cqhci_writel(cq_host, CQHCI_HALT, CQHCI_CTL);
 
-	timeout = ktime_add_us(ktime_get(), CQHCI_OFF_TIMEOUT);
-	while (1) {
-		timed_out = ktime_compare(ktime_get(), timeout) > 0;
-		reg = cqhci_readl(cq_host, CQHCI_CTL);
-		if ((reg & CQHCI_HALT) || timed_out)
-			break;
-	}
-
-	if (timed_out)
+	err = readx_poll_timeout(cqhci_read_ctl, cq_host, reg,
+				 reg & CQHCI_HALT, 0, CQHCI_OFF_TIMEOUT);
+	if (err < 0)
 		pr_err("%s: cqhci: CQE stuck on\n", mmc_hostname(mmc));
 	else
 		pr_debug("%s: cqhci: CQE off\n", mmc_hostname(mmc));


