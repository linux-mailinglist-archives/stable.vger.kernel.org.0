Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8398643A148
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbhJYTiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236720AbhJYTfI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:35:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A8246108C;
        Mon, 25 Oct 2021 19:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190346;
        bh=8rzeqkYyRGngJ0odVsd2BXJ7YP/tIlYXNlf1UGg8N0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTsEk8em5diht9/FP/T2DJ4WnlsMre5fG41iotOcltTDTP09+OkcxJ7m+VXodNaj4
         GpYfr6in101QNebRTPokGhWYRN0A/sscZ3u3hBCeZDQsTXQ8yf95n8dnAwY8Ui1Qsb
         oIbQ419U+UfNcH5fc2wapCuCrRBjxvXfudfSy6nQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/95] net: hns3: reset DWRR of unused tc to zero
Date:   Mon, 25 Oct 2021 21:14:21 +0200
Message-Id: <20211025191000.412773963@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
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
index 69d081515c60..71aa6d16fc19 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -671,6 +671,8 @@ static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
 		hdev->tm_info.pg_info[i].tc_bit_map = hdev->hw_tc_map;
 		for (k = 0; k < hdev->tm_info.num_tc; k++)
 			hdev->tm_info.pg_info[i].tc_dwrr[k] = BW_PERCENT;
+		for (; k < HNAE3_MAX_TC; k++)
+			hdev->tm_info.pg_info[i].tc_dwrr[k] = 0;
 	}
 }
 
-- 
2.33.0



