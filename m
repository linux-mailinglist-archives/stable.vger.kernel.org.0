Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047C02D9FF4
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502649AbgLNTHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 14:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408584AbgLNRhL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:11 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 019/105] ibmvnic: track pending login
Date:   Mon, 14 Dec 2020 18:27:53 +0100
Message-Id: <20201214172556.196755366@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 76cdc5c5d99ce4856ad0ac38facc33b52fa64f77 ]

If after ibmvnic sends a LOGIN it gets a FAILOVER, it is possible that
the worker thread will start reset process and free the login response
buffer before it gets a (now stale) LOGIN_RSP. The ibmvnic tasklet will
then try to access the login response buffer and crash.

Have ibmvnic track pending logins and discard any stale login responses.

Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 17 +++++++++++++++++
 drivers/net/ethernet/ibm/ibmvnic.h |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 006670f318bf1..9aa63b8b44368 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3843,6 +3843,8 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	crq.login.cmd = LOGIN;
 	crq.login.ioba = cpu_to_be32(buffer_token);
 	crq.login.len = cpu_to_be32(buffer_size);
+
+	adapter->login_pending = true;
 	ibmvnic_send_crq(adapter, &crq);
 
 	return 0;
@@ -4374,6 +4376,15 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 	struct ibmvnic_login_buffer *login = adapter->login_buf;
 	int i;
 
+	/* CHECK: Test/set of login_pending does not need to be atomic
+	 * because only ibmvnic_tasklet tests/clears this.
+	 */
+	if (!adapter->login_pending) {
+		netdev_warn(netdev, "Ignoring unexpected login response\n");
+		return 0;
+	}
+	adapter->login_pending = false;
+
 	dma_unmap_single(dev, adapter->login_buf_token, adapter->login_buf_sz,
 			 DMA_TO_DEVICE);
 	dma_unmap_single(dev, adapter->login_rsp_buf_token,
@@ -4721,6 +4732,11 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 		case IBMVNIC_CRQ_INIT:
 			dev_info(dev, "Partner initialized\n");
 			adapter->from_passive_init = true;
+			/* Discard any stale login responses from prev reset.
+			 * CHECK: should we clear even on INIT_COMPLETE?
+			 */
+			adapter->login_pending = false;
+
 			if (!completion_done(&adapter->init_done)) {
 				complete(&adapter->init_done);
 				adapter->init_done_rc = -EIO;
@@ -5188,6 +5204,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	dev_set_drvdata(&dev->dev, netdev);
 	adapter->vdev = dev;
 	adapter->netdev = netdev;
+	adapter->login_pending = false;
 
 	ether_addr_copy(adapter->mac_addr, mac_addr_p);
 	ether_addr_copy(netdev->dev_addr, adapter->mac_addr);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 31d604fc7bde7..77f43cbdb6dc4 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -1084,6 +1084,7 @@ struct ibmvnic_adapter {
 	struct delayed_work ibmvnic_delayed_reset;
 	unsigned long resetting;
 	bool napi_enabled, from_passive_init;
+	bool login_pending;
 
 	bool failover_pending;
 	bool force_reset_recovery;
-- 
2.27.0



