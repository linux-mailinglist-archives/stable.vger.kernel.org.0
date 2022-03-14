Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3EF4D79E3
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 05:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbiCNEbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 00:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiCNEbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 00:31:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC91E3E5F3
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 21:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647232239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BO77OkKAXAd6fg8HoYgYYomm0QShNKPTbMuOp6veM0E=;
        b=MTryu8evCksuS9mIsy1/jKDNVorb1MK1FTt/8z55dL9yf2Pr4NdHwf4WhHhMAPZwZNgRj8
        /iVK43+L/Nws7pAqW/23DKBmDwZzY/eIrCvMSmybLBCqDjLcb7dCg0goKjDAo/cKDBt6eU
        E7N906D5ePwxX7uEmumcNgatHCOJjho=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-KmRh_lR6PGeST97tyrLuLA-1; Mon, 14 Mar 2022 00:30:35 -0400
X-MC-Unique: KmRh_lR6PGeST97tyrLuLA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C6FC38035A8;
        Mon, 14 Mar 2022 04:30:35 +0000 (UTC)
Received: from localhost (ovpn-8-29.pek2.redhat.com [10.72.8.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6A1A111CB96;
        Mon, 14 Mar 2022 04:30:28 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        syzbot+b42749a851a47a0f581b@syzkaller.appspotmail.com
Subject: [PATCH] block: release rq qos structures for queue without disk
Date:   Mon, 14 Mar 2022 12:30:18 +0800
Message-Id: <20220314043018.177141-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

blkcg_init_queue() may add rq qos structures to request queue, previously
blk_cleanup_queue() calls rq_qos_exit() to release them, but commit
8e141f9eb803 ("block: drain file system I/O on del_gendisk")
moves rq_qos_exit() into del_gendisk(), so memory leak is caused
because queues may not have disk, such as un-present scsi luns, nvme
admin queue, ...

Fixes the issue by adding rq_qos_exit() to blk_cleanup_queue() back.

BTW, v5.18 won't need this patch any more since we move
blkcg_init_queue()/blkcg_exit_queue() into disk allocation/release
handler, and patches have been in for-5.18/block.

Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Fixes: 8e141f9eb803 ("block: drain file system I/O on del_gendisk")
Reported-by: syzbot+b42749a851a47a0f581b@syzkaller.appspotmail.com
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index ce08f0aa9dfc..4965307cf7d6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -50,6 +50,7 @@
 #include "blk-pm.h"
 #include "blk-cgroup.h"
 #include "blk-throttle.h"
+#include "blk-rq-qos.h"
 
 struct dentry *blk_debugfs_root;
 
@@ -321,6 +322,9 @@ void blk_cleanup_queue(struct request_queue *q)
 	 */
 	blk_freeze_queue(q);
 
+	/* cleanup rq qos structures for queue without disk */
+	rq_qos_exit(q);
+
 	blk_queue_flag_set(QUEUE_FLAG_DEAD, q);
 
 	blk_sync_queue(q);
-- 
2.31.1

