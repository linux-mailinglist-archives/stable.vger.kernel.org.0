Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA7435BE5A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238458AbhDLI5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238524AbhDLIzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0060461221;
        Mon, 12 Apr 2021 08:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217736;
        bh=sVrCajMgdgNpzRj2BTgdDucVtkmO2lc2YYecXck1zLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wjp7CSzoLLtTWfUFxguVK4KzKTdb88HGiBN/FF4bHLgk8oyPMYnTGFUziZHhzfSAx
         j1XSV4s3T2ZSXIoQZ5pbTVCrRCPrd+yAzlBPXRj7hTtB+lqkOYbLtffef9Fe8nrCK/
         UKZgBrQ1dBFwl9yKaJBK3nbqmgYqZEcJumgLtPpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+739016799a89c530b32a@syzkaller.appspotmail.com,
        Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/188] net: qrtr: Fix memory leak on qrtr_tx_wait failure
Date:   Mon, 12 Apr 2021 10:40:40 +0200
Message-Id: <20210412084017.836981182@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit 8a03dd925786bdc3834d56ccc980bb70668efa35 ]

qrtr_tx_wait does not check for radix_tree_insert failure, causing
the 'flow' object to be unreferenced after qrtr_tx_wait return. Fix
that by releasing flow on radix_tree_insert failure.

Fixes: 5fdeb0d372ab ("net: qrtr: Implement outgoing flow control")
Reported-by: syzbot+739016799a89c530b32a@syzkaller.appspotmail.com
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/qrtr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 45fbf5f4dcd2..93a7edcff11e 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -266,7 +266,10 @@ static int qrtr_tx_wait(struct qrtr_node *node, int dest_node, int dest_port,
 		flow = kzalloc(sizeof(*flow), GFP_KERNEL);
 		if (flow) {
 			init_waitqueue_head(&flow->resume_tx);
-			radix_tree_insert(&node->qrtr_tx_flow, key, flow);
+			if (radix_tree_insert(&node->qrtr_tx_flow, key, flow)) {
+				kfree(flow);
+				flow = NULL;
+			}
 		}
 	}
 	mutex_unlock(&node->qrtr_tx_lock);
-- 
2.30.2



