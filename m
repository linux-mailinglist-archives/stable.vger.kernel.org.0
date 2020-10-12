Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF7528B7D5
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389796AbgJLNp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389772AbgJLNpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D31A0206D9;
        Mon, 12 Oct 2020 13:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510350;
        bh=pMj6tjjf7JsBox8KDM4aZ3vwjIC6cGH3EiCVzdXPpz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n95BESjT5/mPIC7HOYeKNaG/hu2kP0kMXoTiOppSK6yRE57PvouzP/Wi8PJZWxOxG
         OU9M9x/rRlDypPwwV8CuIThsRR0nGQhdHKMaoIWKIyvtt30Wm3vSsKgaAf4jT+kCLF
         utAWuE6ZfmuG/daNf+RxNP9N5x/kyVAjJcG3GauI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo bin <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 062/124] hinic: fix wrong return value of mac-set cmd
Date:   Mon, 12 Oct 2020 15:31:06 +0200
Message-Id: <20201012133149.862322359@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo bin <luobin9@huawei.com>

[ Upstream commit f68910a8056f9451ee9fe7e1b962f7d90d326ad3 ]

It should also be regarded as an error when hw return status=4 for PF's
setting mac cmd. Only if PF return status=4 to VF should this cmd be
taken special treatment.

Fixes: 7dd29ee12865 ("hinic: add sriov feature support")
Signed-off-by: Luo bin <luobin9@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_port.c  |  6 +++---
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c | 12 ++----------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 82d5c50630e64..2be7c254cca90 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -58,9 +58,9 @@ static int change_mac(struct hinic_dev *nic_dev, const u8 *addr,
 				 sizeof(port_mac_cmd),
 				 &port_mac_cmd, &out_size);
 	if (err || out_size != sizeof(port_mac_cmd) ||
-	    (port_mac_cmd.status  &&
-	    port_mac_cmd.status != HINIC_PF_SET_VF_ALREADY &&
-	    port_mac_cmd.status != HINIC_MGMT_STATUS_EXIST)) {
+	    (port_mac_cmd.status &&
+	     (port_mac_cmd.status != HINIC_PF_SET_VF_ALREADY || !HINIC_IS_VF(hwif)) &&
+	     port_mac_cmd.status != HINIC_MGMT_STATUS_EXIST)) {
 		dev_err(&pdev->dev, "Failed to change MAC, err: %d, status: 0x%x, out size: 0x%x\n",
 			err, port_mac_cmd.status, out_size);
 		return -EFAULT;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index 1043389754df0..b757f7057b8fe 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -38,8 +38,7 @@ static int hinic_set_mac(struct hinic_hwdev *hwdev, const u8 *mac_addr,
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_MAC, &mac_info,
 				 sizeof(mac_info), &mac_info, &out_size);
 	if (err || out_size != sizeof(mac_info) ||
-	    (mac_info.status && mac_info.status != HINIC_PF_SET_VF_ALREADY &&
-	    mac_info.status != HINIC_MGMT_STATUS_EXIST)) {
+	    (mac_info.status && mac_info.status != HINIC_MGMT_STATUS_EXIST)) {
 		dev_err(&hwdev->func_to_io.hwif->pdev->dev, "Failed to set MAC, err: %d, status: 0x%x, out size: 0x%x\n",
 			err, mac_info.status, out_size);
 		return -EIO;
@@ -452,8 +451,7 @@ struct hinic_sriov_info *hinic_get_sriov_info_by_pcidev(struct pci_dev *pdev)
 
 static int hinic_check_mac_info(u8 status, u16 vlan_id)
 {
-	if ((status && status != HINIC_MGMT_STATUS_EXIST &&
-	     status != HINIC_PF_SET_VF_ALREADY) ||
+	if ((status && status != HINIC_MGMT_STATUS_EXIST) ||
 	    (vlan_id & CHECK_IPSU_15BIT &&
 	     status == HINIC_MGMT_STATUS_EXIST))
 		return -EINVAL;
@@ -495,12 +493,6 @@ static int hinic_update_mac(struct hinic_hwdev *hwdev, u8 *old_mac,
 		return -EINVAL;
 	}
 
-	if (mac_info.status == HINIC_PF_SET_VF_ALREADY) {
-		dev_warn(&hwdev->hwif->pdev->dev,
-			 "PF has already set VF MAC. Ignore update operation\n");
-		return HINIC_PF_SET_VF_ALREADY;
-	}
-
 	if (mac_info.status == HINIC_MGMT_STATUS_EXIST)
 		dev_warn(&hwdev->hwif->pdev->dev, "MAC is repeated. Ignore update operation\n");
 
-- 
2.25.1



