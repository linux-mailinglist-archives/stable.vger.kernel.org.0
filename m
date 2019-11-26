Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAA6109F81
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 14:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbfKZNsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 08:48:06 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51163 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbfKZNsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 08:48:06 -0500
Received: by mail-wm1-f67.google.com with SMTP id l17so3317324wmh.0
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 05:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1q2B94XyALRvNRnvNJEB1AMhPK5UAr+ZiO6EcUlJFV8=;
        b=rj4k/JL9cDFx/gdRc43YTVFF1MHQbnsWvHaonIT4/LodaIf7+sjqOuDeTdAh1hl+dx
         rncXgAwlyvCMtFsaTg9XoFJyrqA3VUDkAByyT3yTFRylVAlozG9bVdeAO4VFgM0kHXHM
         JbOhs5ZgrarEWnc7bvb9vUz+o4bRZmqcMs2vmoOS9v2axfLKcD9oByeb9cche7vIRA4K
         p0V3gJEK8ZN7jL+0ClCM98GijIafmLjXKOZC6HdKmGSiyG9OEm3Ldb0NkoJ4ZimDMh/W
         XvxvfIlbjzqF0kXjU39t6Yqu0wvTvOovdh4pXmiy4graZMbMiVxVW981zOVJwFKP2Z5h
         4uJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1q2B94XyALRvNRnvNJEB1AMhPK5UAr+ZiO6EcUlJFV8=;
        b=Cr0Zo5TktTM0E4eOt77vrFuiSBgiAzCio7AE5/8B9vbNzo36XBHRHSVgcCZzmOiF1Q
         2+HOoCLZTc7YaEvEx3TVj6WUzmp/cNbMI1H8/yri0Zuo7ixZHoyVDPpJXIN3r+408gma
         vWICbSkST2kgHj/0N7zP0jJ2UiEBsfHLqvDI1Jq5n6BVlw54t//+JkebhLUmEw3nbmZq
         BKjQw8YjT4IK55fFCpeOGmrKHWcvAZ1IbMguTUGBXt+F/q86zr9OVExsuht+IpTQnZx6
         MzD3Zo8Wamqaq461H8imiQ+sEPkRgrtZjpudnvELAbKmpBsjl8o40xVYeY6e1UTW9asn
         gk9Q==
X-Gm-Message-State: APjAAAU0b8z+kt+N7vzGKlf7Mb/71Xp9XX+f9ey4s2cAtF/F9F8Ej/B0
        nHCHhlhQLVPNV92s5mqgisqiVOLGhnY=
X-Google-Smtp-Source: APXvYqylWQ2oZ+4DGMpisOvfJgFIMDopMdSucBNIg8S0q1WbWNSjN0f9CwA7gTahREO2GEWCqRHqwA==
X-Received: by 2002:a1c:f612:: with SMTP id w18mr4670519wmc.28.1574776083324;
        Tue, 26 Nov 2019 05:48:03 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.72])
        by smtp.gmail.com with ESMTPSA id o1sm15085560wrs.50.2019.11.26.05.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 05:48:02 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 3/3] ocfs2: remove ocfs2_is_o2cb_active()
Date:   Tue, 26 Nov 2019 13:47:41 +0000
Message-Id: <20191126134741.12629-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191126134741.12629-1-lee.jones@linaro.org>
References: <20191126134741.12629-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gang He <ghe@suse.com>

[ Upstream commit 9d452c602f0558ec3b0aeab1040bdf4dfbc590eb ]

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

