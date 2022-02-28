Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A55E4C7645
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239414AbiB1SCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239540AbiB1SBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:01:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68B69A4CF;
        Mon, 28 Feb 2022 09:45:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A3D6FCE17C8;
        Mon, 28 Feb 2022 17:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3468C340E7;
        Mon, 28 Feb 2022 17:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070339;
        bh=pr6tgt8ad0uv7k/NL0ebFbptjSDhCdlZv2OAT89RUkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgxLoJ35H9OfWlQnlC/nU2No4XYbmltGtJjLKiPSOM6HHJ+yEn57p60Qiqa/IPQbz
         yAyw0JDd7WQMdeTSR3kEZuBaZ0r4J1vitYjy7iCzXV8NSWyxx6laHYbp8Fy6iu+OU8
         3kQMxRdtbXpnPCnIvMtlQ7KbgbvCDmzv1WZ3Xmh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, asml.silence@gmail.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.16 073/164] block: clear iocb->private in blkdev_bio_end_io_async()
Date:   Mon, 28 Feb 2022 18:23:55 +0100
Message-Id: <20220228172406.691243934@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

commit bb49c6fa8b845591b317b0d7afea4ae60ec7f3aa upstream.

iocb_bio_iopoll() expects iocb->private to be cleared before
releasing the bio.

We already do this in blkdev_bio_end_io(), but we forgot in the
recently added blkdev_bio_end_io_async().

Fixes: 54a88eb838d3 ("block: add single bio async direct IO helper")
Cc: asml.silence@gmail.com
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220211090136.44471-1-sgarzare@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/fops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/block/fops.c
+++ b/block/fops.c
@@ -289,6 +289,8 @@ static void blkdev_bio_end_io_async(stru
 	struct kiocb *iocb = dio->iocb;
 	ssize_t ret;
 
+	WRITE_ONCE(iocb->private, NULL);
+
 	if (likely(!bio->bi_status)) {
 		ret = dio->size;
 		iocb->ki_pos += ret;


