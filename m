Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4F26C6AB
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388695AbfGRDS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391327AbfGRDNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:13:46 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E1B82173E;
        Thu, 18 Jul 2019 03:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419625;
        bh=CJWJ28qHUCdtHEQjtJ5lrq8X5LSMxyqTS10JvvdUuDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGTNIB+uuPkKnRgrewKEmWk7c6U6+L38FZppJwzl+n6Wz5gZdp4ceJ1xytajneEdl
         e9OipIat7W/gr/vvrNz/gBeSdMjJuMu3SBSUVW74MUairOITpJOatVVLBfX+s0wSnA
         RsGYe3aezcDKHU+elho4YXv3JeSsvnRO85ZpjDxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Oros <poros@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 46/54] be2net: fix link failure after ethtool offline test
Date:   Thu, 18 Jul 2019 12:02:16 +0900
Message-Id: <20190718030053.137421438@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030048.392549994@linuxfoundation.org>
References: <20190718030048.392549994@linuxfoundation.org>
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
index 345818193de9..56db37d92937 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -898,7 +898,7 @@ static void be_self_test(struct net_device *netdev, struct ethtool_test *test,
 			 u64 *data)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
-	int status;
+	int status, cnt;
 	u8 link_status = 0;
 
 	if (adapter->function_caps & BE_FUNCTION_CAPS_SUPER_NIC) {
@@ -909,6 +909,9 @@ static void be_self_test(struct net_device *netdev, struct ethtool_test *test,
 
 	memset(data, 0, sizeof(u64) * ETHTOOL_TESTS_NUM);
 
+	/* check link status before offline tests */
+	link_status = netif_carrier_ok(netdev);
+
 	if (test->flags & ETH_TEST_FL_OFFLINE) {
 		if (be_loopback_test(adapter, BE_MAC_LOOPBACK, &data[0]) != 0)
 			test->flags |= ETH_TEST_FL_FAILED;
@@ -929,13 +932,26 @@ static void be_self_test(struct net_device *netdev, struct ethtool_test *test,
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



