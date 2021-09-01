Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C60D3FDA32
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244782AbhIAMbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244528AbhIAMaa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:30:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1547561090;
        Wed,  1 Sep 2021 12:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499373;
        bh=VYLnrJHl436UIhJJAl6DJJMvGLV9Ffn8pByb0Xk52hM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLlikcX0Loj+cpIsG8XpuxMJpyRf8mfyxTSj83lfZ1BkGeIb5A4dQWWz4hj1cWJOG
         3MXFXNX+nNS99N4YzjXu6Jd8VWBTJeBuW1VX6Ag57V9AhqnjMtKHlM4I9byhmcPQaM
         AhCcdVv8W/wpqhc9Wp/9KY/n9PmV8diLVWBlWR98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 01/33] net: qrtr: fix another OOB Read in qrtr_endpoint_post
Date:   Wed,  1 Sep 2021 14:27:50 +0200
Message-Id: <20210901122250.798320864@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122250.752620302@linuxfoundation.org>
References: <20210901122250.752620302@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaolong Huang <butterflyhuangxx@gmail.com>

commit 7e78c597c3ebfd0cb329aa09a838734147e4f117 upstream.

This check was incomplete, did not consider size is 0:

	if (len != ALIGN(size, 4) + hdrlen)
                    goto err;

if size from qrtr_hdr is 0, the result of ALIGN(size, 4)
will be 0, In case of len == hdrlen and size == 0
in header this check won't fail and

	if (cb->type == QRTR_TYPE_NEW_SERVER) {
                /* Remote node endpoint can bridge other distant nodes */
                const struct qrtr_ctrl_pkt *pkt = data + hdrlen;

                qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
        }

will also read out of bound from data, which is hdrlen allocated block.

Fixes: 194ccc88297a ("net: qrtr: Support decoding incoming v2 packets")
Fixes: ad9d24c9429e ("net: qrtr: fix OOB Read in qrtr_endpoint_post")
Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/qrtr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -321,7 +321,7 @@ int qrtr_endpoint_post(struct qrtr_endpo
 		goto err;
 	}
 
-	if (len != ALIGN(size, 4) + hdrlen)
+	if (!size || len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
 	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA)


