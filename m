Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0CD3FDBAE
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344678AbhIAMnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345190AbhIAMkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0665610C8;
        Wed,  1 Sep 2021 12:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499853;
        bh=PiEvoytnhll13TDEI3GSeTkPFU6Bqx6YjDFpfsJSSlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJRQnXPFO+qIxpb1USFJZm1xors7N63eJgMWO3+iyTIUXKKMs5LYM1SydoCeZ59GK
         CcsqQiqb+WAUgp7dQ+xziUOpYlPPkL2BMfYdi56bjZQoxlTakiwmn6SHj9oyB1nWDm
         Z0tn1mrwZqB5EzbT+OisLKmQWYC/dYWmFbSjSHQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 001/113] net: qrtr: fix another OOB Read in qrtr_endpoint_post
Date:   Wed,  1 Sep 2021 14:27:16 +0200
Message-Id: <20210901122302.031489182@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
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
@@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpo
 		goto err;
 	}
 
-	if (len != ALIGN(size, 4) + hdrlen)
+	if (!size || len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
 	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&


