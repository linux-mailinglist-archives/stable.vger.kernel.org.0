Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAE2010BCDD
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731972AbfK0VC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:02:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731201AbfK0VC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:02:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8EB921789;
        Wed, 27 Nov 2019 21:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888577;
        bh=lFZ2Su7NDncLo585KI/7HcUFWThnKbksZPXbbog348E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3z6/sPFwFknQEWH27pSsMLNg6yXd6UJTTWRQAR2YV2IOMt07kdIQyYaiathuAg6E
         jwE4oML8sz/IAK4QGBRjV1uukIFjC9q88lq+HSdLrzk0kEi068JQvSW6kq8d/tQkYi
         FQ2qc5X29dUrcdV2S5NkshJrHF9nyq862tXFVh7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 186/306] net: hns3: bugfix for reporting unknown vector0 interrupt repeatly problem
Date:   Wed, 27 Nov 2019 21:30:36 +0100
Message-Id: <20191127203128.863824979@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit 0d4411408a7fb9aad0645f23911d9bfdd2ce3177 ]

The current driver supports handling two vector0 interrupts, reset and
mailbox. When the hardware reports an interrupt of another type of
interrupt source, if the driver does not process the interrupt, but
enables the interrupt, the hardware will repeatedly report the unknown
interrupt.

Therefore, the driver enables the vector0 interrupt after clearing the
known type of interrupt source. Other conditions are not enabled.

Fixes: cd8c5c269b1d ("net: hns3: Fix for hclge_reset running repeatly problem")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index b04df79f393f8..f8cc8d1f0b209 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2574,7 +2574,7 @@ static irqreturn_t hclge_misc_irq_handle(int irq, void *data)
 	}
 
 	/* clear the source of interrupt if it is not cause by reset */
-	if (event_cause != HCLGE_VECTOR0_EVENT_RST) {
+	if (event_cause == HCLGE_VECTOR0_EVENT_MBX) {
 		hclge_clear_event_cause(hdev, event_cause, clearval);
 		hclge_enable_vector(&hdev->misc_vector, true);
 	}
-- 
2.20.1



