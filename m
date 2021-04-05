Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4339353FFD
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbhDEJPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239872AbhDEJOY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:14:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 324C6611C1;
        Mon,  5 Apr 2021 09:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614058;
        bh=/9ujew30/khoYdl8uTOuMTpa+/+vYu2kig65Xjphl34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBj8eccL6BA4BAKSZsdg9LCq/NXfGHN8USYLA+czUWnXRXCQrQgH8zgkWMY9sLrFq
         4yY56/BJ3ZoXwOAakD80twjim814x/MWGrDBhLmBjQT0VSI1DfARyEF5J32k3BxwxF
         hrI2RKlPcX7BxznuCj/Fjam5FvFkC+jpoQb7wc5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elad Grupi <elad.grupi@dell.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 033/152] nvmet-tcp: fix kmap leak when data digest in use
Date:   Mon,  5 Apr 2021 10:53:02 +0200
Message-Id: <20210405085035.329432506@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



