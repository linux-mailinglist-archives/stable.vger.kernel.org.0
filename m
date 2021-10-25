Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB4F43A254
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbhJYTrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:47:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237261AbhJYTpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:45:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B893C6105A;
        Mon, 25 Oct 2021 19:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190761;
        bh=8o9HeoF9TYmr3BSU3uQgAMEZYVboF3r+myI7DK6BUf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TaTPNwer+P6hE/e024STLMeKIgpFoq6upSPGTzbOfomCOK0XF6Eef+7q0GyAI1BAq
         abI7yJaioUU/FA5Ks9/dT6Dwsxfnc5LT507C50FIWW03jjtGLDBW5H/7/9eRPrv7YP
         kqSfusWHIZWkL4EcvtvDfOs7y5yR68ZQ9ImzE8ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 045/169] net: hns3: reset DWRR of unused tc to zero
Date:   Mon, 25 Oct 2021 21:13:46 +0200
Message-Id: <20211025191023.496526616@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit b63fcaab959807282e9822e659034edf95fc8bd1 ]

Currently, DWRR of tc will be initialized to a fixed value when this tc
is enabled, but it is not been reset to 0 when this tc is disabled. It
cause a problem that the DWRR of unused tc is not 0 after using tc tool
to add and delete multi-tc parameters.

For examples, after enabling 4 TCs and restoring to 1 TC by follow
tc commands:

$ tc qdisc add dev eth0 root mqprio num_tc 4 map 0 1 2 3 0 1 2 3 queues \
  8@0 8@8 8@16 8@24 hw 1 mode channel
$ tc qdisc del dev eth0 root

Now there is just one TC is enabled for eth0, but the tc info querying by
debugfs is shown as follow:

$ cat /mnt/hns3/0000:7d:00.0/tm/tc_sch_info
enabled tc number: 1
weight_offset: 14
TC    MODE  WEIGHT
0     dwrr    100
1     dwrr    100
2     dwrr    100
3     dwrr    100
4     dwrr      0
5     dwrr      0
6     dwrr      0
7     dwrr      0

This patch fixes it by resetting DWRR of tc to 0 when tc is disabled.

Fixes: 848440544b41 ("net: hns3: Add support of TX Scheduler & Shaper to HNS3 driver")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index f314dbd3ce11..95074e91a846 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -752,6 +752,8 @@ static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
 		hdev->tm_info.pg_info[i].tc_bit_map = hdev->hw_tc_map;
 		for (k = 0; k < hdev->tm_info.num_tc; k++)
 			hdev->tm_info.pg_info[i].tc_dwrr[k] = BW_PERCENT;
+		for (; k < HNAE3_MAX_TC; k++)
+			hdev->tm_info.pg_info[i].tc_dwrr[k] = 0;
 	}
 }
 
-- 
2.33.0



