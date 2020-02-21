Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50EA6167120
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgBUHvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:51:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729738AbgBUHvY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:51:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37981207FD;
        Fri, 21 Feb 2020 07:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271483;
        bh=+lVoJ8WapUZPeP45CSRrrWYwdJXfBF+qqGzFeUm9ljs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPeKH3YCBOzjoyPAiSaQ6+/nB7lDltLPaFS1emF/o5hZ6+uR0cCrDBVYQqEICupI4
         JKAm5WNB2U9cEHnvIRruxFX6HgCpJelW3uCbEIWWUQQ+152dxkedlOwOHZ4GFW3Gvg
         rRUDcWqUSa7wcgUqTYjB1OqG7RkrbQmalZqlW1GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 182/399] clk: actually call the clock init before any other callback of the clock
Date:   Fri, 21 Feb 2020 08:38:27 +0100
Message-Id: <20200221072420.455340473@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit f6fa75ca912be6021335de63a32aa4d295f3c524 ]

 __clk_init_parent() will call the .get_parent() callback of the clock
 so .init() must run before.

Fixes: 541debae0adf ("clk: call the clock init() callback before any other ops callback")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lkml.kernel.org/r/20190924123954.31561-2-jbrunet@baylibre.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 772258de2d1f3..53585cfc4b9ba 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3338,6 +3338,21 @@ static int __clk_core_init(struct clk_core *core)
 		goto out;
 	}
 
+	/*
+	 * optional platform-specific magic
+	 *
+	 * The .init callback is not used by any of the basic clock types, but
+	 * exists for weird hardware that must perform initialization magic.
+	 * Please consider other ways of solving initialization problems before
+	 * using this callback, as its use is discouraged.
+	 *
+	 * If it exist, this callback should called before any other callback of
+	 * the clock
+	 */
+	if (core->ops->init)
+		core->ops->init(core->hw);
+
+
 	core->parent = __clk_init_parent(core);
 
 	/*
@@ -3362,17 +3377,6 @@ static int __clk_core_init(struct clk_core *core)
 		core->orphan = true;
 	}
 
-	/*
-	 * optional platform-specific magic
-	 *
-	 * The .init callback is not used by any of the basic clock types, but
-	 * exists for weird hardware that must perform initialization magic.
-	 * Please consider other ways of solving initialization problems before
-	 * using this callback, as its use is discouraged.
-	 */
-	if (core->ops->init)
-		core->ops->init(core->hw);
-
 	/*
 	 * Set clk's accuracy.  The preferred method is to use
 	 * .recalc_accuracy. For simple clocks and lazy developers the default
-- 
2.20.1



