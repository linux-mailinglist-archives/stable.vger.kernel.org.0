Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42C96AF15F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbjCGSmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbjCGSmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:42:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39AC199D9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:32:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D09BC61543
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D46C433D2;
        Tue,  7 Mar 2023 18:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213881;
        bh=VaZHPCKvH+cc7GvKCXfubK+uMFz4i8+GnIX8sPuKvd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDu4sfy4yv4Lh4vDFFUhnfUHlBd9AKlIZH7/I2ox0adk2o2ZjuFxWRdG5isS9F5xf
         wAILCfGxXaE2CNxvf33VDfbaX1ZGaJiYARntd1Cb0n5QmGrwa8TA9guubdwvAwLX30
         zfc/rhF8czfXDjJnL494MBDp0fPz5narOJEJcRhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH 6.1 650/885] block: dont allow multiple bios for IOCB_NOWAIT issue
Date:   Tue,  7 Mar 2023 17:59:44 +0100
Message-Id: <20230307170030.384982834@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 67d59247d4b52c917e373f05a807027756ab216f upstream.

If we're doing a large IO request which needs to be split into multiple
bios for issue, then we can run into the same situation as the below
marked commit fixes - parts will complete just fine, one or more parts
will fail to allocate a request. This will result in a partially
completed read or write request, where the caller gets EAGAIN even though
parts of the IO completed just fine.

Do the same for large bios as we do for splits - fail a NOWAIT request
with EAGAIN. This isn't technically fixing an issue in the below marked
patch, but for stable purposes, we should have either none of them or
both.

This depends on: 613b14884b85 ("block: handle bio_split_to_limits() NULL return")

Cc: stable@vger.kernel.org # 5.15+
Fixes: 9cea62b2cbab ("block: don't allow splitting of a REQ_NOWAIT bio")
Link: https://github.com/axboe/liburing/issues/766
Reported-and-tested-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/fops.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/block/fops.c
+++ b/block/fops.c
@@ -221,6 +221,24 @@ static ssize_t __blkdev_direct_IO(struct
 			bio_endio(bio);
 			break;
 		}
+		if (iocb->ki_flags & IOCB_NOWAIT) {
+			/*
+			 * This is nonblocking IO, and we need to allocate
+			 * another bio if we have data left to map. As we
+			 * cannot guarantee that one of the sub bios will not
+			 * fail getting issued FOR NOWAIT and as error results
+			 * are coalesced across all of them, be safe and ask for
+			 * a retry of this from blocking context.
+			 */
+			if (unlikely(iov_iter_count(iter))) {
+				bio_release_pages(bio, false);
+				bio_clear_flag(bio, BIO_REFFED);
+				bio_put(bio);
+				blk_finish_plug(&plug);
+				return -EAGAIN;
+			}
+			bio->bi_opf |= REQ_NOWAIT;
+		}
 
 		if (is_read) {
 			if (dio->flags & DIO_SHOULD_DIRTY)
@@ -228,9 +246,6 @@ static ssize_t __blkdev_direct_IO(struct
 		} else {
 			task_io_account_write(bio->bi_iter.bi_size);
 		}
-		if (iocb->ki_flags & IOCB_NOWAIT)
-			bio->bi_opf |= REQ_NOWAIT;
-
 		dio->size += bio->bi_iter.bi_size;
 		pos += bio->bi_iter.bi_size;
 


