Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C5E3C4F8D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242013AbhGLH0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343517AbhGLHYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:24:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E15E861416;
        Mon, 12 Jul 2021 07:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074462;
        bh=1MIAf3d4QGmYMvT3UMfZo+tSyjLWakCaiTgLJlb/o8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7JSYQnoXmUMuA+N7y7OaDqVV2qkSwUK9iHSt5d12j3PkGP24e6lROVOPjw0xbOIX
         zixHuw9LDu7Xow6C6IW5XqCk2Pq3BYzqvgBtHYum0sJKS9UaUgYWkaNlse4eO/pKhE
         sWfyW3eHEtWl+4EVxFjSLPfPsOru2RKqvgK9VN7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joachim Fenkes <fenkes@de.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 589/700] fsi/sbefifo: Fix reset timeout
Date:   Mon, 12 Jul 2021 08:11:12 +0200
Message-Id: <20210712061038.656769066@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joachim Fenkes <FENKES@de.ibm.com>

[ Upstream commit 9ab1428dfe2c66b51e0b41337cd0164da0ab6080 ]

On BMCs with lower timer resolution than 1ms, msleep(1) will take
way longer than 1ms, so looping 10k times won't wait for 10s but
significantly longer.

Fix this by using jiffies like the rest of the code.

Fixes: 9f4a8a2d7f9d ("fsi/sbefifo: Add driver for the SBE FIFO")
Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
Link: https://lore.kernel.org/r/20200724071518.430515-3-joel@jms.id.au
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-sbefifo.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/fsi/fsi-sbefifo.c b/drivers/fsi/fsi-sbefifo.c
index de27c435d706..84cb965bfed5 100644
--- a/drivers/fsi/fsi-sbefifo.c
+++ b/drivers/fsi/fsi-sbefifo.c
@@ -325,7 +325,8 @@ static int sbefifo_up_write(struct sbefifo *sbefifo, __be32 word)
 static int sbefifo_request_reset(struct sbefifo *sbefifo)
 {
 	struct device *dev = &sbefifo->fsi_dev->dev;
-	u32 status, timeout;
+	unsigned long end_time;
+	u32 status;
 	int rc;
 
 	dev_dbg(dev, "Requesting FIFO reset\n");
@@ -341,7 +342,8 @@ static int sbefifo_request_reset(struct sbefifo *sbefifo)
 	}
 
 	/* Wait for it to complete */
-	for (timeout = 0; timeout < SBEFIFO_RESET_TIMEOUT; timeout++) {
+	end_time = jiffies + msecs_to_jiffies(SBEFIFO_RESET_TIMEOUT);
+	while (!time_after(jiffies, end_time)) {
 		rc = sbefifo_regr(sbefifo, SBEFIFO_UP | SBEFIFO_STS, &status);
 		if (rc) {
 			dev_err(dev, "Failed to read UP fifo status during reset"
@@ -355,7 +357,7 @@ static int sbefifo_request_reset(struct sbefifo *sbefifo)
 			return 0;
 		}
 
-		msleep(1);
+		cond_resched();
 	}
 	dev_err(dev, "FIFO reset timed out\n");
 
-- 
2.30.2



