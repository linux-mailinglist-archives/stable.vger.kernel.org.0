Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5214699C2
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344932AbhLFPDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:03:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53512 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345012AbhLFPC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:02:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5676E6131D;
        Mon,  6 Dec 2021 14:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1CAC341C1;
        Mon,  6 Dec 2021 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802768;
        bh=XXWIVD2fXFfyPEychYw0wE7XZwGyjlcw+Ol3/b8cz14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRpUAUyNJEATTZTdXA1LXNg2D6bEPaJLCjJ4Y3dC+TfFE7qFT9F6cW1ZeO9vKej/i
         Sp1ct1Lo0t0b0nJ0aQND/n+9WqvFvwSg5w6xwyoKLP8Rt+v3it6YzDH8TAChs6ourk
         tTw1DAcesSZjSvLrlNbVmpZU5w3FM+xjQFiEUlrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [PATCH 4.4 27/52] xen/blkfront: dont take local copy of a request from the ring page
Date:   Mon,  6 Dec 2021 15:56:11 +0100
Message-Id: <20211206145548.814595649@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 8f5a695d99000fc3aa73934d7ced33cfc64dcdab upstream.

In order to avoid a malicious backend being able to influence the local
copy of a request build the request locally first and then copy it to
the ring page instead of doing it the other way round as today.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Roger Pau Monné <roger.pau@citrix.com>
Link: https://lore.kernel.org/r/20210730103854.12681-3-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/xen-blkfront.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -456,16 +456,31 @@ static int blkif_ioctl(struct block_devi
 	return 0;
 }
 
+static unsigned long blkif_ring_get_request(struct blkfront_info *info,
+					    struct request *req,
+					    struct blkif_request **ring_req)
+{
+	unsigned long id;
+
+	*ring_req = RING_GET_REQUEST(&info->ring, info->ring.req_prod_pvt);
+	info->ring.req_prod_pvt++;
+
+	id = get_id_from_freelist(info);
+	info->shadow[id].request = req;
+	info->shadow[id].req.u.rw.id = id;
+
+	return id;
+}
+
 static int blkif_queue_discard_req(struct request *req)
 {
 	struct blkfront_info *info = req->rq_disk->private_data;
-	struct blkif_request *ring_req;
+	struct blkif_request *ring_req, *final_ring_req;
 	unsigned long id;
 
 	/* Fill out a communications ring structure. */
-	ring_req = RING_GET_REQUEST(&info->ring, info->ring.req_prod_pvt);
-	id = get_id_from_freelist(info);
-	info->shadow[id].request = req;
+	id = blkif_ring_get_request(info, req, &final_ring_req);
+	ring_req = &info->shadow[id].req;
 
 	ring_req->operation = BLKIF_OP_DISCARD;
 	ring_req->u.discard.nr_sectors = blk_rq_sectors(req);
@@ -478,8 +493,8 @@ static int blkif_queue_discard_req(struc
 
 	info->ring.req_prod_pvt++;
 
-	/* Keep a private copy so we can reissue requests when recovering. */
-	info->shadow[id].req = *ring_req;
+	/* Copy the request to the ring page. */
+	*final_ring_req = *ring_req;
 
 	return 0;
 }
@@ -569,7 +584,7 @@ static void blkif_setup_rw_req_grant(uns
 static int blkif_queue_rw_req(struct request *req)
 {
 	struct blkfront_info *info = req->rq_disk->private_data;
-	struct blkif_request *ring_req;
+	struct blkif_request *ring_req, *final_ring_req;
 	unsigned long id;
 	int i;
 	struct setup_rw_req setup = {
@@ -613,9 +628,8 @@ static int blkif_queue_rw_req(struct req
 		new_persistent_gnts = 0;
 
 	/* Fill out a communications ring structure. */
-	ring_req = RING_GET_REQUEST(&info->ring, info->ring.req_prod_pvt);
-	id = get_id_from_freelist(info);
-	info->shadow[id].request = req;
+	id = blkif_ring_get_request(info, req, &final_ring_req);
+	ring_req = &info->shadow[id].req;
 
 	BUG_ON(info->max_indirect_segments == 0 &&
 	       GREFS(req->nr_phys_segments) > BLKIF_MAX_SEGMENTS_PER_REQUEST);
@@ -696,8 +710,8 @@ static int blkif_queue_rw_req(struct req
 
 	info->ring.req_prod_pvt++;
 
-	/* Keep a private copy so we can reissue requests when recovering. */
-	info->shadow[id].req = *ring_req;
+	/* Copy request(s) to the ring page. */
+	*final_ring_req = *ring_req;
 
 	if (new_persistent_gnts)
 		gnttab_free_grant_references(setup.gref_head);


