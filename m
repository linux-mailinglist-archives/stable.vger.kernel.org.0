Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A808A450AC6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbhKOROk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:14:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236728AbhKORND (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:13:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4702961C15;
        Mon, 15 Nov 2021 17:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996207;
        bh=bjZkxvjvyGh6iemq/lJDpSd7qA9FMvOg4aq8y7HDrHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ot5LaBU1iEz2GWAr7+j7fPEoZrsXIo0tK6ElDDBR9vEL5Oau3Y04QlVrScoZRtKJd
         BZlVDlvCXfhXeFWuPKzIXSuaNN2sHjm4ub9+EPTfJ1+unt9W43/LitwAPpE0r9e76n
         W2l6P57AZ8Z2g95Du5oWMzl6aSlPztQAhNOBkzUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Engel <amit.engel@dell.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/355] nvmet-tcp: fix header digest verification
Date:   Mon, 15 Nov 2021 17:59:39 +0100
Message-Id: <20211115165315.323417909@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Engel <amit.engel@dell.com>

[ Upstream commit 86aeda32b887cdaeb0f4b7bfc9971e36377181c7 ]

Pass the correct length to nvmet_tcp_verify_hdgst, which is the pdu
header length.  This fixes a wrong behaviour where header digest
verification passes although the digest is wrong.

Signed-off-by: Amit Engel <amit.engel@dell.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 1328ee373e596..6b3d1ba7db7ee 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1020,7 +1020,7 @@ recv:
 	}
 
 	if (queue->hdr_digest &&
-	    nvmet_tcp_verify_hdgst(queue, &queue->pdu, queue->offset)) {
+	    nvmet_tcp_verify_hdgst(queue, &queue->pdu, hdr->hlen)) {
 		nvmet_tcp_fatal_error(queue); /* fatal */
 		return -EPROTO;
 	}
-- 
2.33.0



