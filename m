Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20862F7A6E
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732317AbhAOMtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:49:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387815AbhAOMgY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:36:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0DD722473;
        Fri, 15 Jan 2021 12:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714169;
        bh=sHLPx/EpPrIQ/FsHUH2NuQ4sFSHHtxrHGCW/ThE+vzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kohgz6x3PfZ32F1bRR6OjWwomYsYu7UOCw4t3iZYCBeMmofSiwl9+6E6Pu5qVR+Av
         v8fz64sWh4nPJpbFIWmW3VqYHSi2sq/4nvo82EhPv8VFTgnqXpwB56VID0cmI1v/9Q
         j8GzSWBV17W86N478QkRmEUaSV3NIrRFzkAGOrt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 015/103] net: hns3: fix the number of queues actually used by ARQ
Date:   Fri, 15 Jan 2021 13:27:08 +0100
Message-Id: <20210115122006.783656684@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit 65e61e3c2a619c4d4b873885b2d5394025ed117b ]

HCLGE_MBX_MAX_ARQ_MSG_NUM is used to apply memory for the number
of queues used by ARQ(Asynchronous Receive Queue), so the head
and tail pointers should also use this macro.

Fixes: 07a0556a3a73 ("net: hns3: Changes to support ARQ(Asynchronous Receive Queue)")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h
@@ -168,7 +168,7 @@ struct hclgevf_mbx_arq_ring {
 #define hclge_mbx_ring_ptr_move_crq(crq) \
 	(crq->next_to_use = (crq->next_to_use + 1) % crq->desc_num)
 #define hclge_mbx_tail_ptr_move_arq(arq) \
-	(arq.tail = (arq.tail + 1) % HCLGE_MBX_MAX_ARQ_MSG_SIZE)
+		(arq.tail = (arq.tail + 1) % HCLGE_MBX_MAX_ARQ_MSG_NUM)
 #define hclge_mbx_head_ptr_move_arq(arq) \
-		(arq.head = (arq.head + 1) % HCLGE_MBX_MAX_ARQ_MSG_SIZE)
+		(arq.head = (arq.head + 1) % HCLGE_MBX_MAX_ARQ_MSG_NUM)
 #endif


