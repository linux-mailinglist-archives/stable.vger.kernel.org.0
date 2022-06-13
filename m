Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9A9549238
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381025AbiFMOHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381433AbiFMOEV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:04:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0A02BB18;
        Mon, 13 Jun 2022 04:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9035ECE110D;
        Mon, 13 Jun 2022 11:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7854CC34114;
        Mon, 13 Jun 2022 11:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120368;
        bh=FqAGfbtM97HknUrN5TKRJQyyxOT07KExcU5x8rpdQTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1LS6Gv6rOUsalJ/BvblDPc41vFDf+971APE+x5JKL0xDuO+2IA6QJj8bSB0c+l3sw
         JjzP6PCU0gJQ7SB7yMNhYKnoEhMEk+EFkzXa9t6Z0ZL83eXIkFuOC+YMUnPCR1zTm8
         0Nlmebs7CzeYlc4xJ6zJU2/2aKgPha+QYlR0tz+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9e27a75a8c24f3fe75c1@syzkaller.appspotmail.com,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.18 325/339] mm/huge_memory: Fix xarray node memory leak
Date:   Mon, 13 Jun 2022 12:12:30 +0200
Message-Id: <20220613094936.603838232@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 69a37a8ba1b408a1c7616494aa7018e4b3844cbe upstream.

If xas_split_alloc() fails to allocate the necessary nodes to complete the
xarray entry split, it sets the xa_state to -ENOMEM, which xas_nomem()
then interprets as "Please allocate more memory", not as "Please free
any unnecessary memory" (which was the intended outcome).  It's confusing
to use xas_nomem() to free memory in this context, so call xas_destroy()
instead.

Reported-by: syzbot+9e27a75a8c24f3fe75c1@syzkaller.appspotmail.com
Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/xarray.h |    1 +
 lib/xarray.c           |    5 +++--
 mm/huge_memory.c       |    3 +--
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1508,6 +1508,7 @@ void *xas_find_marked(struct xa_state *,
 void xas_init_marks(const struct xa_state *);
 
 bool xas_nomem(struct xa_state *, gfp_t);
+void xas_destroy(struct xa_state *);
 void xas_pause(struct xa_state *);
 
 void xas_create_range(struct xa_state *);
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -264,9 +264,10 @@ static void xa_node_free(struct xa_node
  * xas_destroy() - Free any resources allocated during the XArray operation.
  * @xas: XArray operation state.
  *
- * This function is now internal-only.
+ * Most users will not need to call this function; it is called for you
+ * by xas_nomem().
  */
-static void xas_destroy(struct xa_state *xas)
+void xas_destroy(struct xa_state *xas)
 {
 	struct xa_node *next, *node = xas->xa_alloc;
 
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2622,8 +2622,7 @@ out_unlock:
 	if (mapping)
 		i_mmap_unlock_read(mapping);
 out:
-	/* Free any memory we didn't use */
-	xas_nomem(&xas, 0);
+	xas_destroy(&xas);
 	count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	return ret;
 }


