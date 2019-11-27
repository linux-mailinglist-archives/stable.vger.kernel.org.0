Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 758C810AB15
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfK0HWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:22:30 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38040 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfK0HWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:22:30 -0500
Received: by mail-wr1-f67.google.com with SMTP id i12so25435271wro.5
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pGX23hmz91I1hVCX2PBQK2x2zyM7e2qWXG1Dd3x0TEU=;
        b=JU+OA2Tx+sCieIUBKnseglWk56a9B55Y1OVcW+ZqUXHsPbUli6Ef+BRjNwDBfWZBsz
         LIZDcNjfMs8thyvVpGo8vdc0M1+kiN4pi/aaE45U6nBoIJrfHLVvBhOPsc22yrMt9RNp
         OI49Nw0RrL0RjJ/jZXneNujFjlJrOKiGOpd7OaLKmzNbHxipp5XrfyNO9SWHNoP0LF+N
         TNxBqUu1ci+pfMfyOjez/bMdUYsHdt/RgSI4DNQ18H+Wqq2ua5bZsfligzZwNMlyzuND
         1DUsJCE0dbrGgsHN7nipdi5Kr4GvKqL4rgEp2Hks9/XykP7oQ+V1ryqE08pfzBHfud4l
         9A0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pGX23hmz91I1hVCX2PBQK2x2zyM7e2qWXG1Dd3x0TEU=;
        b=AVgxY9PEezSrgNtTnGzwdfHViq8z//TR5DZM0bGlL28v3WD2mMvpc63lZFnlaNmWhh
         iYH0BiG4qZVFp/qpn5KYS7mv5r5eVxsVH2v46WHuvqrvgHUADKKwp2nI7C5BALxc4NNR
         MA658UdnCCY4JfFEPjtoufQFzxGTlGTUzuQAItsE5PzhhW9IodD6MvR7U5t/yDYF1jch
         FtNBMQS49sYO/tXfM+zcRnkVAY+dzdFJ8BMxyuQQ208kYEyPNBCF9m8Hdbip485pf9hs
         Xm/6txKJLE5oeEmmKFBq7y3OO6BbVTAv1EtaVE5O8r1qefh80MeTQMept+6zq8jSqjTY
         CY8A==
X-Gm-Message-State: APjAAAWwZW21n1JDF1S6Xq9lWDWWaUtBYMtI6Rap9kAcoiDVw+d6/2sj
        xbJAg7CpbHZwUP2eUE42pgayo/LC4sg=
X-Google-Smtp-Source: APXvYqyMZAmBxF4aw3B4mRSEDqoFJzPWQBguYVGZZlzbTld8KGLUAopgG6TZuLXZqTdktHi20uAQvA==
X-Received: by 2002:adf:f606:: with SMTP id t6mr24454036wrp.85.1574839347996;
        Tue, 26 Nov 2019 23:22:27 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id c193sm5986641wma.8.2019.11.26.23.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:22:27 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 3/3] ocfs2: remove ocfs2_is_o2cb_active()
Date:   Wed, 27 Nov 2019 07:22:10 +0000
Message-Id: <20191127072210.30715-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072210.30715-1-lee.jones@linaro.org>
References: <20191127072210.30715-1-lee.jones@linaro.org>
MIME-Version: 1.0
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
index 933aac5da193..178cb9e6772a 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3603,7 +3603,7 @@ static int ocfs2_downconvert_lock(struct ocfs2_super *osb,
 	 * we can recover correctly from node failure. Otherwise, we may get
 	 * invalid LVB in LKB, but without DLM_SBF_VALNOTVALID being set.
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

