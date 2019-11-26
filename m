Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C599C109F85
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 14:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfKZNs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 08:48:56 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40062 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbfKZNs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 08:48:56 -0500
Received: by mail-wr1-f67.google.com with SMTP id 4so19254199wro.7
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 05:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KNL8F99/kiNCZPUhXHP/twsEU6K48GLn40QObRuuXis=;
        b=X3DFMiowMaSdpJk3f01zYca8OUThUX+8MLB8msP2xsLVyrnbqJnvPUU77S89aF4RMq
         oobcJ5dYxxY9XKpalvMamOdTAGfUhHwhZUHvkNoEs3JrEdV6vXzmrxCLvxCAm7BnExH2
         5IwOdIEqk1sB1Ok5rroONtYiTBzP+rNUs1IfV+Tr083nuOUnpW0DW2hypTis2lrHCvEr
         c0joYCaFfjQEE22jdlSc4/BL4ni/c01yb3wm6Rm+yR1c7/Tak90heERrTxbWDVzuZXwh
         si3w01O/shO1jE/6bdUtVzDzKIdzs2UJHBmUhdLgHvXKj0hov4paqbXMPF8iasp+9GED
         Qj9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KNL8F99/kiNCZPUhXHP/twsEU6K48GLn40QObRuuXis=;
        b=fI7oXK79+8i5g95wPNPbS1cO+Fu9OFa8jqYc2XkFy6S3xeJEBJJr/8WfNHt14acSFf
         bhIDsqDTcKaBXPhssEGXWhLzu2w875clVy0EVX8o7LO6aSjXy0B0cdHUdkz3GSZ8zUBp
         i427mNgk493p80/ftDlUmA7f7zDhoi60qZYVJgwvA4gbAi6B8tnySmqR03tpGbFtDJnT
         nydcr4IHgCf3M7btpYmdGQq2+mmuw7zY7Tr05IWS8LzqKUIfmnu1FsscMIM09iBvJ1Bw
         oiUxdWAghqn1bwjAxwB5WWp943Y8XIclE8xCeJp74eT851h/8D5m9mIHC5b0LghNkwiv
         sESA==
X-Gm-Message-State: APjAAAVZix6aFUCieszzF2Y33zCBQEYdQk8N9PMwSmy1AObbOleCZksq
        jQrpB/QQ4Cf4Fg9LRfZNRP88O7XdcwA=
X-Google-Smtp-Source: APXvYqw6z7xrwICIoHUjrFUK5Ob7FLfO6erZH97NqD/p2xtcpZ3nVSuvFI6ucbnD4KvkPP43je2t4g==
X-Received: by 2002:adf:f34c:: with SMTP id e12mr22258365wrp.184.1574776133314;
        Tue, 26 Nov 2019 05:48:53 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.72])
        by smtp.gmail.com with ESMTPSA id m9sm14374131wro.66.2019.11.26.05.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 05:48:52 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 5/5] ocfs2: remove ocfs2_is_o2cb_active()
Date:   Tue, 26 Nov 2019 13:48:30 +0000
Message-Id: <20191126134830.12747-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191126134830.12747-1-lee.jones@linaro.org>
References: <20191126134830.12747-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gang He <ghe@suse.com>

[ Upstream commit 22ee66ccece0e779fa67c9e7266b926bbc5e903e ]

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
index 5193218f5889..e961015fb484 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3422,7 +3422,7 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 	 * we can recover correctly from node failure. Otherwise, we may get
 	 * invalid LVB in LKB, but without DLM_SBF_VALNOTVALID being set.
 	 */
-	if (!ocfs2_is_o2cb_active() &&
+	if (ocfs2_userspace_stack(osb) &&
 	    lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
 		lvb = 1;
 
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index d6c350ba25b9..c4b029c43464 100644
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
index e3036e1790e8..f2dce10fae54 100644
--- a/fs/ocfs2/stackglue.h
+++ b/fs/ocfs2/stackglue.h
@@ -298,9 +298,6 @@ void ocfs2_stack_glue_set_max_proto_version(struct ocfs2_protocol_version *max_p
 int ocfs2_stack_glue_register(struct ocfs2_stack_plugin *plugin);
 void ocfs2_stack_glue_unregister(struct ocfs2_stack_plugin *plugin);
 
-/* In ocfs2_downconvert_lock(), we need to know which stack we are using */
-int ocfs2_is_o2cb_active(void);
-
 extern struct kset *ocfs2_kset;
 
 #endif  /* STACKGLUE_H */
-- 
2.24.0

