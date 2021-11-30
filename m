Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C1246379B
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243250AbhK3Oyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242932AbhK3Ox2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:53:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A58C0613A1;
        Tue, 30 Nov 2021 06:49:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AFF31CE1A3F;
        Tue, 30 Nov 2021 14:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E942DC53FD2;
        Tue, 30 Nov 2021 14:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283736;
        bh=GvhueYt+SCekSCF1JsdL8Kt4Hd/djiouHtIFM5n5YM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsdoSiUPIjTRO60bsesEgd/Z35fcqTM/aNcBsY/EkqobA9EoIGG4mqMAVs11eXt6Z
         vDfi8gtOmPwrnrxLn0kVtxVmGaU2RpOBUv+Z08H69sr3WDMG/eR3/DDMh6iUEaCMsS
         7URBJyTlQd+wmwmPvIo0uJ56/zI0cigdnBdK7tbXxtFLyEQG2sz6U9lcx7G6ex28QO
         fciv6qGh8BANmKpImCvIJN7PQyE+Vumw/QEwT+8tVvyriSN7exmbYTCneLFv8ar/Ne
         Li+svO4oa+oR76wEmqIMAiJJC9mbCFYh2vkKC16nlr/u+rz9upO1OSd78W7u0QS0FZ
         gBYmU8Zq9VIYw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Meneghini <jmeneghi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kch@nvidia.com,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 42/68] nvmet-tcp: fix memory leak when performing a controller reset
Date:   Tue, 30 Nov 2021 09:46:38 -0500
Message-Id: <20211130144707.944580-42-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit af21250bb503a02e705b461886321e394b300524 ]

If a reset controller is executed while the initiator
is performing some I/O the driver may leak the memory allocated
for the commands' iovec.

Make sure that nvmet_tcp_uninit_data_in_cmds() releases
all the memory.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 786b1440a9af4..605aa2a8ca536 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1427,7 +1427,10 @@ static void nvmet_tcp_uninit_data_in_cmds(struct nvmet_tcp_queue *queue)
 
 	for (i = 0; i < queue->nr_cmds; i++, cmd++) {
 		if (nvmet_tcp_need_data_in(cmd))
-			nvmet_tcp_finish_cmd(cmd);
+			nvmet_req_uninit(&cmd->req);
+
+		nvmet_tcp_unmap_pdu_iovec(cmd);
+		nvmet_tcp_free_cmd_buffers(cmd);
 	}
 
 	if (!queue->nr_cmds && nvmet_tcp_need_data_in(&queue->connect)) {
-- 
2.33.0

