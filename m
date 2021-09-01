Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7422B3FDC82
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345476AbhIAMvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346056AbhIAMtN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:49:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA94660FD7;
        Wed,  1 Sep 2021 12:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500068;
        bh=oZXMUwiTIOfEwuL3OmK/Oe+3RaJsvtrPBajd7B6CjoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPpd0qmdxlUyaNcKJMi0x1gN5FW8Ygnm5cwB0gntRzZa54O9uJq8RKhFvIlQSSLyB
         1YmO17sgZ7md2K7UcVSaghaMznzqu8Pk7NRILanj/B8QLBIO7fiW67wUhXgcf5bQix
         3+dKkz+5K4NccPk/QPoRiCpPr37C+BdRCkN1oXnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guojia Liao <liaoguojia@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 063/113] net: hns3: fix duplicate node in VLAN list
Date:   Wed,  1 Sep 2021 14:28:18 +0200
Message-Id: <20210901122304.066801665@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
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
index 00254d167904..f105ff9e3f4c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9869,7 +9869,11 @@ static int hclge_init_vlan_config(struct hclge_dev *hdev)
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



