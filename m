Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2BB2DEE19
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 11:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgLSKGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 05:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgLSKGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 05:06:12 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191AFC0617B0;
        Sat, 19 Dec 2020 02:05:32 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id q22so6792013eja.2;
        Sat, 19 Dec 2020 02:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7W4RYxZj8lkWpWkE7UHIfL8SS0IH4o1LBa7PCi5M3wI=;
        b=dhyBJMtvrKQNAWrETDplQ9mjvDaT0lh2/dFwdO2c0yU2efoRcGvwZwz3avH4WtFGC+
         f28q7HEh/McQ/uRy7sCWOjFq29M+CPf0y7X+bk1MV74YMoA9c9Zy4HtweGrFAgK+oIoz
         /J8POygW0Q/0TegHzFprmxfxKKXHx5eC7NbNWRvgyWUF/9BK7SZfOm9KNHELouT9K2rO
         EBA7TD/lYPdWjTU+T7FU81vV+iODZ3YlFNXlhWPNEtjyn3geSy6V2D8ce/s5au8tZc8l
         NEthhUaBKP6Jk0H3Mpbyx2vroIiDgUo8CKfZI0jmV8FsPsQ+eCf6PGGR7gHodeeGM8kk
         4GOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7W4RYxZj8lkWpWkE7UHIfL8SS0IH4o1LBa7PCi5M3wI=;
        b=HZHA98jMvRTwrU25mwCKVkqnraZaErLTQzr2VDCf1xMQ57zfGjZppvO66tcCn3VM/l
         8zTygnXBP4K6ZhqMMjPrMYjMb114YBjdW4cZv+h7jARQsBdCKAoUOvUgt8qZxWR5fjgJ
         /1gCr1CfThMj4u2Uwz5xbxmbqZ4E50JBy5hcelZunxdrm7k9Elj+TvCAYcKglpLYt2iL
         NOcg66tbLjUXhdTmi1exhGeDYch2U3S9DOlz7wXv4PTkAPOOES5s9uK8XVcOdq+V814P
         0OBDCSPuc0r+jJPOcIdUShj10Yi9jCsiAU7Qvfh+FL7pvXCezfeBpzNVcYrC7bE/AkCX
         GbeQ==
X-Gm-Message-State: AOAM532FSSRQWBRr+VVd5CtP6X1h3UIdt4zcl3kgnk9DewpIQsUAGslW
        GIB0JTWKP3ADDhSpQ8kli5A=
X-Google-Smtp-Source: ABdhPJze5KIsjiEkOFsbxg5X9Tu9I1qLEYe8iHtQXSOXOjINhhuqqibupHdBQQGJWKLZ7qpz4ZRMxg==
X-Received: by 2002:a17:906:f153:: with SMTP id gw19mr7918482ejb.272.1608372330717;
        Sat, 19 Dec 2020 02:05:30 -0800 (PST)
Received: from localhost.localdomain ([31.210.181.203])
        by smtp.gmail.com with ESMTPSA id a10sm6633651ejk.92.2020.12.19.02.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 02:05:30 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Michael Labriola <michael.d.labriola@gmail.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] selinux: fix inconsistency between inode_getxattr and inode_listsecurity
Date:   Sat, 19 Dec 2020 12:05:27 +0200
Message-Id: <20201219100527.16060-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When inode has no listxattr op of its own (e.g. squashfs) vfs_listxattr
calls the LSM inode_listsecurity hooks to list the xattrs that LSMs will
intercept in inode_getxattr hooks.

When selinux LSM is installed but not initialized, it will list the
security.selinux xattr in inode_listsecurity, but will not intercept it
in inode_getxattr.  This results in -ENODATA for a getxattr call for an
xattr returned by listxattr.

This situation was manifested as overlayfs failure to copy up lower
files from squashfs when selinux is built-in but not initialized,
because ovl_copy_xattr() iterates the lower inode xattrs by
vfs_listxattr() and vfs_getxattr().

Match the logic of inode_listsecurity to that of inode_getxattr and
do not list the security.selinux xattr if selinux is not initialized.

Reported-by: Michael Labriola <michael.d.labriola@gmail.com>
Tested-by: Michael Labriola <michael.d.labriola@gmail.com>
Link: https://lore.kernel.org/linux-unionfs/2nv9d47zt7.fsf@aldarion.sourceruckus.org/
Fixes: c8e222616c7e ("selinux: allow reading labels before policy is loaded")
Cc: stable@vger.kernel.org#v5.9+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 security/selinux/hooks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6b1826fc3658..e132e082a5af 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3406,6 +3406,10 @@ static int selinux_inode_setsecurity(struct inode *inode, const char *name,
 static int selinux_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size)
 {
 	const int len = sizeof(XATTR_NAME_SELINUX);
+
+	if (!selinux_initialized(&selinux_state))
+		return 0;
+
 	if (buffer && len <= buffer_size)
 		memcpy(buffer, XATTR_NAME_SELINUX, len);
 	return len;
-- 
2.25.1

