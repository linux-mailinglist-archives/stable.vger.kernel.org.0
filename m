Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCAD5106C65
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbfKVKvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:51:45 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33528 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729177AbfKVKvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:51:45 -0500
Received: by mail-wr1-f65.google.com with SMTP id w9so8104214wrr.0
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eZYw16U+8nuxkccXCYNgtvJx1TG7O/vbSuX+/oKS/b8=;
        b=XVNFpM3VQfxOeyUpUkOYYjbuTvz+dyp2Rfy9HnWGMHxyB7pyJKqjBJqgGVAPImm34o
         cAf70PF7zG5P0mgHlo2ayidtTp5vhI0pYiTfaLZ/X8iAlPCyzcJnY7t0diq8psKCYXGG
         a6dHwl9x8etMe8peebxVYQwjfYnAvhDhvO+CJfq5peCde8uxbXcDvFZB9gl924xOAcbU
         yRZzkio7PAnWtiWNzBhYxvWuACfFi+IbqodnRe1XO8LuUWROP+UTIQkrEjggW6KonsFq
         VewFF7C3Qpx53Hso14xzYYWKVVSp6vHUTkVFuIc9A8+gmtTAKd2jtAXEjP2NuiTxXb/E
         DjXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eZYw16U+8nuxkccXCYNgtvJx1TG7O/vbSuX+/oKS/b8=;
        b=kgJuLKd8i54pi8sZGwRnU0W7VMD2QtYAiA7vfnO0paSzSp4S/YugautAD74F7soROW
         EywToh1KYgVIeSiW+b5isOaiuMgikkwicazhrV+hKVTSsKaj1r5x8fgS30ihcaQ+/c27
         nyZYzGxyaaEjiRuQn7foGAq+7FN1vhiS4R7lbW6GVMjZRVBtkCI9EAsf6q5bFCmuNVGy
         HeecD0ASJrAFcHpzeawrsI8xIQfFPpXZerDKa/x+XmQDehTgzkA+eLLZrIsFomFfa7SU
         Y9FxJfqiEqxJ77GgdF4iywzglksCy5F4NKVHzAYYV5eT548gdbVkf4iX3LwePBwFbGyQ
         hK9Q==
X-Gm-Message-State: APjAAAWRqFT48tj71XvnljR3M5ip94u7eSsGWERNdxkutB5kFbIMenWU
        Ic7+6QlVHwlHXi5BbkfyBJNZew==
X-Google-Smtp-Source: APXvYqy9szVjHNrtR0GdyHhICO8z+5rPCd6R4+fi3xQteehMXFwG+13meWPBIi5JVHUIZSLXS8ayvQ==
X-Received: by 2002:a5d:4c8c:: with SMTP id z12mr16899509wrs.347.1574419903537;
        Fri, 22 Nov 2019 02:51:43 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id w4sm2894338wmk.29.2019.11.22.02.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:51:43 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.4 8/9] ocfs2: remove ocfs2_is_o2cb_active()
Date:   Fri, 22 Nov 2019 10:51:12 +0000
Message-Id: <20191122105113.11213-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105113.11213-1-lee.jones@linaro.org>
References: <20191122105113.11213-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gang He <ghe@suse.com>

[ Upstream commit a634644751c46238df58bbfe992e30c1668388db ]

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
---
 fs/ocfs2/dlmglue.c   | 2 +-
 fs/ocfs2/stackglue.c | 6 ------
 fs/ocfs2/stackglue.h | 3 ---
 3 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 555b57a16499..faaf8bfd2f52 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3426,7 +3426,7 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 	 * we can recover correctly from node failure. Otherwise, we may get
 	 * invalid LVB in LKB, but without DLM_SBF_VALNOTVALID being set.
 	 */
-	if (!ocfs2_is_o2cb_active() &&
+	if (ocfs2_userspace_stack(osb) &&
 	    lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
 		lvb = 1;
 
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 783bcdce5666..5d965e83bd43 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -48,12 +48,6 @@ static char ocfs2_hb_ctl_path[OCFS2_MAX_HB_CTL_PATH] = "/sbin/ocfs2_hb_ctl";
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
diff --git a/fs/ocfs2/stackglue.h b/fs/ocfs2/stackglue.h
index e1b30931974d..66334a30cea8 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -298,7 +298,4 @@ void ocfs2_stack_glue_set_max_proto_version(struct ocfs2_protocol_version *max_p
 int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
 void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
 
-/* In ocfs2_downconvert_lock(), we need to know which stack we are using */
-int ocfs2_is_o2cb_active(void);
-
 #endif  /* STACKGLUE_H */
-- 
2.24.0

