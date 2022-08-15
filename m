Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F31D59381B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244023AbiHOSwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244688AbiHOSvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:51:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFCF474CF;
        Mon, 15 Aug 2022 11:29:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38E3D60FDA;
        Mon, 15 Aug 2022 18:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EC9C433D6;
        Mon, 15 Aug 2022 18:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588171;
        bh=TxnbgPq7C531PMW+6Zh6jzpMqahQckFdHnZGC1A72TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlqxF1BEqDnVBUxp7cAasyAYj2z9d9HrtIqe7lb4s8sNhPhNX9F4ujJ78HD7aUj3F
         PMLIRhK/Pp8YVppKJIfENyqxpkwliooc4xadgXL6mQHGeuwk9r91oSepI7e29/9K2c
         zQQoPPhIGkFqVN02XnlXcwrLbtdf+afnGC/HfB1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 317/779] hinic: Use the bitmap API when applicable
Date:   Mon, 15 Aug 2022 19:59:21 +0200
Message-Id: <20220815180350.830851945@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 7c2c57263af41cfd8b5022274e6801542831bb69 ]

'vlan_bitmap' is a bitmap and is used as such. So allocate it with
devm_bitmap_zalloc() and its explicit bit size (i.e. VLAN_N_VID).

This avoids the need of the VLAN_BITMAP_SIZE macro which:
   - needlessly has a 'nic_dev' parameter
   - should be "long" (and not byte) aligned, so that the bitmap semantic
     is respected

This is in fact not an issue because VLAN_N_VID is 4096 at the time
being, but devm_bitmap_zalloc() is less verbose and easier to understand.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/6ff7b7d21414240794a77dc2456914412718a145.1656260842.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index f8aa80ec201b..bece6a12368d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -62,8 +62,6 @@ MODULE_PARM_DESC(rx_weight, "Number Rx packets for NAPI budget (default=64)");
 
 #define HINIC_LRO_RX_TIMER_DEFAULT	16
 
-#define VLAN_BITMAP_SIZE(nic_dev)       (ALIGN(VLAN_N_VID, 8) / 8)
-
 #define work_to_rx_mode_work(work)      \
 		container_of(work, struct hinic_rx_mode_work, work)
 
@@ -1241,9 +1239,8 @@ static int nic_dev_init(struct pci_dev *pdev)
 	u64_stats_init(&tx_stats->syncp);
 	u64_stats_init(&rx_stats->syncp);
 
-	nic_dev->vlan_bitmap = devm_kzalloc(&pdev->dev,
-					    VLAN_BITMAP_SIZE(nic_dev),
-					    GFP_KERNEL);
+	nic_dev->vlan_bitmap = devm_bitmap_zalloc(&pdev->dev, VLAN_N_VID,
+						  GFP_KERNEL);
 	if (!nic_dev->vlan_bitmap) {
 		err = -ENOMEM;
 		goto err_vlan_bitmap;
-- 
2.35.1



