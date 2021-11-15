Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4A0450F1B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhKOS0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:26:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241177AbhKOSYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:24:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CCE06341E;
        Mon, 15 Nov 2021 17:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998863;
        bh=hnTRkKzHGFJm4rbLcGVcEju3ceNhn37d9azHP3lhQTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjKBL2QefcNo0Wlf+EvGDESJrQYrZi51cir+bAPP6t8L6UTIU2Ng59Rke8Q1kud1n
         eAPGDB2x5mehr+eWFn3/dXTjxo0bIHt1iVT8oG8Hgqz8tteutj4FzjJkMxnjJYj7vZ
         kS7huBeKPyXUJAstUzsnTq/+VFraPz0jYOAFdycc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Engel <amit.engel@dell.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 089/849] nvmet-tcp: fix header digest verification
Date:   Mon, 15 Nov 2021 17:52:52 +0100
Message-Id: <20211115165423.083270854@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 586ca20837e7b..46c3b3be7e033 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1096,7 +1096,7 @@ recv:
 	}
 
 	if (queue->hdr_digest &&
-	    nvmet_tcp_verify_hdgst(queue, &queue->pdu, queue->offset)) {
+	    nvmet_tcp_verify_hdgst(queue, &queue->pdu, hdr->hlen)) {
 		nvmet_tcp_fatal_error(queue); /* fatal */
 		return -EPROTO;
 	}
-- 
2.33.0



