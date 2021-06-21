Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBF43AED7F
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhFUQU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231370AbhFUQUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:20:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41749611CE;
        Mon, 21 Jun 2021 16:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292267;
        bh=Zi8QVkUbPr5TatUjiZdN5sSF8ZhPbTB44EnotF7idWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdi9vqIaDMx/PcQlZReqL9cs5umJ5re+0DcKnUCHLvBsIJJI9QWnjHFeFzwRQDNIM
         pg0i/0+K4w/RX4Jk5kTXVj50yoPAxKCZE9ENLTZ/RzBU/focGIym1qHGZ8vjhC0JIq
         C49INGTY23m2MMgDn4OdUf8rRVs7ryFTue2BD4Ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+1917d778024161609247@syzkaller.appspotmail.com
Subject: [PATCH 5.4 27/90] net: qrtr: fix OOB Read in qrtr_endpoint_post
Date:   Mon, 21 Jun 2021 18:15:02 +0200
Message-Id: <20210621154905.039257253@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit ad9d24c9429e2159d1e279dc3a83191ccb4daf1d ]

Syzbot reported slab-out-of-bounds Read in
qrtr_endpoint_post. The problem was in wrong
_size_ type:

	if (len != ALIGN(size, 4) + hdrlen)
		goto err;

If size from qrtr_hdr is 4294967293 (0xfffffffd), the result of
ALIGN(size, 4) will be 0. In case of len == hdrlen and size == 4294967293
in header this check won't fail and

	skb_put_data(skb, data + hdrlen, size);

will read out of bound from data, which is hdrlen allocated block.

Fixes: 194ccc88297a ("net: qrtr: Support decoding incoming v2 packets")
Reported-and-tested-by: syzbot+1917d778024161609247@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/qrtr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 46273a838361..faea2ce12511 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -257,7 +257,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	const struct qrtr_hdr_v2 *v2;
 	struct sk_buff *skb;
 	struct qrtr_cb *cb;
-	unsigned int size;
+	size_t size;
 	unsigned int ver;
 	size_t hdrlen;
 
-- 
2.30.2



