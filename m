Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25843137A2
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbhBHP20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233844AbhBHPXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:23:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B32D64EA4;
        Mon,  8 Feb 2021 15:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797266;
        bh=S1coIZflJIvUE2Km3MzTAR00e0rZwype0VVf6gZi52E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xK84ni+wBEVdQi4hxeC7K0ORdCDh3g168wCVa20LwUXzxKNGutYQxCFgx+k80yIEi
         pUWBfaxaVL1YE2tJRGOStZrJjbpjhXaAi95lF8nv8Qt6Yw7T2zsmTwjAJIRHr9R7D9
         7csxv7kuuM/u1N1tFOBuvU858Cn5FCVOA6Lnt+WM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Narayan Ayalasomayajula <Narayan.Ayalasomayajula@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/120] nvmet-tcp: fix out-of-bounds access when receiving multiple h2cdata PDUs
Date:   Mon,  8 Feb 2021 16:00:36 +0100
Message-Id: <20210208145820.379544245@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit cb8563f5c735a042ea2dd7df1ad55ae06d63ffeb ]

When the host sends multiple h2cdata PDUs, we keep track on
the receive progress and calculate the scatterlist index and
offsets.

The issue is that sg_offset should only be kept for the first
iov entry we map in the iovec as this is the difference between
our cursor and the sg entry offset itself.

In addition, the sg index was calculated wrong because we should
not round up when dividing the command byte offset with PAG_SIZE.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Reported-by: Narayan Ayalasomayajula <Narayan.Ayalasomayajula@wdc.com>
Tested-by: Narayan Ayalasomayajula <Narayan.Ayalasomayajula@wdc.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index dc1f0f6471896..aacf06f0b4312 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -305,7 +305,7 @@ static void nvmet_tcp_map_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 	length = cmd->pdu_len;
 	cmd->nr_mapped = DIV_ROUND_UP(length, PAGE_SIZE);
 	offset = cmd->rbytes_done;
-	cmd->sg_idx = DIV_ROUND_UP(offset, PAGE_SIZE);
+	cmd->sg_idx = offset / PAGE_SIZE;
 	sg_offset = offset % PAGE_SIZE;
 	sg = &cmd->req.sg[cmd->sg_idx];
 
@@ -318,6 +318,7 @@ static void nvmet_tcp_map_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 		length -= iov_len;
 		sg = sg_next(sg);
 		iov++;
+		sg_offset = 0;
 	}
 
 	iov_iter_kvec(&cmd->recv_msg.msg_iter, READ, cmd->iov,
-- 
2.27.0



