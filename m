Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF27312C688
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731370AbfL2Rr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:47:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731368AbfL2Rr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:47:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24CCE206A4;
        Sun, 29 Dec 2019 17:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641677;
        bh=ot7C7BgLlTHzgcxd/QU4FIRu3ygxaVMu4VTKToAEDkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GWIfByTZFPtQhYq45TWBPiCGwPw4mdW3P4662Cs0FCu/WTztY+uzbClkFxAVhJK1q
         Mm+piBIClHApZwtgAKXFZTp+7mcn80eI02rFL3oMgKDdlnCv2VQFMJOlCuJwGQzbxS
         WcBWK/4SsouZNVV+0WQPubSAtaXehrl1x1V4Ge18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 165/434] net: hns3: log and clear hardware error after reset complete
Date:   Sun, 29 Dec 2019 18:23:38 +0100
Message-Id: <20191229172712.760614935@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 4fdd0bca6152aa201898454e63cbb255a18ae6e9 ]

When device is resetting, the CMDQ service may be stopped until
reset completed. If a new RAS error occurs at this moment, it
will no be able to clear the RAS source. This patch fixes it
by clear the RAS source after reset complete.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index c052bb33b3d3..162881005a6d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9443,6 +9443,9 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 		return ret;
 	}
 
+	/* Log and clear the hw errors those already occurred */
+	hclge_handle_all_hns_hw_errors(ae_dev);
+
 	/* Re-enable the hw error interrupts because
 	 * the interrupts get disabled on global reset.
 	 */
-- 
2.20.1



