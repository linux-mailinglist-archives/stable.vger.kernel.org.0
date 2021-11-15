Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCB2451461
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349173AbhKOUEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:04:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344240AbhKOTYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F96F63651;
        Mon, 15 Nov 2021 18:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002460;
        bh=XoTfu593th2BWsnW7rzxzDyROXqDnwb2J51OrSt+NRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvNE2keWkb3yL7t4WBMapkZwQFmEoii2fYx8Pc+XHOhw6gPIweXVXtSQvucxF7VKx
         6pDXX6JXAiMR0X6+uZH0m5L+ewuTrCmfTkPCzNiYpcwzU6M0CBdDlgtTD20cdraqgJ
         b9CeEQhA0NOFu2OkdRb2cEX9aj12llQNthn0cIpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vaishnavi Bhat <vaish123@in.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 558/917] ibmvnic: delay complete()
Date:   Mon, 15 Nov 2021 18:00:53 +0100
Message-Id: <20211115165447.714972893@linuxfoundation.org>
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

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 6b278c0cb378079f3c0c61ae4a369c09ff1a4188 ]

If we get CRQ_INIT, we set errno to -EIO and first call complete() to
notify the waiter. Then we try to schedule a FAILOVER reset. If this
occurs while adapter is in PROBING state, ibmvnic_reset() changes the
error code to EAGAIN and returns without scheduling the FAILOVER. The
purpose of setting error code to EAGAIN is to ask the waiter to retry.

But due to the earlier complete() call, the waiter may already have seen
the -EIO response and decided not to retry. This can cause intermittent
failures when bringing up ibmvnic adapters during boot, specially in
in kexec/kdump kernels.

Defer the complete() call until after scheduling the reset.

Also streamline the error code to EAGAIN. Don't see why we need EIO
sometimes. All 3 callers of ibmvnic_reset_init() can handle EAGAIN.

Fixes: 17c8705838a5 ("ibmvnic: Return error code if init interrupted by transport event")
Reported-by: Vaishnavi Bhat <vaish123@in.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 84961a83803b7..352ffe982d849 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2565,7 +2565,7 @@ static int ibmvnic_reset(struct ibmvnic_adapter *adapter,
 
 	if (adapter->state == VNIC_PROBING) {
 		netdev_warn(netdev, "Adapter reset during probe\n");
-		adapter->init_done_rc = EAGAIN;
+		adapter->init_done_rc = -EAGAIN;
 		ret = EAGAIN;
 		goto err;
 	}
@@ -5067,11 +5067,6 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 			 */
 			adapter->login_pending = false;
 
-			if (!completion_done(&adapter->init_done)) {
-				complete(&adapter->init_done);
-				adapter->init_done_rc = -EIO;
-			}
-
 			if (adapter->state == VNIC_DOWN)
 				rc = ibmvnic_reset(adapter, VNIC_RESET_PASSIVE_INIT);
 			else
@@ -5092,6 +5087,13 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 					   rc);
 				adapter->failover_pending = false;
 			}
+
+			if (!completion_done(&adapter->init_done)) {
+				complete(&adapter->init_done);
+				if (!adapter->init_done_rc)
+					adapter->init_done_rc = -EAGAIN;
+			}
+
 			break;
 		case IBMVNIC_CRQ_INIT_COMPLETE:
 			dev_info(dev, "Partner initialization complete\n");
@@ -5559,7 +5561,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 		}
 
 		rc = ibmvnic_reset_init(adapter, false);
-	} while (rc == EAGAIN);
+	} while (rc == -EAGAIN);
 
 	/* We are ignoring the error from ibmvnic_reset_init() assuming that the
 	 * partner is not ready. CRQ is not active. When the partner becomes
-- 
2.33.0



