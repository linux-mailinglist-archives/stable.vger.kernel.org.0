Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7103C3DDE
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 19:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbfJARCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 13:02:51 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:60713 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728546AbfJARCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 13:02:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id F187A576;
        Tue,  1 Oct 2019 13:02:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 01 Oct 2019 13:02:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mRo19F
        G3YSfSqgOAl8k9vcYo/3luvuQ0dRH8sAMaLwM=; b=eVTces1aga8cLSGd2mgMVX
        Z+tzx6v4FZOgYIGwKzX/mZDfZzsPUKeztb9t8lr+lmsNwe3QamIsrly4vWTKBlWm
        tG3oY8aX+1h8pu+z/O0ZP4KbK/Q23lB0T2YodBJDKzt4RUYml8owTwliIgoXe230
        Itl90MnrFcpek9KjDoxwj676rPsEFLivrICNvrs95622Rm/pYj53xbDMNuyq5sHu
        Am39qKIu2TXHGGgp7XAWNWJyodIH5RQ4KfbqjiGoux1ZMm+GfBYyD7C/JmJKS+I0
        UWk4rzeyCPevxv9wqt9VCurHEevfTRttBbaWFMrZwu5czcSUz7KKRZzN/I/RP8vg
        ==
X-ME-Sender: <xms:uIaTXbibZT8hlNbw-NKfcPG5is97JncH7qLRE9VBnebDe8XKay_YnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeggddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:uIaTXdgzVaziVgrn9LYrJi_wh8sWeV_sTscNw-zwe6KCXX1Jyj1gpg>
    <xmx:uIaTXaL0-TIOA-mtyUcjZzfKWiRskW55dbN-DQgVShlGOA8HxP0Fqg>
    <xmx:uIaTXcnCJxFRnU56XAFwUk9iCnOe6IT9RepK24Ch_m_5-8srU6c55g>
    <xmx:uIaTXbGOj89puIhPcdQsAqvTBkksQP9dU4gc_P9fd93E46M3r-55Pg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4C5818005C;
        Tue,  1 Oct 2019 13:02:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: implement .cleanup_rq callback" failed to apply to 4.19-stable tree
To:     ming.lei@redhat.com, axboe@kernel.dk, bvanassche@acm.org,
        emilne@redhat.com, hare@suse.com, hch@lst.de, snitzer@redhat.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 01 Oct 2019 19:02:45 +0200
Message-ID: <1569949365193105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

