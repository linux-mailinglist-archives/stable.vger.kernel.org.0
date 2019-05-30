Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5C92F5BA
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfE3DLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbfE3DLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:08 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DF5D24482;
        Thu, 30 May 2019 03:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185868;
        bh=wCSwVXjdOLI6nyJgiCgO9fwcnCb+fHP6vdUDUQCEPHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlYZokVqtRenJ98UH3M/QtF2SytrubIPU6bKlFLE3JNFWpq7Tl6nlfDS/BD5QEP/0
         5PIp6G9tojfNWY9CiiOAZjRv048QGrkQnixM8srKzAngayDPwr4P601T8SBacBwbFm
         qbyRCaqciNkQqcfRd41qdcarc9kxbYTuraBRY5TE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 208/405] net: hns3: free the pending skb when clean RX ring
Date:   Wed, 29 May 2019 20:03:26 -0700
Message-Id: <20190530030551.653211198@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cc5ff6e90f808f9a4c8229bf2f1de0dfe5d7931c ]

If there is pending skb in RX flow when close the port, and the
pending buffer is not cleaned, the new packet will be added to
the pending skb when the port opens again, and the first new
packet has error data.

This patch cleans the pending skb when clean RX ring.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 0208efe282775..d6b488c2de332 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3851,6 +3851,13 @@ static int hns3_clear_rx_ring(struct hns3_enet_ring *ring)
 		ring_ptr_move_fw(ring, next_to_use);
 	}
 
+	/* Free the pending skb in rx ring */
+	if (ring->skb) {
+		dev_kfree_skb_any(ring->skb);
+		ring->skb = NULL;
+		ring->pending_buf = 0;
+	}
+
 	return 0;
 }
 
-- 
2.20.1



