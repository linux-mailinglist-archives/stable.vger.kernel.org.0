Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3246AB5CAF
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbfIRG0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:26:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728395AbfIRG0S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:26:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD5A621924;
        Wed, 18 Sep 2019 06:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787977;
        bh=Lb6PQz8+/DWzFIUSaUwex+ThbiYq5c6fI82ixMMnb7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5rQa1o8zZnnRqYcIb4QzUUWiic86Dwl5DAYlK4HrrDSLmy8qbv13R/3xfHwFMdKS
         0SIeheiHxnvBSb/B+AXbsPRDumqSbXJ4BdPcR57RlnzxRqwrvC/+8oBsKmVrInfTXP
         GpCrksLA2i6cAfPOf107OjsEPVAIvTgDp1pU8cF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.2 55/85] clk: Simplify debugfs printing and add a newline
Date:   Wed, 18 Sep 2019 08:19:13 +0200
Message-Id: <20190918061235.849500666@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

commit 11f6c2307caee89370d7752eb6f404f1ed73faaf upstream.

The possible parent printing function duplicates a bunch of if
conditions. Pull that into another function so we can print an extra
character at the end, either a space or a newline. This way we can add
the required newline that got lost here and also shorten the code.

Fixes: 2d156b78ce8f ("clk: Fix debugfs clk_possible_parents for clks without parent string names")
Cc: Chen-Yu Tsai <wens@csie.org>
Tested-by: Chen-Yu Tsai <wens@csie.org>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3020,11 +3020,10 @@ static int clk_flags_show(struct seq_fil
 }
 DEFINE_SHOW_ATTRIBUTE(clk_flags);
 
-static int possible_parents_show(struct seq_file *s, void *data)
+static void possible_parent_show(struct seq_file *s, struct clk_core *core,
+				 unsigned int i, char terminator)
 {
-	struct clk_core *core = s->private;
 	struct clk_core *parent;
-	int i;
 
 	/*
 	 * Go through the following options to fetch a parent's name.
@@ -3038,22 +3037,6 @@ static int possible_parents_show(struct
 	 * specified directly via a struct clk_hw pointer, but it isn't
 	 * registered (yet).
 	 */
-	for (i = 0; i < core->num_parents - 1; i++) {
-		parent = clk_core_get_parent_by_index(core, i);
-		if (parent)
-			seq_printf(s, "%s ", parent->name);
-		else if (core->parents[i].name)
-			seq_printf(s, "%s ", core->parents[i].name);
-		else if (core->parents[i].fw_name)
-			seq_printf(s, "<%s>(fw) ", core->parents[i].fw_name);
-		else if (core->parents[i].index >= 0)
-			seq_printf(s, "%s ",
-				   of_clk_get_parent_name(core->of_node,
-							  core->parents[i].index));
-		else
-			seq_puts(s, "(missing) ");
-	}
-
 	parent = clk_core_get_parent_by_index(core, i);
 	if (parent)
 		seq_printf(s, "%s", parent->name);
@@ -3068,6 +3051,19 @@ static int possible_parents_show(struct
 	else
 		seq_puts(s, "(missing)");
 
+	seq_putc(s, terminator);
+}
+
+static int possible_parents_show(struct seq_file *s, void *data)
+{
+	struct clk_core *core = s->private;
+	int i;
+
+	for (i = 0; i < core->num_parents - 1; i++)
+		possible_parent_show(s, core, i, ' ');
+
+	possible_parent_show(s, core, i, '\n');
+
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(possible_parents);


