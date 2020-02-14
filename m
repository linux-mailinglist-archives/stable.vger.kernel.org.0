Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4E815EBC7
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391307AbgBNQJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:09:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391302AbgBNQJd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:09:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86F9424682;
        Fri, 14 Feb 2020 16:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696573;
        bh=FGprxRun26IH1icAQXs7d2ZLvfCNFwA9W5z0AhAUZhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOT4Uz9SW2/sDUYe2I9eDa5pZTr62Zs+lTKVyYfdOXLIlNePdHZIciOgOCw5KYGNv
         RLI96INBGbWVd8QZ4tXFBVdx+L4RC0SGeqWk18BrlPnn3T23wDPoTnnsd0dAq8A3tf
         hzFIHwlFQOh4qxm1iT1DWs3uQQYWaVCVQVbN1Oh0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jessica Yu <jeyu@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 362/459] module: avoid setting info->name early in case we can fall back to info->mod->name
Date:   Fri, 14 Feb 2020 11:00:12 -0500
Message-Id: <20200214160149.11681-362-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jessica Yu <jeyu@kernel.org>

[ Upstream commit 708e0ada1916be765b7faa58854062f2bc620bbf ]

In setup_load_info(), info->name (which contains the name of the module,
mostly used for early logging purposes before the module gets set up)
gets unconditionally assigned if .modinfo is missing despite the fact
that there is an if (!info->name) check near the end of the function.
Avoid assigning a placeholder string to info->name if .modinfo doesn't
exist, so that we can fall back to info->mod->name later on.

Fixes: 5fdc7db6448a ("module: setup load info before module_sig_check()")
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 135861c2ac782..a2a47f4a33a78 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3059,9 +3059,7 @@ static int setup_load_info(struct load_info *info, int flags)
 
 	/* Try to find a name early so we can log errors with a module name */
 	info->index.info = find_sec(info, ".modinfo");
-	if (!info->index.info)
-		info->name = "(missing .modinfo section)";
-	else
+	if (info->index.info)
 		info->name = get_modinfo(info, "name");
 
 	/* Find internal symbols and strings. */
@@ -3076,14 +3074,15 @@ static int setup_load_info(struct load_info *info, int flags)
 	}
 
 	if (info->index.sym == 0) {
-		pr_warn("%s: module has no symbols (stripped?)\n", info->name);
+		pr_warn("%s: module has no symbols (stripped?)\n",
+			info->name ?: "(missing .modinfo section or name field)");
 		return -ENOEXEC;
 	}
 
 	info->index.mod = find_sec(info, ".gnu.linkonce.this_module");
 	if (!info->index.mod) {
 		pr_warn("%s: No module found in object\n",
-			info->name ?: "(missing .modinfo name field)");
+			info->name ?: "(missing .modinfo section or name field)");
 		return -ENOEXEC;
 	}
 	/* This is temporary: point mod into copy of data. */
-- 
2.20.1

