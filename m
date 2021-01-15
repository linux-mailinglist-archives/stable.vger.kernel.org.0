Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250DF2F7A75
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387972AbhAOMty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:49:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:42934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbhAOMgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:36:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF7DB221FA;
        Fri, 15 Jan 2021 12:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714167;
        bh=oYzQ0GpoPLA19Tqk2PUHYgiPOs3BgEpNVATYi51TYgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1LpNwTb+i7SyO7egMRhRpMxlwnrGI57Q37HnzlMOAJmQ5gHXEXsGtWUWNhrKyH9B
         nLiRzrUPvsEF8QXKum9VwyyajrqGZld6CoajVd1d+fEFV6g8r2nprUq7J7acSS8BSK
         AU4l+vEAG3MQEE+i3iTsGM1pfMpwR42nBc5Ict5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 014/103] net: hns3: fix incorrect handling of sctp6 rss tuple
Date:   Fri, 15 Jan 2021 13:27:07 +0100
Message-Id: <20210115122006.735771290@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit ab6e32d2913a594bc8f822ce4a75c400190b2ecc ]

For DEVICE_VERSION_V2, the hardware only supports src-ip,
dst-ip and verification-tag for rss tuple set of sctp6
packet. For DEVICE_VERSION_V3, the hardware supports
src-port and dst-port as well.

Currently, when user queries the sctp6 rss tuples info,
some unsupported information will be showed on V2. So add
a check for hardware version when initializing and queries
sctp6 rss tuple to fix this issue.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   |    6 ++++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   |    2 ++
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |    9 ++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h |    2 ++
 4 files changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -4484,8 +4484,8 @@ static int hclge_set_rss_tuple(struct hn
 		req->ipv4_sctp_en = tuple_sets;
 		break;
 	case SCTP_V6_FLOW:
-		if ((nfc->data & RXH_L4_B_0_1) ||
-		    (nfc->data & RXH_L4_B_2_3))
+		if (hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 &&
+		    (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)))
 			return -EINVAL;
 
 		req->ipv6_sctp_en = tuple_sets;
@@ -4665,6 +4665,8 @@ static void hclge_rss_init_cfg(struct hc
 		vport[i].rss_tuple_sets.ipv6_udp_en =
 			HCLGE_RSS_INPUT_TUPLE_OTHER;
 		vport[i].rss_tuple_sets.ipv6_sctp_en =
+			hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 ?
+			HCLGE_RSS_INPUT_TUPLE_SCTP_NO_PORT :
 			HCLGE_RSS_INPUT_TUPLE_SCTP;
 		vport[i].rss_tuple_sets.ipv6_fragment_en =
 			HCLGE_RSS_INPUT_TUPLE_OTHER;
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -105,6 +105,8 @@
 #define HCLGE_D_IP_BIT			BIT(2)
 #define HCLGE_S_IP_BIT			BIT(3)
 #define HCLGE_V_TAG_BIT			BIT(4)
+#define HCLGE_RSS_INPUT_TUPLE_SCTP_NO_PORT	\
+		(HCLGE_D_IP_BIT | HCLGE_S_IP_BIT | HCLGE_V_TAG_BIT)
 
 #define HCLGE_RSS_TC_SIZE_0		1
 #define HCLGE_RSS_TC_SIZE_1		2
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -901,8 +901,8 @@ static int hclgevf_set_rss_tuple(struct
 		req->ipv4_sctp_en = tuple_sets;
 		break;
 	case SCTP_V6_FLOW:
-		if ((nfc->data & RXH_L4_B_0_1) ||
-		    (nfc->data & RXH_L4_B_2_3))
+		if (hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 &&
+		    (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)))
 			return -EINVAL;
 
 		req->ipv6_sctp_en = tuple_sets;
@@ -2481,7 +2481,10 @@ static void hclgevf_rss_init_cfg(struct
 		tuple_sets->ipv4_fragment_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
 		tuple_sets->ipv6_tcp_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
 		tuple_sets->ipv6_udp_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
-		tuple_sets->ipv6_sctp_en = HCLGEVF_RSS_INPUT_TUPLE_SCTP;
+		tuple_sets->ipv6_sctp_en =
+			hdev->ae_dev->dev_version <= HNAE3_DEVICE_VERSION_V2 ?
+					HCLGEVF_RSS_INPUT_TUPLE_SCTP_NO_PORT :
+					HCLGEVF_RSS_INPUT_TUPLE_SCTP;
 		tuple_sets->ipv6_fragment_en = HCLGEVF_RSS_INPUT_TUPLE_OTHER;
 	}
 
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -122,6 +122,8 @@
 #define HCLGEVF_D_IP_BIT		BIT(2)
 #define HCLGEVF_S_IP_BIT		BIT(3)
 #define HCLGEVF_V_TAG_BIT		BIT(4)
+#define HCLGEVF_RSS_INPUT_TUPLE_SCTP_NO_PORT	\
+	(HCLGEVF_D_IP_BIT | HCLGEVF_S_IP_BIT | HCLGEVF_V_TAG_BIT)
 
 #define HCLGEVF_STATS_TIMER_INTERVAL	36U
 


