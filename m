Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C4349958A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442080AbiAXUwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:52:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43164 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352486AbiAXUt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:49:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8859060916;
        Mon, 24 Jan 2022 20:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A173C340E5;
        Mon, 24 Jan 2022 20:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057359;
        bh=bvHOw9ERgB7iEz1yUKq8HHn8qQmBpOq3NOnQT7Kd3hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gB3SZQ8pZip0M74uqCWBrTsv5iOvt04MFWvklg1a8Be9ZEbaOx0fE83LgMZMFFsV+
         6mpxr3H34Pqd/kNOeOroGj4NsESyGrqvrygYM8qb0j9j70SZRBNS9kpaLIKBBTnWWM
         mUA9NTFuE719c+QW62+9YCYZo6a8bi3bdCwoqAg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.15 785/846] clk: Emit a stern warning with writable debugfs enabled
Date:   Mon, 24 Jan 2022 19:45:02 +0100
Message-Id: <20220124184128.029688795@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <sboyd@kernel.org>

commit 489a71964f9d74e697a12cd0ace20ed829eb1f93 upstream.

We don't want vendors to be enabling this part of the clk code and
shipping it to customers. Exposing the ability to change clk frequencies
and parents via debugfs is potentially damaging to the system if folks
don't know what they're doing. Emit a strong warning so that the message
is clear: don't enable this outside of development systems.

Fixes: 37215da5553e ("clk: Add support for setting clk_rate via debugfs")
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20211210014237.2130300-1-sboyd@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3340,6 +3340,24 @@ static int __init clk_debug_init(void)
 {
 	struct clk_core *core;
 
+#ifdef CLOCK_ALLOW_WRITE_DEBUGFS
+	pr_warn("\n");
+	pr_warn("********************************************************************\n");
+	pr_warn("**     NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE           **\n");
+	pr_warn("**                                                                **\n");
+	pr_warn("**  WRITEABLE clk DebugFS SUPPORT HAS BEEN ENABLED IN THIS KERNEL **\n");
+	pr_warn("**                                                                **\n");
+	pr_warn("** This means that this kernel is built to expose clk operations  **\n");
+	pr_warn("** such as parent or rate setting, enabling, disabling, etc.      **\n");
+	pr_warn("** to userspace, which may compromise security on your system.    **\n");
+	pr_warn("**                                                                **\n");
+	pr_warn("** If you see this message and you are not debugging the          **\n");
+	pr_warn("** kernel, report this immediately to your vendor!                **\n");
+	pr_warn("**                                                                **\n");
+	pr_warn("**     NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE           **\n");
+	pr_warn("********************************************************************\n");
+#endif
+
 	rootdir = debugfs_create_dir("clk", NULL);
 
 	debugfs_create_file("clk_summary", 0444, rootdir, &all_lists,


