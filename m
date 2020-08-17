Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01BA246A20
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgHQPai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730185AbgHQPae (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:30:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 356B62075B;
        Mon, 17 Aug 2020 15:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678233;
        bh=37MMSSoL6oqEcfaGDD2YYEbR6qmbWEcwABOL7QfqCbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKlmD898T3R7c5A7cD/YjVWdQdNvY2XtOeG0i/4jS8DyCzTYbuG9Hh+fw2HxFE5+U
         iehO3hW/ZiEjpPY3BJjIOkm7qUY9VggRFDxLXN/rA1VHF1dDOp/Ch7q+AeHUo2t2OX
         pNo/PtRghFkIHlY/E/d5syWAduclJkTwa6Mz0F/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Leach <mike.leach@linaro.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 264/464] coresight: tmc: Fix TMC mode read in tmc_read_unprepare_etb()
Date:   Mon, 17 Aug 2020 17:13:37 +0200
Message-Id: <20200817143846.434796758@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

[ Upstream commit d021f5c5ff679432c5e9faee0fd7350db2efb97c ]

Reading TMC mode register without proper coresight power
management can lead to exceptions like the one in the call
trace below in tmc_read_unprepare_etb() when the trace data
is read after the sink is disabled. So fix this by having
a check for coresight sysfs mode before reading TMC mode
management register in tmc_read_unprepare_etb() similar to
tmc_read_prepare_etb().

  SError Interrupt on CPU6, code 0xbe000411 -- SError
  pstate: 80400089 (Nzcv daIf +PAN -UAO)
  pc : tmc_read_unprepare_etb+0x74/0x108
  lr : tmc_read_unprepare_etb+0x54/0x108
  sp : ffffff80d9507c30
  x29: ffffff80d9507c30 x28: ffffff80b3569a0c
  x27: 0000000000000000 x26: 00000000000a0001
  x25: ffffff80cbae9550 x24: 0000000000000010
  x23: ffffffd07296b0f0 x22: ffffffd0109ee028
  x21: 0000000000000000 x20: ffffff80d19e70e0
  x19: ffffff80d19e7080 x18: 0000000000000000
  x17: 0000000000000000 x16: 0000000000000000
  x15: 0000000000000000 x14: 0000000000000000
  x13: 0000000000000000 x12: 0000000000000000
  x11: 0000000000000000 x10: dfffffd000000001
  x9 : 0000000000000000 x8 : 0000000000000002
  x7 : ffffffd071d0fe78 x6 : 0000000000000000
  x5 : 0000000000000080 x4 : 0000000000000001
  x3 : ffffffd071d0fe98 x2 : 0000000000000000
  x1 : 0000000000000004 x0 : 0000000000000001
  Kernel panic - not syncing: Asynchronous SError Interrupt

Fixes: 4525412a5046 ("coresight: tmc: making prepare/unprepare functions generic")
Reported-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Tested-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200716175746.3338735-14-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-tmc-etf.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etf.c b/drivers/hwtracing/coresight/coresight-tmc-etf.c
index 36cce2bfb7449..6375504ba8b00 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
@@ -639,15 +639,14 @@ int tmc_read_unprepare_etb(struct tmc_drvdata *drvdata)
 
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 
-	/* There is no point in reading a TMC in HW FIFO mode */
-	mode = readl_relaxed(drvdata->base + TMC_MODE);
-	if (mode != TMC_MODE_CIRCULAR_BUFFER) {
-		spin_unlock_irqrestore(&drvdata->spinlock, flags);
-		return -EINVAL;
-	}
-
 	/* Re-enable the TMC if need be */
 	if (drvdata->mode == CS_MODE_SYSFS) {
+		/* There is no point in reading a TMC in HW FIFO mode */
+		mode = readl_relaxed(drvdata->base + TMC_MODE);
+		if (mode != TMC_MODE_CIRCULAR_BUFFER) {
+			spin_unlock_irqrestore(&drvdata->spinlock, flags);
+			return -EINVAL;
+		}
 		/*
 		 * The trace run will continue with the same allocated trace
 		 * buffer. As such zero-out the buffer so that we don't end
-- 
2.25.1



