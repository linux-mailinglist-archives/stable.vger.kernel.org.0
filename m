Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA753FDB4A
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344242AbhIAMko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344376AbhIAMiN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:38:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6072461156;
        Wed,  1 Sep 2021 12:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499679;
        bh=gg4mDgOjar1aB7r2/4i3EGT/Wz/5N4+MfJVdf2qk7xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twnO/KL9/577yzrnMTU5Z5K+07aar6fIrq9dNr5qRMVaHoodOzEQwuDcV689OiN0r
         6Kqp1ebuG8Mw1uPRJe646OqaHqxsgeSYcf4YUewymzUAh3wQpAgCloWeZ69J5zhFp7
         TEHbqgqmgB2oF0lxF6YV2sNrm/vb3IMrQpzOoRFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/103] net: hns3: add waiting time before cmdq memory is released
Date:   Wed,  1 Sep 2021 14:27:53 +0200
Message-Id: <20210901122302.030426430@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit a96d9330b02a3d051ae689bc2c5e7d3a2ba25594 ]

After the cmdq registers are cleared, the firmware may take time to
clear out possible left over commands in the cmdq. Driver must release
cmdq memory only after firmware has completed processing of left over
commands.

Fixes: 232d0d55fca6 ("net: hns3: uninitialize command queue while unloading PF driver")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c   | 6 +++++-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h   | 1 +
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 7 ++++++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h | 1 +
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index e6321dda0f3f..6f9f759ce0c0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -521,9 +521,13 @@ static void hclge_cmd_uninit_regs(struct hclge_hw *hw)
 
 void hclge_cmd_uninit(struct hclge_dev *hdev)
 {
+	set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
+	/* wait to ensure that the firmware completes the possible left
+	 * over commands.
+	 */
+	msleep(HCLGE_CMDQ_CLEAR_WAIT_TIME);
 	spin_lock_bh(&hdev->hw.cmq.csq.lock);
 	spin_lock(&hdev->hw.cmq.crq.lock);
-	set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
 	hclge_cmd_uninit_regs(&hdev->hw);
 	spin_unlock(&hdev->hw.cmq.crq.lock);
 	spin_unlock_bh(&hdev->hw.cmq.csq.lock);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index b38b48b9f0b1..3d70c3a47d63 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -9,6 +9,7 @@
 #include "hnae3.h"
 
 #define HCLGE_CMDQ_TX_TIMEOUT		30000
+#define HCLGE_CMDQ_CLEAR_WAIT_TIME	200
 #define HCLGE_DESC_DATA_LEN		6
 
 struct hclge_dev;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 66866c1cfb12..cae6db17cb19 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -472,12 +472,17 @@ static void hclgevf_cmd_uninit_regs(struct hclgevf_hw *hw)
 
 void hclgevf_cmd_uninit(struct hclgevf_dev *hdev)
 {
+	set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
+	/* wait to ensure that the firmware completes the possible left
+	 * over commands.
+	 */
+	msleep(HCLGEVF_CMDQ_CLEAR_WAIT_TIME);
 	spin_lock_bh(&hdev->hw.cmq.csq.lock);
 	spin_lock(&hdev->hw.cmq.crq.lock);
-	set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
 	hclgevf_cmd_uninit_regs(&hdev->hw);
 	spin_unlock(&hdev->hw.cmq.crq.lock);
 	spin_unlock_bh(&hdev->hw.cmq.csq.lock);
+
 	hclgevf_free_cmd_desc(&hdev->hw.cmq.csq);
 	hclgevf_free_cmd_desc(&hdev->hw.cmq.crq);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 9460c128c095..f90ff8a84b7e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -8,6 +8,7 @@
 #include "hnae3.h"
 
 #define HCLGEVF_CMDQ_TX_TIMEOUT		30000
+#define HCLGEVF_CMDQ_CLEAR_WAIT_TIME	200
 #define HCLGEVF_CMDQ_RX_INVLD_B		0
 #define HCLGEVF_CMDQ_RX_OUTVLD_B	1
 
-- 
2.30.2



