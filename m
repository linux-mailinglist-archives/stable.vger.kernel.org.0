Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7EDD6649A5
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbjAJSXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239327AbjAJSWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:22:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5502A19C04
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:20:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E63FD61865
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B08C433F0;
        Tue, 10 Jan 2023 18:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374833;
        bh=IJiUjh+9liN1fNfyUXZ1kHU7gp9bYEh2g9lHVqyz9AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijIy9tGfAccvDCqXyNh1efOFP42N8r1xkB9Yj4L1oVs9doOX8ehpcfnehMStAv4ux
         4wOaaOOkdO5YsitEJiwaMKh6QHXdGZYNuc3rsSKlRiu7xK8P3/s0zweeOD5ddk4vbr
         6l3LX9KnvENCq4Ps+MpB7GZ/GGmwaJ//7CcNWFJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rafael Mendonca <rafaelmendsr@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Suwan Kim <suwan.kim027@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/159] virtio_blk: Fix signedness bug in virtblk_prep_rq()
Date:   Tue, 10 Jan 2023 19:04:57 +0100
Message-Id: <20230110180023.245441087@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit a26116c1e74028914f281851488546c91cbae57d ]

The virtblk_map_data() function returns negative error codes, however, the
'nents' field of vbr->sg_table is an unsigned int, which causes the error
handling not to work correctly.

Cc: stable@vger.kernel.org
Fixes: 0e9911fa768f ("virtio-blk: support mq_ops->queue_rqs()")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Message-Id: <20221021204126.927603-1-rafaelmendsr@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Suwan Kim <suwan.kim027@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 3efe3da5f8c2..a7697027ce43 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -334,14 +334,16 @@ static blk_status_t virtblk_prep_rq(struct blk_mq_hw_ctx *hctx,
 					struct virtblk_req *vbr)
 {
 	blk_status_t status;
+	int num;
 
 	status = virtblk_setup_cmd(vblk->vdev, req, vbr);
 	if (unlikely(status))
 		return status;
 
-	vbr->sg_table.nents = virtblk_map_data(hctx, req, vbr);
-	if (unlikely(vbr->sg_table.nents < 0))
+	num = virtblk_map_data(hctx, req, vbr);
+	if (unlikely(num < 0))
 		return virtblk_fail_to_queue(req, -ENOMEM);
+	vbr->sg_table.nents = num;
 
 	blk_mq_start_request(req);
 
-- 
2.35.1



