Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5293961E6
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhEaOro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233256AbhEaOpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:45:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3C8161437;
        Mon, 31 May 2021 13:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469328;
        bh=R7fGHLtuHqWMQLf1kTqQdOKEvzKXPfzIK9wJtXAntKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCpk15J6qV+/t0edkpQ7GNNSwe4drnPyk/Hh9KxrHhzybFJd/TcZN1TXcjeJTgjhD
         lE40y0lOn75dUiloeTpTdKMGIdyWbFpVo2Xf+a57PTYY51gWVYa19Kb9X168llFVBr
         Lwp+2JP5cjlehRaUiTfxA/3X7JPzoawLtRUqa0dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Pu <houpu.main@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.12 156/296] nvmet-tcp: fix inline data size comparison in nvmet_tcp_queue_response
Date:   Mon, 31 May 2021 15:13:31 +0200
Message-Id: <20210531130709.107873224@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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


