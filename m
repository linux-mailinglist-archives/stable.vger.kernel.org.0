Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAECFC1869
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbfI2Rbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729400AbfI2Rbq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:31:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA31121906;
        Sun, 29 Sep 2019 17:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778305;
        bh=F8RTzDc+fECkTRNigXyurxf3VNTlrsOpbjYpgckPm38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDaE5NSM3FVA7TK9eB/IZuU9lbf+p4wlFN+y8ttg5ZMVQmxuAg1tPSe2Pc5Mf8n8m
         ONMQvnVJTHd+d3Ec92HD9RIlKWTpRXH0SyEO3R8IIJ1x9/jgJEBEpEIelrYmXr8VgV
         uyAdF0FSCcZvHdTxEf5ygdy3F8YPm+QKz7Lo864Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, selinux@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 24/49] selinux: fix residual uses of current_security() for the SELinux blob
Date:   Sun, 29 Sep 2019 13:30:24 -0400
Message-Id: <20190929173053.8400-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173053.8400-1-sashal@kernel.org>
References: <20190929173053.8400-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

[ Upstream commit 169ce0c081cd85f78388bb6c1638c1ad7b81bde7 ]

We need to use selinux_cred() to fetch the SELinux cred blob instead
of directly using current->security or current_security().  There
were a couple of lingering uses of current_security() in the SELinux code
that were apparently missed during the earlier conversions. IIUC, this
would only manifest as a bug if multiple security modules including
SELinux are enabled and SELinux is not first in the lsm order. After
this change, there appear to be no other users of current_security()
in-tree; perhaps we should remove it altogether.

Fixes: bbd3662a8348 ("Infrastructure management of the cred security blob")
Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Reviewed-by: James Morris <jamorris@linux.microsoft.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/hooks.c          |  2 +-
 security/selinux/include/objsec.h | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 74dd46de01b6a..e755174647866 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3403,7 +3403,7 @@ static int selinux_inode_copy_up_xattr(const char *name)
 static int selinux_kernfs_init_security(struct kernfs_node *kn_dir,
 					struct kernfs_node *kn)
 {
-	const struct task_security_struct *tsec = current_security();
+	const struct task_security_struct *tsec = selinux_cred(current_cred());
 	u32 parent_sid, newsid, clen;
 	int rc;
 	char *context;
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 91c5395dd20c2..586b7abd0aa73 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -37,16 +37,6 @@ struct task_security_struct {
 	u32 sockcreate_sid;	/* fscreate SID */
 };
 
-/*
- * get the subjective security ID of the current task
- */
-static inline u32 current_sid(void)
-{
-	const struct task_security_struct *tsec = current_security();
-
-	return tsec->sid;
-}
-
 enum label_initialized {
 	LABEL_INVALID,		/* invalid or not initialized */
 	LABEL_INITIALIZED,	/* initialized */
@@ -185,4 +175,14 @@ static inline struct ipc_security_struct *selinux_ipc(
 	return ipc->security + selinux_blob_sizes.lbs_ipc;
 }
 
+/*
+ * get the subjective security ID of the current task
+ */
+static inline u32 current_sid(void)
+{
+	const struct task_security_struct *tsec = selinux_cred(current_cred());
+
+	return tsec->sid;
+}
+
 #endif /* _SELINUX_OBJSEC_H_ */
-- 
2.20.1

