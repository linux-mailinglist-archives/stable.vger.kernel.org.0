Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E566DEED9
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjDLIpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjDLIpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:45:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA647869E
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:44:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C2A96308F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF7DC433EF;
        Wed, 12 Apr 2023 08:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289090;
        bh=MG45AQEO2C1dGckktMwzp1rN3JgRNBVGyccvyt/p36E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSLIiAQnj0a3cuNAptzaCSw5++nxnFLQpRgLwWs++PhiN+bsNs4AfrP7K6AuzwM8Z
         hZpAXA/QDSxjFsASgTsrz9p6/cRwC4EofDBmQ1sCanGFSucZpBhk181LZnqxCjO/DI
         XBLGQLVIfMWLf90RIbzsCPck8QOniIYbw1XWiif8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 132/164] ublk: read any SQE values upfront
Date:   Wed, 12 Apr 2023 10:34:14 +0200
Message-Id: <20230412082842.224994399@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 8c68ae3b22fa6fb2dbe83ef955ff10936503d28e upstream.

Since SQE memory is shared with userspace, we should only be reading it
once. We cannot read it multiple times, particularly when it's read once
for validation and then read again for the actual use.

ublk_ch_uring_cmd() is safe when called as a retry operation, as the
memory backing is stable at that point. But for normal issue, we want
to ensure that we only read ublksrv_io_cmd once. Wrap the function in
a helper that reads the value into an on-stack copy of the struct.

Cc: stable@vger.kernel.org # 6.0+
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1202,9 +1202,10 @@ static void ublk_handle_need_get_data(st
 	ublk_queue_cmd(ubq, req);
 }
 
-static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
+			       unsigned int issue_flags,
+			       struct ublksrv_io_cmd *ub_cmd)
 {
-	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->cmd;
 	struct ublk_device *ub = cmd->file->private_data;
 	struct ublk_queue *ubq;
 	struct ublk_io *io;
@@ -1306,6 +1307,23 @@ static int ublk_ch_uring_cmd(struct io_u
 	return -EIOCBQUEUED;
 }
 
+static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	struct ublksrv_io_cmd *ub_src = (struct ublksrv_io_cmd *) cmd->cmd;
+	struct ublksrv_io_cmd ub_cmd;
+
+	/*
+	 * Not necessary for async retry, but let's keep it simple and always
+	 * copy the values to avoid any potential reuse.
+	 */
+	ub_cmd.q_id = READ_ONCE(ub_src->q_id);
+	ub_cmd.tag = READ_ONCE(ub_src->tag);
+	ub_cmd.result = READ_ONCE(ub_src->result);
+	ub_cmd.addr = READ_ONCE(ub_src->addr);
+
+	return __ublk_ch_uring_cmd(cmd, issue_flags, &ub_cmd);
+}
+
 static const struct file_operations ublk_ch_fops = {
 	.owner = THIS_MODULE,
 	.open = ublk_ch_open,


