Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBC34F3F58
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381026AbiDEMYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345111AbiDEKkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:40:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037202DAAE;
        Tue,  5 Apr 2022 03:25:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9694761425;
        Tue,  5 Apr 2022 10:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CEDC385A0;
        Tue,  5 Apr 2022 10:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154350;
        bh=a6oPxCJzwFg+auaLybS3Cz5xCfoOmB6qPAWpGmmbt78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVDadoXOdGQeFf7zhCfwoxHCL8sJ9uIMRORw6byvTDbpjPod8gnYSnumalRd/xwMc
         mpYLqnKp/iXDHd3OZumqvvShAmrcqvOY5syCdUzA20se2K+Xgs/7STyorh2SR96n4P
         A/BElTnYuUQWlJe/khU2jDtuGhA9no5FyzhjQM34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0d2b0bf32ca5cfd09f2e@syzkaller.appspotmail.com,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.10 548/599] XArray: Fix xas_create_range() when multi-order entry present
Date:   Tue,  5 Apr 2022 09:34:02 +0200
Message-Id: <20220405070315.148705763@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 3e3c658055c002900982513e289398a1aad4a488 upstream.

If there is already an entry present that is of order >= XA_CHUNK_SHIFT
when we call xas_create_range(), xas_create_range() will misinterpret
that entry as a node and dereference xa_node->parent, generally leading
to a crash that looks something like this:

general protection fault, probably for non-canonical address 0xdffffc0000000001:
0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 32 Comm: khugepaged Not tainted 5.17.0-rc8-syzkaller-00003-g56e337f2cf13 #0
RIP: 0010:xa_parent_locked include/linux/xarray.h:1207 [inline]
RIP: 0010:xas_create_range+0x2d9/0x6e0 lib/xarray.c:725

It's deterministically reproducable once you know what the problem is,
but producing it in a live kernel requires khugepaged to hit a race.
While the problem has been present since xas_create_range() was
introduced, I'm not aware of a way to hit it before the page cache was
converted to use multi-index entries.

Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Reported-by: syzbot+0d2b0bf32ca5cfd09f2e@syzkaller.appspotmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_xarray.c |   22 ++++++++++++++++++++++
 lib/xarray.c      |    2 ++
 2 files changed, 24 insertions(+)

--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1463,6 +1463,25 @@ unlock:
 	XA_BUG_ON(xa, !xa_empty(xa));
 }
 
+static noinline void check_create_range_5(struct xarray *xa,
+		unsigned long index, unsigned int order)
+{
+	XA_STATE_ORDER(xas, xa, index, order);
+	unsigned int i;
+
+	xa_store_order(xa, index, order, xa_mk_index(index), GFP_KERNEL);
+
+	for (i = 0; i < order + 10; i++) {
+		do {
+			xas_lock(&xas);
+			xas_create_range(&xas);
+			xas_unlock(&xas);
+		} while (xas_nomem(&xas, GFP_KERNEL));
+	}
+
+	xa_destroy(xa);
+}
+
 static noinline void check_create_range(struct xarray *xa)
 {
 	unsigned int order;
@@ -1490,6 +1509,9 @@ static noinline void check_create_range(
 		check_create_range_4(xa, (3U << order) + 1, order);
 		check_create_range_4(xa, (3U << order) - 1, order);
 		check_create_range_4(xa, (1U << 24) + 1, order);
+
+		check_create_range_5(xa, 0, order);
+		check_create_range_5(xa, (1U << order), order);
 	}
 
 	check_create_range_3();
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -722,6 +722,8 @@ void xas_create_range(struct xa_state *x
 
 		for (;;) {
 			struct xa_node *node = xas->xa_node;
+			if (node->shift >= shift)
+				break;
 			xas->xa_node = xa_parent_locked(xas->xa, node);
 			xas->xa_offset = node->offset - 1;
 			if (node->offset != 0)


