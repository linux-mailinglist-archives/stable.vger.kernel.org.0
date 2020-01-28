Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA49114BB8E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgA1ODD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:03:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727782AbgA1ODC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:03:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83612205F4;
        Tue, 28 Jan 2020 14:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220182;
        bh=9SeEzEL13nTWWwVtaYrsa7o11fBxFK58T2PwnjRlYOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zm9RXpOPbbyThZxj4+0A9IM9hA8B+VnbckRk/rxQyPPWnIH3pGmLJ/hV0lI2WUJA8
         E9iA33J8lJjLAoDeKhNErq+IaTU5eD58+1IWrX/7AoCicGnmgWT4uoGZAk3x8uLa37
         3IIp1u3p2tfew14tk0HnSBvXzM6bhqgwuBHFS7RA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.4 050/104] XArray: Fix infinite loop with entry at ULONG_MAX
Date:   Tue, 28 Jan 2020 15:00:11 +0100
Message-Id: <20200128135824.574648455@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 430f24f94c8a174d411a550d7b5529301922e67a upstream.

If there is an entry at ULONG_MAX, xa_for_each() will overflow the
'index + 1' in xa_find_after() and wrap around to 0.  Catch this case
and terminate the loop by returning NULL.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/test_xarray.c |   17 +++++++++++++++++
 lib/xarray.c      |    3 +++
 2 files changed, 20 insertions(+)

--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1046,11 +1046,28 @@ static noinline void check_find_3(struct
 	xa_destroy(xa);
 }
 
+static noinline void check_find_4(struct xarray *xa)
+{
+	unsigned long index = 0;
+	void *entry;
+
+	xa_store_index(xa, ULONG_MAX, GFP_KERNEL);
+
+	entry = xa_find_after(xa, &index, ULONG_MAX, XA_PRESENT);
+	XA_BUG_ON(xa, entry != xa_mk_index(ULONG_MAX));
+
+	entry = xa_find_after(xa, &index, ULONG_MAX, XA_PRESENT);
+	XA_BUG_ON(xa, entry);
+
+	xa_erase_index(xa, ULONG_MAX);
+}
+
 static noinline void check_find(struct xarray *xa)
 {
 	check_find_1(xa);
 	check_find_2(xa);
 	check_find_3(xa);
+	check_find_4(xa);
 	check_multi_find(xa);
 	check_multi_find_2(xa);
 }
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1847,6 +1847,9 @@ void *xa_find_after(struct xarray *xa, u
 	XA_STATE(xas, xa, *indexp + 1);
 	void *entry;
 
+	if (xas.xa_index == 0)
+		return NULL;
+
 	rcu_read_lock();
 	for (;;) {
 		if ((__force unsigned int)filter < XA_MAX_MARKS)


