Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAC1452747
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347179AbhKPCUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:20:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:57922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhKORnE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:43:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB7AB6328D;
        Mon, 15 Nov 2021 17:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997287;
        bh=tSklQLeH8noyZTrFa4qQeEIxVA9LvVVGzV9h7cBqZt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSAgBjfJ930cXhqKzFCvciX6KPq96odDiKsJvZTYuFuUNVPcqIMqmDzXdIMWVMMKT
         Yzyr0xnH6Gn5io58y3LFy+VgXfcQU3J36zUyf2yTfmQeXoNauvo+uwXRcyguc9DkVj
         fohqMmQy7PYQhezo0GHkDlzYzQikksh3XN4gY1GE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Engel <amit.engel@dell.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/575] nvmet-tcp: fix header digest verification
Date:   Mon, 15 Nov 2021 17:56:41 +0100
Message-Id: <20211115165346.262220289@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index b4ef7e9e8461f..58dc517fe8678 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1084,7 +1084,7 @@ recv:
 	}
 
 	if (queue->hdr_digest &&
-	    nvmet_tcp_verify_hdgst(queue, &queue->pdu, queue->offset)) {
+	    nvmet_tcp_verify_hdgst(queue, &queue->pdu, hdr->hlen)) {
 		nvmet_tcp_fatal_error(queue); /* fatal */
 		return -EPROTO;
 	}
-- 
2.33.0



