Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3A2419BDD
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbhI0RXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237095AbhI0RVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69C1261360;
        Mon, 27 Sep 2021 17:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762820;
        bh=Pujct7ko0Dbu3tjBEaxnoSsjTsZPCfKQx4GmTGagKM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MR0syKkzZbno9ot8XOQhH3BJIRUtmfP2JENWyFbTi+v74pk++uB3+CaiD9Kg4/MOp
         Y2/+7MHOX+Sw8kB64QwdFOvAFQkaml0D0Jx2v9RFCNCWAYQskkpcmQdEvnZoPl+eoo
         Wuce24r0QLGjJuAYIuW4QSC9tQwydNS7PxQMwVqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 064/162] net: hns3: fix inconsistent vf id print
Date:   Mon, 27 Sep 2021 19:01:50 +0200
Message-Id: <20210927170235.684113640@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 91bc0d5272d3a4dc3d4fd2a74387c7e7361bbe96 ]

The vf id from ethtool is added 1 before configured to driver.
So it's necessary to minus 1 when printing it, in order to
keep consistent with user's configuration.

Fixes: dd74f815dd41 ("net: hns3: Add support for rule add/delete for flow director")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 40c4949eed4d..45faf924bc36 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6635,10 +6635,13 @@ static int hclge_fd_parse_ring_cookie(struct hclge_dev *hdev, u64 ring_cookie,
 		u8 vf = ethtool_get_flow_spec_ring_vf(ring_cookie);
 		u16 tqps;
 
+		/* To keep consistent with user's configuration, minus 1 when
+		 * printing 'vf', because vf id from ethtool is added 1 for vf.
+		 */
 		if (vf > hdev->num_req_vfs) {
 			dev_err(&hdev->pdev->dev,
-				"Error: vf id (%u) > max vf num (%u)\n",
-				vf, hdev->num_req_vfs);
+				"Error: vf id (%u) should be less than %u\n",
+				vf - 1, hdev->num_req_vfs);
 			return -EINVAL;
 		}
 
-- 
2.33.0



