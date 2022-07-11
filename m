Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF7756FDAF
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbiGKJ7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbiGKJ6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:58:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD4BB5D16;
        Mon, 11 Jul 2022 02:27:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A819B80D2C;
        Mon, 11 Jul 2022 09:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F7AC34115;
        Mon, 11 Jul 2022 09:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531648;
        bh=n0hYW14P2MKpZwo1i5aFk7orNBSieQ8KYy2b4+bCFyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jm281VnOWQIOe18JArJwlJQZO0F/RsYuHa4UXtC2N0g9U6DjkNAC0V3qnBWwGb4n9
         9zKXrLVEhSLOuxaxXy6p+cUqvszFeapNXLhGuonlXnh5ECnYQERoFr5qbEjI+wEa8P
         xk5IJ/9H6yYycjjRfqXdCCAMq5VeS2eDkKabk7N0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Ye Guojin <ye.guojin@zte.com.cn>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 5.15 174/230] virtio-blk: modify the value type of num in virtio_queue_rq()
Date:   Mon, 11 Jul 2022 11:07:10 +0200
Message-Id: <20220711090608.997252359@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Guojin <ye.guojin@zte.com.cn>

commit 0466a39bd0b6c462338f10d18076703d14a552de upstream.

This was found by coccicheck:
./drivers/block/virtio_blk.c, 334, 14-17, WARNING Unsigned expression
compared with zero  num < 0

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
Link: https://lore.kernel.org/r/20211117063955.160777-1-ye.guojin@zte.com.cn
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: 02746e26c39e ("virtio-blk: avoid preallocating big SGL for data")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/virtio_blk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -308,7 +308,7 @@ static blk_status_t virtio_queue_rq(stru
 	struct request *req = bd->rq;
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 	unsigned long flags;
-	unsigned int num;
+	int num;
 	int qid = hctx->queue_num;
 	int err;
 	bool notify = false;


