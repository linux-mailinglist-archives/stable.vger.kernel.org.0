Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D813288A4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbhCARnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233254AbhCARfJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:35:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0873464FBB;
        Mon,  1 Mar 2021 16:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617666;
        bh=3Fgy4sTjE3O5lPvAZyRXzlWXb8xt+MXREJIzXdjOc2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sb4wdyNL6VcLlh/O6NBCFqrSnkOB6EcUJNyjmy3VRqUKed3BAwdI0IXPGZ6zGtrS1
         huc75MHddw7whKDORhcu1eh4+JsIwvB/MBgb/fLAmcUZPfpl9f4FAllVFK5ofBUj+X
         VhFfkTg7bSE+/hOuxOtfdl6VFElKv74QYzNp+KiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 153/340] certs: Fix blacklist flag type confusion
Date:   Mon,  1 Mar 2021 17:11:37 +0100
Message-Id: <20210301161055.847676041@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 4993e1f9479a4161fd7d93e2b8b30b438f00cb0f ]

KEY_FLAG_KEEP is not meant to be passed to keyring_alloc() or key_alloc(),
as these only take KEY_ALLOC_* flags.  KEY_FLAG_KEEP has the same value as
KEY_ALLOC_BYPASS_RESTRICTION, but fortunately only key_create_or_update()
uses it.  LSMs using the key_alloc hook don't check that flag.

KEY_FLAG_KEEP is then ignored but fortunately (again) the root user cannot
write to the blacklist keyring, so it is not possible to remove a key/hash
from it.

Fix this by adding a KEY_ALLOC_SET_KEEP flag that tells key_alloc() to set
KEY_FLAG_KEEP on the new key.  blacklist_init() can then, correctly, pass
this to keyring_alloc().

We can also use this in ima_mok_init() rather than setting the flag
manually.

Note that this doesn't fix an observable bug with the current
implementation but it is required to allow addition of new hashes to the
blacklist in the future without making it possible for them to be removed.

Fixes: 734114f8782f ("KEYS: Add a system blacklist keyring")
Reported-by: Mickaël Salaün <mic@linux.microsoft.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Mickaël Salaün <mic@linux.microsoft.com>
cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 certs/blacklist.c                | 2 +-
 include/linux/key.h              | 1 +
 security/integrity/ima/ima_mok.c | 5 ++---
 security/keys/key.c              | 2 ++
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/certs/blacklist.c b/certs/blacklist.c
index ec00bf337eb67..025a41de28fda 100644
--- a/certs/blacklist.c
+++ b/certs/blacklist.c
@@ -153,7 +153,7 @@ static int __init blacklist_init(void)
 			      KEY_USR_VIEW | KEY_USR_READ |
 			      KEY_USR_SEARCH,
 			      KEY_ALLOC_NOT_IN_QUOTA |
-			      KEY_FLAG_KEEP,
+			      KEY_ALLOC_SET_KEEP,
 			      NULL, NULL);
 	if (IS_ERR(blacklist_keyring))
 		panic("Can't allocate system blacklist keyring\n");
diff --git a/include/linux/key.h b/include/linux/key.h
index 6cf8e71cf8b7c..9c26cc9b802a0 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -269,6 +269,7 @@ extern struct key *key_alloc(struct key_type *type,
 #define KEY_ALLOC_BUILT_IN		0x0004	/* Key is built into kernel */
 #define KEY_ALLOC_BYPASS_RESTRICTION	0x0008	/* Override the check on restricted keyrings */
 #define KEY_ALLOC_UID_KEYRING		0x0010	/* allocating a user or user session keyring */
+#define KEY_ALLOC_SET_KEEP		0x0020	/* Set the KEEP flag on the key/keyring */
 
 extern void key_revoke(struct key *key);
 extern void key_invalidate(struct key *key);
diff --git a/security/integrity/ima/ima_mok.c b/security/integrity/ima/ima_mok.c
index 36cadadbfba47..1e5c019161738 100644
--- a/security/integrity/ima/ima_mok.c
+++ b/security/integrity/ima/ima_mok.c
@@ -38,13 +38,12 @@ __init int ima_mok_init(void)
 				(KEY_POS_ALL & ~KEY_POS_SETATTR) |
 				KEY_USR_VIEW | KEY_USR_READ |
 				KEY_USR_WRITE | KEY_USR_SEARCH,
-				KEY_ALLOC_NOT_IN_QUOTA,
+				KEY_ALLOC_NOT_IN_QUOTA |
+				KEY_ALLOC_SET_KEEP,
 				restriction, NULL);
 
 	if (IS_ERR(ima_blacklist_keyring))
 		panic("Can't allocate IMA blacklist keyring.");
-
-	set_bit(KEY_FLAG_KEEP, &ima_blacklist_keyring->flags);
 	return 0;
 }
 device_initcall(ima_mok_init);
diff --git a/security/keys/key.c b/security/keys/key.c
index e9845d0d8d349..623fcb4094dd4 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -302,6 +302,8 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 		key->flags |= 1 << KEY_FLAG_BUILTIN;
 	if (flags & KEY_ALLOC_UID_KEYRING)
 		key->flags |= 1 << KEY_FLAG_UID_KEYRING;
+	if (flags & KEY_ALLOC_SET_KEEP)
+		key->flags |= 1 << KEY_FLAG_KEEP;
 
 #ifdef KEY_DEBUGGING
 	key->magic = KEY_DEBUG_MAGIC;
-- 
2.27.0



