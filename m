Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C1820DDC4
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgF2UTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732631AbgF2TZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEF1E25381;
        Mon, 29 Jun 2020 15:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445246;
        bh=9o5x72zZZnWSCJ6J+SEm8U/hiA+ojDbeHCsxOYiiEwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erWO35jjJYLPPwes7c2a8yPgO+MeuxHg88BJ9u9CZHQaX+tJ/wOecN4ueXSqbG1Gs
         Gu3wlfh18yTIKF8WrMdYmnwonAwJ4GMID9yT6hqwdrIHXopmAqkt/VQQP1rZtHkKVR
         2oio3N19iHNgJlHXIU9s4EhWpWkl53EAMJBMp6Hc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 030/191] i2c: pxa: fix i2c_pxa_scream_blue_murder() debug output
Date:   Mon, 29 Jun 2020 11:37:26 -0400
Message-Id: <20200629154007.2495120-31-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 88b73ee7ca4c90baf136ed5a8377fc5a9b73ac08 ]

The IRQ log output is supposed to appear on a single line.  However,
commit 3a2dc1677b60 ("i2c: pxa: Update debug function to dump more info
on error") resulted in it being printed one-entry-per-line, which is
excessively long.

Fixing this is not a trivial matter; using pr_cont() doesn't work as
the previous dev_dbg() may not have been compiled in, or may be
dynamic.

Since the rest of this function output is at error level, and is also
debug output, promote this to error level as well to avoid this
problem.

Reduce the number of always zero prefix digits to save screen real-
estate.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-pxa.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index e49af19852098..fb191ad8fc3aa 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -297,11 +297,10 @@ static void i2c_pxa_scream_blue_murder(struct pxa_i2c *i2c, const char *why)
 	dev_err(dev, "IBMR: %08x IDBR: %08x ICR: %08x ISR: %08x\n",
 		readl(_IBMR(i2c)), readl(_IDBR(i2c)), readl(_ICR(i2c)),
 		readl(_ISR(i2c)));
-	dev_dbg(dev, "log: ");
+	dev_err(dev, "log:");
 	for (i = 0; i < i2c->irqlogidx; i++)
-		pr_debug("[%08x:%08x] ", i2c->isrlog[i], i2c->icrlog[i]);
-
-	pr_debug("\n");
+		pr_cont(" [%03x:%05x]", i2c->isrlog[i], i2c->icrlog[i]);
+	pr_cont("\n");
 }
 
 #else /* ifdef DEBUG */
-- 
2.25.1

