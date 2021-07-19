Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D213CDDA0
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245324AbhGSO7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245314AbhGSO6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:58:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A026761006;
        Mon, 19 Jul 2021 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708948;
        bh=L9EOp0CMXoCBbI6VEQ3Nfa7kROKz0JsL2eqy9d/5u7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cKSl/vx5qvWsa/3ZzU7wpqbqsrGdu1UvM+67Yjc2IE5TrdvU8MqTHdA5/6REWXdOQ
         nIW+6maS0PTcnG6esywqg5rhXOgZ7eCSFNDVUqU9Y3AUNfFDrs6bWaCAg2wu+nc3KG
         zEnnwNVX20f98wSXasuZbA/f2EVRz3ds9qJfGaiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joachim Fenkes <fenkes@de.ibm.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 194/421] fsi/sbefifo: Fix reset timeout
Date:   Mon, 19 Jul 2021 16:50:05 +0200
Message-Id: <20210719144953.126241054@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
index b43c2d424d00..ace42cd2915e 100644
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



