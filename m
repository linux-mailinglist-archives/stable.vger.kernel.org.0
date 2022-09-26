Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08BEC5EA522
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239138AbiIZL6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238947AbiIZL46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:56:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7D17A767;
        Mon, 26 Sep 2022 03:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1AFFB80926;
        Mon, 26 Sep 2022 10:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DF7C433C1;
        Mon, 26 Sep 2022 10:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189471;
        bh=y7Mlu+4vaXSTwuWXF2lDCSOlXNwTXgB3fXmnlL3jX8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNbCOFQ67SoPir/eh7Se0i6IzODxVCr2FdsrJOFQsifIgveCY7NafyQgbfv4nPlri
         4Phetmpos4PvpRRJMM/zxrZxVyGEOmXZPwIPi/oHN0JCa5VHaN/aTJZJPNm4LWd1jg
         IlfpIKGy18mBTEUCFasilww/WFbMI0p/USaUzVZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.19 169/207] block: call blk_mq_exit_queue from disk_release for never added disks
Date:   Mon, 26 Sep 2022 12:12:38 +0200
Message-Id: <20220926100814.224159894@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit c5db2cfc6274692d821d33b59acb6ff615e350c1 upstream.

To undo the all initialization from blk_mq_init_allocated_queue in case
of a probe failure where add_disk is never called we have to call
blk_mq_exit_queue from put_disk.

This relies on the fact that drivers always call blk_mq_free_tag_set
after calling put_disk in the probe error path if they have a gendisk
at all.

We should be doing this in general, but can't do it for the normal
teardown case (yet) as the tagset can be gone by the time the disk is
released once it was added.  I hope to sort this out properly eventually
but for now this isolated hack will do it.

Fixes: 6f8191fdf41d ("block: simplify disk shutdown")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20220720130541.1323531-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/genhd.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1158,6 +1158,18 @@ static void disk_release(struct device *
 	might_sleep();
 	WARN_ON_ONCE(disk_live(disk));
 
+	/*
+	 * To undo the all initialization from blk_mq_init_allocated_queue in
+	 * case of a probe failure where add_disk is never called we have to
+	 * call blk_mq_exit_queue here. We can't do this for the more common
+	 * teardown case (yet) as the tagset can be gone by the time the disk
+	 * is released once it was added.
+	 */
+	if (queue_is_mq(disk->queue) &&
+	    test_bit(GD_OWNS_QUEUE, &disk->state) &&
+	    !test_bit(GD_ADDED, &disk->state))
+		blk_mq_exit_queue(disk->queue);
+
 	blkcg_exit_queue(disk->queue);
 
 	disk_release_events(disk);
@@ -1422,6 +1434,9 @@ EXPORT_SYMBOL(__blk_alloc_disk);
  * This decrements the refcount for the struct gendisk. When this reaches 0
  * we'll have disk_release() called.
  *
+ * Note: for blk-mq disk put_disk must be called before freeing the tag_set
+ * when handling probe errors (that is before add_disk() is called).
+ *
  * Context: Any context, but the last reference must not be dropped from
  *          atomic context.
  */


