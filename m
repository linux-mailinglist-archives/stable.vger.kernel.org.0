Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7CC49A914
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322023AbiAYDU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:20:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33974 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349172AbiAXUHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:07:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9B906131D;
        Mon, 24 Jan 2022 20:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EFFC340E5;
        Mon, 24 Jan 2022 20:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054831;
        bh=bTFoX/N6uoPeZfsGy7J1VXRKpnYHbB47AS5vmroa+hU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0e67oGZvX7TN207OLwdKmtS5tHUErLOlU4wRRl48B/6ntRMp/RDlY0trDrDpYW3bK
         d0rw2ArRXY5AbWqTSXU6wzHjF1CoI36B6j4pXZ1hm7vba1Jr69FET8dajqZRwwxwhk
         0edQpd4Z0laz/KMG/vhY81O2GcbFF0wkwwL2cWKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.10 517/563] clk: Emit a stern warning with writable debugfs enabled
Date:   Mon, 24 Jan 2022 19:44:42 +0100
Message-Id: <20220124184042.331859164@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -3314,6 +3314,24 @@ static int __init clk_debug_init(void)
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


