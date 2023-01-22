Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD2F676ED0
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjAVPOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbjAVPOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:14:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347F022023
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:14:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C792260C48
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB19CC433D2;
        Sun, 22 Jan 2023 15:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400477;
        bh=3tnUXVaN+1eNMKO1KZVaHGPZ0vBV7131K/j+FSC1twM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIPTYSfaE1GNUilRj1B6MEFEk5K/38amDWLTkkR/mPo9R7msPF7DK3ssbk0w3h/Vc
         evPscSe4Hn6HJFGbmqOIAae2Gom01ANe2bzY0iuBTblwwOU9OMVfbNKL9L7OI41apC
         +7r1ezhyUWptNm43GJg5akNk8+APDVOWS3/o36wY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 90/98] io_uring: io_kiocb_update_pos() should not touch file for non -1 offset
Date:   Sun, 22 Jan 2023 16:04:46 +0100
Message-Id: <20230122150233.225071093@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 6f83ab22adcb77a5824d2c274dace0d99e21319f upstream.

-1 tells use to use the current position, but we check if the file is
a stream regardless of that. Fix up io_kiocb_update_pos() to only
dip into file if we need to. This is both more efficient and also drops
12 bytes of text on aarch64 and 64 bytes on x86-64.

Fixes: b4aec4001595 ("io_uring: do not recalculate ppos unnecessarily")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3011,19 +3011,18 @@ static inline void io_rw_done(struct kio
 static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 {
 	struct kiocb *kiocb = &req->rw.kiocb;
-	bool is_stream = req->file->f_mode & FMODE_STREAM;
 
-	if (kiocb->ki_pos == -1) {
-		if (!is_stream) {
-			req->flags |= REQ_F_CUR_POS;
-			kiocb->ki_pos = req->file->f_pos;
-			return &kiocb->ki_pos;
-		} else {
-			kiocb->ki_pos = 0;
-			return NULL;
-		}
+	if (kiocb->ki_pos != -1)
+		return &kiocb->ki_pos;
+
+	if (!(req->file->f_mode & FMODE_STREAM)) {
+		req->flags |= REQ_F_CUR_POS;
+		kiocb->ki_pos = req->file->f_pos;
+		return &kiocb->ki_pos;
 	}
-	return is_stream ? NULL : &kiocb->ki_pos;
+
+	kiocb->ki_pos = 0;
+	return NULL;
 }
 
 static void kiocb_done(struct kiocb *kiocb, ssize_t ret,


