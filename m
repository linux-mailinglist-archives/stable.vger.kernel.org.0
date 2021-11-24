Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A898F45C67E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351937AbhKXOKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354175AbhKXOGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:06:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7CEA633FE;
        Wed, 24 Nov 2021 13:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759519;
        bh=rddSBgIFGT2E1nkyJvYc7jsRF402ZYGjpieBaMV3paY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSn4YGHAV9gJj+VqA0xAO9XlMP8VqSogr0HxbQatlhrMcVIBLCOumh6M0DxugSVYB
         /ofvAs1D1C/9t7Jfh4+QsGgJxp+0WWAyOVr9kW4JEXoPZuo6Jmfu5A5GD3pvS+Tgmu
         gK54CcYmHVB0IuiD3hvL2TpE83kXDfoq37LVe22g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 270/279] selinux: fix NULL-pointer dereference when hashtab allocation fails
Date:   Wed, 24 Nov 2021 12:59:17 +0100
Message-Id: <20211124115728.017444288@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit dc27f3c5d10c58069672215787a96b4fae01818b upstream.

When the hash table slot array allocation fails in hashtab_init(),
h->size is left initialized with a non-zero value, but the h->htable
pointer is NULL. This may then cause a NULL pointer dereference, since
the policydb code relies on the assumption that even after a failed
hashtab_init(), hashtab_map() and hashtab_destroy() can be safely called
on it. Yet, these detect an empty hashtab only by looking at the size.

Fix this by making sure that hashtab_init() always leaves behind a valid
empty hashtab when the allocation fails.

Cc: stable@vger.kernel.org
Fixes: 03414a49ad5f ("selinux: do not allocate hashtabs dynamically")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/hashtab.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/security/selinux/ss/hashtab.c
+++ b/security/selinux/ss/hashtab.c
@@ -30,13 +30,20 @@ static u32 hashtab_compute_size(u32 nel)
 
 int hashtab_init(struct hashtab *h, u32 nel_hint)
 {
-	h->size = hashtab_compute_size(nel_hint);
+	u32 size = hashtab_compute_size(nel_hint);
+
+	/* should already be zeroed, but better be safe */
 	h->nel = 0;
-	if (!h->size)
-		return 0;
+	h->size = 0;
+	h->htable = NULL;
 
-	h->htable = kcalloc(h->size, sizeof(*h->htable), GFP_KERNEL);
-	return h->htable ? 0 : -ENOMEM;
+	if (size) {
+		h->htable = kcalloc(size, sizeof(*h->htable), GFP_KERNEL);
+		if (!h->htable)
+			return -ENOMEM;
+		h->size = size;
+	}
+	return 0;
 }
 
 int __hashtab_insert(struct hashtab *h, struct hashtab_node **dst,


