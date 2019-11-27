Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC9410AB08
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfK0HV6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:21:58 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42699 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfK0HV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:21:58 -0500
Received: by mail-wr1-f67.google.com with SMTP id a15so25372046wrf.9
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 23:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eZYw16U+8nuxkccXCYNgtvJx1TG7O/vbSuX+/oKS/b8=;
        b=JVUkem6mwUz7LUmutuOGbPEynAM3riP2XuMK7Us1xCv3+TGT3hmebH4LX9Jgyk6yyA
         c//7f7HoQzfSVOlPqi1lU885qL2BWLAAkjs4crY1nocRD4sCumDJt+uO1ZyHS9gTArpy
         zWBeJojZEg8s9yUs/PphkMplgphJUjX5Blp79Z26/X2q0cJOS5qKvosw+7CfsOj0dMYk
         VxyHQlsPdLU2hIB4/KGzztRLpulOZyRUAIbO/eUTjuI+iWsMHF1DUqhnGGjzI0s51rS4
         oPeHm/SE3Z5tI2anEPUizL0ysd/k418IhoBYJq6SSfd8zSROMLb+ur7UxEO7/VoAU/EJ
         SkkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eZYw16U+8nuxkccXCYNgtvJx1TG7O/vbSuX+/oKS/b8=;
        b=Gnuia5mcaPShMer8P8jsbuLZCEPlR+SC8AlfFHPkLYmTCWPZi0UQARD1m9k3051d7o
         GbIsfFPUP+O8mjW6bMIwMckYcUmdznvpS9t9R5HXZKEOIoFr4Lmfzg+5EzXwLHTHdVM1
         0ekRXHaWvT1IsMgxF29As2guB73uOEaFw2KWLCtPJdXMRnHFKkh7AwYIwqH2aG/8Svzx
         TmiffwluQl2GVQor5XRGf5UMXFlcvvJfof7Fv554EHIRL9cHT2qgM+O1vkBjkV3PHkYL
         Fm/Hq/LtwLEc2pN36dPST/exanEiWhQfwuYRvgJXSHVbqaW7gTvVOjpVM4z7zsxz5FwM
         ft1g==
X-Gm-Message-State: APjAAAVIgXst+Ku9A0SKcZEjhV6K3VbxrcEYGs1M5pHKXGiwLGbUWtN9
        BzoWz9rrGxydLTGuLSXf4B6dNVVQY58=
X-Google-Smtp-Source: APXvYqyQY4NEayv8hNfjp2FoFD3xgPnxYCarecp5ZwGIFXjo6FDHdjbEFTg32tOudAe/HobCrP+Pew==
X-Received: by 2002:adf:e506:: with SMTP id j6mr42008736wrm.19.1574839313896;
        Tue, 26 Nov 2019 23:21:53 -0800 (PST)
Received: from localhost.localdomain ([95.149.164.101])
        by smtp.gmail.com with ESMTPSA id y6sm18151872wrn.21.2019.11.26.23.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 23:21:53 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 6/6] ocfs2: remove ocfs2_is_o2cb_active()
Date:   Wed, 27 Nov 2019 07:21:24 +0000
Message-Id: <20191127072124.30445-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127072124.30445-1-lee.jones@linaro.org>
References: <20191127072124.30445-1-lee.jones@linaro.org>
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

