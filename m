Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6E526EB0C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgIRCCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgIRCCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7F2B2376F;
        Fri, 18 Sep 2020 02:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394562;
        bh=7LXURWva2hr25lWX5PhgyRYZqNDi63uIDEJvA5/Ru90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tG6Sf7Y0KBnNreRQwrQZRhAb5pMNAv1tPzEa7YGbMMqqNdqIayZ0eeTykLz8FlcRT
         wcsseMWqkrH2/skflNi/bHuqX6k/d2+0IhlvfwvUszVNa1f+6lS6eu0vP2Emz27Uzf
         QeTEBqpDU9bICF61aQLClbx2Hn1WpmpsplMYA6OU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Jessica Yu <jeyu@kernel.org>,
        Divya Indi <divya.indi@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 075/330] module: Remove accidental change of module_enable_x()
Date:   Thu, 17 Sep 2020 21:56:55 -0400
Message-Id: <20200918020110.2063155-75-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

[ Upstream commit af74262337faa65d5ac2944553437d3f5fb29123 ]

When pulling in Divya Indi's patch, I made a minor fix to remove unneeded
braces. I commited my fix up via "git commit -a --amend". Unfortunately, I
didn't realize I had some changes I was testing in the module code, and
those changes were applied to Divya's patch as well.

This reverts the accidental updates to the module code.

Cc: Jessica Yu <jeyu@kernel.org>
Cc: Divya Indi <divya.indi@oracle.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Fixes: e585e6469d6f ("tracing: Verify if trace array exists before destroying it.")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 0e3743dd3a568..819c5d3b4c295 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3753,6 +3753,7 @@ static int complete_formation(struct module *mod, struct load_info *info)
 
 	module_enable_ro(mod, false);
 	module_enable_nx(mod);
+	module_enable_x(mod);
 
 	/* Mark state as coming so strong_try_module_get() ignores us,
 	 * but kallsyms etc. can see us. */
@@ -3775,11 +3776,6 @@ static int prepare_coming_module(struct module *mod)
 	if (err)
 		return err;
 
-	/* Make module executable after ftrace is enabled */
-	mutex_lock(&module_mutex);
-	module_enable_x(mod);
-	mutex_unlock(&module_mutex);
-
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_COMING, mod);
 	return 0;
-- 
2.25.1

