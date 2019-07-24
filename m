Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E305B73FC9
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388361AbfGXUfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388078AbfGXT0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:26:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53238229F3;
        Wed, 24 Jul 2019 19:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996367;
        bh=35gqSgFFgFhclDpTnJY/MV9ueyv3aP4Lk8CgSO14UvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hid31+SYBCS8doNcjfrdI+eaXDSmc4NjpCfNXN/l2UN97unZLeWD+XczcPqsP4yBj
         QF3LWvWvMh3RSezrkOP85gmZiORH9F5/nDd7lFz32mdmrXjnMyMvHOIVCbVJls7zoD
         DuM9+ZeEhcCweNtbXTKWg0eAUNPKJFS4xX24gQss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 035/413] net: hns3: fix for FEC configuration
Date:   Wed, 24 Jul 2019 21:15:26 +0200
Message-Id: <20190724191738.128109214@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f438bfe9d4fe2e491505abfbf04d7c506e00d146 ]

The FEC capbility may be changed with port speed changes. Driver
needs to read the active FEC mode, and update FEC capability
when port speed changes.

Fixes: 7e6ec9148a1d ("net: hns3: add support for FEC encoding control")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index d3b1f8cb1155..4d9bcad26f06 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2508,6 +2508,9 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 
 static void hclge_update_port_capability(struct hclge_mac *mac)
 {
+	/* update fec ability by speed */
+	hclge_convert_setting_fec(mac);
+
 	/* firmware can not identify back plane type, the media type
 	 * read from configuration can help deal it
 	 */
@@ -2580,6 +2583,10 @@ static int hclge_get_sfp_info(struct hclge_dev *hdev, struct hclge_mac *mac)
 		mac->speed_ability = le32_to_cpu(resp->speed_ability);
 		mac->autoneg = resp->autoneg;
 		mac->support_autoneg = resp->autoneg_ability;
+		if (!resp->active_fec)
+			mac->fec_mode = 0;
+		else
+			mac->fec_mode = BIT(resp->active_fec);
 	} else {
 		mac->speed_type = QUERY_SFP_SPEED;
 	}
-- 
2.20.1



