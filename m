Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9152F7B5B
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388434AbhAONBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:01:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732055AbhAOMdF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:33:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0D1C235F9;
        Fri, 15 Jan 2021 12:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713945;
        bh=LcsDfsXtnt6BALebnMNStaCQLdQeJlU3QXNbuKfSNKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxCJb2ahaQzw+ZBWcKkmhhu3U127kwpkmpl69Xu0wokT9K74sJoojI4WSnO1WC8Od
         TD5iVWept/KVWgaZuu4ujqziUp/yXIsYWr8SQx9zKJwSEP+r/5Y9EYBKhReI1hhRKy
         j6NJ3hYIzYXYxnRl/AFSNZ/jF8QIyn+tVHLcYLRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 02/43] net: hns3: fix the number of queues actually used by ARQ
Date:   Fri, 15 Jan 2021 13:27:32 +0100
Message-Id: <20210115121957.165879490@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
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
@@ -102,7 +102,7 @@ struct hclgevf_mbx_arq_ring {
 #define hclge_mbx_ring_ptr_move_crq(crq) \
 	(crq->next_to_use = (crq->next_to_use + 1) % crq->desc_num)
 #define hclge_mbx_tail_ptr_move_arq(arq) \
-	(arq.tail = (arq.tail + 1) % HCLGE_MBX_MAX_ARQ_MSG_SIZE)
+		(arq.tail = (arq.tail + 1) % HCLGE_MBX_MAX_ARQ_MSG_NUM)
 #define hclge_mbx_head_ptr_move_arq(arq) \
-		(arq.head = (arq.head + 1) % HCLGE_MBX_MAX_ARQ_MSG_SIZE)
+		(arq.head = (arq.head + 1) % HCLGE_MBX_MAX_ARQ_MSG_NUM)
 #endif


