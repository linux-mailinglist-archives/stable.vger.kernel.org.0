Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FB34095D5
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346037AbhIMOpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:45:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346436AbhIMOmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:42:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 685D460FF2;
        Mon, 13 Sep 2021 13:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541406;
        bh=JRGX/Lop0/dOvKLFORGazAXF1hzRTdd/R6m1yGKy9PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rx05806UoNiMUrs+CWUtmAwhIPfFUPkci4dTatYw0zFGg9IwEGSTmpKSXYyMdIDPY
         SnTffR1ZvP+yDFLQOP8pVmolYVWz8YaSQjW3CgGxurio7bnMHu6Vvpv8ZM7I5/NGny
         A9/tCMdtb2L6DXH89sXHQbtltzx0vn0nJDWaTP3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 286/334] net: qrtr: make checks in qrtr_endpoint_post() stricter
Date:   Mon, 13 Sep 2021 15:15:40 +0200
Message-Id: <20210913131123.091601343@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index 0c30908628ba..bdbda61db8b9 100644
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



