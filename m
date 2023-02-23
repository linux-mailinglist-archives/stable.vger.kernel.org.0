Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54ACE6A0CC2
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 16:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbjBWPVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 10:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbjBWPU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 10:20:59 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7653359424;
        Thu, 23 Feb 2023 07:20:58 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id l1so10680741wry.10;
        Thu, 23 Feb 2023 07:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrQM3AyDV05ITqVjKXkNXYcLdaW5PD/abgi+AuvoFXs=;
        b=R7/45VU8HUYmMY+peQiG7ibg1YgSci85ujlTxGCKkSQ4JvM5RPZ2fQUnYqFAuLDWg6
         J7XpfyhL1oS56DVD3gpIghMOfdlfmjUfzm0UnScaVz0oTaTyB1Rm9JAn3Oztlouqtb3l
         fBKeTpZTYY4v2I2Fb3f/1hakxbFZR/Y2ioIylSUsky54VDHS5S/hmA5uwecp+qAOJNQp
         HgZKqiDQWIMI79whR3U/VLuMTggXVbKT2W9VbtZ/sl781dfB2C/hHF/PP8P6/1ZN3/sx
         InQo8V4GrzkXFxhgsAvjJ2Et7wuP1Qt8k2oTG7WCIieZCVPBD9ZVRDERKQNlhFAeCDyD
         paVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BrQM3AyDV05ITqVjKXkNXYcLdaW5PD/abgi+AuvoFXs=;
        b=Ol+/anQm4h96YZ5V9xbo/zbL9jvsT524cHKRWLO5TqeNiaI3jkNdMn60JZGPZmnLoz
         kOh0D78nSg+1BjuRnDxySxaZNuHrG7F4WYvuXbzqSIN8lG7ynDEA1fM7KqmhgAMaS9yG
         f+O60pA6dpvLI1/oDFkh1WQlPalfcht7HMlgManmerS5Mpgi47oeaPQOG6BXdg9y5XSy
         JnjUt1XB7CM1E7z2DWYXeuyXatvon1YOOCRw5389V3gZ3feAA3+pfAHNcVP6UU+4dmPE
         bjx5DL5TjKpWJO1PNxsX39wBFdE//XtfnEPJvUsJjfocUEGB13svERc1zasZJoDZJw1p
         MAmQ==
X-Gm-Message-State: AO0yUKVvxK5VE1S2bhEUTSsirbqWSvEYlSyH4EFT2jDADjrqgh/Baee5
        z7y60FwwXiF6s0wT6hDoeWNygatTdKg=
X-Google-Smtp-Source: AK7set+Re/zg0gYlhWDUz2scGCI2FxXH85YrMIIPmcj4t1/ATJV751aYkkABKcj/+ogTYDZjnkeveA==
X-Received: by 2002:a5d:6a03:0:b0:2c7:84e:1cfa with SMTP id m3-20020a5d6a03000000b002c7084e1cfamr6699861wru.40.1677165653395;
        Thu, 23 Feb 2023 07:20:53 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k9-20020a5d6289000000b002c56af32e8csm9372590wru.35.2023.02.23.07.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 07:20:52 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 6.1 2/5] fs: move should_remove_suid()
Date:   Thu, 23 Feb 2023 17:20:41 +0200
Message-Id: <20230223152044.1064909-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230223152044.1064909-1-amir73il@gmail.com>
References: <20230223152044.1064909-1-amir73il@gmail.com>
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

From: Christian Brauner <brauner@kernel.org>

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
index b1162fca84a2..e508b3caae76 100644
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
 /**
  * chown_ok - verify permissions to chown inode
  * @mnt_userns:	user namespace of the mount @inode was found from
diff --git a/fs/inode.c b/fs/inode.c
index 55299b710c45..6df2b7c936c2 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1948,35 +1948,6 @@ void touch_atime(const struct path *path)
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

