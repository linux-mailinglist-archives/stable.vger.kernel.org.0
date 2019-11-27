Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2AA810AB0D
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfK0HWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:11 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34441 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfK0HWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:10 -0500
Received: by mail-wr1-f68.google.com with SMTP id t2so25377137wrr.1
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=c1Oau3Pvqb3kiOGOU8Ip4efQlbsCGfoIa++MtluImhk=;
        b=LflgAXI6UuG+j1OC4PPlqDG0tprhsdAb1bpuvwpw2e/uEYAcVLpKPpU6rW2ze+A102
         ZS1KkNlRGNv0DLuterYUoVi1IX+uZxDKgn1XozkIQd0L4e+EQ59gGHHyXgZtkYk8ZCpz
         yPIXNDCXOngB1pT6SP747RfaCOUCays0JN/kCgSSTtdr/mfo6tkm5GSDltaZ81N3EGg5
         AVW+umHGBljQwQqYATmMPUEMCTHHJqSotjLJMd/BJ0t0Uh8vUdAn0Ghyt710oUm4SqRK
         zhPEXtp2XcA07GoHAG2H1VI2QkNhflxF4vaITOqBk5H9IzZxFoTdP6KZsI9HvMEihoY5
         bZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c1Oau3Pvqb3kiOGOU8Ip4efQlbsCGfoIa++MtluImhk=;
        b=CfdMpwwpQAkyMI16oo4pmoFS1+YlUzuFcBvbnuQ8g+8ZTgSkD2PL7z+9oEfL9bpC4b
         3OZCdGJwYkAecrvZBg6urZEwNWMlfi28ZyIYOoqP72IlrM3uaDx9lCIS8L1mibgI6fSJ
         Myx4nvRWWg7OJRW9yE2AXy/0ByIBz21fZAskM9S+Lh7I9rRfl+99nzp4InJwMrG5JCia
         KTEmKJTSwsqPUbcbECfhTxO+dQ71/fwFdCC45BtCv3e/qZYvrO42E8S//aw470P5vphR
         lQ/kOHHI3CYqfh9VgNw0hhGBsnpO6GgBoEPOlmD5UbaiX8HmZFJJrRFWEORdmH9sgzSy
         OLBw==
X-Gm-Message-State: APjAAAUyLYHvD2FKXRRpfsiGf5g7bDyrYcIiFKraXB0W0TThFnDRoGDd
        e34ayUlXVnF2zjSuL/RK+jffCqglESI=
X-Google-Smtp-Source: APXvYqyyZle05lcK0iS8HhMOoC1/bfCR0KBN1IitjXTUgqXVbHP+FSF6/luY3TCu2I7y81VImK4/Ow==
X-Received: by 2002:adf:f103:: with SMTP id r3mr4582018wro.295.1574839328131;
        Tue, 26 Nov 2019 23:22:08 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id e16sm17983130wrj.80.2019.11.26.23.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:07 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 6/6] ocfs2: remove ocfs2_is_o2cb_active()
Date:   Wed, 27 Nov 2019 07:21:44 +0000
Message-Id: <20191127072144.30537-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072144.30537-1-lee.jones@linaro.org>
References: <20191127072144.30537-1-lee.jones@linaro.org>
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

