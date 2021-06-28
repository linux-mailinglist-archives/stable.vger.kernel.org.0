Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E76A3B626D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhF1Ori (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234830AbhF1OmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADA7F61CEA;
        Mon, 28 Jun 2021 14:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890824;
        bh=xELFI+IjnvHx6hSiy12kU34qZjeXBfpK3NmgXgL7kgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRwWSMN4jm3m5JEQD0BVCOT04Jnl0TwokcPkor4kvNZszjK362oY1MK+0ZgNvMM0w
         FXhBsE0lvsASgXo/VQphQGUBi7kGoYMauVRRYdN3biYx3KHUXDmHvTvyOl43COF+cT
         ydG99wzGZZes9KX9ll1Hj2J3+PqqIRArebcIMs3iV0uDofDzv+JsX29pXlwkxGje/3
         3LTb5NbBWoThXZwK8VXeo1cbqMN4QsQ8Gvt5riOsNUgZeANOVex8v7+QzH251bX4Ja
         eSCrqZCwv4eHT1ztxCEtG2hUcz4ksSBbFAAmLMAHQhH8Ng7XJWs48tWEsgB005LaeB
         Xl8sOpCrkWQKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+1917d778024161609247@syzkaller.appspotmail.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/109] net: qrtr: fix OOB Read in qrtr_endpoint_post
Date:   Mon, 28 Jun 2021 10:31:57 -0400
Message-Id: <20210628143305.32978-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index 43f63d0606ec..1e2772913957 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -264,7 +264,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	const struct qrtr_hdr_v2 *v2;
 	struct sk_buff *skb;
 	struct qrtr_cb *cb;
-	unsigned int size;
+	size_t size;
 	unsigned int ver;
 	size_t hdrlen;
 
-- 
2.30.2

