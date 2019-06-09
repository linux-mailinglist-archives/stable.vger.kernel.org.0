Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5B53AA91
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731208AbfFIRTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729778AbfFIQs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:48:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72AD8206C3;
        Sun,  9 Jun 2019 16:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098905;
        bh=vaYwb1577dLTm2yh/ziP4tzrtY8aiMNv6GGrTDhWrVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ieNprXqVxYDDCeykioF/m3dx/v7dthPblPzDvyglSTiKGCpP7QzUO6Xs/d2Sp06P
         SrNSXBd4BbYh+bYa6L4E2Qf9+2WShxiX8xNBHmi+4yKZo+StCIzz3uYLmi9NYqBIqX
         ZzYMLOWaXtFC91bb2dqP+wyGTAZ9lQcDxmKN2OTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Jackson <ian.jackson@citrix.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.19 31/51] xen-blkfront: switch kcalloc to kvcalloc for large array allocation
Date:   Sun,  9 Jun 2019 18:42:12 +0200
Message-Id: <20190609164129.060139900@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.123076536@linuxfoundation.org>
References: <20190609164127.123076536@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Pau Monne <roger.pau@citrix.com>

commit 1d5c76e66433382a1e170d1d5845bb0fed7467aa upstream.

There's no reason to request physically contiguous memory for those
allocations.

[boris: added CC to stable]

Cc: stable@vger.kernel.org
Reported-by: Ian Jackson <ian.jackson@citrix.com>
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkfront.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1310,11 +1310,11 @@ static void blkif_free_ring(struct blkfr
 		}
 
 free_shadow:
-		kfree(rinfo->shadow[i].grants_used);
+		kvfree(rinfo->shadow[i].grants_used);
 		rinfo->shadow[i].grants_used = NULL;
-		kfree(rinfo->shadow[i].indirect_grants);
+		kvfree(rinfo->shadow[i].indirect_grants);
 		rinfo->shadow[i].indirect_grants = NULL;
-		kfree(rinfo->shadow[i].sg);
+		kvfree(rinfo->shadow[i].sg);
 		rinfo->shadow[i].sg = NULL;
 	}
 
@@ -1353,7 +1353,7 @@ static void blkif_free(struct blkfront_i
 	for (i = 0; i < info->nr_rings; i++)
 		blkif_free_ring(&info->rinfo[i]);
 
-	kfree(info->rinfo);
+	kvfree(info->rinfo);
 	info->rinfo = NULL;
 	info->nr_rings = 0;
 }
@@ -1914,9 +1914,9 @@ static int negotiate_mq(struct blkfront_
 	if (!info->nr_rings)
 		info->nr_rings = 1;
 
-	info->rinfo = kcalloc(info->nr_rings,
-			      sizeof(struct blkfront_ring_info),
-			      GFP_KERNEL);
+	info->rinfo = kvcalloc(info->nr_rings,
+			       sizeof(struct blkfront_ring_info),
+			       GFP_KERNEL);
 	if (!info->rinfo) {
 		xenbus_dev_fatal(info->xbdev, -ENOMEM, "allocating ring_info structure");
 		info->nr_rings = 0;
@@ -2232,17 +2232,17 @@ static int blkfront_setup_indirect(struc
 
 	for (i = 0; i < BLK_RING_SIZE(info); i++) {
 		rinfo->shadow[i].grants_used =
-			kcalloc(grants,
-				sizeof(rinfo->shadow[i].grants_used[0]),
-				GFP_NOIO);
-		rinfo->shadow[i].sg = kcalloc(psegs,
-					      sizeof(rinfo->shadow[i].sg[0]),
-					      GFP_NOIO);
+			kvcalloc(grants,
+				 sizeof(rinfo->shadow[i].grants_used[0]),
+				 GFP_NOIO);
+		rinfo->shadow[i].sg = kvcalloc(psegs,
+					       sizeof(rinfo->shadow[i].sg[0]),
+					       GFP_NOIO);
 		if (info->max_indirect_segments)
 			rinfo->shadow[i].indirect_grants =
-				kcalloc(INDIRECT_GREFS(grants),
-					sizeof(rinfo->shadow[i].indirect_grants[0]),
-					GFP_NOIO);
+				kvcalloc(INDIRECT_GREFS(grants),
+					 sizeof(rinfo->shadow[i].indirect_grants[0]),
+					 GFP_NOIO);
 		if ((rinfo->shadow[i].grants_used == NULL) ||
 			(rinfo->shadow[i].sg == NULL) ||
 		     (info->max_indirect_segments &&
@@ -2256,11 +2256,11 @@ static int blkfront_setup_indirect(struc
 
 out_of_memory:
 	for (i = 0; i < BLK_RING_SIZE(info); i++) {
-		kfree(rinfo->shadow[i].grants_used);
+		kvfree(rinfo->shadow[i].grants_used);
 		rinfo->shadow[i].grants_used = NULL;
-		kfree(rinfo->shadow[i].sg);
+		kvfree(rinfo->shadow[i].sg);
 		rinfo->shadow[i].sg = NULL;
-		kfree(rinfo->shadow[i].indirect_grants);
+		kvfree(rinfo->shadow[i].indirect_grants);
 		rinfo->shadow[i].indirect_grants = NULL;
 	}
 	if (!list_empty(&rinfo->indirect_pages)) {


