Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F674321758
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhBVMqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:46:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231635AbhBVMnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:43:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4427E64E20;
        Mon, 22 Feb 2021 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997616;
        bh=G1HzQO4OTyQBv4uITkzqKStVJ7xjJjTU0A8uzDKDLFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08o9dUCv9lcWdQvjKA3D/OylYQCLgul7AdeZYi/VXZlJ87MqTtj9Rf8rJBC3hMJiB
         lDFapS8eqm7w7qwBKR1ID3iP2bk+iLMXD30WDghTIGSQKrlGh8ll4fGBOClPhxhpIj
         08VuwRugoSt4GGqYSLe8JtnivQhCxxiT3NJ3LMOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>, Julien Grall <julien@xen.org>
Subject: [PATCH 4.4 33/35] xen-blkback: fix error handling in xen_blkbk_map()
Date:   Mon, 22 Feb 2021 13:36:29 +0100
Message-Id: <20210222121022.346442686@linuxfoundation.org>
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

From: Jan Beulich <jbeulich@suse.com>

commit 871997bc9e423f05c7da7c9178e62dde5df2a7f8 upstream.

The function uses a goto-based loop, which may lead to an earlier error
getting discarded by a later iteration. Exit this ad-hoc loop when an
error was encountered.

The out-of-memory error path additionally fails to fill a structure
field looked at by xen_blkbk_unmap_prepare() before inspecting the
handle which does get properly set (to BLKBACK_INVALID_HANDLE).

Since the earlier exiting from the ad-hoc loop requires the same field
filling (invalidation) as that on the out-of-memory path, fold both
paths. While doing so, drop the pr_alert(), as extra log messages aren't
going to help the situation (the kernel will log oom conditions already
anyway).

This is XSA-365.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Julien Grall <julien@xen.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkback/blkback.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -825,8 +825,11 @@ again:
 			pages[i]->page = persistent_gnt->page;
 			pages[i]->persistent_gnt = persistent_gnt;
 		} else {
-			if (get_free_page(blkif, &pages[i]->page))
-				goto out_of_memory;
+			if (get_free_page(blkif, &pages[i]->page)) {
+				put_free_pages(blkif, pages_to_gnt, segs_to_map);
+				ret = -ENOMEM;
+				goto out;
+			}
 			addr = vaddr(pages[i]->page);
 			pages_to_gnt[segs_to_map] = pages[i]->page;
 			pages[i]->persistent_gnt = NULL;
@@ -910,15 +913,18 @@ next:
 	}
 	segs_to_map = 0;
 	last_map = map_until;
-	if (map_until != num)
+	if (!ret && map_until != num)
 		goto again;
 
-	return ret;
+out:
+	for (i = last_map; i < num; i++) {
+		/* Don't zap current batch's valid persistent grants. */
+		if(i >= last_map + segs_to_map)
+			pages[i]->persistent_gnt = NULL;
+		pages[i]->handle = BLKBACK_INVALID_HANDLE;
+	}
 
-out_of_memory:
-	pr_alert("%s: out of memory\n", __func__);
-	put_free_pages(blkif, pages_to_gnt, segs_to_map);
-	return -ENOMEM;
+	return ret;
 }
 
 static int xen_blkbk_map_seg(struct pending_req *pending_req)


