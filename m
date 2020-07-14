Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B2221FBB9
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbgGNS4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730997AbgGNS4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:56:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAF14229CA;
        Tue, 14 Jul 2020 18:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752993;
        bh=HdD+zjhNHTtx9jtvQ4QzA4QAaCJhqfArhQrSAfv6lMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDM8ODjh6JG7l9caRfXnzCL26H8BfJurfIjb+SM5aJZWjVK53FYeKPqMIURhLbJ6e
         Slr3g+VtduUcMYcGzN8lqSqLR/4TMqNEaBgFg8RP+FoG6+eTtZ6DJd0pLwPMNYphch
         USdHl9Ezt5wATqhs+ehpSI7rrE5UltS5iZbCXLuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 078/166] net: hns3: fix for mishandle of asserting VF reset fail
Date:   Tue, 14 Jul 2020 20:44:03 +0200
Message-Id: <20200714184119.586712582@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit cddd5648926d7a6e84526dadd8bfb21609a14fb7 ]

When asserts VF reset fail, flag HCLGEVF_STATE_CMD_DISABLE
and handshake status should not set, otherwise the retry will
fail. So adds a check for asserting VF reset and returns
directly when fails.

Fixes: ef5f8e507ec9 ("net: hns3: stop handling command queue while resetting VF")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index e02d427131eeb..e6cdd06925e6b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1527,6 +1527,11 @@ static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
 	if (hdev->reset_type == HNAE3_VF_FUNC_RESET) {
 		hclgevf_build_send_msg(&send_msg, HCLGE_MBX_RESET, 0);
 		ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, NULL, 0);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to assert VF reset, ret = %d\n", ret);
+			return ret;
+		}
 		hdev->rst_stats.vf_func_rst_cnt++;
 	}
 
-- 
2.25.1



