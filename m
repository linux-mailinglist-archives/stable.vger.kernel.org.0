Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3B6106F43
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfKVLO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:14:29 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32823 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730219AbfKVKxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:53:34 -0500
Received: by mail-wr1-f66.google.com with SMTP id w9so8111100wrr.0
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=c1Oau3Pvqb3kiOGOU8Ip4efQlbsCGfoIa++MtluImhk=;
        b=ymMzJdkffV1JOgkelIDUr/zrANxWOe5wqs5SWPn+jVsvZO/sayhx6QmDE/373U/Ziz
         +niv8nn3V75IdEHExEetckUtb/a21gg3r2Schvk3tA3DmkK0hvOld50GrFMyYMm2xvzl
         DHh5jKAjZpLhnZ2Zn3fdYSYbVu+YNpqwihzYG1W5WNl0LZ5ZxcilLvDLoEmbfDq6X8Ud
         EM5Mz1HmKjzcgipePt40z2nWSlPu9H5d0cNDWFo29yVlyHD+FuO13b7V1qfeO34nsfyI
         naxRg6k3h9Fd96bGrkZGOEPvW1XqoVSBnVj7jhANhw8vSC+cKEjOa8PpYnM5Ks0BEY6E
         2+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c1Oau3Pvqb3kiOGOU8Ip4efQlbsCGfoIa++MtluImhk=;
        b=Orxd5Tjj8bDzq442zz/4qZnT8kiO9c+Tb5fpcDg7vWxTSdt6gtF3g+IRoMvFITme7T
         jz2W6FGscvQZ6jreBv5J8iG0/GqKMza+wTvvMOdi2RTaEE8P/bC6VuGMj8qcIKIBLrCB
         ScQr2whwpH95zElzqri4QstQKZZcMjZv28uT+LEU0EniWXCdCfIoXSxO5W9xTQ+MiLZm
         TDsCrQyICjMbteg9gXm0vd/Ug6gC8lfPa/tQ7N7jwkV67CaLXtVfb6uJJpqA7VVBj4Fa
         2iWxB2xfdOUZcojuiUKxa3RoPL5RFMYr29kZuhDzAJ1VmYHdG31D2wXCj1mnOuGXkAdq
         BZjw==
X-Gm-Message-State: APjAAAXs0K7u3o2nrvMlBedZXX1vsfN2x4xo8BovI9uXrMXJwUjVa0Rw
        xkr94WW7uUYEnsq1iUWJKmxRSA==
X-Google-Smtp-Source: APXvYqx77jviRqo+QVKxemvMIgVqm3j7jMOEIbmuOUjh4WBuJcr1mxaALX4sgy3KDrz+MIGL3RV/fg==
X-Received: by 2002:adf:d1a3:: with SMTP id w3mr18057845wrc.9.1574420012581;
        Fri, 22 Nov 2019 02:53:32 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id o1sm7444087wrs.50.2019.11.22.02.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:53:32 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.9 7/8] ocfs2: remove ocfs2_is_o2cb_active()
Date:   Fri, 22 Nov 2019 10:52:52 +0000
Message-Id: <20191122105253.11375-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105253.11375-1-lee.jones@linaro.org>
References: <20191122105253.11375-1-lee.jones@linaro.org>
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
index 5729d55da67d..2c3e975126b3 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3421,7 +3421,7 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 	 * we can recover correctly from node failure. Otherwise, we may get
 	 * invalid LVB in LKB, but without DLM_SBF_VALNOTVALID being set.
 	 */
-	if (!ocfs2_is_o2cb_active() &&
+	if (ocfs2_userspace_stack(osb) &&
 	    lockres->l_ops->flags & LOCK_TYPE_USES_LVB)
 		lvb = 1;
 
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 820359096c7a..52c07346bea3 100644
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

