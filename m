Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26E41FBB82
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731659AbgFPQTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730205AbgFPPhH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:37:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E9E12098B;
        Tue, 16 Jun 2020 15:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321826;
        bh=zpIpPomPOC5UU8WDjgESvYXTrjxI7qC3+cdXH6qAkQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LHek30uWBypu6+HJdutv0TY/HP76121wj0N30RUXigVSQheMV+WUSXQnmqW1KhANa
         Q9lT0Qsd214ce5THHE+sUI1i56kbvCkZi8m6ZfasziHuG/uxompuzEy6HrC7ZdV1GJ
         HKo7bURpzreXoWkvGnoJP28tB1V1zEGiPOocbXII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <longman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Biggers <ebiggers@google.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Joe Perches <joe@perches.com>,
        Matthew Wilcox <willy@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/134] mm: add kvfree_sensitive() for freeing sensitive data objects
Date:   Tue, 16 Jun 2020 17:33:34 +0200
Message-Id: <20200616153102.223495522@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit d4eaa2837851db2bfed572898bfc17f9a9f9151e ]

For kvmalloc'ed data object that contains sensitive information like
cryptographic keys, we need to make sure that the buffer is always cleared
before freeing it.  Using memset() alone for buffer clearing may not
provide certainty as the compiler may compile it away.  To be sure, the
special memzero_explicit() has to be used.

This patch introduces a new kvfree_sensitive() for freeing those sensitive
data objects allocated by kvmalloc().  The relevant places where
kvfree_sensitive() can be used are modified to use it.

Fixes: 4f0882491a14 ("KEYS: Avoid false positive ENOMEM error on key read")
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Joe Perches <joe@perches.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Link: http://lkml.kernel.org/r/20200407200318.11711-1-longman@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mm.h       |  1 +
 mm/util.c                | 18 ++++++++++++++++++
 security/keys/internal.h | 11 -----------
 security/keys/keyctl.c   | 16 +++++-----------
 4 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 53bad834adf5..3285dae06c03 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -694,6 +694,7 @@ static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
 }
 
 extern void kvfree(const void *addr);
+extern void kvfree_sensitive(const void *addr, size_t len);
 
 /*
  * Mapcount of compound page as a whole, does not include mapped sub-pages.
diff --git a/mm/util.c b/mm/util.c
index 3ad6db9a722e..ab358c64bbd3 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -594,6 +594,24 @@ void kvfree(const void *addr)
 }
 EXPORT_SYMBOL(kvfree);
 
+/**
+ * kvfree_sensitive - Free a data object containing sensitive information.
+ * @addr: address of the data object to be freed.
+ * @len: length of the data object.
+ *
+ * Use the special memzero_explicit() function to clear the content of a
+ * kvmalloc'ed object containing sensitive data to make sure that the
+ * compiler won't optimize out the data clearing.
+ */
+void kvfree_sensitive(const void *addr, size_t len)
+{
+	if (likely(!ZERO_OR_NULL_PTR(addr))) {
+		memzero_explicit((void *)addr, len);
+		kvfree(addr);
+	}
+}
+EXPORT_SYMBOL(kvfree_sensitive);
+
 static inline void *__page_rmapping(struct page *page)
 {
 	unsigned long mapping;
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 7e9914943616..1ca8bfaed0e8 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -350,15 +350,4 @@ static inline void key_check(const struct key *key)
 #define key_check(key) do {} while(0)
 
 #endif
-
-/*
- * Helper function to clear and free a kvmalloc'ed memory object.
- */
-static inline void __kvzfree(const void *addr, size_t len)
-{
-	if (addr) {
-		memset((void *)addr, 0, len);
-		kvfree(addr);
-	}
-}
 #endif /* _INTERNAL_H */
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 5e01192e222a..edde63a63007 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -142,10 +142,7 @@ SYSCALL_DEFINE5(add_key, const char __user *, _type,
 
 	key_ref_put(keyring_ref);
  error3:
-	if (payload) {
-		memzero_explicit(payload, plen);
-		kvfree(payload);
-	}
+	kvfree_sensitive(payload, plen);
  error2:
 	kfree(description);
  error:
@@ -360,7 +357,7 @@ long keyctl_update_key(key_serial_t id,
 
 	key_ref_put(key_ref);
 error2:
-	__kvzfree(payload, plen);
+	kvfree_sensitive(payload, plen);
 error:
 	return ret;
 }
@@ -914,7 +911,7 @@ long keyctl_read_key(key_serial_t keyid, char __user *buffer, size_t buflen)
 		 */
 		if (ret > key_data_len) {
 			if (unlikely(key_data))
-				__kvzfree(key_data, key_data_len);
+				kvfree_sensitive(key_data, key_data_len);
 			key_data_len = ret;
 			continue;	/* Allocate buffer */
 		}
@@ -923,7 +920,7 @@ long keyctl_read_key(key_serial_t keyid, char __user *buffer, size_t buflen)
 			ret = -EFAULT;
 		break;
 	}
-	__kvzfree(key_data, key_data_len);
+	kvfree_sensitive(key_data, key_data_len);
 
 key_put_out:
 	key_put(key);
@@ -1225,10 +1222,7 @@ long keyctl_instantiate_key_common(key_serial_t id,
 		keyctl_change_reqkey_auth(NULL);
 
 error2:
-	if (payload) {
-		memzero_explicit(payload, plen);
-		kvfree(payload);
-	}
+	kvfree_sensitive(payload, plen);
 error:
 	return ret;
 }
-- 
2.25.1



