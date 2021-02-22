Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4F1321735
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhBVMoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:44:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:52900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231302AbhBVMmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:42:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0657E64F2E;
        Mon, 22 Feb 2021 12:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997588;
        bh=FxvIie0TwWdYwhTUKc9EkfUgOQU5MaeD4kpPsCa6Cmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQwauM+ixIqk2PtQKxzxihnK7mShsWVZGkM6KPRRT3BVpXGwBhunSpFyQh6QhKnq+
         yJhrBC0VId8FV9t6QV78EAkA2ud7CgJXX6IvkXHgdNvVw5OgWx1wKWteq9Eqk1IcOH
         Wm/bPbVORiA+JRsc4W2rrJJotbFvzo/vSweyUK14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Wysochanski <dwysocha@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 06/35] SUNRPC: Move simple_get_bytes and simple_get_netobj into private header
Date:   Mon, 22 Feb 2021 13:36:02 +0100
Message-Id: <20210222121018.386753841@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
References: <20210222121013.581198717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Wysochanski <dwysocha@redhat.com>

[ Upstream commit ba6dfce47c4d002d96cd02a304132fca76981172 ]

Remove duplicated helper functions to parse opaque XDR objects
and place inside new file net/sunrpc/auth_gss/auth_gss_internal.h.
In the new file carry the license and copyright from the source file
net/sunrpc/auth_gss/auth_gss.c.  Finally, update the comment inside
include/linux/sunrpc/xdr.h since lockd is not the only user of
struct xdr_netobj.

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/xdr.h              |  3 +-
 net/sunrpc/auth_gss/auth_gss.c          | 30 +-----------------
 net/sunrpc/auth_gss/auth_gss_internal.h | 42 +++++++++++++++++++++++++
 net/sunrpc/auth_gss/gss_krb5_mech.c     | 31 ++----------------
 4 files changed, 46 insertions(+), 60 deletions(-)
 create mode 100644 net/sunrpc/auth_gss/auth_gss_internal.h

diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index 70c6b92e15a7c..8def5e0a491fa 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -23,8 +23,7 @@
 #define XDR_QUADLEN(l)		(((l) + 3) >> 2)
 
 /*
- * Generic opaque `network object.' At the kernel level, this type
- * is used only by lockd.
+ * Generic opaque `network object.'
  */
 #define XDR_MAX_NETOBJ		1024
 struct xdr_netobj {
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 62fca77bf3c70..7bde2976307ed 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -53,6 +53,7 @@
 #include <asm/uaccess.h>
 #include <linux/hashtable.h>
 
+#include "auth_gss_internal.h"
 #include "../netns.h"
 
 static const struct rpc_authops authgss_ops;
@@ -147,35 +148,6 @@ gss_cred_set_ctx(struct rpc_cred *cred, struct gss_cl_ctx *ctx)
 	clear_bit(RPCAUTH_CRED_NEW, &cred->cr_flags);
 }
 
-static const void *
-simple_get_bytes(const void *p, const void *end, void *res, size_t len)
-{
-	const void *q = (const void *)((const char *)p + len);
-	if (unlikely(q > end || q < p))
-		return ERR_PTR(-EFAULT);
-	memcpy(res, p, len);
-	return q;
-}
-
-static inline const void *
-simple_get_netobj(const void *p, const void *end, struct xdr_netobj *dest)
-{
-	const void *q;
-	unsigned int len;
-
-	p = simple_get_bytes(p, end, &len, sizeof(len));
-	if (IS_ERR(p))
-		return p;
-	q = (const void *)((const char *)p + len);
-	if (unlikely(q > end || q < p))
-		return ERR_PTR(-EFAULT);
-	dest->data = kmemdup(p, len, GFP_NOFS);
-	if (unlikely(dest->data == NULL))
-		return ERR_PTR(-ENOMEM);
-	dest->len = len;
-	return q;
-}
-
 static struct gss_cl_ctx *
 gss_cred_get_ctx(struct rpc_cred *cred)
 {
diff --git a/net/sunrpc/auth_gss/auth_gss_internal.h b/net/sunrpc/auth_gss/auth_gss_internal.h
new file mode 100644
index 0000000000000..c5603242b54bf
--- /dev/null
+++ b/net/sunrpc/auth_gss/auth_gss_internal.h
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/*
+ * linux/net/sunrpc/auth_gss/auth_gss_internal.h
+ *
+ * Internal definitions for RPCSEC_GSS client authentication
+ *
+ * Copyright (c) 2000 The Regents of the University of Michigan.
+ * All rights reserved.
+ *
+ */
+#include <linux/err.h>
+#include <linux/string.h>
+#include <linux/sunrpc/xdr.h>
+
+static inline const void *
+simple_get_bytes(const void *p, const void *end, void *res, size_t len)
+{
+	const void *q = (const void *)((const char *)p + len);
+	if (unlikely(q > end || q < p))
+		return ERR_PTR(-EFAULT);
+	memcpy(res, p, len);
+	return q;
+}
+
+static inline const void *
+simple_get_netobj(const void *p, const void *end, struct xdr_netobj *dest)
+{
+	const void *q;
+	unsigned int len;
+
+	p = simple_get_bytes(p, end, &len, sizeof(len));
+	if (IS_ERR(p))
+		return p;
+	q = (const void *)((const char *)p + len);
+	if (unlikely(q > end || q < p))
+		return ERR_PTR(-EFAULT);
+	dest->data = kmemdup(p, len, GFP_NOFS);
+	if (unlikely(dest->data == NULL))
+		return ERR_PTR(-ENOMEM);
+	dest->len = len;
+	return q;
+}
diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index 28db442a0034a..89e616da161fd 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -45,6 +45,8 @@
 #include <linux/crypto.h>
 #include <linux/sunrpc/gss_krb5_enctypes.h>
 
+#include "auth_gss_internal.h"
+
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
 # define RPCDBG_FACILITY	RPCDBG_AUTH
 #endif
@@ -186,35 +188,6 @@ get_gss_krb5_enctype(int etype)
 	return NULL;
 }
 
-static const void *
-simple_get_bytes(const void *p, const void *end, void *res, int len)
-{
-	const void *q = (const void *)((const char *)p + len);
-	if (unlikely(q > end || q < p))
-		return ERR_PTR(-EFAULT);
-	memcpy(res, p, len);
-	return q;
-}
-
-static const void *
-simple_get_netobj(const void *p, const void *end, struct xdr_netobj *res)
-{
-	const void *q;
-	unsigned int len;
-
-	p = simple_get_bytes(p, end, &len, sizeof(len));
-	if (IS_ERR(p))
-		return p;
-	q = (const void *)((const char *)p + len);
-	if (unlikely(q > end || q < p))
-		return ERR_PTR(-EFAULT);
-	res->data = kmemdup(p, len, GFP_NOFS);
-	if (unlikely(res->data == NULL))
-		return ERR_PTR(-ENOMEM);
-	res->len = len;
-	return q;
-}
-
 static inline const void *
 get_key(const void *p, const void *end,
 	struct krb5_ctx *ctx, struct crypto_blkcipher **res)
-- 
2.27.0



