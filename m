Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFD44793FB
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 19:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbhLQSVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 13:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbhLQSVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 13:21:43 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF6DC061574;
        Fri, 17 Dec 2021 10:21:43 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id t13so5907414uad.9;
        Fri, 17 Dec 2021 10:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+y22jHbqQZDK8m/WWN/kME90chEPhhMX+wdbHczsHEY=;
        b=ia3gfZArhfZPnaCC4+1Z3+XNE42MlPD3hDLf2pwl+2T3/apxOFS6/XMhcWzHa70KJI
         yaCVnJ4BT7yCyO3n8Vklnzaf6uaYkagIFPj5pYgPBf7p+xqH5O+z+SzC7jLrYqf/nDqQ
         gjqlp4C0sXCcXas8GsQ9hWlSpTbP28erOOgwmyZtA/lz2h/xrNbmD/i3WtiQFJGxw5In
         lNToEKS9RX3ue8YHHR+VS5NG8rtUIbn8CWoERlnERbUterRof7Vm04L3safj+WWxlOuX
         ogAC0vHK6crMvbuCKFb1GVhLJOUz9JwH1qWJOfUSZLLIy43kOupRUnbp7lEm5NR4r1p/
         nsKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+y22jHbqQZDK8m/WWN/kME90chEPhhMX+wdbHczsHEY=;
        b=Xm0ZqPqGNFdj/vYDM/D5vObDcRrhI/t/bBFTbPLcrfRbO001QA46UwPnxTWzijH+IT
         V63raQ+jqoC43izVC6a0jYLOmHX7K1bE0F9oH1Lk+veI5I0VwTD5zDCeMqvBrizG3lDZ
         lGNg/CjiqIkNrcLbk1tHfeYVztXv5or84Vzm+T30svxeg1z9Hv9CFbsBRTZpDunZ+sU6
         o4B0p5n7gW34DagVRfNBklQW5y4c4W5bTlTqyIX9794pmnAs5PyTOCyqJs6zGNqM3HNP
         X4x/U8hBFZnE/IDb61WuhK/G4Wp604VhEb9vDBEbzEIqCjEkqEvXaN53FVtQxgQnE4x3
         4Ffg==
X-Gm-Message-State: AOAM532gpFTxmKfYRb0FaXZ33f4srgjckGXA9y2t2oi+s7zoO7MteU3R
        2y2qpoUa63z7vf90S8ayXSGPQg5w6QQ=
X-Google-Smtp-Source: ABdhPJxKnmcyycAGJAvFuCeTRDfhFLEuw9yCgTJ6xlpx1roas+eSve61HUfTgFQHt1nbTWCHrA2ygg==
X-Received: by 2002:a9f:24d6:: with SMTP id 80mr1661616uar.132.1639765302215;
        Fri, 17 Dec 2021 10:21:42 -0800 (PST)
Received: from nyarly.rlyeh.local ([179.233.248.238])
        by smtp.gmail.com with ESMTPSA id l28sm2127439vkn.45.2021.12.17.10.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 10:21:41 -0800 (PST)
From:   Thiago Rafael Becker <trbecker@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Steve French <sfrench@samba.org>, linux-kernel@vger.kernel.org,
        lsahlber@redhat.com, Thiago Rafael Becker <trbecker@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] cifs: sanitize multiple delimiters in prepath
Date:   Fri, 17 Dec 2021 15:20:22 -0300
Message-Id: <20211217182022.589857-1-trbecker@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

mount.cifs can pass a device with multiple delimiters in it. This will
cause rename(2) to fail with ENOENT.

V2:
  - Make sanitize_path more readable.
  - Fix multiple delimiters between UNC and prepath.
  - Avoid a memory leak if a bad user starts putting a lot of delimiters
    in the path on purpose.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=2031200
Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Cc: stable@vger.kernel.org # 5.11+
Signed-off-by: Thiago Rafael Becker <trbecker@gmail.com>
---
 fs/cifs/fs_context.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 6a179ae753c1..e3ed25dc6f3f 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -434,6 +434,42 @@ int smb3_parse_opt(const char *options, const char *key, char **val)
 	return rc;
 }
 
+/*
+ * Remove duplicate path delimiters. Windows is supposed to do that
+ * but there are some bugs that prevent rename from working if there are
+ * multiple delimiters.
+ *
+ * Returns a sanitized duplicate of @path. The caller is responsible for
+ * cleaning up the original.
+ */
+#define IS_DELIM(c) ((c) == '/' || (c) == '\\')
+static char *sanitize_path(char *path)
+{
+	char *cursor1 = path, *cursor2 = path;
+
+	/* skip all prepended delimiters */
+	while (IS_DELIM(*cursor1))
+		cursor1++;
+
+	/* copy the first letter */
+	*cursor2 = *cursor1;
+
+	/* copy the remainder... */
+	while (*(cursor1++)) {
+		/* ... skipping all duplicated delimiters */
+		if (IS_DELIM(*cursor1) && IS_DELIM(*cursor2))
+			continue;
+		*(++cursor2) = *cursor1;
+	}
+
+	/* if the last character is a delimiter, skip it */
+	if (IS_DELIM(*(cursor2 - 1)))
+		cursor2--;
+
+	*(cursor2) = '\0';
+	return kstrdup(path, GFP_KERNEL);
+}
+
 /*
  * Parse a devname into substrings and populate the ctx->UNC and ctx->prepath
  * fields with the result. Returns 0 on success and an error otherwise
@@ -493,7 +529,7 @@ smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
 	if (!*pos)
 		return 0;
 
-	ctx->prepath = kstrdup(pos, GFP_KERNEL);
+	ctx->prepath = sanitize_path(pos);
 	if (!ctx->prepath)
 		return -ENOMEM;
 
-- 
2.31.1

