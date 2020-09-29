Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E0D27C5A7
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgI2Lhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730111AbgI2Lh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6567923B2A;
        Tue, 29 Sep 2020 11:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379232;
        bh=8moSyQWcR5Dfn0LKMN/FdEuxOvN9l38MDYQEaW7SuiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVOsTHvC87CuIfkZ8oEhLSGr0BNlZdTE2hNmCPp5BE6g+A434tj7YE8bUApN6qPiJ
         6FswTb7HzQAErLtoicS/GYM3U7dgAHSOnEXUu04KUDC3WNFrimIZDsw/8YhSKjfhZd
         aWGNXF6YLbr/AppWLTDuXVUVy4qQfOrt68U7Uons=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jessica Yu <jeyu@kernel.org>,
        Divya Indi <divya.indi@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/388] module: Remove accidental change of module_enable_x()
Date:   Tue, 29 Sep 2020 12:56:43 +0200
Message-Id: <20200929110013.978142707@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

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



