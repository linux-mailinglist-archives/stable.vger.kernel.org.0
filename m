Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE72755AB1A
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 16:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiFYOpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 10:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbiFYOpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 10:45:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C276C12773
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 07:45:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 584886146E
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 14:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F718C3411C;
        Sat, 25 Jun 2022 14:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656168302;
        bh=yHp//QA9N5aZ35tRKORwxoHdtbINqIUn0LBqolvrBHE=;
        h=Subject:To:Cc:From:Date:From;
        b=MihdJh6hMOU8bJIlYmkisGf1eWs1q1Tg/WhbC+WKwY5nEAaj8SL5VRkuoxzM19RAH
         3M+Y6lu5XMk9Eg5WYKA3X4oweOpk6SRZbS8V/sMjJzy0qcn78YdO0pdvkqX2eXjUad
         NFKuYaCMANQs29a64FaYTBMXXmwMvVHpMlx5keew=
Subject: FAILED: patch "[PATCH] filemap: Handle sibling entries in filemap_get_read_batch()" failed to apply to 5.15-stable tree
To:     willy@infradead.org, bfoster@redhat.com, david@fromorbit.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 25 Jun 2022 16:44:59 +0200
Message-ID: <16561682994109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cb995f4eeba9d268fd4b56c2423ad6c1d1ea1b82 Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Fri, 17 Jun 2022 20:00:17 -0400
Subject: [PATCH] filemap: Handle sibling entries in filemap_get_read_batch()

If a read races with an invalidation followed by another read, it is
possible for a folio to be replaced with a higher-order folio.  If that
happens, we'll see a sibling entry for the new folio in the next iteration
of the loop.  This manifests as a NULL pointer dereference while holding
the RCU read lock.

Handle this by simply returning.  The next call will find the new folio
and handle it correctly.  The other ways of handling this rare race are
more complex and it's just not worth it.

Reported-by: Dave Chinner <david@fromorbit.com>
Reported-by: Brian Foster <bfoster@redhat.com>
Debugged-by: Brian Foster <bfoster@redhat.com>
Tested-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Fixes: cbd59c48ae2b ("mm/filemap: use head pages in generic_file_buffered_read")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

diff --git a/mm/filemap.c b/mm/filemap.c
index 577068868449..ffdfbc8b0e3c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2385,6 +2385,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
 			continue;
 		if (xas.xa_index > max || xa_is_value(folio))
 			break;
+		if (xa_is_sibling(folio))
+			break;
 		if (!folio_try_get_rcu(folio))
 			goto retry;
 

