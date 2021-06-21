Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC1E3AF00D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhFUQqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233163AbhFUQnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:43:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3840D61445;
        Mon, 21 Jun 2021 16:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293089;
        bh=G6azULgzfCzqoGEWeSwpKyauIDsk5HwKoz6iDfwBgMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1pgO8nq0kykThVHWr4aW10Ve0CemcPqelg48oU8SD8dKyk2hmCBpYXsC6HlcOv+D
         pLiwkagI1LFV7y7X74J1c6mQkG9Epufhpejc/AF/NqUg3PQyIh+p0mvYA47/ChpRMX
         S8mggN3n3Q1Hji6Qcx8W7pQPrfo2P24xNe6faIK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+1917d778024161609247@syzkaller.appspotmail.com
Subject: [PATCH 5.12 061/178] net: qrtr: fix OOB Read in qrtr_endpoint_post
Date:   Mon, 21 Jun 2021 18:14:35 +0200
Message-Id: <20210621154924.560861055@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
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
index 1e4fb568fa84..24f10bf7d8a3 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -435,7 +435,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	struct qrtr_sock *ipc;
 	struct sk_buff *skb;
 	struct qrtr_cb *cb;
-	unsigned int size;
+	size_t size;
 	unsigned int ver;
 	size_t hdrlen;
 
-- 
2.30.2



