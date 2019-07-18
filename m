Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6AF6C659
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392081AbfGRDPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392072AbfGRDPc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:15:32 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 027DF2077C;
        Thu, 18 Jul 2019 03:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419731;
        bh=dJceh5GuZD1qx718708X96536gfKf2Bn+LkDgawMbf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ds2A36u1w+4QCI75dl1QNXL6KRFwj1qNjK06aqMh8V7koJQhrl9dwjEwRdRai9IwS
         CCazOgiDS9RAmcCfbilXqVxVarBBlz6V71kMPKz8zSHRADSETS6M4hxM6ojJfs2ypQ
         /i+KYgsO0u7iOyiB+JKaWnAep3+faUpQ/ul00Yro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Oros <poros@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 31/40] be2net: fix link failure after ethtool offline test
Date:   Thu, 18 Jul 2019 12:02:27 +0900
Message-Id: <20190718030049.741161856@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030039.676518610@linuxfoundation.org>
References: <20190718030039.676518610@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2e5db6eb3c23e5dc8171eb8f6af7a97ef9fcf3a9 ]

Certain cards in conjunction with certain switches need a little more
time for link setup that results in ethtool link test failure after
offline test. Patch adds a loop that waits for a link setup finish.

Changes in v2:
- added fixes header

Fixes: 4276e47e2d1c ("be2net: Add link test to list of ethtool self tests.")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/emulex/benet/be_ethtool.c    | 28 +++++++++++++++----
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index 51bfe74be8d4..4e5646b3da09 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -868,7 +868,7 @@ static void be_self_test(struct net_device *netdev, struct ethtool_test *test,
 			 u64 *data)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
-	int status;
+	int status, cnt;
 	u8 link_status = 0;
 
 	if (adapter->function_caps & BE_FUNCTION_CAPS_SUPER_NIC) {
@@ -879,6 +879,9 @@ static void be_self_test(struct net_device *netdev, struct ethtool_test *test,
 
 	memset(data, 0, sizeof(u64) * ETHTOOL_TESTS_NUM);
 
+	/* check link status before offline tests */
+	link_status = netif_carrier_ok(netdev);
+
 	if (test->flags & ETH_TEST_FL_OFFLINE) {
 		if (be_loopback_test(adapter, BE_MAC_LOOPBACK, &data[0]) != 0)
 			test->flags |= ETH_TEST_FL_FAILED;
@@ -899,13 +902,26 @@ static void be_self_test(struct net_device *netdev, struct ethtool_test *test,
 		test->flags |= ETH_TEST_FL_FAILED;
 	}
 
-	status = be_cmd_link_status_query(adapter, NULL, &link_status, 0);
-	if (status) {
-		test->flags |= ETH_TEST_FL_FAILED;
-		data[4] = -1;
-	} else if (!link_status) {
+	/* link status was down prior to test */
+	if (!link_status) {
 		test->flags |= ETH_TEST_FL_FAILED;
 		data[4] = 1;
+		return;
+	}
+
+	for (cnt = 10; cnt; cnt--) {
+		status = be_cmd_link_status_query(adapter, NULL, &link_status,
+						  0);
+		if (status) {
+			test->flags |= ETH_TEST_FL_FAILED;
+			data[4] = -1;
+			break;
+		}
+
+		if (link_status)
+			break;
+
+		msleep_interruptible(500);
 	}
 }
 
-- 
2.20.1



