Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9221FDD21
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730328AbgFRBX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:23:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731107AbgFRBX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:23:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C6A220776;
        Thu, 18 Jun 2020 01:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443437;
        bh=yrsb5sDyQK0/tXeTGDfxt669NSiTccbeU4EEGkjL5ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BAu+w4Y69gXuWqXjp+lJZIkyYgptS/YW/62c8ltI7qAzt5KXERWG25M2FnbFrPEqd
         JTY5tsdHySd3bXJcUu1vIEamWQNNRevtB1A9uCmp/KhcFUNx1oIo04U98935jxU9be
         LNNVSpKCQzL+t4w5hDvJ37Sq6dh2LWlvjk1EMnHQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 075/172] i2c: pxa: fix i2c_pxa_scream_blue_murder() debug output
Date:   Wed, 17 Jun 2020 21:20:41 -0400
Message-Id: <20200618012218.607130-75-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
MIME-Version: 1.0
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
index 7248ba6763e4..c10ae4778d35 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -315,11 +315,10 @@ static void i2c_pxa_scream_blue_murder(struct pxa_i2c *i2c, const char *why)
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

