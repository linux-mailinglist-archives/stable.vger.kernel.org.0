Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E646C6BF96A
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjCRKQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjCRKP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:15:58 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB96279A5;
        Sat, 18 Mar 2023 03:15:54 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so6405116wmb.5;
        Sat, 18 Mar 2023 03:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hNVncBi+eLx3DXaqCOJRdjKPPS5ZKYBqno7LFhDYHyo=;
        b=JH9SEF/ey2pweaLNV7mCepNRPDqcG38XZ6lsqEgz6GiLnpJ+ZyPdCh9NjDLp3+kVO7
         UIGir8NsTMaYk6XYDlhCahKfunhurLSKM1clpIgWA/E7UMYw8uIXMhN2Az2jV8ZZqnFq
         uFv3pevOFm15bJnAcdDfyn3PrIm4+9NBzXLAJmn+uozBRdJcvr2EQlIMQtWRoQGYi80H
         JSl/72Ab858npJxZEH3MPQQi7ZX8KirB0dvHwF35n26/Iro1/ygK0e4IFS/0okjKABOO
         zj5Kd1YizHV4n82tqmbTFRdd8kT5dudSkZAwDDA8ZfRLJRs0x+lvSzvD9FpSQ7SGkZ6o
         C5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hNVncBi+eLx3DXaqCOJRdjKPPS5ZKYBqno7LFhDYHyo=;
        b=5EM9J4XulQA4SJMeAB+mmOzNHCZb0uInEpz28aABRvELHA4Z4uuJYMvQEOfvV04hbs
         gQpaPRGXSLyQaC9wNEhS6JHgjXbd7tWFsbucxZ7PwJse0HX5T9vYcctE9x+6Ivqt+TFN
         JWEbq0LjOag1Q0nywu4QpzY2rBMDGy8zfX3nvzW3+a2AFjgOMh6TdvIhAzTiC6R3Csd7
         yyZy2l/TTD93rQYA7sdBGo2yrB4es9me9zmMBv8o94hpyY+33WTEmQ4xQ5c9OKk+WNh+
         pLdYoAnzHoCBXKAVpi8dat7/iNUTKL05zOS3s000Y6dEGtE9c90s/8Jg2XZoMaSYWnuU
         q+EQ==
X-Gm-Message-State: AO0yUKWzq+DgFxOUXjbwCYAeFFP0rQ+6wyWpGBB55APjAbAH+zHBdb4V
        wLQWJIieVDa0eDYZ5D3/W1AZo74YObA=
X-Google-Smtp-Source: AK7set9ZwL7TEXVhKEgYtnfgytaWXHs6ZSpYij5gPF80VJTPA0CYOMAlwYJvX7rM0vcDhNFrh9BI0g==
X-Received: by 2002:a05:600c:4f8e:b0:3e2:662:ade6 with SMTP id n14-20020a05600c4f8e00b003e20662ade6mr26346649wmq.26.1679134553874;
        Sat, 18 Mar 2023 03:15:53 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:53 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 5.10 11/15] fs: move should_remove_suid()
Date:   Sat, 18 Mar 2023 12:15:25 +0200
Message-Id: <20230318101529.1361673-12-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230318101529.1361673-1-amir73il@gmail.com>
References: <20230318101529.1361673-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e243e3f94c804ecca9a8241b5babe28f35258ef4 upstream.

Move the helper from inode.c to attr.c. This keeps the the core of the
set{g,u}id stripping logic in one place when we add follow-up changes.
It is the better place anyway, since should_remove_suid() returns
ATTR_KILL_S{G,U}ID flags.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/attr.c  | 29 +++++++++++++++++++++++++++++
 fs/inode.c | 29 -----------------------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index 300ba5153868..666489157978 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -20,6 +20,35 @@
 
 #include "internal.h"
 
+/*
+ * The logic we want is
+ *
+ *	if suid or (sgid and xgrp)
+ *		remove privs
+ */
+int should_remove_suid(struct dentry *dentry)
+{
+	umode_t mode = d_inode(dentry)->i_mode;
+	int kill = 0;
+
+	/* suid always must be killed */
+	if (unlikely(mode & S_ISUID))
+		kill = ATTR_KILL_SUID;
+
+	/*
+	 * sgid without any exec bits is just a mandatory locking mark; leave
+	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
+	 */
+	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
+		kill |= ATTR_KILL_SGID;
+
+	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
+		return kill;
+
+	return 0;
+}
+EXPORT_SYMBOL(should_remove_suid);
+
 static bool chown_ok(const struct inode *inode, kuid_t uid)
 {
 	if (uid_eq(current_fsuid(), inode->i_uid) &&
diff --git a/fs/inode.c b/fs/inode.c
index 63f86aeda7fd..f52dd6feea98 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1854,35 +1854,6 @@ void touch_atime(const struct path *path)
 }
 EXPORT_SYMBOL(touch_atime);
 
-/*
- * The logic we want is
- *
- *	if suid or (sgid and xgrp)
- *		remove privs
- */
-int should_remove_suid(struct dentry *dentry)
-{
-	umode_t mode = d_inode(dentry)->i_mode;
-	int kill = 0;
-
-	/* suid always must be killed */
-	if (unlikely(mode & S_ISUID))
-		kill = ATTR_KILL_SUID;
-
-	/*
-	 * sgid without any exec bits is just a mandatory locking mark; leave
-	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
-	 */
-	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
-		kill |= ATTR_KILL_SGID;
-
-	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
-		return kill;
-
-	return 0;
-}
-EXPORT_SYMBOL(should_remove_suid);
-
 /*
  * Return mask of changes for notify_change() that need to be done as a
  * response to write or truncate. Return 0 if nothing has to be changed.
-- 
2.34.1

