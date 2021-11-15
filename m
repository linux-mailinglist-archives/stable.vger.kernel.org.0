Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40318450F1C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbhKOS0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:26:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241233AbhKOSYu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:24:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74B5261B4C;
        Mon, 15 Nov 2021 17:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998869;
        bh=GXA+G534SxnJyiNiV3J7vfAc30628SlhCP5S2O8fmnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifsnpsMtCFytnKTodsX9xy1J5C4w3Eu45m7fROf5q+1DQlvaqzWVbsg2TQ25CGPu/
         1kHQvWwJYSl05YvhSick6yOefafgckCgqKC1HEUIHOl6E65JXuM8ox0mPHK+2h4CgC
         DNk+C84yQH2ZOkebVI0lZBghJujsb9klpF+RgfY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 091/849] net: hns3: ignore reset event before initialization process is done
Date:   Mon, 15 Nov 2021 17:52:54 +0100
Message-Id: <20211115165423.166717511@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit 0251d196b0e1a19c870be882e5d4f496de8ab758 ]

Currently, if there is a reset event triggered by RAS during device in
initialization process, driver may run reset process concurrently with
initialization process. In this case, it may cause problem. For example,
the RSS indirection table may has not been alloc memory in initialization
process yet, but it is used in reset process, it will cause a call trace
like this:

[61228.744836] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
...
[61228.897677] Workqueue: hclgevf hclgevf_service_task [hclgevf]
[61228.911390] pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=--)
[61228.918670] pc : hclgevf_set_rss_indir_table+0xb4/0x190 [hclgevf]
[61228.927812] lr : hclgevf_set_rss_indir_table+0x90/0x190 [hclgevf]
[61228.937248] sp : ffff8000162ebb50
[61228.941087] x29: ffff8000162ebb50 x28: ffffb77add72dbc0 x27: ffff0820c7dc8080
[61228.949516] x26: 0000000000000000 x25: ffff0820ad4fc880 x24: ffff0820c7dc8080
[61228.958220] x23: ffff0820c7dc8090 x22: 00000000ffffffff x21: 0000000000000040
[61228.966360] x20: ffffb77add72b9c0 x19: 0000000000000000 x18: 0000000000000030
[61228.974646] x17: 0000000000000000 x16: ffffb77ae713feb0 x15: ffff0820ad4fcce8
[61228.982808] x14: ffffffffffffffff x13: ffff8000962eb7f7 x12: 00003834ec70c960
[61228.991990] x11: 00e0fafa8c206982 x10: 9670facc78a8f9a8 x9 : ffffb77add717530
[61229.001123] x8 : ffff0820ad4fd6b8 x7 : 0000000000000000 x6 : 0000000000000011
[61229.010249] x5 : 00000000000cb1b0 x4 : 0000000000002adb x3 : 0000000000000049
[61229.018662] x2 : ffff8000162ebbb8 x1 : 0000000000000000 x0 : 0000000000000480
[61229.027002] Call trace:
[61229.030177]  hclgevf_set_rss_indir_table+0xb4/0x190 [hclgevf]
[61229.039009]  hclgevf_rss_init_hw+0x128/0x1b4 [hclgevf]
[61229.046809]  hclgevf_reset_rebuild+0x17c/0x69c [hclgevf]
[61229.053862]  hclgevf_reset_service_task+0x4cc/0xa80 [hclgevf]
[61229.061306]  hclgevf_service_task+0x6c/0x630 [hclgevf]
[61229.068491]  process_one_work+0x1dc/0x48c
[61229.074121]  worker_thread+0x15c/0x464
[61229.078562]  kthread+0x168/0x16c
[61229.082873]  ret_from_fork+0x10/0x18
[61229.088221] Code: 7900e7f6 f904a683 d503201f 9101a3e2 (38616b43)
[61229.095357] ---[ end trace 153661a538f6768c ]---

To fix this problem, don't schedule reset task before initialization
process is done.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index dc748f2f18434..b1397d9f9a62e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2852,6 +2852,7 @@ static void hclge_mbx_task_schedule(struct hclge_dev *hdev)
 static void hclge_reset_task_schedule(struct hclge_dev *hdev)
 {
 	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
+	    test_bit(HCLGE_STATE_SERVICE_INITED, &hdev->state) &&
 	    !test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
 		mod_delayed_work(hclge_wq, &hdev->service_task, 0);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index a1713a1ce6839..9d36620f9c035 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2230,6 +2230,7 @@ static void hclgevf_get_misc_vector(struct hclgevf_dev *hdev)
 void hclgevf_reset_task_schedule(struct hclgevf_dev *hdev)
 {
 	if (!test_bit(HCLGEVF_STATE_REMOVING, &hdev->state) &&
+	    test_bit(HCLGEVF_STATE_SERVICE_INITED, &hdev->state) &&
 	    !test_and_set_bit(HCLGEVF_STATE_RST_SERVICE_SCHED,
 			      &hdev->state))
 		mod_delayed_work(hclgevf_wq, &hdev->service_task, 0);
@@ -3443,6 +3444,8 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 
 	hclgevf_init_rxd_adv_layout(hdev);
 
+	set_bit(HCLGEVF_STATE_SERVICE_INITED, &hdev->state);
+
 	hdev->last_reset_time = jiffies;
 	dev_info(&hdev->pdev->dev, "finished initializing %s driver\n",
 		 HCLGEVF_DRIVER_NAME);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index e8013be055f89..19f1494e356ab 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -144,6 +144,7 @@ enum hclgevf_states {
 	HCLGEVF_STATE_REMOVING,
 	HCLGEVF_STATE_NIC_REGISTERED,
 	HCLGEVF_STATE_ROCE_REGISTERED,
+	HCLGEVF_STATE_SERVICE_INITED,
 	/* task states */
 	HCLGEVF_STATE_RST_SERVICE_SCHED,
 	HCLGEVF_STATE_RST_HANDLING,
-- 
2.33.0



