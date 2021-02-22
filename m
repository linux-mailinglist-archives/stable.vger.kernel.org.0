Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1790C321754
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhBVMqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:46:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231634AbhBVMnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:43:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C3E964F39;
        Mon, 22 Feb 2021 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997609;
        bh=nVbfW7ph2K5aUDNXp3ifSNm9eQuAHOgr+wa0yM3Oi7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xV7C1lcZYupe9mkkVQi01jOPqrFjGAb3WNp8EqExPxsFniceSaskDILg27cN6a5iX
         0pmnRCFetPzGT0F/aYe1et2iRBtNbzfwgDkBI0xW45Q2SjfG15YFE7bbBSUGVEMTb0
         6M0Xu/OnvZFd+rMmjGIy8loQTayXGzqvyzUFmS0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.4 30/35] xen-blkback: dont "handle" error by BUG()
Date:   Mon, 22 Feb 2021 13:36:26 +0100
Message-Id: <20210222121022.092641075@linuxfoundation.org>
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

commit 5a264285ed1cd32e26d9de4f3c8c6855e467fd63 upstream.

In particular -ENOMEM may come back here, from set_foreign_p2m_mapping().
Don't make problems worse, the more that handling elsewhere (together
with map's status fields now indicating whether a mapping wasn't even
attempted, and hence has to be considered failed) doesn't require this
odd way of dealing with errors.

This is part of XSA-362.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkback/blkback.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -842,10 +842,8 @@ again:
 			break;
 	}
 
-	if (segs_to_map) {
+	if (segs_to_map)
 		ret = gnttab_map_refs(map, NULL, pages_to_gnt, segs_to_map);
-		BUG_ON(ret);
-	}
 
 	/*
 	 * Now swizzle the MFN in our domain with the MFN from the other domain
@@ -860,7 +858,7 @@ again:
 				pr_debug("invalid buffer -- could not remap it\n");
 				put_free_pages(blkif, &pages[seg_idx]->page, 1);
 				pages[seg_idx]->handle = BLKBACK_INVALID_HANDLE;
-				ret |= 1;
+				ret |= !ret;
 				goto next;
 			}
 			pages[seg_idx]->handle = map[new_map_idx].handle;


