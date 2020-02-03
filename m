Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18DD9150CE4
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgBCQkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:40:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731012AbgBCQgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:36:42 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EB7620721;
        Mon,  3 Feb 2020 16:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747802;
        bh=MQloD+ljaY++Y/2nGPXHMv5VcpK5swuR/ik+qbYnln4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmiCrgmspvxbcC0HXiJ7vpMWfbQ5ZZoKSYy6AjxjgyeXI4LEEWiHoEAt5M/vG0Thu
         VVllUPbpuB7NA9uAEPKW3rcnBdLjNB10Iu8Uvqw6UBmEKRPe3c7MpZR23e7Rq3tJI0
         Wi9vjFyTcoksKNDtasZ0JrICZ4wSieTWjtfh0RdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 59/90] XArray: Fix xas_pause at ULONG_MAX
Date:   Mon,  3 Feb 2020 16:20:02 +0000
Message-Id: <20200203161924.828775805@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 82a22311b7a68a78709699dc8c098953b70e4fd2 ]

If we were unlucky enough to call xas_pause() when the index was at
ULONG_MAX (or a multi-slot entry which ends at ULONG_MAX), we would
wrap the index back around to 0 and restart the iteration from the
beginning.  Use the XAS_BOUNDS state to indicate that we should just
stop the iteration.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_xarray.c | 22 ++++++++++++++++++++++
 lib/xarray.c      |  8 +++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 03c3f42966cec..55c14e8c88591 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1160,6 +1160,27 @@ static noinline void check_move_tiny(struct xarray *xa)
 	XA_BUG_ON(xa, !xa_empty(xa));
 }
 
+static noinline void check_move_max(struct xarray *xa)
+{
+	XA_STATE(xas, xa, 0);
+
+	xa_store_index(xa, ULONG_MAX, GFP_KERNEL);
+	rcu_read_lock();
+	XA_BUG_ON(xa, xas_find(&xas, ULONG_MAX) != xa_mk_index(ULONG_MAX));
+	XA_BUG_ON(xa, xas_find(&xas, ULONG_MAX) != NULL);
+	rcu_read_unlock();
+
+	xas_set(&xas, 0);
+	rcu_read_lock();
+	XA_BUG_ON(xa, xas_find(&xas, ULONG_MAX) != xa_mk_index(ULONG_MAX));
+	xas_pause(&xas);
+	XA_BUG_ON(xa, xas_find(&xas, ULONG_MAX) != NULL);
+	rcu_read_unlock();
+
+	xa_erase_index(xa, ULONG_MAX);
+	XA_BUG_ON(xa, !xa_empty(xa));
+}
+
 static noinline void check_move_small(struct xarray *xa, unsigned long idx)
 {
 	XA_STATE(xas, xa, 0);
@@ -1268,6 +1289,7 @@ static noinline void check_move(struct xarray *xa)
 	xa_destroy(xa);
 
 	check_move_tiny(xa);
+	check_move_max(xa);
 
 	for (i = 0; i < 16; i++)
 		check_move_small(xa, 1UL << i);
diff --git a/lib/xarray.c b/lib/xarray.c
index 47e17d46e5f85..1d9fab7db8dad 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -968,6 +968,7 @@ void xas_pause(struct xa_state *xas)
 	if (xas_invalid(xas))
 		return;
 
+	xas->xa_node = XAS_RESTART;
 	if (node) {
 		unsigned int offset = xas->xa_offset;
 		while (++offset < XA_CHUNK_SIZE) {
@@ -975,10 +976,11 @@ void xas_pause(struct xa_state *xas)
 				break;
 		}
 		xas->xa_index += (offset - xas->xa_offset) << node->shift;
+		if (xas->xa_index == 0)
+			xas->xa_node = XAS_BOUNDS;
 	} else {
 		xas->xa_index++;
 	}
-	xas->xa_node = XAS_RESTART;
 }
 EXPORT_SYMBOL_GPL(xas_pause);
 
@@ -1080,7 +1082,7 @@ void *xas_find(struct xa_state *xas, unsigned long max)
 {
 	void *entry;
 
-	if (xas_error(xas))
+	if (xas_error(xas) || xas->xa_node == XAS_BOUNDS)
 		return NULL;
 	if (xas->xa_index > max)
 		return set_bounds(xas);
@@ -1088,7 +1090,7 @@ void *xas_find(struct xa_state *xas, unsigned long max)
 	if (!xas->xa_node) {
 		xas->xa_index = 1;
 		return set_bounds(xas);
-	} else if (xas_top(xas->xa_node)) {
+	} else if (xas->xa_node == XAS_RESTART) {
 		entry = xas_load(xas);
 		if (entry || xas_not_node(xas->xa_node))
 			return entry;
-- 
2.20.1



