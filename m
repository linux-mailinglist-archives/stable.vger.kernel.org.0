Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8333B4F3402
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350609AbiDEJ7G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344150AbiDEJSZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:18:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6C4443D8;
        Tue,  5 Apr 2022 02:04:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FBEBB81BBF;
        Tue,  5 Apr 2022 09:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906C3C385A1;
        Tue,  5 Apr 2022 09:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149475;
        bh=dVqkzsew4DEHWhEltK2MJT27ooP0p4RsSCP3QwS6HIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xECi6vXAO1LoGWOQ+5KjNzPlYi2CtftvMLnROBm8GpRJK6ZhbRrk/+jvezIN2B+A4
         E31dx36I28BJDjj8PqRAqE4AWx1FXux1g5CqnTzGtaW5XVkkzA6fRWuvNUVccfZFj/
         C7iJ3zWfrp3b6go1Gt2i/5J+hjsi08Td3md05994=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0729/1017] net: hns3: fix bug when PF set the duplicate MAC address for VFs
Date:   Tue,  5 Apr 2022 09:27:22 +0200
Message-Id: <20220405070415.905924838@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index c2a58101144e..0fc8810671dc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8888,12 +8888,11 @@ int hclge_rm_uc_addr_common(struct hclge_vport *vport,
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



