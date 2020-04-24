Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC0C1B7534
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgDXMbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbgDXMXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85A2621582;
        Fri, 24 Apr 2020 12:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587730992;
        bh=AiHZMRGZN++JkczioNXBdzkyrnsdGgspzRfy4nft0mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDYxHJ//hrlq75jPlPKbi1+rFZubZFD6BlX4Ds59z3He/5aa/MFJiO/lgblG/4CvB
         k+n2bsIwYOJlodCK/O8O+7ekWoBUBe7sh8d1MV6HtH60E0hM3Vze/+oNwaeZgYmtVY
         1fJ78Dg/+5kyVTyr2YSmeHmcj6fnd81Cur1gDCHI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 30/38] i2c: tegra: Better handle case where CPU0 is busy for a long time
Date:   Fri, 24 Apr 2020 08:22:28 -0400
Message-Id: <20200424122237.9831-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122237.9831-1-sashal@kernel.org>
References: <20200424122237.9831-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit a900aeac253729411cf33c6cb598c152e9e4137f ]

Boot CPU0 always handle I2C interrupt and under some rare circumstances
(like running KASAN + NFS root) it may stuck in uninterruptible state for
a significant time. In this case we will get timeout if I2C transfer is
running on a sibling CPU, despite of IRQ being raised. In order to handle
this rare condition, the IRQ status needs to be checked after completion
timeout.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-tegra.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index cbc2ad49043e4..0daa863fb26f2 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -1000,14 +1000,13 @@ tegra_i2c_poll_completion_timeout(struct tegra_i2c_dev *i2c_dev,
 	do {
 		u32 status = i2c_readl(i2c_dev, I2C_INT_STATUS);
 
-		if (status) {
+		if (status)
 			tegra_i2c_isr(i2c_dev->irq, i2c_dev);
 
-			if (completion_done(complete)) {
-				s64 delta = ktime_ms_delta(ktimeout, ktime);
+		if (completion_done(complete)) {
+			s64 delta = ktime_ms_delta(ktimeout, ktime);
 
-				return msecs_to_jiffies(delta) ?: 1;
-			}
+			return msecs_to_jiffies(delta) ?: 1;
 		}
 
 		ktime = ktime_get();
@@ -1034,14 +1033,18 @@ tegra_i2c_wait_completion_timeout(struct tegra_i2c_dev *i2c_dev,
 		disable_irq(i2c_dev->irq);
 
 		/*
-		 * There is a chance that completion may happen after IRQ
-		 * synchronization, which is done by disable_irq().
+		 * Under some rare circumstances (like running KASAN +
+		 * NFS root) CPU, which handles interrupt, may stuck in
+		 * uninterruptible state for a significant time.  In this
+		 * case we will get timeout if I2C transfer is running on
+		 * a sibling CPU, despite of IRQ being raised.
+		 *
+		 * In order to handle this rare condition, the IRQ status
+		 * needs to be checked after timeout.
 		 */
-		if (ret == 0 && completion_done(complete)) {
-			dev_warn(i2c_dev->dev,
-				 "completion done after timeout\n");
-			ret = 1;
-		}
+		if (ret == 0)
+			ret = tegra_i2c_poll_completion_timeout(i2c_dev,
+								complete, 0);
 	}
 
 	return ret;
-- 
2.20.1

