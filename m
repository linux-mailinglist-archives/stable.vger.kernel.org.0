Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0B85FD1E6
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiJMA4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiJMA4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:56:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA8912EA66;
        Wed, 12 Oct 2022 17:53:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4F40616CB;
        Thu, 13 Oct 2022 00:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE43C43141;
        Thu, 13 Oct 2022 00:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620768;
        bh=j+67didnIPF+xzyve6MvUXmjz4nmKeBUiydpiwCnhUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VmcsQZWXdC+C1VleaBDwW39O+UhK1kDH9cWUoLlk+zpIWQpR9efcCwpyHl9FXjsT5
         UGyWfAyb0EfpS0H+qIN0jv44S2ocbHzAE6qxzXqx8QX3ZYx9WBzzOKLYzGuU0O93g9
         O86qAxZQdZ9yhI2sFmkLQh3uGSog5iGp85ptYlTYxrME8J0oFui5oY8n7AjoJFXYa1
         I4iyPlr+/e3dOArI10n7DRmRb0BQtWOKvEJPKpXyVGloB3bE1lXKA6uaXEXrp3gqqQ
         O+L1ZC0manfD9cpxF7T8o6AsRmmbF0/ZROffjWVHiLByVGw0NmTVzUdBFqyIQz+WF2
         C6VjJUJuory1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Varun Prakash <varun@chelsio.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kch@nvidia.com,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 23/27] nvmet-tcp: add bounds check on Transfer Tag
Date:   Wed, 12 Oct 2022 20:24:55 -0400
Message-Id: <20221013002501.1895204-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002501.1895204-1-sashal@kernel.org>
References: <20221013002501.1895204-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>

[ Upstream commit b6a545ffa2c192b1e6da4a7924edac5ba9f4ea2b ]

ttag is used as an index to get cmd in nvmet_tcp_handle_h2c_data_pdu(),
add a bounds check to avoid out-of-bounds access.

Signed-off-by: Varun Prakash <varun@chelsio.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index eb5b39c2bba8..df7a911d303f 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -858,10 +858,17 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 	struct nvme_tcp_data_pdu *data = &queue->pdu.data;
 	struct nvmet_tcp_cmd *cmd;
 
-	if (likely(queue->nr_cmds))
+	if (likely(queue->nr_cmds)) {
+		if (unlikely(data->ttag >= queue->nr_cmds)) {
+			pr_err("queue %d: received out of bound ttag %u, nr_cmds %u\n",
+				queue->idx, data->ttag, queue->nr_cmds);
+			nvmet_tcp_fatal_error(queue);
+			return -EPROTO;
+		}
 		cmd = &queue->cmds[data->ttag];
-	else
+	} else {
 		cmd = &queue->connect;
+	}
 
 	if (le32_to_cpu(data->data_offset) != cmd->rbytes_done) {
 		pr_err("ttag %u unexpected data offset %u (expected %u)\n",
-- 
2.35.1

