Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E3B2EBBD
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730442AbfE3DPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730430AbfE3DPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:41 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06AA524595;
        Thu, 30 May 2019 03:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186141;
        bh=PjcI6j3JVgIlgjdTsXLDxlehs3jes36s+UDL4rG7FDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAlyNgeLuzNUTn3JiynS+VHmPYCMXjZeK18i/Sh+LqfXAK2R5tqWlinCLmZZJS7DJ
         M9IYpIqmLxcxg0vkM/ph1DgC9+3H8QtYb19MbOgDXGxPzXqQtZAMI20AjP0WDRhM/o
         UIoIbqyWDM+HKxJnUwLAPw6w/qnZsVNr8I5Ahwvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yu <zhangyu31@baidu.com>,
        Li RongQing <lirongqing@baidu.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 316/346] audit: fix a memleak caused by auditing load module
Date:   Wed, 29 May 2019 20:06:29 -0700
Message-Id: <20190530030556.823676683@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 95e0b46fcebd7dbf6850dee96046e4c4ddc7f69c ]

module.name will be allocated unconditionally when auditing load
module, and audit_log_start() can fail with other reasons, or
audit_log_exit maybe not called, caused module.name is not freed

so free module.name in audit_free_context and __audit_syscall_exit

unreferenced object 0xffff88af90837d20 (size 8):
  comm "modprobe", pid 1036, jiffies 4294704867 (age 3069.138s)
  hex dump (first 8 bytes):
    69 78 67 62 65 00 ff ff                          ixgbe...
  backtrace:
    [<0000000008da28fe>] __audit_log_kern_module+0x33/0x80
    [<00000000c1491e61>] load_module+0x64f/0x3850
    [<000000007fc9ae3f>] __do_sys_init_module+0x218/0x250
    [<0000000000d4a478>] do_syscall_64+0x117/0x400
    [<000000004924ded8>] entry_SYSCALL_64_after_hwframe+0x49/0xbe
    [<000000007dc331dd>] 0xffffffffffffffff

Fixes: ca86cad7380e3 ("audit: log module name on init_module")
Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
[PM: manual merge fixup in __audit_syscall_exit()]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/auditsc.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index b585ceb2f7a2c..71e7377746110 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -837,6 +837,13 @@ static inline void audit_proctitle_free(struct audit_context *context)
 	context->proctitle.len = 0;
 }
 
+static inline void audit_free_module(struct audit_context *context)
+{
+	if (context->type == AUDIT_KERN_MODULE) {
+		kfree(context->module.name);
+		context->module.name = NULL;
+	}
+}
 static inline void audit_free_names(struct audit_context *context)
 {
 	struct audit_names *n, *next;
@@ -920,6 +927,7 @@ int audit_alloc(struct task_struct *tsk)
 
 static inline void audit_free_context(struct audit_context *context)
 {
+	audit_free_module(context);
 	audit_free_names(context);
 	unroll_tree_refs(context, NULL, 0);
 	free_tree_refs(context);
@@ -1237,7 +1245,6 @@ static void show_special(struct audit_context *context, int *call_panic)
 		audit_log_format(ab, "name=");
 		if (context->module.name) {
 			audit_log_untrustedstring(ab, context->module.name);
-			kfree(context->module.name);
 		} else
 			audit_log_format(ab, "(null)");
 
@@ -1574,6 +1581,7 @@ void __audit_syscall_exit(int success, long return_code)
 	context->in_syscall = 0;
 	context->prio = context->state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
 
+	audit_free_module(context);
 	audit_free_names(context);
 	unroll_tree_refs(context, NULL, 0);
 	audit_free_aux(context);
-- 
2.20.1



