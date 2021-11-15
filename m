Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4303D451EBF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355279AbhKPAhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:47888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344891AbhKOTZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 109F3636E4;
        Mon, 15 Nov 2021 19:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003172;
        bh=hrmQyVoN56FYms+DoXsQSCLBLvU9kwLcw3hriJgLS8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pwUbN71KQEdCbfiSRBEyseOV87DDF+Kpp4cwZxn6oH1Tt2n6+YPcdHBEq3WrJIFQq
         F3LFcMVf+3gS3FPkGggYj+25PSkuY6HAIMCorfdFdVLoXTrOjG7jdqve812LnSPx3t
         V+XHC1H+puNBwqAKtwIMeenquaN4ef5jV5+pWcM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 836/917] net: hns3: fix kernel crash when unload VF while it is being reset
Date:   Mon, 15 Nov 2021 18:05:31 +0100
Message-Id: <20211115165457.391196334@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

[ Upstream commit e140c7983e3054be0652bf914f4454f16c5520b0 ]

When fully configure VLANs for a VF, then unload the VF while
triggering a reset to PF, will cause a kernel crash because the
irq is already uninit.

[ 293.177579] ------------[ cut here ]------------
[ 293.183502] kernel BUG at drivers/pci/msi.c:352!
[ 293.189547] Internal error: Oops - BUG: 0 [#1] SMP
......
[ 293.390124] Workqueue: hclgevf hclgevf_service_task [hclgevf]
[ 293.402627] pstate: 80c00009 (Nzcv daif +PAN +UAO)
[ 293.414324] pc : free_msi_irqs+0x19c/0x1b8
[ 293.425429] lr : free_msi_irqs+0x18c/0x1b8
[ 293.436545] sp : ffff00002716fbb0
[ 293.446950] x29: ffff00002716fbb0 x28: 0000000000000000
[ 293.459519] x27: 0000000000000000 x26: ffff45b91ea16b00
[ 293.472183] x25: 0000000000000000 x24: ffffa587b08f4700
[ 293.484717] x23: ffffc591ac30e000 x22: ffffa587b08f8428
[ 293.497190] x21: ffffc591ac30e300 x20: 0000000000000000
[ 293.509594] x19: ffffa58a062a8300 x18: 0000000000000000
[ 293.521949] x17: 0000000000000000 x16: ffff45b91dcc3f48
[ 293.534013] x15: 0000000000000000 x14: 0000000000000000
[ 293.545883] x13: 0000000000000040 x12: 0000000000000228
[ 293.557508] x11: 0000000000000020 x10: 0000000000000040
[ 293.568889] x9 : ffff45b91ea1e190 x8 : ffffc591802d0000
[ 293.580123] x7 : ffffc591802d0148 x6 : 0000000000000120
[ 293.591190] x5 : ffffc591802d0000 x4 : 0000000000000000
[ 293.602015] x3 : 0000000000000000 x2 : 0000000000000000
[ 293.612624] x1 : 00000000000004a4 x0 : ffffa58a1e0c6b80
[ 293.623028] Call trace:
[ 293.630340] free_msi_irqs+0x19c/0x1b8
[ 293.638849] pci_disable_msix+0x118/0x140
[ 293.647452] pci_free_irq_vectors+0x20/0x38
[ 293.656081] hclgevf_uninit_msi+0x44/0x58 [hclgevf]
[ 293.665309] hclgevf_reset_rebuild+0x1ac/0x2e0 [hclgevf]
[ 293.674866] hclgevf_reset+0x358/0x400 [hclgevf]
[ 293.683545] hclgevf_reset_service_task+0xd0/0x1b0 [hclgevf]
[ 293.693325] hclgevf_service_task+0x4c/0x2e8 [hclgevf]
[ 293.702307] process_one_work+0x1b0/0x448
[ 293.710034] worker_thread+0x54/0x468
[ 293.717331] kthread+0x134/0x138
[ 293.724114] ret_from_fork+0x10/0x18
[ 293.731324] Code: f940b000 b4ffff00 a903e7b8 f90017b6 (d4210000)

This patch fixes the problem by waiting for the VF reset done
while unloading the VF.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 5 +++++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 4cf34f1693544..3b8bde58613a8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3010,7 +3010,10 @@ static void hclgevf_uninit_client_instance(struct hnae3_client *client,
 
 	/* un-init roce, if it exists */
 	if (hdev->roce_client) {
+		while (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state))
+			msleep(HCLGEVF_WAIT_RESET_DONE);
 		clear_bit(HCLGEVF_STATE_ROCE_REGISTERED, &hdev->state);
+
 		hdev->roce_client->ops->uninit_instance(&hdev->roce, 0);
 		hdev->roce_client = NULL;
 		hdev->roce.client = NULL;
@@ -3019,6 +3022,8 @@ static void hclgevf_uninit_client_instance(struct hnae3_client *client,
 	/* un-init nic/unic, if this was not called by roce client */
 	if (client->ops->uninit_instance && hdev->nic_client &&
 	    client->type != HNAE3_CLIENT_ROCE) {
+		while (test_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state))
+			msleep(HCLGEVF_WAIT_RESET_DONE);
 		clear_bit(HCLGEVF_STATE_NIC_REGISTERED, &hdev->state);
 
 		client->ops->uninit_instance(&hdev->nic, 0);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index 4bd922b475012..f6f736c0091c0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -109,6 +109,8 @@
 #define HCLGEVF_VF_RST_ING		0x07008
 #define HCLGEVF_VF_RST_ING_BIT		BIT(16)
 
+#define HCLGEVF_WAIT_RESET_DONE		100
+
 #define HCLGEVF_RSS_IND_TBL_SIZE		512
 #define HCLGEVF_RSS_SET_BITMAP_MSK	0xffff
 #define HCLGEVF_RSS_KEY_SIZE		40
-- 
2.33.0



