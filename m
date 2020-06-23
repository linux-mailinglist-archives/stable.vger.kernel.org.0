Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57B2206192
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392727AbgFWUpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:45:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390941AbgFWUpK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:45:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73DCB21BE5;
        Tue, 23 Jun 2020 20:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945111;
        bh=WjpFl7wlHy8PUGGqQ+jjo7NvQULXFyfkngycAh22ifQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLlHtasRUcbWjumaKYYwIuEFzWbJgUQajPjyQKhke2MGBdBQpIj/zIKeuQ+/3/BKE
         KiLqT1Bmsh6Cb9H8eP1LSc0QeKnMaIO4q3zlyJXF1CY0bUsn/O3wYVUQccnx4Hjtzs
         5rJGsosOMZKvZoxryLs+mvS0texCYDobcTtnj0wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 044/136] i2c: pxa: fix i2c_pxa_scream_blue_murder() debug output
Date:   Tue, 23 Jun 2020 21:58:20 +0200
Message-Id: <20200623195305.861831772@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ecc84aea51319..e300f9530f190 100644
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



