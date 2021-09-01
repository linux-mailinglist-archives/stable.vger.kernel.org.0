Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7153FDAB7
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245574AbhIAMep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244795AbhIAMcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:32:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB001610CE;
        Wed,  1 Sep 2021 12:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499501;
        bh=vIPqLVxU8JpdLAM9GSc3B+uDioxIjvzFNcsB3uiDjlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IqR/wDDWp2T06wEzBYA6DgLsg9SciXAKwduNGBIIHMU1MTDBA/ZZXE5+hqNFyC806
         ZQXVunoXfZLLYR1xVaUboNtAlAm7h5Ve8yjl7bE+4UyzLh7pYpRH414PKCiN/E+jS7
         H+wths5qNt94UMvUHEnqDzbMaH9cN941+rSEOb40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guojia Liao <liaoguojia@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 23/48] net: hns3: fix duplicate node in VLAN list
Date:   Wed,  1 Sep 2021 14:28:13 +0200
Message-Id: <20210901122254.175251794@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guojia Liao <liaoguojia@huawei.com>

[ Upstream commit 94391fae82f71c98ecc7716a32611fcca73c74eb ]

VLAN list should not be added duplicate VLAN node, otherwise it would
cause "add failed" when restore VLAN from VLAN list, so this patch adds
VLAN ID check before adding node into VLAN list.

Fixes: c6075b193462 ("net: hns3: Record VF vlan tables")
Signed-off-by: Guojia Liao <liaoguojia@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 28e260439196..aa402e267121 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8006,7 +8006,11 @@ static int hclge_init_vlan_config(struct hclge_dev *hdev)
 static void hclge_add_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
 				       bool writen_to_tbl)
 {
-	struct hclge_vport_vlan_cfg *vlan;
+	struct hclge_vport_vlan_cfg *vlan, *tmp;
+
+	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node)
+		if (vlan->vlan_id == vlan_id)
+			return;
 
 	vlan = kzalloc(sizeof(*vlan), GFP_KERNEL);
 	if (!vlan)
-- 
2.30.2



