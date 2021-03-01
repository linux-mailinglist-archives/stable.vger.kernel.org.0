Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF130328544
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235694AbhCAQwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:52:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235619AbhCAQo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:44:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B90164E75;
        Mon,  1 Mar 2021 16:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616240;
        bh=tWdUGxfyINHSYfFsUn9PAa869QR+4uaxsWqg3S16LNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9eAxvyWJtDfZi5wHsM95bzdjMAUTbaP3l4G9aUrxEaD7nY7cYRI6rRB66efGmKhq
         2Wk9ZUeaVoOuYRVJpBowOMbpx3d5exXxG/am4Vw5RJSi/cau9wfescFy+ev8PhGFLu
         1dHurAPXjX6nkC9wNCHa0InEPXJsQHLe97AATI5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 082/176] certs: Fix blacklist flag type confusion
Date:   Mon,  1 Mar 2021 17:12:35 +0100
Message-Id: <20210301161025.042459610@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
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
index 3a507b9e2568a..e9f3f81c51f96 100644
--- a/certs/blacklist.c
+++ b/certs/blacklist.c
@@ -157,7 +157,7 @@ static int __init blacklist_init(void)
 			      KEY_USR_VIEW | KEY_USR_READ |
 			      KEY_USR_SEARCH,
 			      KEY_ALLOC_NOT_IN_QUOTA |
-			      KEY_FLAG_KEEP,
+			      KEY_ALLOC_SET_KEEP,
 			      NULL, NULL);
 	if (IS_ERR(blacklist_keyring))
 		panic("Can't allocate system blacklist keyring\n");
diff --git a/include/linux/key.h b/include/linux/key.h
index 8a15cabe928d0..8a66292090150 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -248,6 +248,7 @@ extern struct key *key_alloc(struct key_type *type,
 #define KEY_ALLOC_BUILT_IN		0x0004	/* Key is built into kernel */
 #define KEY_ALLOC_BYPASS_RESTRICTION	0x0008	/* Override the check on restricted keyrings */
 #define KEY_ALLOC_UID_KEYRING		0x0010	/* allocating a user or user session keyring */
+#define KEY_ALLOC_SET_KEEP		0x0020	/* Set the KEEP flag on the key/keyring */
 
 extern void key_revoke(struct key *key);
 extern void key_invalidate(struct key *key);
diff --git a/security/integrity/ima/ima_mok.c b/security/integrity/ima/ima_mok.c
index 073ddc9bce5ba..3e7a1523663b8 100644
--- a/security/integrity/ima/ima_mok.c
+++ b/security/integrity/ima/ima_mok.c
@@ -43,13 +43,12 @@ __init int ima_mok_init(void)
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
index 5f4cb271464a0..0dec3c82dde95 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -305,6 +305,8 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 		key->flags |= 1 << KEY_FLAG_BUILTIN;
 	if (flags & KEY_ALLOC_UID_KEYRING)
 		key->flags |= 1 << KEY_FLAG_UID_KEYRING;
+	if (flags & KEY_ALLOC_SET_KEEP)
+		key->flags |= 1 << KEY_FLAG_KEEP;
 
 #ifdef KEY_DEBUGGING
 	key->magic = KEY_DEBUG_MAGIC;
-- 
2.27.0



