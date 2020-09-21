Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A0227304B
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbgIUREE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:04:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728933AbgIUQgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:36:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3F5623719;
        Mon, 21 Sep 2020 16:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706160;
        bh=lBxjOzOKcQ9/Ya/MDKQJKPCHaMmXwHvZoDchC1P0GtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2EI8Aw5atNAG0iRcjeD2SnKXf67qcVEXJwc0YwlhNU/2wou6EKJoOFMHQvb2CHuf
         oXB0Su51TQl5dYhwl8X7rLWlJroi9MxpmO3HD/K0n5Q1c5oJV9wT7Y39uXrwHhDgBz
         nOOV261t+2Xm8qTBIztEdx8sBJoevLiOwfnBPs8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Christie <michael.christie@oralce.com>,
        Varun Prakash <varun@chelsio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 32/70] scsi: target: iscsi: Fix data digest calculation
Date:   Mon, 21 Sep 2020 18:27:32 +0200
Message-Id: <20200921162036.596518250@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>

commit 5528d03183fe5243416c706f64b1faa518b05130 upstream.

Current code does not consider 'page_off' in data digest calculation. To
fix this, add a local variable 'first_sg' and set first_sg.offset to
sg->offset + page_off.

Link: https://lore.kernel.org/r/1598358910-3052-1-git-send-email-varun@chelsio.com
Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: <stable@vger.kernel.org>
Reviewed-by: Mike Christie <michael.christie@oralce.com>
Signed-off-by: Varun Prakash <varun@chelsio.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1396,14 +1396,27 @@ static u32 iscsit_do_crypto_hash_sg(
 	sg = cmd->first_data_sg;
 	page_off = cmd->first_data_sg_off;
 
+	if (data_length && page_off) {
+		struct scatterlist first_sg;
+		u32 len = min_t(u32, data_length, sg->length - page_off);
+
+		sg_init_table(&first_sg, 1);
+		sg_set_page(&first_sg, sg_page(sg), len, sg->offset + page_off);
+
+		ahash_request_set_crypt(hash, &first_sg, NULL, len);
+		crypto_ahash_update(hash);
+
+		data_length -= len;
+		sg = sg_next(sg);
+	}
+
 	while (data_length) {
-		u32 cur_len = min_t(u32, data_length, (sg->length - page_off));
+		u32 cur_len = min_t(u32, data_length, sg->length);
 
 		ahash_request_set_crypt(hash, sg, NULL, cur_len);
 		crypto_ahash_update(hash);
 
 		data_length -= cur_len;
-		page_off = 0;
 		/* iscsit_map_iovec has already checked for invalid sg pointers */
 		sg = sg_next(sg);
 	}


