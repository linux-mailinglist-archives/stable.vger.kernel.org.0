Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1C3B5C6C
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbfIRG0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbfIRG0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:26:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A17920644;
        Wed, 18 Sep 2019 06:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787974;
        bh=rwEA9Q0a06XgOshyqVw2qobUN8dbpfreOZ0k15eEyTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkgMlKEgBGr1frH1l5NJpA5TAvObNMr8gS2aBtDdeLjjyygdTv7dJf23opfQxOAfQ
         Xqn/esteLShH1mrIDANIV4I3xwO91s2MriwV/WgkmMdq3xgj2Pj+Pi+JIj3LZ1rZmX
         vDsoOq11Jk+o74FIgRES4z13dvlA5D3pYhiH7XHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 5.2 54/85] clk: Fix debugfs clk_possible_parents for clks without parent string names
Date:   Wed, 18 Sep 2019 08:19:12 +0200
Message-Id: <20190918061235.821904087@linuxfoundation.org>
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

From: Chen-Yu Tsai <wens@csie.org>

commit 2d156b78ce8febf15cd58a025d7d9d7b7577126a upstream.

Following the commit fc0c209c147f ("clk: Allow parents to be specified
without string names"), the parent name string is not always populated.

Instead, fetch the parents clk_core struct using the appropriate helper,
and read its name directly. If that fails, go through the possible
sources of parent names. The order in which they are used is different
from how parents are looked up, with the global name having precedence
over local fw_name and indices. This makes more sense as a) the
parent_maps structure does not differentiate between legacy global names
and fallback global names, and b) global names likely provide more
information than local fw_names.

Fixes: fc0c209c147f ("clk: Allow parents to be specified without string names")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk.c |   44 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3023,12 +3023,50 @@ DEFINE_SHOW_ATTRIBUTE(clk_flags);
 static int possible_parents_show(struct seq_file *s, void *data)
 {
 	struct clk_core *core = s->private;
+	struct clk_core *parent;
 	int i;
 
-	for (i = 0; i < core->num_parents - 1; i++)
-		seq_printf(s, "%s ", core->parents[i].name);
+	/*
+	 * Go through the following options to fetch a parent's name.
+	 *
+	 * 1. Fetch the registered parent clock and use its name
+	 * 2. Use the global (fallback) name if specified
+	 * 3. Use the local fw_name if provided
+	 * 4. Fetch parent clock's clock-output-name if DT index was set
+	 *
+	 * This may still fail in some cases, such as when the parent is
+	 * specified directly via a struct clk_hw pointer, but it isn't
+	 * registered (yet).
+	 */
+	for (i = 0; i < core->num_parents - 1; i++) {
+		parent = clk_core_get_parent_by_index(core, i);
+		if (parent)
+			seq_printf(s, "%s ", parent->name);
+		else if (core->parents[i].name)
+			seq_printf(s, "%s ", core->parents[i].name);
+		else if (core->parents[i].fw_name)
+			seq_printf(s, "<%s>(fw) ", core->parents[i].fw_name);
+		else if (core->parents[i].index >= 0)
+			seq_printf(s, "%s ",
+				   of_clk_get_parent_name(core->of_node,
+							  core->parents[i].index));
+		else
+			seq_puts(s, "(missing) ");
+	}
 
-	seq_printf(s, "%s\n", core->parents[i].name);
+	parent = clk_core_get_parent_by_index(core, i);
+	if (parent)
+		seq_printf(s, "%s", parent->name);
+	else if (core->parents[i].name)
+		seq_printf(s, "%s", core->parents[i].name);
+	else if (core->parents[i].fw_name)
+		seq_printf(s, "<%s>(fw)", core->parents[i].fw_name);
+	else if (core->parents[i].index >= 0)
+		seq_printf(s, "%s",
+			   of_clk_get_parent_name(core->of_node,
+						  core->parents[i].index));
+	else
+		seq_puts(s, "(missing)");
 
 	return 0;
 }


