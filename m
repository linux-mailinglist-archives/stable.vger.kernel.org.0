Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B51C663A8F
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 09:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbjAJIIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 03:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbjAJIIO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 03:08:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE99113F64
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 00:08:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 566F4B81106
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C03C433D2;
        Tue, 10 Jan 2023 08:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673338090;
        bh=FwPq4raJGEUNZX/Ls/IkLu4hYCpZPJQS45T3Hv/TY7M=;
        h=Subject:To:Cc:From:Date:From;
        b=R2ZzZ99h6fNydbrQ6yBp40oMyAtUJpY8/tULcCiC40PHp+sTy+2eYYRKKsztJIVnG
         FlDUKbQ+EPkbxwCl0LQemzealilIfcKrLFTJYDaZZlfSAYT8ls5wVMcTCocR0Xm8Gm
         GcKTXF59jVXrhdsUkveYvya2s2OwoPR8JfNe4ucY=
Subject: FAILED: patch "[PATCH] virtio_blk: Fix signedness bug in virtblk_prep_rq()" failed to apply to 6.1-stable tree
To:     rafaelmendsr@gmail.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, stefanha@redhat.com, suwan.kim027@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Jan 2023 09:08:05 +0100
Message-ID: <167333808585201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a26116c1e740 ("virtio_blk: Fix signedness bug in virtblk_prep_rq()")
258896fcc786 ("virtio-blk: use a helper to handle request queuing errors")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a26116c1e74028914f281851488546c91cbae57d Mon Sep 17 00:00:00 2001
From: Rafael Mendonca <rafaelmendsr@gmail.com>
Date: Fri, 21 Oct 2022 17:41:26 -0300
Subject: [PATCH] virtio_blk: Fix signedness bug in virtblk_prep_rq()

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

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index dcbf86cd2155..6a77fa917428 100644
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
 

