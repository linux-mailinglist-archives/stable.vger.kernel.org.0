Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8894F407B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382364AbiDEMPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239467AbiDEKfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:35:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5103B4D24A;
        Tue,  5 Apr 2022 03:20:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01CF7B81C8A;
        Tue,  5 Apr 2022 10:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57115C385A1;
        Tue,  5 Apr 2022 10:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154051;
        bh=xmpYNe7lP0sm/crrazOov450MjnZ3vDtEETdr1+zEH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbwJtdubnwIUzkrPJtA1jE2jDyhdFM4J0XDY7f0axQ4kSBR9o35aA/1OlA2889eM0
         +/k3q5/e65EkSsvSEQnZHQJVO+yIrV9otjs+oaqZBEGSaWs1FVWN+WhWvt/kJZ7YGT
         KE5bOC48iAuTZXan7SGI48A88VvmXOFMQXm9lzCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 439/599] net: hns3: fix bug when PF set the duplicate MAC address for VFs
Date:   Tue,  5 Apr 2022 09:32:13 +0200
Message-Id: <20220405070311.896333933@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit ccb18f05535c96d26e2d559d402acb87700fc5a7 ]

If the MAC address A is configured to vport A and then vport B. The MAC
address of vport A in the hardware becomes invalid. If the address of
vport A is changed to MAC address B, the driver needs to delete the MAC
address A of vport A. Due to the MAC address A of vport A has become
invalid in the hardware entry, so "-ENOENT" is returned. In this case, the
"used_umv_size" value recorded in driver is not updated. As a result, the
MAC entry status of the software is inconsistent with that of the hardware.

Therefore, the driver updates the umv size even if the MAC entry cannot be
found. Ensure that the software and hardware status is consistent.

Fixes: ee4bcd3b7ae4 ("net: hns3: refactor the MAC address configure")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7b94764b4f5d..49129e8002fc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7616,12 +7616,11 @@ int hclge_rm_uc_addr_common(struct hclge_vport *vport,
 	hnae3_set_bit(req.entry_type, HCLGE_MAC_VLAN_BIT0_EN_B, 0);
 	hclge_prepare_mac_addr(&req, addr, false);
 	ret = hclge_remove_mac_vlan_tbl(vport, &req);
-	if (!ret) {
+	if (!ret || ret == -ENOENT) {
 		mutex_lock(&hdev->vport_lock);
 		hclge_update_umv_space(vport, true);
 		mutex_unlock(&hdev->vport_lock);
-	} else if (ret == -ENOENT) {
-		ret = 0;
+		return 0;
 	}
 
 	return ret;
-- 
2.34.1



