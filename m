Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 789AE1486BF
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390624AbgAXOS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:18:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390579AbgAXOS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:18:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42D87214DB;
        Fri, 24 Jan 2020 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875505;
        bh=dCB5a7jBrPFkI8apoOVO1s5KUGv3XxaDg3HI2580nQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=maiZgQl6n14WTf1KCL1OU0NbSGEk8rhD5y1H5wjxIB/gwcnpM3sjCTU+bKN/tb4U/
         uU/onzHIyw5JUr/hxV5FOCnFcjBzRJkEkFMLldhI+vr3oVYhnOhulm2n9blTy6u3+j
         MgyJBQah4jg39XHS/QBJ3mNQVhffz5jDEJu7qn/Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 007/107] bus: ti-sysc: Fix iterating over clocks
Date:   Fri, 24 Jan 2020 09:16:37 -0500
Message-Id: <20200124141817.28793-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 2c81f0f6d3f52ac222a5dc07a6e5c06e1543e88b ]

Commit d878970f6ce1 ("bus: ti-sysc: Add separate functions for handling
clocks") separated handling of optional clocks from the main clocks, but
introduced an issue where we do not necessarily allocate a slot for both
fck and ick clocks, but still assume fixed slots for enumerating over the
clocks.

Let's fix the issue by ensuring we always have slots for both fck and ick
even if we don't use ick, and don't attempt to enumerate optional clocks
if not allocated.

In the long run we might want to simplify things a bit by only allocating
space only for the optional clocks as we have only few devices with
optional clocks.

Fixes: d878970f6ce1 ("bus: ti-sysc: Add separate functions for handling clocks")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 34bd9bf4e68ab..abbf281ee337b 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -343,6 +343,12 @@ static int sysc_get_clocks(struct sysc *ddata)
 		return -EINVAL;
 	}
 
+	/* Always add a slot for main clocks fck and ick even if unused */
+	if (!nr_fck)
+		ddata->nr_clocks++;
+	if (!nr_ick)
+		ddata->nr_clocks++;
+
 	ddata->clocks = devm_kcalloc(ddata->dev,
 				     ddata->nr_clocks, sizeof(*ddata->clocks),
 				     GFP_KERNEL);
@@ -421,7 +427,7 @@ static int sysc_enable_opt_clocks(struct sysc *ddata)
 	struct clk *clock;
 	int i, error;
 
-	if (!ddata->clocks)
+	if (!ddata->clocks || ddata->nr_clocks < SYSC_OPTFCK0 + 1)
 		return 0;
 
 	for (i = SYSC_OPTFCK0; i < SYSC_MAX_CLOCKS; i++) {
@@ -455,7 +461,7 @@ static void sysc_disable_opt_clocks(struct sysc *ddata)
 	struct clk *clock;
 	int i;
 
-	if (!ddata->clocks)
+	if (!ddata->clocks || ddata->nr_clocks < SYSC_OPTFCK0 + 1)
 		return;
 
 	for (i = SYSC_OPTFCK0; i < SYSC_MAX_CLOCKS; i++) {
-- 
2.20.1

