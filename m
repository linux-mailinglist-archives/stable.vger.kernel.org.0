Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E21348F88
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhCYL2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:28:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231235AbhCYL0n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBC6D61A33;
        Thu, 25 Mar 2021 11:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671602;
        bh=/9ujew30/khoYdl8uTOuMTpa+/+vYu2kig65Xjphl34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3wzwtS4Nx4w5zUzbA29o51FjfKVu2GDZY6mPoJe3BqLQ4jKaXCy30uU5vgKxEAWB
         /Z6AhbuHhEMGT4ZHmBkvsd4Ql1y+/cp0iLccb7bK0fYxk+5zwFBDS4+etY8DF3G7tb
         caHrACJJXyI8YKS2A5z8/yoH+thIsULwxzsHiksewXci81X/UrD+y2wXdEIucnMyTZ
         4jm2wn5fkfP7C2pcKjZO5u+XXXL8U3qYIYYhSHqctVpvJayS6W8k18RLSEYyV9kyGE
         M2jIOAqIl6+URm5tlTEmZ3BtSiiO0nCwm+Tuo8Vto26hpFvULk7/jPwctAcf9PQKwQ
         +qDB3wEHoNQlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Elad Grupi <elad.grupi@dell.com>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 33/39] nvmet-tcp: fix kmap leak when data digest in use
Date:   Thu, 25 Mar 2021 07:25:52 -0400
Message-Id: <20210325112558.1927423-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Elad Grupi <elad.grupi@dell.com>

[ Upstream commit bac04454ef9fada009f0572576837548b190bf94 ]

When data digest is enabled we should unmap pdu iovec before handling
the data digest pdu.

Signed-off-by: Elad Grupi <elad.grupi@dell.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 8b0485ada315..d658c6e8263a 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1098,11 +1098,11 @@ static int nvmet_tcp_try_recv_data(struct nvmet_tcp_queue *queue)
 		cmd->rbytes_done += ret;
 	}
 
+	nvmet_tcp_unmap_pdu_iovec(cmd);
 	if (queue->data_digest) {
 		nvmet_tcp_prep_recv_ddgst(cmd);
 		return 0;
 	}
-	nvmet_tcp_unmap_pdu_iovec(cmd);
 
 	if (!(cmd->flags & NVMET_TCP_F_INIT_FAILED) &&
 	    cmd->rbytes_done == cmd->req.transfer_len) {
-- 
2.30.1

