Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F94C353EB0
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238005AbhDEJH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238192AbhDEJHP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:07:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC26C613A0;
        Mon,  5 Apr 2021 09:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613629;
        bh=/9ujew30/khoYdl8uTOuMTpa+/+vYu2kig65Xjphl34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/YP5qgIfUXnlfJjEg7sIPBZ1430zOMVgnTbs86nxTrS4e7+8Ebe8ptafk6I5qv/F
         D2kKsRtOfu9McJes9U33B/HS+vtiLgzE8BZAw5C0N86M5e9Q18/Wh6cQ7Dy4jjNHBE
         fTWl0nTBHC5vzEZO2t2uza5PLWjCTYaUfFcPZ+0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elad Grupi <elad.grupi@dell.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/126] nvmet-tcp: fix kmap leak when data digest in use
Date:   Mon,  5 Apr 2021 10:53:14 +0200
Message-Id: <20210405085032.102660351@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
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



