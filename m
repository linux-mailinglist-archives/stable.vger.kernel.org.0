Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABE641249E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379142AbhITSgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380085AbhITSc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:32:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7400461AA4;
        Mon, 20 Sep 2021 17:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158862;
        bh=uJUTMTu1vO5waaucqVJrvfx6ghghdNY2kgLhBdfGwQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zrt+k51Gck+c3r0K892E0m1hsy9oBLX3aRspip/oishJd0e12i+am/r9wC2Flvzek
         wXm4DgtHqOUNLz2Xxvbpdu8KPkO+WlknwcefK037jwLbGrE/CkPhC7SxHO9FehVh98
         rzlyyPYNeiTGt1r6tWdUV2M99TBi1646yqRs+IvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/122] tracing/boot: Fix a hist trigger dependency for boot time tracing
Date:   Mon, 20 Sep 2021 18:44:21 +0200
Message-Id: <20210920163918.710277100@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 6fe7c745f2acb73e4cc961d7f91125eef5a8861f ]

Fixes a build error when CONFIG_HIST_TRIGGERS=n with boot-time
tracing. Since the trigger_process_regex() is defined only
when CONFIG_HIST_TRIGGERS=y, if it is disabled, the 'actions'
event option also must be disabled.

Link: https://lkml.kernel.org/r/162856123376.203126.582144262622247352.stgit@devnote2

Fixes: 81a59555ff15 ("tracing/boot: Add per-event settings")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_boot.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index a82f03f385f8..0996d59750ff 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -205,12 +205,15 @@ trace_boot_init_one_event(struct trace_array *tr, struct xbc_node *gnode,
 			pr_err("Failed to apply filter: %s\n", buf);
 	}
 
-	xbc_node_for_each_array_value(enode, "actions", anode, p) {
-		if (strlcpy(buf, p, ARRAY_SIZE(buf)) >= ARRAY_SIZE(buf))
-			pr_err("action string is too long: %s\n", p);
-		else if (trigger_process_regex(file, buf) < 0)
-			pr_err("Failed to apply an action: %s\n", buf);
-	}
+	if (IS_ENABLED(CONFIG_HIST_TRIGGERS)) {
+		xbc_node_for_each_array_value(enode, "actions", anode, p) {
+			if (strlcpy(buf, p, ARRAY_SIZE(buf)) >= ARRAY_SIZE(buf))
+				pr_err("action string is too long: %s\n", p);
+			else if (trigger_process_regex(file, buf) < 0)
+				pr_err("Failed to apply an action: %s\n", buf);
+		}
+	} else if (xbc_node_find_value(enode, "actions", NULL))
+		pr_err("Failed to apply event actions because CONFIG_HIST_TRIGGERS is not set.\n");
 
 	if (xbc_node_find_value(enode, "enable", NULL)) {
 		if (trace_event_enable_disable(file, 1, 0) < 0)
-- 
2.30.2



