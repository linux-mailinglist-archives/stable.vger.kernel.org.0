Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5607F3A00FE
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhFHSup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235688AbhFHSrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:47:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B11361417;
        Tue,  8 Jun 2021 18:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177481;
        bh=4FcyaguISM1PgqqomZKvZuyeUf7ahnUYCUJk4+qmEZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xfjl0IfjYSemaaOqsPEHIRTfUsExeWkQJcfWOumTJX1NSNE7fS7utTZZ9qF22UptG
         vQIgz0xVj8GXl1IqoJz1GnaU6d6gopucpmQ15ZawOIcL/QIAPcksFBEP7KuDekZU5t
         iqJJAob60SUKnLY3PF4LLjgQMFvbWXrc4OWH4v+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Qian Cai <cai@lca.pw>, Song Liu <songliubraving@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 66/78] XArray: add xa_get_order
Date:   Tue,  8 Jun 2021 20:27:35 +0200
Message-Id: <20210608175937.496153693@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

commit 57417cebc96b57122a2207fc84a6077d20c84b4b upstream

Patch series "Fix read-only THP for non-tmpfs filesystems".

As described more verbosely in the [3/3] changelog, we can inadvertently
put an order-0 page in the page cache which occupies 512 consecutive
entries.  Users are running into this if they enable the
READ_ONLY_THP_FOR_FS config option; see
https://bugzilla.kernel.org/show_bug.cgi?id=206569 and Qian Cai has also
reported it here:
https://lore.kernel.org/lkml/20200616013309.GB815@lca.pw/

This is a rather intrusive way of fixing the problem, but has the
advantage that I've actually been testing it with the THP patches, which
means that it sees far more use than it does upstream -- indeed, Song has
been entirely unable to reproduce it.  It also has the advantage that it
removes a few patches from my gargantuan backlog of THP patches.

This patch (of 3):

This function returns the order of the entry at the index.  We need this
because there isn't space in the shadow entry to encode its order.

[akpm@linux-foundation.org: export xa_get_order to modules]

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Qian Cai <cai@lca.pw>
Cc: Song Liu <songliubraving@fb.com>
Link: https://lkml.kernel.org/r/20200903183029.14930-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20200903183029.14930-2-willy@infradead.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/xarray.h |    9 +++++++++
 lib/test_xarray.c      |   21 +++++++++++++++++++++
 lib/xarray.c           |   40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+)

--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1470,6 +1470,15 @@ void xas_pause(struct xa_state *);
 
 void xas_create_range(struct xa_state *);
 
+#ifdef CONFIG_XARRAY_MULTI
+int xa_get_order(struct xarray *, unsigned long index);
+#else
+static inline int xa_get_order(struct xarray *xa, unsigned long index)
+{
+	return 0;
+}
+#endif
+
 /**
  * xas_reload() - Refetch an entry from the xarray.
  * @xas: XArray operation state.
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1649,6 +1649,26 @@ static noinline void check_account(struc
 #endif
 }
 
+static noinline void check_get_order(struct xarray *xa)
+{
+	unsigned int max_order = IS_ENABLED(CONFIG_XARRAY_MULTI) ? 20 : 1;
+	unsigned int order;
+	unsigned long i, j;
+
+	for (i = 0; i < 3; i++)
+		XA_BUG_ON(xa, xa_get_order(xa, i) != 0);
+
+	for (order = 0; order < max_order; order++) {
+		for (i = 0; i < 10; i++) {
+			xa_store_order(xa, i << order, order,
+					xa_mk_index(i << order), GFP_KERNEL);
+			for (j = i << order; j < (i + 1) << order; j++)
+				XA_BUG_ON(xa, xa_get_order(xa, j) != order);
+			xa_erase(xa, i << order);
+		}
+	}
+}
+
 static noinline void check_destroy(struct xarray *xa)
 {
 	unsigned long index;
@@ -1697,6 +1717,7 @@ static int xarray_checks(void)
 	check_reserve(&array);
 	check_reserve(&xa0);
 	check_multi_store(&array);
+	check_get_order(&array);
 	check_xa_alloc();
 	check_find(&array);
 	check_find_entry(&array);
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1592,6 +1592,46 @@ unlock:
 	return xas_result(&xas, NULL);
 }
 EXPORT_SYMBOL(xa_store_range);
+
+/**
+ * xa_get_order() - Get the order of an entry.
+ * @xa: XArray.
+ * @index: Index of the entry.
+ *
+ * Return: A number between 0 and 63 indicating the order of the entry.
+ */
+int xa_get_order(struct xarray *xa, unsigned long index)
+{
+	XA_STATE(xas, xa, index);
+	void *entry;
+	int order = 0;
+
+	rcu_read_lock();
+	entry = xas_load(&xas);
+
+	if (!entry)
+		goto unlock;
+
+	if (!xas.xa_node)
+		goto unlock;
+
+	for (;;) {
+		unsigned int slot = xas.xa_offset + (1 << order);
+
+		if (slot >= XA_CHUNK_SIZE)
+			break;
+		if (!xa_is_sibling(xas.xa_node->slots[slot]))
+			break;
+		order++;
+	}
+
+	order += xas.xa_node->shift;
+unlock:
+	rcu_read_unlock();
+
+	return order;
+}
+EXPORT_SYMBOL(xa_get_order);
 #endif /* CONFIG_XARRAY_MULTI */
 
 /**


