Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EE535C0BE
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241351AbhDLJPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240694AbhDLJKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F0AA61363;
        Mon, 12 Apr 2021 09:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218381;
        bh=XMiwNQTDOiRTSd56F8WAVOgIVi5fgZLreImXNBJsaWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unES/LWSd7Ax2w4qZfTnEkJkTAIxBLyFUJygDJKvAraqczNmJkaH1c9kM+LrZDvGD
         /DFgzxhmINXajYLza9+7UDA60cqVlLYvTEw9OW1gf5OQVuJNw/X38tH+W3E6zi3fuP
         mkPWx4GNWdFVClolLMqrSwljXHgPgko8tpNiGUKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 177/210] net: hns3: clear VF down state bit before request link status
Date:   Mon, 12 Apr 2021 10:41:22 +0200
Message-Id: <20210412084021.913427795@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit ed7bedd2c3ca040f1e8ea02c6590a93116b1ec78 ]

Currently, the VF down state bit is cleared after VF sending
link status request command. There is problem that when VF gets
link status replied from PF, the down state bit may still set
as 1. In this case, the link status replied from PF will be
ignored and always set VF link status to down.

To fix this problem, clear VF down state bit before VF requests
link status.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 674b3a22e91f..3bd7bc794677 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2575,14 +2575,14 @@ static int hclgevf_ae_start(struct hnae3_handle *handle)
 {
 	struct hclgevf_dev *hdev = hclgevf_ae_get_hdev(handle);
 
+	clear_bit(HCLGEVF_STATE_DOWN, &hdev->state);
+
 	hclgevf_reset_tqp_stats(handle);
 
 	hclgevf_request_link_info(hdev);
 
 	hclgevf_update_link_mode(hdev);
 
-	clear_bit(HCLGEVF_STATE_DOWN, &hdev->state);
-
 	return 0;
 }
 
-- 
2.30.2



