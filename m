Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05451321670
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhBVMWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:22:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230240AbhBVMSb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:18:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F2AB64EEF;
        Mon, 22 Feb 2021 12:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996271;
        bh=pd3PrJb+foKqU8w6hxDu5EHxFOO37VLjIZrxGe3+9WI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D41LGIL8w+GF5Ea3+anrXD4IBXLPhL877cIx5/yAioG5g0pfpRkxTt0LEYc6oJG1W
         Lb5sd/1+o62uXQvZkJG+5p3iQE0GqrA0T5AntXdqs9QAHztpnOtgpVFu6nCaGUu49g
         yAn+E9us5iAnzj0W3ZiGDfa1UHxH1/qiyCaoGe+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/50] net: qrtr: Fix port ID for control messages
Date:   Mon, 22 Feb 2021 13:13:30 +0100
Message-Id: <20210222121026.522104836@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit ae068f561baa003d260475c3e441ca454b186726 ]

The port ID for control messages was uncorrectly set with broadcast
node ID value, causing message to be dropped on remote side since
not passing packet filtering (cb->dst_port != QRTR_PORT_CTRL).

Fixes: d27e77a3de28 ("net: qrtr: Reset the node and port ID of broadcast messages")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/qrtr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index a05c5cb3429c0..69cf9cbbb05f6 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -194,7 +194,7 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 	hdr->src_port_id = cpu_to_le32(from->sq_port);
 	if (to->sq_port == QRTR_PORT_CTRL) {
 		hdr->dst_node_id = cpu_to_le32(node->nid);
-		hdr->dst_port_id = cpu_to_le32(QRTR_NODE_BCAST);
+		hdr->dst_port_id = cpu_to_le32(QRTR_PORT_CTRL);
 	} else {
 		hdr->dst_node_id = cpu_to_le32(to->sq_node);
 		hdr->dst_port_id = cpu_to_le32(to->sq_port);
-- 
2.27.0



