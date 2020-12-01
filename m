Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70ACB2C9C11
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390351AbgLAJOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:14:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390343AbgLAJOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:14:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60E2720770;
        Tue,  1 Dec 2020 09:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606814043;
        bh=rTTl8HkZ1DrIXRLG0LSKAhE+I9MpqlkH5GZL4IyovdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPoiWutE8vug4z7Y7pgQrunD9btsaN3aLszYAMfzSsrSZNYH1YM34vjvuzDdgm7b6
         RQhxjYNCNcQiXMMhkFu7oIyMju70V8p4Sdx5KLD+U/zKJuvl0gnv+GjsmIzbjKBtVj
         +O03oKgbKDyUxy/ku8vDwwlzcOMHpZDC2GFHLXrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 116/152] ibmvnic: enhance resetting status check during module exit
Date:   Tue,  1 Dec 2020 09:53:51 +0100
Message-Id: <20201201084727.016111098@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit 3ada288150fb17ab3fcce2cf5fce20461f86b2ee ]

Based on the discussion with Sukadev Bhattiprolu and Dany Madden,
we believe that checking adapter->resetting bit is preferred
since RESETTING state flag is not as strict as resetting bit.
RESETTING state flag is removed since it is verbose now.

Fixes: 7d7195a026ba ("ibmvnic: Do not process device remove during device reset")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 +--
 drivers/net/ethernet/ibm/ibmvnic.h | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index af8c10e629f88..81ec233926acb 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2228,7 +2228,6 @@ static void __ibmvnic_reset(struct work_struct *work)
 
 		if (!saved_state) {
 			reset_state = adapter->state;
-			adapter->state = VNIC_RESETTING;
 			saved_state = true;
 		}
 		spin_unlock_irqrestore(&adapter->state_lock, flags);
@@ -5261,7 +5260,7 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->state_lock, flags);
-	if (adapter->state == VNIC_RESETTING) {
+	if (test_bit(0, &adapter->resetting)) {
 		spin_unlock_irqrestore(&adapter->state_lock, flags);
 		return -EBUSY;
 	}
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 43feb96b0a68a..31d604fc7bde7 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -941,8 +941,7 @@ enum vnic_state {VNIC_PROBING = 1,
 		 VNIC_CLOSING,
 		 VNIC_CLOSED,
 		 VNIC_REMOVING,
-		 VNIC_REMOVED,
-		 VNIC_RESETTING};
+		 VNIC_REMOVED};
 
 enum ibmvnic_reset_reason {VNIC_RESET_FAILOVER = 1,
 			   VNIC_RESET_MOBILITY,
-- 
2.27.0



