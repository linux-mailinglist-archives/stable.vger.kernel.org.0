Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF42515F19E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbgBNPyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:54:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731539AbgBNPyb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D42D2465D;
        Fri, 14 Feb 2020 15:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695669;
        bh=+lVoJ8WapUZPeP45CSRrrWYwdJXfBF+qqGzFeUm9ljs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMYnG7lyWF6k5BZ3wHmf9YncqRzKXemqVgVykPOcV46DipH5yrVLCbI09gafBa7eJ
         sqQKz4LGQdh2RgFsreI7S3UkabfnAx1TRVFLnT7rbE4ZUSarWCSNrVs/4qNwXor7pZ
         Vyj7GOYoLK93LCaw7S96buII2Fzu1gi+2oAD8YMQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 258/542] clk: actually call the clock init before any other callback of the clock
Date:   Fri, 14 Feb 2020 10:44:10 -0500
Message-Id: <20200214154854.6746-258-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

