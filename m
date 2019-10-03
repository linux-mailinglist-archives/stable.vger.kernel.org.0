Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04207CA7E3
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405829AbfJCQtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405819AbfJCQta (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:49:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 410082086A;
        Thu,  3 Oct 2019 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121369;
        bh=rAHWafvF/p2ISqdL4GkXcPnZbLUrH+29egDL3TH7uyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=deGs1FHJ124WjTY5tP2tsJnpKVlS0GSdaFtLOpI9vAkf1OHHuDgM3ZZJImTkul64F
         0todPgwNLpUOTt1ZIzcdyNiWMTI1EiJONXx+t5p9ZxT1Ccci+EltHrBBNpIsB3oFZ2
         VcufkBsX8m/prIpQwojg8L5ee7zuLABQbCpHjg78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 252/344] scsi: implement .cleanup_rq callback
Date:   Thu,  3 Oct 2019 17:53:37 +0200
Message-Id: <20191003154605.365782189@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit b7e9e1fb7a9227be34ad4a5e778022c3164494cf ]

Implement .cleanup_rq() callback for freeing driver private part
of the request. Then we can avoid to leak this part if the request isn't
completed by SCSI, and freed by blk-mq or upper layer(such as dm-rq) finally.

Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Cc: <stable@vger.kernel.org>
Fixes: 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_lib.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 11e64b50497f8..4e88d7e9cf9a3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1089,6 +1089,18 @@ static void scsi_initialize_rq(struct request *rq)
 	cmd->retries = 0;
 }
 
+/*
+ * Only called when the request isn't completed by SCSI, and not freed by
+ * SCSI
+ */
+static void scsi_cleanup_rq(struct request *rq)
+{
+	if (rq->rq_flags & RQF_DONTPREP) {
+		scsi_mq_uninit_cmd(blk_mq_rq_to_pdu(rq));
+		rq->rq_flags &= ~RQF_DONTPREP;
+	}
+}
+
 /* Add a command to the list used by the aacraid and dpt_i2o drivers */
 void scsi_add_cmd_to_list(struct scsi_cmnd *cmd)
 {
@@ -1821,6 +1833,7 @@ static const struct blk_mq_ops scsi_mq_ops = {
 	.init_request	= scsi_mq_init_request,
 	.exit_request	= scsi_mq_exit_request,
 	.initialize_rq_fn = scsi_initialize_rq,
+	.cleanup_rq	= scsi_cleanup_rq,
 	.busy		= scsi_mq_lld_busy,
 	.map_queues	= scsi_map_queues,
 };
-- 
2.20.1



