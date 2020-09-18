Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684AD26F440
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgIRCCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgIRCCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BBCA21734;
        Fri, 18 Sep 2020 02:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394521;
        bh=1B2jgEi+I4h0qdUddLJbSRrLZfoagbPlCdBWYqZFP4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/wKzDg3GVqFKC63cah9zCKjZ6v3HmKCv7/A35jTw79bQ+ObmDaQgs50yBjKUNfhL
         j/YJlwVNu032F0f0Zh2/3UfHfiS1jtXVy6T2AYO19aAXXrEEAcczf9rg35NL3rp0BH
         Ly9DCC1wWAM/TEJ5RYrKSdZqDzqg8+hmQgx4em8E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Divya Indi <divya.indi@oracle.com>,
        Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 043/330] tracing: Verify if trace array exists before destroying it.
Date:   Thu, 17 Sep 2020 21:56:23 -0400
Message-Id: <20200918020110.2063155-43-sashal@kernel.org>
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

From: Divya Indi <divya.indi@oracle.com>

[ Upstream commit e585e6469d6f476b82aa148dc44aaf7ae269a4e2 ]

A trace array can be destroyed from userspace or kernel. Verify if the
trace array exists before proceeding to destroy/remove it.

Link: http://lkml.kernel.org/r/1565805327-579-3-git-send-email-divya.indi@oracle.com

Reviewed-by: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Signed-off-by: Divya Indi <divya.indi@oracle.com>
[ Removed unneeded braces ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c      |  6 +++++-
 kernel/trace/trace.c | 15 ++++++++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 819c5d3b4c295..0e3743dd3a568 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3753,7 +3753,6 @@ static int complete_formation(struct module *mod, struct load_info *info)
 
 	module_enable_ro(mod, false);
 	module_enable_nx(mod);
-	module_enable_x(mod);
 
 	/* Mark state as coming so strong_try_module_get() ignores us,
 	 * but kallsyms etc. can see us. */
@@ -3776,6 +3775,11 @@ static int prepare_coming_module(struct module *mod)
 	if (err)
 		return err;
 
+	/* Make module executable after ftrace is enabled */
+	mutex_lock(&module_mutex);
+	module_enable_x(mod);
+	mutex_unlock(&module_mutex);
+
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_COMING, mod);
 	return 0;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f9c2bdbbd8936..cd3d91554aff1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8502,17 +8502,26 @@ static int __remove_instance(struct trace_array *tr)
 	return 0;
 }
 
-int trace_array_destroy(struct trace_array *tr)
+int trace_array_destroy(struct trace_array *this_tr)
 {
+	struct trace_array *tr;
 	int ret;
 
-	if (!tr)
+	if (!this_tr)
 		return -EINVAL;
 
 	mutex_lock(&event_mutex);
 	mutex_lock(&trace_types_lock);
 
-	ret = __remove_instance(tr);
+	ret = -ENODEV;
+
+	/* Making sure trace array exists before destroying it. */
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		if (tr == this_tr) {
+			ret = __remove_instance(tr);
+			break;
+		}
+	}
 
 	mutex_unlock(&trace_types_lock);
 	mutex_unlock(&event_mutex);
-- 
2.25.1

