Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B8829C279
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1820594AbgJ0Rg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:36:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760751AbgJ0OgQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:36:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4A3222202;
        Tue, 27 Oct 2020 14:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809375;
        bh=lpOGQ10X7hAeMbLI1BwsoVxveb/z8ud/NuNpMRcRJBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MMSZXm3yLf1B56ZA8BopE0UvyTTq6GG3oU5pqX7gNasxNyiv3iqAb4T+RSg+2nPw
         FjykFnZaYwxdQfdXvWhhxQv/1xruyGqJKSt6cy7W0Ph0FpSzcchGmIo5HP85/DHA3j
         zIPmTxlAs76ow841qQ9iMSIBTVRXhLvucAKiPpcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/408] ibmvnic: set up 200GBPS speed
Date:   Tue, 27 Oct 2020 14:51:51 +0100
Message-Id: <20201027135503.124342856@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit b9cd795b0e4860f482bf3741d12e1c8f3ec1cfc9 ]

Set up the speed according to crq->query_phys_parms.rsp.speed.
Fix IBMVNIC_10GBPS typo.

Fixes: f8d6ae0d27ec ("ibmvnic: Report actual backing device speed and duplex values")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 5 ++++-
 drivers/net/ethernet/ibm/ibmvnic.h | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 59d437df6cab4..48105a2eebe4d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4477,7 +4477,7 @@ static int handle_query_phys_parms_rsp(union ibmvnic_crq *crq,
 	case IBMVNIC_1GBPS:
 		adapter->speed = SPEED_1000;
 		break;
-	case IBMVNIC_10GBP:
+	case IBMVNIC_10GBPS:
 		adapter->speed = SPEED_10000;
 		break;
 	case IBMVNIC_25GBPS:
@@ -4492,6 +4492,9 @@ static int handle_query_phys_parms_rsp(union ibmvnic_crq *crq,
 	case IBMVNIC_100GBPS:
 		adapter->speed = SPEED_100000;
 		break;
+	case IBMVNIC_200GBPS:
+		adapter->speed = SPEED_200000;
+		break;
 	default:
 		if (netif_carrier_ok(netdev))
 			netdev_warn(netdev, "Unknown speed 0x%08x\n", rspeed);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index ebc39248b334a..0da20f19bb17c 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -373,7 +373,7 @@ struct ibmvnic_phys_parms {
 #define IBMVNIC_10MBPS		0x40000000
 #define IBMVNIC_100MBPS		0x20000000
 #define IBMVNIC_1GBPS		0x10000000
-#define IBMVNIC_10GBP		0x08000000
+#define IBMVNIC_10GBPS		0x08000000
 #define IBMVNIC_40GBPS		0x04000000
 #define IBMVNIC_100GBPS		0x02000000
 #define IBMVNIC_25GBPS		0x01000000
-- 
2.25.1



