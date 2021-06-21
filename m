Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDB93AEE72
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhFUQ2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232029AbhFUQ1g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:27:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FC24613E8;
        Mon, 21 Jun 2021 16:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292579;
        bh=TQ8IPQXY75jtU1OWQu9A+36NPPEwaM6gv/UUn4Qn4DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vlv7cRmtbJRfaAaZWi88uREd+bGSC1XuHbXGDfdTc9y+arzPE9UCC36RdvtRjuLFQ
         o8wEXJlNh2I6XMTtNETQ+yXPh4fmFR8wpiB1O009y22rqYZV2iMH2Dqg3P3ZA4luXJ
         aOuqovaLIe4fuqBIKt9+e29V1MHFYxFJUaJOuYU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+1917d778024161609247@syzkaller.appspotmail.com
Subject: [PATCH 5.10 053/146] net: qrtr: fix OOB Read in qrtr_endpoint_post
Date:   Mon, 21 Jun 2021 18:14:43 +0200
Message-Id: <20210621154913.812385167@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
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
index 93a7edcff11e..0d9baddb9cd4 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -429,7 +429,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	struct qrtr_sock *ipc;
 	struct sk_buff *skb;
 	struct qrtr_cb *cb;
-	unsigned int size;
+	size_t size;
 	unsigned int ver;
 	size_t hdrlen;
 
-- 
2.30.2



