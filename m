Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685464092BD
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241287AbhIMOPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241402AbhIMONS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:13:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F86461354;
        Mon, 13 Sep 2021 13:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540587;
        bh=1SzleJ2zTAGKhV/CRYpfEc03b9xHuP+Ub5N/JYZLyXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNR2pr3Fg/QrENcbuel35xM1g5epBzw/KRenzjQZn6yErvaL4uUfWVMFtIwjRPOjj
         rF+HzcAENf+fUH6AN1a1re5yPvvwLBiHePQ3Aj/rNuIgQFhKfjfedplzboZMjjZC1E
         R6AvDMjyVSn5FqMeL4PsMLBdZQ5ScrfBkr58G/pI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 254/300] net: qrtr: make checks in qrtr_endpoint_post() stricter
Date:   Mon, 13 Sep 2021 15:15:15 +0200
Message-Id: <20210913131117.930610395@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit aaa8e4922c887ff47ad66ef918193682bccc1905 ]

These checks are still not strict enough.  The main problem is that if
"cb->type == QRTR_TYPE_NEW_SERVER" is true then "len - hdrlen" is
guaranteed to be 4 but we need to be at least 16 bytes.  In fact, we
can reject everything smaller than sizeof(*pkt) which is 20 bytes.

Also I don't like the ALIGN(size, 4).  It's better to just insist that
data is needs to be aligned at the start.

Fixes: 0baa99ee353c ("net: qrtr: Allow non-immediate node routing")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/qrtr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 52b7f6490d24..2e732ea2b82f 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		goto err;
 	}
 
-	if (!size || len != ALIGN(size, 4) + hdrlen)
+	if (!size || size & 3 || len != size + hdrlen)
 		goto err;
 
 	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
@@ -506,8 +506,12 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 
 	if (cb->type == QRTR_TYPE_NEW_SERVER) {
 		/* Remote node endpoint can bridge other distant nodes */
-		const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
+		const struct qrtr_ctrl_pkt *pkt;
 
+		if (size < sizeof(*pkt))
+			goto err;
+
+		pkt = data + hdrlen;
 		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
 	}
 
-- 
2.30.2



