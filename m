Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE8C1ACBBA
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442723AbgDPPt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895827AbgDPNc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:32:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE26A22265;
        Thu, 16 Apr 2020 13:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043937;
        bh=uCDUcXmEwX5SSUfpabvQs8S1gdekkxZT6ihr0BNLMug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbwN4lPYik2cYIi48nOFEV0fDwBukL97loyHFXKy52zLjxWnk3qfY6t8WPjWzAFPt
         Y+6HRt7hzNkA8Y2BFxujHwmBRJyMn+d5wSISYztW+wxm0Sdjuff/Fi5+pqqpKdUTmh
         javoJGA+N0g/gmsk4RQH+YUOe3k4ajpMUnqrFoC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo bin <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 015/257] hinic: fix a bug of waitting for IO stopped
Date:   Thu, 16 Apr 2020 15:21:06 +0200
Message-Id: <20200416131327.770507452@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo bin <luobin9@huawei.com>

[ Upstream commit 96758117dc528e6d84bd23d205e8cf7f31eda029 ]

it's unreliable for fw to check whether IO is stopped, so driver
wait for enough time to ensure IO process is done in hw before
freeing resources

Signed-off-by: Luo bin <luobin9@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  | 51 +------------------
 1 file changed, 2 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 79b3d53f2fbfa..c7c75b772a866 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -360,50 +360,6 @@ static int wait_for_db_state(struct hinic_hwdev *hwdev)
 	return -EFAULT;
 }
 
-static int wait_for_io_stopped(struct hinic_hwdev *hwdev)
-{
-	struct hinic_cmd_io_status cmd_io_status;
-	struct hinic_hwif *hwif = hwdev->hwif;
-	struct pci_dev *pdev = hwif->pdev;
-	struct hinic_pfhwdev *pfhwdev;
-	unsigned long end;
-	u16 out_size;
-	int err;
-
-	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif)) {
-		dev_err(&pdev->dev, "Unsupported PCI Function type\n");
-		return -EINVAL;
-	}
-
-	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
-
-	cmd_io_status.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
-
-	end = jiffies + msecs_to_jiffies(IO_STATUS_TIMEOUT);
-	do {
-		err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
-					HINIC_COMM_CMD_IO_STATUS_GET,
-					&cmd_io_status, sizeof(cmd_io_status),
-					&cmd_io_status, &out_size,
-					HINIC_MGMT_MSG_SYNC);
-		if ((err) || (out_size != sizeof(cmd_io_status))) {
-			dev_err(&pdev->dev, "Failed to get IO status, ret = %d\n",
-				err);
-			return err;
-		}
-
-		if (cmd_io_status.status == IO_STOPPED) {
-			dev_info(&pdev->dev, "IO stopped\n");
-			return 0;
-		}
-
-		msleep(20);
-	} while (time_before(jiffies, end));
-
-	dev_err(&pdev->dev, "Wait for IO stopped - Timeout\n");
-	return -ETIMEDOUT;
-}
-
 /**
  * clear_io_resource - set the IO resources as not active in the NIC
  * @hwdev: the NIC HW device
@@ -423,11 +379,8 @@ static int clear_io_resources(struct hinic_hwdev *hwdev)
 		return -EINVAL;
 	}
 
-	err = wait_for_io_stopped(hwdev);
-	if (err) {
-		dev_err(&pdev->dev, "IO has not stopped yet\n");
-		return err;
-	}
+	/* sleep 100ms to wait for firmware stopping I/O */
+	msleep(100);
 
 	cmd_clear_io_res.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
 
-- 
2.20.1



