Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6FA10BEB0
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbfK0Up5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:45:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbfK0Up5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:45:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5BB12178F;
        Wed, 27 Nov 2019 20:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887556;
        bh=xcuo46ZBvX1YCpcetNRUT5rVfIvBZCdTb3ynfGInL1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0a4IkcCDcW8Vqo7dQv9TT3tqal2s/IyqKMQqUvJ3K89fP0M+WXkzDhBJdfi0MtX8
         P/ohpMc9JfGFOW0LYuC9SOyw+5w3lTl1LGW2SSNWuNvxFfxiDNmpTRPjB6KSc8vjlG
         n7QjlebDdQDawFYK0v3bSK6NIPIBM3QaCHOrw/hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gang He <ghe@suse.com>,
        Joseph Qi <jiangqi903@gmail.com>, Eric Ren <zren@suse.com>,
        Changwei Ge <ge.changwei@h3c.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 116/151] ocfs2: remove ocfs2_is_o2cb_active()
Date:   Wed, 27 Nov 2019 21:31:39 +0100
Message-Id: <20191127203044.137496591@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gang He <ghe@suse.com>

commit a634644751c46238df58bbfe992e30c1668388db upstream.

Remove ocfs2_is_o2cb_active().  We have similar functions to identify
which cluster stack is being used via osb->osb_cluster_stack.

Secondly, the current implementation of ocfs2_is_o2cb_active() is not
totally safe.  Based on the design of stackglue, we need to get
ocfs2_stack_lock before using ocfs2_stack related data structures, and
that active_stack pointer can be NULL in the case of mount failure.

Link: http://lkml.kernel.org/r/1495441079-11708-1-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Reviewed-by: Eric Ren <zren@suse.com>
Acked-by: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ocfs2/dlmglue.c   |    2 +-
 fs/ocfs2/stackglue.c |    6 ------
 fs/ocfs2/stackglue.h |    3 ---
 3 files changed, 1 insertion(+), 10 deletions(-)

--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3421,7 +3421,7 @@ static int ocfs2_downconvert_lock(struct
 	 * we can recover correctly from node failure. Otherwise, we may get
 	 * invalid LVB in LKB, but without DLM_SBF_VALNOTVALID being set.
 	 */
-	if (!ocfs2_is_o2cb_active() &&
+	if (ocfs2_userspace_stack(osb) &&
 	    lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
 		lvb = 1;
 
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -48,12 +48,6 @@ static char ocfs2_hb_ctl_path[OCFS2_MAX_
  */
 static struct ocfs2_stack_plugin *active_stack;
 
-inline int ocfs2_is_o2cb_active(void)
-{
-	return !strcmp(active_stack->sp_name, OCFS2_STACK_PLUGIN_O2CB);
-}
-EXPORT_SYMBOL_GPL(ocfs2_is_o2cb_active);
-
 static struct ocfs2_stack_plugin *ocfs2_stack_lookup(const char *name)
 {
 	struct ocfs2_stack_plugin *p;
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -298,9 +298,6 @@ void ocfs2_stack_glue_set_max_proto_vers
 int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
 void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
 
-/* In ocfs2_downconvert_lock(), we need to know which stack we are using */
-int ocfs2_is_o2cb_active(void);
-
 extern struct kset *ocfs2_kset;
 
 #endif  /* STACKGLUE_H */


