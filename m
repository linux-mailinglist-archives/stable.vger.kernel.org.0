Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EED395E8A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhEaOAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232897AbhEaN56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:57:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AC7861940;
        Mon, 31 May 2021 13:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468124;
        bh=R7fGHLtuHqWMQLf1kTqQdOKEvzKXPfzIK9wJtXAntKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JY9roNVD4HQr3VfMLHuUQALxnJP1blIIERakKrYVE/nCNkMNUgFden0nvV/czpXUK
         uQFyGz2F8V5JxvQAjh2vzY7kYrEq8tud1Bf1EhgjAQanmlfP2uw4BUThJAnupuqNKS
         h+zbYPKd2kYqcC1u8CWSj8unPKNIWXdsVkjoiwrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Pu <houpu.main@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 126/252] nvmet-tcp: fix inline data size comparison in nvmet_tcp_queue_response
Date:   Mon, 31 May 2021 15:13:11 +0200
Message-Id: <20210531130702.293479967@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Pu <houpu.main@gmail.com>

commit 25df1acd2d36eb72b14c3d00f6b861b1e00b3aab upstream.

Using "<=" instead "<" to compare inline data size.

Fixes: bdaf13279192 ("nvmet-tcp: fix a segmentation fault during io parsing error")
Signed-off-by: Hou Pu <houpu.main@gmail.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -538,7 +538,7 @@ static void nvmet_tcp_queue_response(str
 		 * nvmet_req_init is completed.
 		 */
 		if (queue->rcv_state == NVMET_TCP_RECV_PDU &&
-		    len && len < cmd->req.port->inline_data_size &&
+		    len && len <= cmd->req.port->inline_data_size &&
 		    nvme_is_write(cmd->req.cmd))
 			return;
 	}


