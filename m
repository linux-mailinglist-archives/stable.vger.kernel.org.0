Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 714A99DF8A
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730285AbfH0HzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729387AbfH0HzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:55:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFF6020828;
        Tue, 27 Aug 2019 07:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892515;
        bh=HDYpMpXygh6DzBAFUso9mRhj6FU64mGHz38ZIkfZbwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFVZO8zAh62K1DzRehzv1Gh0OtKt3i+QsIN1viyxMpThQ7BLAxi5SIs3k7GbQr2Yu
         tFyMF6qmZ4Bq7DSTYKyKZN3xojckcg/veOGwS5l5bk4cgq4Punq7gKLPK/Kpx4ov9H
         bMw3VIbjvDQc1Sy5wNX8zGLMyCVggMZX/I2NTtgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/98] qed: RDMA - Fix the hw_ver returned in device attributes
Date:   Tue, 27 Aug 2019 09:49:59 +0200
Message-Id: <20190827072719.349691597@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 81af04b432fdfabcdbd2c06be2ee647e3ca41a22 ]

The hw_ver field was initialized to zero. Return the chip revision.
This is relevant for rdma driver.

Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 13802b825d65a..909422d939033 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -442,7 +442,7 @@ static void qed_rdma_init_devinfo(struct qed_hwfn *p_hwfn,
 	/* Vendor specific information */
 	dev->vendor_id = cdev->vendor_id;
 	dev->vendor_part_id = cdev->device_id;
-	dev->hw_ver = 0;
+	dev->hw_ver = cdev->chip_rev;
 	dev->fw_ver = (FW_MAJOR_VERSION << 24) | (FW_MINOR_VERSION << 16) |
 		      (FW_REVISION_VERSION << 8) | (FW_ENGINEERING_VERSION);
 
-- 
2.20.1



