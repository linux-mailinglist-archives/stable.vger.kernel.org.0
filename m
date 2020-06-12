Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF191F7AB3
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 17:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgFLPXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 11:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgFLPXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jun 2020 11:23:38 -0400
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A44AE20890;
        Fri, 12 Jun 2020 15:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591975418;
        bh=4NxsWbYy8tttI/qIvtMbNeqPjzpkgvMM0wqi9DcMHlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ieSCUjTWAMzSe2X5+Tb6xLYwVRYCFRF/cjNiRkv5kAh+Zeyn08XtNyGp5DLraWTI+
         NsU2fIvYEThmrGtk08xdz1rooXbXJeqUClrI1odkL4pHOJJtYBf+SKKOv7WeqJ5b8R
         Lc7USrQZZT5YPT/Cy3UQndshvTPfUi2D9KUIZdjY=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] tools/bootconfig: Fix to return 0 if succeeded to show the bootconfig
Date:   Sat, 13 Jun 2020 00:23:35 +0900
Message-Id: <159197541534.80267.9851345208191438725.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <159197538852.80267.10091816844311950396.stgit@devnote2>
References: <159197538852.80267.10091816844311950396.stgit@devnote2>
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
 tools/bootconfig/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
index 21896a6675fd..ff2cc9520e10 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -209,8 +209,10 @@ int show_xbc(const char *path)
 	ret = load_xbc_from_initrd(fd, &buf);
 	if (ret < 0)
 		pr_err("Failed to load a boot config from initrd: %d\n", ret);
-	else
+	else {
 		xbc_show_compact_tree();
+		ret = 0;
+	}
 
 	close(fd);
 	free(buf);

