Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4D2440D0
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388746AbfFMQJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731262AbfFMIo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:44:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EEF42173C;
        Thu, 13 Jun 2019 08:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415466;
        bh=S5A7UTeQWhWBtP5fYLh/wg3KEQnbgwNH5S8HaOS8f1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SocppfwY08nWCb0Rm+nR7PtrIxCw9SHT4YUxIkLB1GTqBn/bHKzdlYB/AmemaIBGQ
         HjwRfRfgvAPr27WLS2rzvPM4GB9WNMuju7kIaJHnqPSm2tHJf8ZaM9Q2MF+oSJdGIu
         bYK76tvZuAmMuKXjuiRUEn5wNBAV36gl54nqkIlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 004/155] rapidio: fix a NULL pointer dereference when create_workqueue() fails
Date:   Thu, 13 Jun 2019 10:31:56 +0200
Message-Id: <20190613075652.964720344@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 23015b22e47c5409620b1726a677d69e5cd032ba ]

In case create_workqueue fails, the fix releases resources and returns
-ENOMEM to avoid NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Acked-by: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/rio_cm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/rapidio/rio_cm.c b/drivers/rapidio/rio_cm.c
index cf45829585cb..b29fc258eeba 100644
--- a/drivers/rapidio/rio_cm.c
+++ b/drivers/rapidio/rio_cm.c
@@ -2147,6 +2147,14 @@ static int riocm_add_mport(struct device *dev,
 	mutex_init(&cm->rx_lock);
 	riocm_rx_fill(cm, RIOCM_RX_RING_SIZE);
 	cm->rx_wq = create_workqueue(DRV_NAME "/rxq");
+	if (!cm->rx_wq) {
+		riocm_error("failed to allocate IBMBOX_%d on %s",
+			    cmbox, mport->name);
+		rio_release_outb_mbox(mport, cmbox);
+		kfree(cm);
+		return -ENOMEM;
+	}
+
 	INIT_WORK(&cm->rx_work, rio_ibmsg_handler);
 
 	cm->tx_slot = 0;
-- 
2.20.1



