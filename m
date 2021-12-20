Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81DB47AFCE
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237790AbhLTPUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238186AbhLTPSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:18:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5B5C00FC78;
        Mon, 20 Dec 2021 06:59:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D95B611A7;
        Mon, 20 Dec 2021 14:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3932AC36AE7;
        Mon, 20 Dec 2021 14:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012359;
        bh=q/kimq+Yzy6ZHPGTnASfxMdyvyA5hehqC61nggoLPPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ma5pa8XnuaIvT5KqFhCB1PBF7hNGxM2YEvtUQn1aMXd3gAhS37TXVHRExjqs2wUfD
         U2tbBJNuA/JVKWWz+YVCQpts0eg9IztF4hjJRaWyjFBdb/1oBLooILcCn5K/Ir9a9L
         psKw+NPL1cqjRXkBVy3o7v3SuqVNlzlcUF88Z5X4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Thiago Rafael Becker <trbecker@gmail.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 140/177] cifs: sanitize multiple delimiters in prepath
Date:   Mon, 20 Dec 2021 15:34:50 +0100
Message-Id: <20211220143044.795802497@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thiago Rafael Becker <trbecker@gmail.com>

commit a31080899d5fdafcccf7f39dd214a814a2c82626 upstream.

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
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Thiago Rafael Becker <trbecker@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/fs_context.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -432,6 +432,42 @@ out:
 }
 
 /*
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
+/*
  * Parse a devname into substrings and populate the ctx->UNC and ctx->prepath
  * fields with the result. Returns 0 on success and an error otherwise
  * (e.g. ENOMEM or EINVAL)
@@ -490,7 +526,7 @@ smb3_parse_devname(const char *devname,
 	if (!*pos)
 		return 0;
 
-	ctx->prepath = kstrdup(pos, GFP_KERNEL);
+	ctx->prepath = sanitize_path(pos);
 	if (!ctx->prepath)
 		return -ENOMEM;
 


