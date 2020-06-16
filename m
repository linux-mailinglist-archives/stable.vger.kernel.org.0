Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC811FADAE
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 12:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgFPKO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 06:14:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726052AbgFPKO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 06:14:29 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CED320734;
        Tue, 16 Jun 2020 10:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592302468;
        bh=UXfCyP+Xp14GVhxH+a3ULCFKGys2vq8CRdRVm47yCYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0eSIpaJLvTtQWq2UAwb171QD2F/yQpSdGBSMbkC+lgOZvbJMUk9IQqDZ/SKOaN5gx
         CLRBqlNUq9cW4p8PCIjD3iJXa63eMNdQUGsOdqs2yiXgNLPt1QiCrOE6uP4h/dQe/H
         t1ObfSKLy5Ky2aJ4sqp0lRgJ4++Pny4n1pxboa9Y=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/4] tools/bootconfig: Fix to return 0 if succeeded to show the bootconfig
Date:   Tue, 16 Jun 2020 19:14:25 +0900
Message-Id: <159230246566.65555.11891772258543514487.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <159230243779.65555.11413773790099102781.stgit@devnote2>
References: <159230243779.65555.11413773790099102781.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix bootconfig to return 0 if succeeded to show the bootconfig
in initrd. Without this fix, "bootconfig INITRD" command
returns !0 even if the command succeeded to show the bootconfig.

Fixes: 950313ebf79c ("tools: bootconfig: Add bootconfig command")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
  Changes in v2:
   - Use goto for better reading.
---
 tools/bootconfig/main.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
index 21896a6675fd..e0878f5f74b1 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -207,11 +207,13 @@ int show_xbc(const char *path)
 	}
 
 	ret = load_xbc_from_initrd(fd, &buf);
-	if (ret < 0)
+	if (ret < 0) {
 		pr_err("Failed to load a boot config from initrd: %d\n", ret);
-	else
-		xbc_show_compact_tree();
-
+		goto out;
+	}
+	xbc_show_compact_tree();
+	ret = 0;
+out:
 	close(fd);
 	free(buf);
 

