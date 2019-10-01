Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05085C40F0
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 21:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfJATUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 15:20:30 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39431 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726010AbfJATU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 15:20:29 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3810E224EE;
        Tue,  1 Oct 2019 15:20:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 01 Oct 2019 15:20:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=l6nNdZ
        ZM24Pkw5iL71ChNSglh+qjzyYS8aiVukaF1ZA=; b=mCCrTUdtjhyHooEZ5NA9+E
        MfhAbNdDWk/JKCYxsGN9nGYikFUMc7BvjOHfY6nHqnlfmu35zO02C7r+ndaIP38Z
        7mvwpw2Nm6S7sKHP9zAyAoJi2tJH4B8SxcScGjt4OC1IomynUkuARx/GlI/oKAJA
        /2jq8gnN6TBxLP2945qeZ+apMob6LOoAW8nk1PKpOE62Z73bu9BBQK3CyDqG6gpu
        ZcaMU5Vu7g7cNMoIhkg2rVbqSP0rTtc+HCEmMXNv2rQWC6/P/8FE3UVta7mTeewo
        77j+2Bq643NMiiIol5Ze27HiZdT89dVeisPv8dfrUbPNaLuQHC2r8rrSIxJtmjRA
        ==
X-ME-Sender: <xms:_KaTXVvIXdUxJQBoEYGy6K4iaXTuEbdQUt3R8CyPkhlzpwlKMVBb_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeggddufeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:_KaTXSeLHNHkZV1ACCpFgQsgRZkKgP2QeFXkdmVTsOmqIbobGsRQ8g>
    <xmx:_KaTXX2AQcWqbIxJF4xcW-IMR7X-XRXSniqx6PJiRPTfc-31AUVEEQ>
    <xmx:_KaTXd95ckoAQm0TOd1BDXh-QfaUgqEzB0x-4m8LMGEf97gn56wQTA>
    <xmx:_aaTXS1SuOlLuxITzQxfLlv0rFNhCSX7j4mRGGCydF7QQBFUiOLCUQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CCA4B8006A;
        Tue,  1 Oct 2019 15:20:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: implement .cleanup_rq callback" failed to apply to 5.3-stable tree
To:     ming.lei@redhat.com, axboe@kernel.dk, bvanassche@acm.org,
        emilne@redhat.com, hare@suse.com, hch@lst.de, snitzer@redhat.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 01 Oct 2019 21:14:42 +0200
Message-ID: <1569957282145249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b7e9e1fb7a9227be34ad4a5e778022c3164494cf Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Thu, 25 Jul 2019 10:05:00 +0800
Subject: [PATCH] scsi: implement .cleanup_rq callback

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

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 11e64b50497f..4e88d7e9cf9a 100644
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

