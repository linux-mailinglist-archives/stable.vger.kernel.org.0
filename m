Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429D81BCA40
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbgD1SlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730800AbgD1SlB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:41:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1598B2076A;
        Tue, 28 Apr 2020 18:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099261;
        bh=1dk3KTCDU6EOcCn8O51KsGwI6VoE3fjIwnY5nvJO1yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmCYzG+2jgT0ZGOPvUDNNZNmwkb3dpVrXScSQvJD0BrgKZ2YghXHrIY0bioHOysPY
         Mom2rMsotWJOztZ/NuoSxmWN84iOkIGtdWs44z4Ml0ig2MET2WjhyoydcJq9dIFMGQ
         h61c2WkAsTEJ8Dr45TEemo3BZ6Dj+rfjq+S55y04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/168] KEYS: Avoid false positive ENOMEM error on key read
Date:   Tue, 28 Apr 2020 20:24:17 +0200
Message-Id: <20200428182242.711179853@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit 4f0882491a148059a52480e753b7f07fc550e188 ]

By allocating a kernel buffer with a user-supplied buffer length, it
is possible that a false positive ENOMEM error may be returned because
the user-supplied length is just too large even if the system do have
enough memory to hold the actual key data.

Moreover, if the buffer length is larger than the maximum amount of
memory that can be returned by kmalloc() (2^(MAX_ORDER-1) number of
pages), a warning message will also be printed.

To reduce this possibility, we set a threshold (PAGE_SIZE) over which we
do check the actual key length first before allocating a buffer of the
right size to hold it. The threshold is arbitrary, it is just used to
trigger a buffer length check. It does not limit the actual key length
as long as there is enough memory to satisfy the memory request.

To further avoid large buffer allocation failure due to page
fragmentation, kvmalloc() is used to allocate the buffer so that vmapped
pages can be used when there is not a large enough contiguous set of
pages available for allocation.

In the extremely unlikely scenario that the key keeps on being changed
and made longer (still <= buflen) in between 2 __keyctl_read_key()
calls, the __keyctl_read_key() calling loop in keyctl_read_key() may
have to be iterated a large number of times, but definitely not infinite.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/internal.h | 12 +++++++++
 security/keys/keyctl.c   | 58 +++++++++++++++++++++++++++++-----------
 2 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/security/keys/internal.h b/security/keys/internal.h
index c039373488bd9..7e99149436167 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -16,6 +16,8 @@
 #include <linux/keyctl.h>
 #include <linux/refcount.h>
 #include <linux/compat.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
 
 struct iovec;
 
@@ -349,4 +351,14 @@ static inline void key_check(const struct key *key)
 
 #endif
 
+/*
+ * Helper function to clear and free a kvmalloc'ed memory object.
+ */
+static inline void __kvzfree(const void *addr, size_t len)
+{
+	if (addr) {
+		memset((void *)addr, 0, len);
+		kvfree(addr);
+	}
+}
 #endif /* _INTERNAL_H */
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 106e16f9006b4..5e01192e222a0 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -339,7 +339,7 @@ long keyctl_update_key(key_serial_t id,
 	payload = NULL;
 	if (plen) {
 		ret = -ENOMEM;
-		payload = kmalloc(plen, GFP_KERNEL);
+		payload = kvmalloc(plen, GFP_KERNEL);
 		if (!payload)
 			goto error;
 
@@ -360,7 +360,7 @@ long keyctl_update_key(key_serial_t id,
 
 	key_ref_put(key_ref);
 error2:
-	kzfree(payload);
+	__kvzfree(payload, plen);
 error:
 	return ret;
 }
@@ -827,7 +827,8 @@ long keyctl_read_key(key_serial_t keyid, char __user *buffer, size_t buflen)
 	struct key *key;
 	key_ref_t key_ref;
 	long ret;
-	char *key_data;
+	char *key_data = NULL;
+	size_t key_data_len;
 
 	/* find the key first */
 	key_ref = lookup_user_key(keyid, 0, 0);
@@ -878,24 +879,51 @@ can_read_key:
 	 * Allocating a temporary buffer to hold the keys before
 	 * transferring them to user buffer to avoid potential
 	 * deadlock involving page fault and mmap_sem.
+	 *
+	 * key_data_len = (buflen <= PAGE_SIZE)
+	 *		? buflen : actual length of key data
+	 *
+	 * This prevents allocating arbitrary large buffer which can
+	 * be much larger than the actual key length. In the latter case,
+	 * at least 2 passes of this loop is required.
 	 */
-	key_data = kmalloc(buflen, GFP_KERNEL);
+	key_data_len = (buflen <= PAGE_SIZE) ? buflen : 0;
+	for (;;) {
+		if (key_data_len) {
+			key_data = kvmalloc(key_data_len, GFP_KERNEL);
+			if (!key_data) {
+				ret = -ENOMEM;
+				goto key_put_out;
+			}
+		}
 
-	if (!key_data) {
-		ret = -ENOMEM;
-		goto key_put_out;
-	}
-	ret = __keyctl_read_key(key, key_data, buflen);
+		ret = __keyctl_read_key(key, key_data, key_data_len);
+
+		/*
+		 * Read methods will just return the required length without
+		 * any copying if the provided length isn't large enough.
+		 */
+		if (ret <= 0 || ret > buflen)
+			break;
+
+		/*
+		 * The key may change (unlikely) in between 2 consecutive
+		 * __keyctl_read_key() calls. In this case, we reallocate
+		 * a larger buffer and redo the key read when
+		 * key_data_len < ret <= buflen.
+		 */
+		if (ret > key_data_len) {
+			if (unlikely(key_data))
+				__kvzfree(key_data, key_data_len);
+			key_data_len = ret;
+			continue;	/* Allocate buffer */
+		}
 
-	/*
-	 * Read methods will just return the required length without
-	 * any copying if the provided length isn't large enough.
-	 */
-	if (ret > 0 && ret <= buflen) {
 		if (copy_to_user(buffer, key_data, ret))
 			ret = -EFAULT;
+		break;
 	}
-	kzfree(key_data);
+	__kvzfree(key_data, key_data_len);
 
 key_put_out:
 	key_put(key);
-- 
2.20.1



