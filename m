Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E953215F3
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhBVMPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:15:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230248AbhBVMOs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:14:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDBAD64EDB;
        Mon, 22 Feb 2021 12:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996019;
        bh=4oHfP0ip4vBy5gmxRB4+XOs5P0IytXOPdTKFQLWg3aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OInIB+5FiBLLcRiyRub2vfWtwhUSrRRd4yiR0C5d7Ct1iOqFty44rN4Li1neM72v
         DM57wE3geRi59fTozcST9ahd4F4oL5JoHfkg7CFQ4v8OQB22TF/s0A7DvkTvLHtQHe
         Ne1/LWoEEATKaFkoOpmwwxETZsfCF/zoQl5kN2UQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>, Julien Grall <julien@xen.org>
Subject: [PATCH 5.11 09/12] xen-blkback: fix error handling in xen_blkbk_map()
Date:   Mon, 22 Feb 2021 13:13:01 +0100
Message-Id: <20210222121018.740916111@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.586597942@linuxfoundation.org>
References: <20210222121013.586597942@linuxfoundation.org>
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
 drivers/block/xen-blkback/blkback.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -794,8 +794,13 @@ again:
 			pages[i]->persistent_gnt = persistent_gnt;
 		} else {
 			if (gnttab_page_cache_get(&ring->free_pages,
-						  &pages[i]->page))
-				goto out_of_memory;
+						  &pages[i]->page)) {
+				gnttab_page_cache_put(&ring->free_pages,
+						      pages_to_gnt,
+						      segs_to_map);
+				ret = -ENOMEM;
+				goto out;
+			}
 			addr = vaddr(pages[i]->page);
 			pages_to_gnt[segs_to_map] = pages[i]->page;
 			pages[i]->persistent_gnt = NULL;
@@ -880,17 +885,18 @@ next:
 	}
 	segs_to_map = 0;
 	last_map = map_until;
-	if (map_until != num)
+	if (!ret && map_until != num)
 		goto again;
 
-	return ret;
-
-out_of_memory:
-	pr_alert("%s: out of memory\n", __func__);
-	gnttab_page_cache_put(&ring->free_pages, pages_to_gnt, segs_to_map);
-	for (i = last_map; i < num; i++)
+out:
+	for (i = last_map; i < num; i++) {
+		/* Don't zap current batch's valid persistent grants. */
+		if(i >= last_map + segs_to_map)
+			pages[i]->persistent_gnt = NULL;
 		pages[i]->handle = BLKBACK_INVALID_HANDLE;
-	return -ENOMEM;
+	}
+
+	return ret;
 }
 
 static int xen_blkbk_map_seg(struct pending_req *pending_req)


