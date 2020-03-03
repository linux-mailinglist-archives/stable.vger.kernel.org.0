Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A614177F17
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbgCCRsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:48:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730586AbgCCRsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:48:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0EE22146E;
        Tue,  3 Mar 2020 17:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257719;
        bh=61cMcrHpCmck7DJMugnV0iIAxMjsJLcZIVyODY/uwUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPqpS7Xhfkq/qcOmLOd6WKUNSLhpZ1U/DS5nK+hgmf60p92bOx89OcOk6/x5F1ISt
         mvfklErgL2BenTOQHW7CBfcBsKiDrV6YLl7ySJbPEsxZeHnzDkbuMzfGn3qqklXMEi
         4svP0LJcZfE1D0Vh1toNgK8uJf6xG/CRmGajuZnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 077/176] net: hns3: fix a copying IPv6 address error in hclge_fd_get_flow_tuples()
Date:   Tue,  3 Mar 2020 18:42:21 +0100
Message-Id: <20200303174313.526363215@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit 47327c9315b2f3ae4ab659457977a26669631f20 ]

The IPv6 address defined in struct in6_addr is specified as
big endian, but there is no specified endian in struct
hclge_fd_rule_tuples, so it  will cause a problem if directly
use memcpy() to copy ipv6 address between these two structures
since this field in struct hclge_fd_rule_tuples is little endian.

This patch fixes this problem by using be32_to_cpu() to convert
endian of IPv6 address of struct in6_addr before copying.

Fixes: d93ed94fbeaf ("net: hns3: add aRFS support for PF")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index bfdb08572f0cc..5d74f5a60102a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6106,6 +6106,9 @@ static int hclge_get_all_rules(struct hnae3_handle *handle,
 static void hclge_fd_get_flow_tuples(const struct flow_keys *fkeys,
 				     struct hclge_fd_rule_tuples *tuples)
 {
+#define flow_ip6_src fkeys->addrs.v6addrs.src.in6_u.u6_addr32
+#define flow_ip6_dst fkeys->addrs.v6addrs.dst.in6_u.u6_addr32
+
 	tuples->ether_proto = be16_to_cpu(fkeys->basic.n_proto);
 	tuples->ip_proto = fkeys->basic.ip_proto;
 	tuples->dst_port = be16_to_cpu(fkeys->ports.dst);
@@ -6114,12 +6117,12 @@ static void hclge_fd_get_flow_tuples(const struct flow_keys *fkeys,
 		tuples->src_ip[3] = be32_to_cpu(fkeys->addrs.v4addrs.src);
 		tuples->dst_ip[3] = be32_to_cpu(fkeys->addrs.v4addrs.dst);
 	} else {
-		memcpy(tuples->src_ip,
-		       fkeys->addrs.v6addrs.src.in6_u.u6_addr32,
-		       sizeof(tuples->src_ip));
-		memcpy(tuples->dst_ip,
-		       fkeys->addrs.v6addrs.dst.in6_u.u6_addr32,
-		       sizeof(tuples->dst_ip));
+		int i;
+
+		for (i = 0; i < IPV6_SIZE; i++) {
+			tuples->src_ip[i] = be32_to_cpu(flow_ip6_src[i]);
+			tuples->dst_ip[i] = be32_to_cpu(flow_ip6_dst[i]);
+		}
 	}
 }
 
-- 
2.20.1



