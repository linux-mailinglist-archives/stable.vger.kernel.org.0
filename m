Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9893215FE
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhBVMPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:15:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230335AbhBVMPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A76C64F0E;
        Mon, 22 Feb 2021 12:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996061;
        bh=sSXsUrcIB8DW/Klreg+7NzLV1np9GJl7ncTYGo8V2Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBP8EtTi7Vmmu8YHlt6+8Xj5PkqHncNvPRqzWl0f4xyHfat4uJzKv4mw4fwSxxki+
         bNBgotr6eMuUHBcogAxVJ7q8JtxhB2+WeTmoLJpk1A0jOnY0nevCW8V7srz0TEvLt2
         2sVrBJcLQmO2l7u2O1ixaatgbs+p+imKZOw86TsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/29] net: qrtr: Fix port ID for control messages
Date:   Mon, 22 Feb 2021 13:13:01 +0100
Message-Id: <20210222121021.353938023@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
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
index 957aa9263ba4c..d7134c558993c 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -347,7 +347,7 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
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



