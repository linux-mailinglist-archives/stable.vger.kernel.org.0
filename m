Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3603395CCC
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhEaNiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:38:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231803AbhEaNf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:35:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DC7D613AB;
        Mon, 31 May 2021 13:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467539;
        bh=AqPSNXmqpkBuzKNdGEkl44YQeFHwWt4dlcI5cmmDdjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqRsmYGsoiIUT7s3+tQzZ0TZqrLsbSAbWdS/bo3egu7+5tiRbyy5uedKtrIa40orN
         Pud9cBsXYp6hfwA7/JG87MBp+6x01E2ORQB1J50F55n6tIW8zCvO5NQTxXdFQJgk04
         pfFvYVxtNNhNGo0AlqNAm9AvaotqxKfFAYipHHJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/116] net: bnx2: Fix error return code in bnx2_init_board()
Date:   Mon, 31 May 2021 15:14:38 +0200
Message-Id: <20210531130643.584295963@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 28c66b6da4087b8cfe81c2ec0a46eb6116dafda9 ]

Fix to return -EPERM from the error handling case instead of 0, as done
elsewhere in this function.

Fixes: b6016b767397 ("[BNX2]: New Broadcom gigabit network driver.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 122fdb80a789..9993f1162ac6 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8253,9 +8253,9 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
 		BNX2_WR(bp, PCI_COMMAND, reg);
 	} else if ((BNX2_CHIP_ID(bp) == BNX2_CHIP_ID_5706_A1) &&
 		!(bp->flags & BNX2_FLAG_PCIX)) {
-
 		dev_err(&pdev->dev,
 			"5706 A1 can only be used in a PCIX bus, aborting\n");
+		rc = -EPERM;
 		goto err_out_unmap;
 	}
 
-- 
2.30.2



