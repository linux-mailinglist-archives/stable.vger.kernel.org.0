Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5C9622EF
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389507AbfGHP3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389504AbfGHP3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:29:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 582ED21707;
        Mon,  8 Jul 2019 15:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599773;
        bh=OYcuxhqUVb8Tjwl2xKM6ssuEmlmfYxwlb2hiW3ErcAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ias2ZMSVkSqTxXmLscD81+aEbS4vTXH2p5wGTAr7i8owCwxQnf79bnDi64C1IbCwH
         HquC8810b6n/SEB0LncTsHsjUyWbrYN7/M9tr6WHkqDq1Wa2cmluGJ1dRmDW6PUZ+P
         ey3eSMuUfZEoytVkybhwrPLa3DPpONQ2Dmq8soWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 73/90] net: hns: Fixes the missing put_device in positive leg for roce reset
Date:   Mon,  8 Jul 2019 17:13:40 +0200
Message-Id: <20190708150526.015161864@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4d96e13ee9cd1f7f801e8c7f4b12f09d1da4a5d8 ]

This patch fixes the missing device reference release-after-use in
the positive leg of the roce reset API of the HNS DSAF.

Fixes: c969c6e7ab8c ("net: hns: Fix object reference leaks in hns_dsaf_roce_reset()")
Reported-by: John Garry <john.garry@huawei.com>
Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
index fdff5526d2e8..f5ff07cb2b72 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
@@ -3149,6 +3149,9 @@ int hns_dsaf_roce_reset(struct fwnode_handle *dsaf_fwnode, bool dereset)
 		dsaf_set_bit(credit, DSAF_SBM_ROCEE_CFG_CRD_EN_B, 1);
 		dsaf_write_dev(dsaf_dev, DSAF_SBM_ROCEE_CFG_REG_REG, credit);
 	}
+
+	put_device(&pdev->dev);
+
 	return 0;
 }
 EXPORT_SYMBOL(hns_dsaf_roce_reset);
-- 
2.20.1



