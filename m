Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2280C4622F5
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 22:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbhK2VJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 16:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhK2VHr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 16:07:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067D2C12532A;
        Mon, 29 Nov 2021 10:27:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0FABB815CF;
        Mon, 29 Nov 2021 18:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78BEC53FCD;
        Mon, 29 Nov 2021 18:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210431;
        bh=F2rRZN7KHykaQkyTOKUkqLXb7EDLqjwTFBsqEiLkjVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxX13KntDwG6SiJ7ujDQC9z2zhUDjANdBO/LzpNv6VNLninb9KGLn/ll1rnpRI7FG
         lrsBzf/iLM24W78VyKZ/MJlP2rWPyjqE6TRG/c4qXdp/YT88X+jYPm/AlkPMfgEBrP
         HPFJzcm3nAv8GmfpkwLb3BFWPuXfBNIMQntk8QU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>
Subject: [PATCH 5.4 86/92] xen/blkfront: dont take local copy of a request from the ring page
Date:   Mon, 29 Nov 2021 19:18:55 +0100
Message-Id: <20211129181710.266890887@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
 drivers/block/xen-blkfront.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -536,7 +536,7 @@ static unsigned long blkif_ring_get_requ
 	rinfo->shadow[id].status = REQ_WAITING;
 	rinfo->shadow[id].associated_id = NO_ASSOCIATED_ID;
 
-	(*ring_req)->u.rw.id = id;
+	rinfo->shadow[id].req.u.rw.id = id;
 
 	return id;
 }
@@ -544,11 +544,12 @@ static unsigned long blkif_ring_get_requ
 static int blkif_queue_discard_req(struct request *req, struct blkfront_ring_info *rinfo)
 {
 	struct blkfront_info *info = rinfo->dev_info;
-	struct blkif_request *ring_req;
+	struct blkif_request *ring_req, *final_ring_req;
 	unsigned long id;
 
 	/* Fill out a communications ring structure. */
-	id = blkif_ring_get_request(rinfo, req, &ring_req);
+	id = blkif_ring_get_request(rinfo, req, &final_ring_req);
+	ring_req = &rinfo->shadow[id].req;
 
 	ring_req->operation = BLKIF_OP_DISCARD;
 	ring_req->u.discard.nr_sectors = blk_rq_sectors(req);
@@ -559,8 +560,8 @@ static int blkif_queue_discard_req(struc
 	else
 		ring_req->u.discard.flag = 0;
 
-	/* Keep a private copy so we can reissue requests when recovering. */
-	rinfo->shadow[id].req = *ring_req;
+	/* Copy the request to the ring page. */
+	*final_ring_req = *ring_req;
 
 	return 0;
 }
@@ -693,6 +694,7 @@ static int blkif_queue_rw_req(struct req
 {
 	struct blkfront_info *info = rinfo->dev_info;
 	struct blkif_request *ring_req, *extra_ring_req = NULL;
+	struct blkif_request *final_ring_req, *final_extra_ring_req = NULL;
 	unsigned long id, extra_id = NO_ASSOCIATED_ID;
 	bool require_extra_req = false;
 	int i;
@@ -737,7 +739,8 @@ static int blkif_queue_rw_req(struct req
 	}
 
 	/* Fill out a communications ring structure. */
-	id = blkif_ring_get_request(rinfo, req, &ring_req);
+	id = blkif_ring_get_request(rinfo, req, &final_ring_req);
+	ring_req = &rinfo->shadow[id].req;
 
 	num_sg = blk_rq_map_sg(req->q, req, rinfo->shadow[id].sg);
 	num_grant = 0;
@@ -788,7 +791,9 @@ static int blkif_queue_rw_req(struct req
 		ring_req->u.rw.nr_segments = num_grant;
 		if (unlikely(require_extra_req)) {
 			extra_id = blkif_ring_get_request(rinfo, req,
-							  &extra_ring_req);
+							  &final_extra_ring_req);
+			extra_ring_req = &rinfo->shadow[extra_id].req;
+
 			/*
 			 * Only the first request contains the scatter-gather
 			 * list.
@@ -830,10 +835,10 @@ static int blkif_queue_rw_req(struct req
 	if (setup.segments)
 		kunmap_atomic(setup.segments);
 
-	/* Keep a private copy so we can reissue requests when recovering. */
-	rinfo->shadow[id].req = *ring_req;
+	/* Copy request(s) to the ring page. */
+	*final_ring_req = *ring_req;
 	if (unlikely(require_extra_req))
-		rinfo->shadow[extra_id].req = *extra_ring_req;
+		*final_extra_ring_req = *extra_ring_req;
 
 	if (new_persistent_gnts)
 		gnttab_free_grant_references(setup.gref_head);


