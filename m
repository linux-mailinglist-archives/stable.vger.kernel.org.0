Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE053AAC8
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbfFIQpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:45:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730033AbfFIQpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:45:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AE0920833;
        Sun,  9 Jun 2019 16:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098739;
        bh=qu3AXhIjStH1+re7tKqaUvy781oKsZ24j3DKALUl09Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUQKr7UyaweXsUPpQKmV7+LO9ySn7zvqjn7ZUxGMGhKlHMBN8HOrRdmNqbHUteCZ6
         bH878uUO7nMo0H1O6ZeacsFmKHn7rNQXu/lVU9J2Ajz+Fvjrv5f4E9Gm8cdpoAJSIz
         EnzBi22KrVjO4pobOIUN9b/c6tSb5aAiMbtYDrJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.1 36/70] memstick: mspro_block: Fix an error code in mspro_block_issue_req()
Date:   Sun,  9 Jun 2019 18:41:47 +0200
Message-Id: <20190609164130.189649566@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 61009f82a93f7c0b33cd9b3b263a6ab48f8b49d4 upstream.

We accidentally changed the error code from -EAGAIN to 1 when we did the
blk-mq conversion.

Maybe a contributing factor to this mistake is that it wasn't obvious
that the "while (chunk) {" condition is always true.  I have cleaned
that up as well.

Fixes: d0be12274dad ("mspro_block: convert to blk-mq")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memstick/core/mspro_block.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -694,13 +694,13 @@ static void h_mspro_block_setup_cmd(stru
 
 /*** Data transfer ***/
 
-static int mspro_block_issue_req(struct memstick_dev *card, bool chunk)
+static int mspro_block_issue_req(struct memstick_dev *card)
 {
 	struct mspro_block_data *msb = memstick_get_drvdata(card);
 	u64 t_off;
 	unsigned int count;
 
-	while (chunk) {
+	while (true) {
 		msb->current_page = 0;
 		msb->current_seg = 0;
 		msb->seg_count = blk_rq_map_sg(msb->block_req->q,
@@ -709,6 +709,7 @@ static int mspro_block_issue_req(struct
 
 		if (!msb->seg_count) {
 			unsigned int bytes = blk_rq_cur_bytes(msb->block_req);
+			bool chunk;
 
 			chunk = blk_update_request(msb->block_req,
 							BLK_STS_RESOURCE,
@@ -718,7 +719,7 @@ static int mspro_block_issue_req(struct
 			__blk_mq_end_request(msb->block_req,
 						BLK_STS_RESOURCE);
 			msb->block_req = NULL;
-			break;
+			return -EAGAIN;
 		}
 
 		t_off = blk_rq_pos(msb->block_req);
@@ -735,8 +736,6 @@ static int mspro_block_issue_req(struct
 		memstick_new_req(card->host);
 		return 0;
 	}
-
-	return 1;
 }
 
 static int mspro_block_complete_req(struct memstick_dev *card, int error)
@@ -779,7 +778,7 @@ static int mspro_block_complete_req(stru
 		chunk = blk_update_request(msb->block_req,
 				errno_to_blk_status(error), t_len);
 		if (chunk) {
-			error = mspro_block_issue_req(card, chunk);
+			error = mspro_block_issue_req(card);
 			if (!error)
 				goto out;
 		} else {
@@ -849,7 +848,7 @@ static blk_status_t mspro_queue_rq(struc
 	msb->block_req = bd->rq;
 	blk_mq_start_request(bd->rq);
 
-	if (mspro_block_issue_req(card, true))
+	if (mspro_block_issue_req(card))
 		msb->block_req = NULL;
 
 	spin_unlock_irq(&msb->q_lock);


