Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440DB111FF4
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbfLCWku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:40:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728145AbfLCWkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:40:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0E7D2073C;
        Tue,  3 Dec 2019 22:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412849;
        bh=uAgnL+AGiaxwbGNAJ3Nh9nL+IzPCCFmp/0KO5eh3YxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cw3pDbfv7AYlvpxKmaYlPERUyEYBdCpfntoPBFE0u0/8uqopXjVVn2KUAEBwcOR39
         O7fL6+yiNW7inuqPqnnjkWKmNZb9Cnkbl0R0pokStG+XRv1kiEwc0Im7FfRt7BTgIe
         6mpnqPkG4alEqugY1eJiQcR1RB4+4c9vAAwO650k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 004/135] XArray: Fix xas_next() with a single entry at 0
Date:   Tue,  3 Dec 2019 23:34:04 +0100
Message-Id: <20191203213006.620763007@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 91abab83839aa2eba073e4a63c729832fdb27ea1 ]

If there is only a single entry at 0, the first time we call xas_next(),
we return the entry.  Unfortunately, all subsequent times we call
xas_next(), we also return the entry at 0 instead of noticing that the
xa_index is now greater than zero.  This broke find_get_pages_contig().

Fixes: 64d3e9a9e0cc ("xarray: Step through an XArray")
Reported-by: Kent Overstreet <kent.overstreet@gmail.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_xarray.c | 24 ++++++++++++++++++++++++
 lib/xarray.c      |  4 ++++
 2 files changed, 28 insertions(+)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 9d631a7b6a705..7df4f7f395bf2 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1110,6 +1110,28 @@ static noinline void check_find_entry(struct xarray *xa)
 	XA_BUG_ON(xa, !xa_empty(xa));
 }
 
+static noinline void check_move_tiny(struct xarray *xa)
+{
+	XA_STATE(xas, xa, 0);
+
+	XA_BUG_ON(xa, !xa_empty(xa));
+	rcu_read_lock();
+	XA_BUG_ON(xa, xas_next(&xas) != NULL);
+	XA_BUG_ON(xa, xas_next(&xas) != NULL);
+	rcu_read_unlock();
+	xa_store_index(xa, 0, GFP_KERNEL);
+	rcu_read_lock();
+	xas_set(&xas, 0);
+	XA_BUG_ON(xa, xas_next(&xas) != xa_mk_index(0));
+	XA_BUG_ON(xa, xas_next(&xas) != NULL);
+	xas_set(&xas, 0);
+	XA_BUG_ON(xa, xas_prev(&xas) != xa_mk_index(0));
+	XA_BUG_ON(xa, xas_prev(&xas) != NULL);
+	rcu_read_unlock();
+	xa_erase_index(xa, 0);
+	XA_BUG_ON(xa, !xa_empty(xa));
+}
+
 static noinline void check_move_small(struct xarray *xa, unsigned long idx)
 {
 	XA_STATE(xas, xa, 0);
@@ -1217,6 +1239,8 @@ static noinline void check_move(struct xarray *xa)
 
 	xa_destroy(xa);
 
+	check_move_tiny(xa);
+
 	for (i = 0; i < 16; i++)
 		check_move_small(xa, 1UL << i);
 
diff --git a/lib/xarray.c b/lib/xarray.c
index 446b956c91888..1237c213f52bc 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -994,6 +994,8 @@ void *__xas_prev(struct xa_state *xas)
 
 	if (!xas_frozen(xas->xa_node))
 		xas->xa_index--;
+	if (!xas->xa_node)
+		return set_bounds(xas);
 	if (xas_not_node(xas->xa_node))
 		return xas_load(xas);
 
@@ -1031,6 +1033,8 @@ void *__xas_next(struct xa_state *xas)
 
 	if (!xas_frozen(xas->xa_node))
 		xas->xa_index++;
+	if (!xas->xa_node)
+		return set_bounds(xas);
 	if (xas_not_node(xas->xa_node))
 		return xas_load(xas);
 
-- 
2.20.1



