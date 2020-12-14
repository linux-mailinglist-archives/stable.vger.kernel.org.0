Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CD52D9FC9
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 20:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408609AbgLNS7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:59:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502193AbgLNRh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:37:29 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 020/105] ibmvnic: send_login should check for crq errors
Date:   Mon, 14 Dec 2020 18:27:54 +0100
Message-Id: <20201214172556.244669301@linuxfoundation.org>
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

From: Dany Madden <drt@linux.ibm.com>

[ Upstream commit c98d9cc4170da7e16a1012563d0f9fbe1c7cfe27 ]

send_login() does not check for the result of ibmvnic_send_crq() of the
login request. This results in the driver needlessly retrying the login
10 times even when CRQ is no longer active. Check the return code and
give up in case of errors in sending the CRQ.

The only time we want to retry is if we get a PARITALSUCCESS response
from the partner.

Fixes: 032c5e82847a2 ("Driver for IBM System i/p VNIC protocol")
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 9aa63b8b44368..de25d1860f16f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -862,10 +862,8 @@ static int ibmvnic_login(struct net_device *netdev)
 		adapter->init_done_rc = 0;
 		reinit_completion(&adapter->init_done);
 		rc = send_login(adapter);
-		if (rc) {
-			netdev_warn(netdev, "Unable to login\n");
+		if (rc)
 			return rc;
-		}
 
 		if (!wait_for_completion_timeout(&adapter->init_done,
 						 timeout)) {
@@ -3731,15 +3729,16 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	struct ibmvnic_login_rsp_buffer *login_rsp_buffer;
 	struct ibmvnic_login_buffer *login_buffer;
 	struct device *dev = &adapter->vdev->dev;
+	struct vnic_login_client_data *vlcd;
 	dma_addr_t rsp_buffer_token;
 	dma_addr_t buffer_token;
 	size_t rsp_buffer_size;
 	union ibmvnic_crq crq;
+	int client_data_len;
 	size_t buffer_size;
 	__be64 *tx_list_p;
 	__be64 *rx_list_p;
-	int client_data_len;
-	struct vnic_login_client_data *vlcd;
+	int rc;
 	int i;
 
 	if (!adapter->tx_scrq || !adapter->rx_scrq) {
@@ -3845,16 +3844,23 @@ static int send_login(struct ibmvnic_adapter *adapter)
 	crq.login.len = cpu_to_be32(buffer_size);
 
 	adapter->login_pending = true;
-	ibmvnic_send_crq(adapter, &crq);
+	rc = ibmvnic_send_crq(adapter, &crq);
+	if (rc) {
+		adapter->login_pending = false;
+		netdev_err(adapter->netdev, "Failed to send login, rc=%d\n", rc);
+		goto buf_rsp_map_failed;
+	}
 
 	return 0;
 
 buf_rsp_map_failed:
 	kfree(login_rsp_buffer);
+	adapter->login_rsp_buf = NULL;
 buf_rsp_alloc_failed:
 	dma_unmap_single(dev, buffer_token, buffer_size, DMA_TO_DEVICE);
 buf_map_failed:
 	kfree(login_buffer);
+	adapter->login_buf = NULL;
 buf_alloc_failed:
 	return -1;
 }
-- 
2.27.0



