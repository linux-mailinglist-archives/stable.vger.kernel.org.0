Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC821A9BB4
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896723AbgDOLFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:05:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36329 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896713AbgDOLEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:04:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 552315C01A9;
        Wed, 15 Apr 2020 07:04:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:04:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LrVqQT
        DWuMOeaAScPdt9JGXroHmeOP9ZOqPKWokGiIE=; b=SijOwtCIOe/e8lR/uZ37nM
        /PDnEnIp1TOr7M2/qomJglG9C8srhHW1jCzVjv9TZWg77F6nRrfCTWaRFFf1u1iM
        PcG0sh6JQ/NKzhjwKT1pTSqaTPkffLoighiIkAwhaJrArF82QqbbI49FzeTHBIK/
        nMHHLcnstLN2t14jvTt4UIAyzHq5xagLEqhRo0U5+1gMVpsyigQHShtb9vmFV7uN
        OXClfNJuI1XZ+BA7fY8GdraXxRZat3Juf2EtHP7wghdP+yhxjP0Eo+RQlHvwTUOT
        tOSwxjUMZzWXIYuTPc+LiFZ0FjdGHc2fcjRkv9R7ma4irJ/THPx1NLYbeev16qCg
        ==
X-ME-Sender: <xms:RuqWXh1CEiixX4eoTclSt5L7BSgM4zI32IFHy7H-7M_M1hPEGzSKkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepheenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:RuqWXu6ZCDRvSBeWiAy27sfDvRzwrw6j0a93Gkp52dyA9_hNMDkWKQ>
    <xmx:RuqWXq306gqDlcF94gov_fGoCy68UZhUorLaG5y51qhqVsYjNOjM2g>
    <xmx:RuqWXhpnW2vfQbZ-pUYTdNcOQIeo9eAQ0dKKSZ6A97ADblGVa9bUpQ>
    <xmx:T-qWXs3azSXFCuuma7iaAOGyJSZDoT9bFJ_mHREguXv0ZOdDnCVevA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 833DB306005E;
        Wed, 15 Apr 2020 07:04:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] XArray: Fix xa_find_next for large multi-index entries" failed to apply to 5.4-stable tree
To:     willy@infradead.org, bhelgaas@google.com, keescook@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:04:37 +0200
Message-ID: <1586948677159164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bd40b17ca49d7d110adf456e647701ce74de2241 Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Fri, 31 Jan 2020 05:07:55 -0500
Subject: [PATCH] XArray: Fix xa_find_next for large multi-index entries

Coverity pointed out that xas_sibling() was shifting xa_offset without
promoting it to an unsigned long first, so the shift could cause an
overflow and we'd get the wrong answer.  The fix is obvious, and the
new test-case provokes UBSAN to report an error:
runtime error: shift exponent 60 is too large for 32-bit type 'int'

Fixes: 19c30f4dd092 ("XArray: Fix xa_find_after with multi-index entries")
Reported-by: Bjorn Helgaas <bhelgaas@google.com>
Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable@vger.kernel.org

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 55c14e8c8859..8c7d7a8468b8 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -12,6 +12,9 @@
 static unsigned int tests_run;
 static unsigned int tests_passed;
 
+static const unsigned int order_limit =
+		IS_ENABLED(CONFIG_XARRAY_MULTI) ? BITS_PER_LONG : 1;
+
 #ifndef XA_DEBUG
 # ifdef __KERNEL__
 void xa_dump(const struct xarray *xa) { }
@@ -959,6 +962,20 @@ static noinline void check_multi_find_2(struct xarray *xa)
 	}
 }
 
+static noinline void check_multi_find_3(struct xarray *xa)
+{
+	unsigned int order;
+
+	for (order = 5; order < order_limit; order++) {
+		unsigned long index = 1UL << (order - 5);
+
+		XA_BUG_ON(xa, !xa_empty(xa));
+		xa_store_order(xa, 0, order - 4, xa_mk_index(0), GFP_KERNEL);
+		XA_BUG_ON(xa, xa_find_after(xa, &index, ULONG_MAX, XA_PRESENT));
+		xa_erase_index(xa, 0);
+	}
+}
+
 static noinline void check_find_1(struct xarray *xa)
 {
 	unsigned long i, j, k;
@@ -1081,6 +1098,7 @@ static noinline void check_find(struct xarray *xa)
 	for (i = 2; i < 10; i++)
 		check_multi_find_1(xa, i);
 	check_multi_find_2(xa);
+	check_multi_find_3(xa);
 }
 
 /* See find_swap_entry() in mm/shmem.c */
diff --git a/lib/xarray.c b/lib/xarray.c
index 1d9fab7db8da..acd1fad2e862 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1839,7 +1839,8 @@ static bool xas_sibling(struct xa_state *xas)
 	if (!node)
 		return false;
 	mask = (XA_CHUNK_SIZE << node->shift) - 1;
-	return (xas->xa_index & mask) > (xas->xa_offset << node->shift);
+	return (xas->xa_index & mask) >
+		((unsigned long)xas->xa_offset << node->shift);
 }
 
 /**

