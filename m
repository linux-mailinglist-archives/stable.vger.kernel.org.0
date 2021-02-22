Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CC0321710
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhBVMmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:42:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230077AbhBVMlC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:41:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F093164E76;
        Mon, 22 Feb 2021 12:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997521;
        bh=aVtwxMQ0yET8MYZsd8pC53W+SekETh83OMG7Vad2+pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTehh7A0deSCAT/uT3N66aAsunywGzINNQK+EHY4MamV646srYqqMMdWy6Kp9ytqp
         mJrhFGEWmYLmCcAADaonyU4NWCbQi7ADycM55sBtrrbErViC91l50Wfq2iJ3HqBMGN
         QU07og1h09jumHkG3MPYcJJjSATGZC85LNeKOuls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.14 50/57] xen-blkback: dont "handle" error by BUG()
Date:   Mon, 22 Feb 2021 13:36:16 +0100
Message-Id: <20210222121034.656136555@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
References: <20210222121027.174911182@linuxfoundation.org>
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
@@ -860,10 +860,8 @@ again:
 			break;
 	}
 
-	if (segs_to_map) {
+	if (segs_to_map)
 		ret = gnttab_map_refs(map, NULL, pages_to_gnt, segs_to_map);
-		BUG_ON(ret);
-	}
 
 	/*
 	 * Now swizzle the MFN in our domain with the MFN from the other domain
@@ -878,7 +876,7 @@ again:
 				pr_debug("invalid buffer -- could not remap it\n");
 				put_free_pages(ring, &pages[seg_idx]->page, 1);
 				pages[seg_idx]->handle = BLKBACK_INVALID_HANDLE;
-				ret |= 1;
+				ret |= !ret;
 				goto next;
 			}
 			pages[seg_idx]->handle = map[new_map_idx].handle;


