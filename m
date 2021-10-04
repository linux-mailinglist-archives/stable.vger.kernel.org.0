Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F547420EB6
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbhJDN1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:27:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236974AbhJDNZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:25:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FB5F61B00;
        Mon,  4 Oct 2021 13:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353083;
        bh=yuqo054ZUEgcZ4czkQOXmi4eJq2jz1HMI8CjAhDrs5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMUUFYRKp7nlOtdAsh4aB+OmyrCyHEZtKqwfA7TVZ+iO4uBrEVquvKM1kBmEqiBd1
         v/f76ljC/y2CtdsFuCzFPbjN6xd7ZxIYCS/AoxdJcGDrIfF9Y+/1+QfFwk3Yw94RXw
         nvupKTDzlIFgDAflUnZ1VP6JMUXeXEClSOBCYVmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 56/93] net: hns3: do not allow call hns3_nic_net_open repeatedly
Date:   Mon,  4 Oct 2021 14:52:54 +0200
Message-Id: <20211004125036.422158837@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 5b09e88e1bf7fe86540fab4b5f3eece8abead39e ]

hns3_nic_net_open() is not allowed to called repeatly, but there
is no checking for this. When doing device reset and setup tc
concurrently, there is a small oppotunity to call hns3_nic_net_open
repeatedly, and cause kernel bug by calling napi_enable twice.

The calltrace information is like below:
[ 3078.222780] ------------[ cut here ]------------
[ 3078.230255] kernel BUG at net/core/dev.c:6991!
[ 3078.236224] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[ 3078.243431] Modules linked in: hns3 hclgevf hclge hnae3 vfio_iommu_type1 vfio_pci vfio_virqfd vfio pv680_mii(O)
[ 3078.258880] CPU: 0 PID: 295 Comm: kworker/u8:5 Tainted: G           O      5.14.0-rc4+ #1
[ 3078.269102] Hardware name:  , BIOS KpxxxFPGA 1P B600 V181 08/12/2021
[ 3078.276801] Workqueue: hclge hclge_service_task [hclge]
[ 3078.288774] pstate: 60400009 (nZCv daif +PAN -UAO -TCO BTYPE=--)
[ 3078.296168] pc : napi_enable+0x80/0x84
tc qdisc sho[w  3d0e7v8 .e3t0h218 79] lr : hns3_nic_net_open+0x138/0x510 [hns3]

[ 3078.314771] sp : ffff8000108abb20
[ 3078.319099] x29: ffff8000108abb20 x28: 0000000000000000 x27: ffff0820a8490300
[ 3078.329121] x26: 0000000000000001 x25: ffff08209cfc6200 x24: 0000000000000000
[ 3078.339044] x23: ffff0820a8490300 x22: ffff08209cd76000 x21: ffff0820abfe3880
[ 3078.349018] x20: 0000000000000000 x19: ffff08209cd76900 x18: 0000000000000000
[ 3078.358620] x17: 0000000000000000 x16: ffffc816e1727a50 x15: 0000ffff8f4ff930
[ 3078.368895] x14: 0000000000000000 x13: 0000000000000000 x12: 0000259e9dbeb6b4
[ 3078.377987] x11: 0096a8f7e764eb40 x10: 634615ad28d3eab5 x9 : ffffc816ad8885b8
[ 3078.387091] x8 : ffff08209cfc6fb8 x7 : ffff0820ac0da058 x6 : ffff0820a8490344
[ 3078.396356] x5 : 0000000000000140 x4 : 0000000000000003 x3 : ffff08209cd76938
[ 3078.405365] x2 : 0000000000000000 x1 : 0000000000000010 x0 : ffff0820abfe38a0
[ 3078.414657] Call trace:
[ 3078.418517]  napi_enable+0x80/0x84
[ 3078.424626]  hns3_reset_notify_up_enet+0x78/0xd0 [hns3]
[ 3078.433469]  hns3_reset_notify+0x64/0x80 [hns3]
[ 3078.441430]  hclge_notify_client+0x68/0xb0 [hclge]
[ 3078.450511]  hclge_reset_rebuild+0x524/0x884 [hclge]
[ 3078.458879]  hclge_reset_service_task+0x3c4/0x680 [hclge]
[ 3078.467470]  hclge_service_task+0xb0/0xb54 [hclge]
[ 3078.475675]  process_one_work+0x1dc/0x48c
[ 3078.481888]  worker_thread+0x15c/0x464
[ 3078.487104]  kthread+0x160/0x170
[ 3078.492479]  ret_from_fork+0x10/0x18
[ 3078.498785] Code: c8027c81 35ffffa2 d50323bf d65f03c0 (d4210000)
[ 3078.506889] ---[ end trace 8ebe0340a1b0fb44 ]---

Once hns3_nic_net_open() is excute success, the flag
HNS3_NIC_STATE_DOWN will be cleared. So add checking for this
flag, directly return when HNS3_NIC_STATE_DOWN is no set.

Fixes: e888402789b9 ("net: hns3: call hns3_nic_net_open() while doing HNAE3_UP_CLIENT")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 936b9cfe1a62..4777db2623cf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -444,6 +444,11 @@ static int hns3_nic_net_open(struct net_device *netdev)
 	if (hns3_nic_resetting(netdev))
 		return -EBUSY;
 
+	if (!test_bit(HNS3_NIC_STATE_DOWN, &priv->state)) {
+		netdev_warn(netdev, "net open repeatedly!\n");
+		return 0;
+	}
+
 	netif_carrier_off(netdev);
 
 	ret = hns3_nic_set_real_num_queue(netdev);
-- 
2.33.0



