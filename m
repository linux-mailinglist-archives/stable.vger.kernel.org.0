Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0B2599F5D
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351615AbiHSQLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351635AbiHSQJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:09:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4014CA2E;
        Fri, 19 Aug 2022 08:56:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB4ECB82818;
        Fri, 19 Aug 2022 15:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E17C433B5;
        Fri, 19 Aug 2022 15:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924598;
        bh=dK9jhqwjJ76X4pHQCcYFQk/buytrnpJSftykc1vErfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dcIIVfpN8pIwMqJCyJjtaVvopthc3CwTl1dpKRT8Ja10YPMzbbYnGeH+TETFze/+A
         FYMIKAR8MNWgu0sszloFXnDKp8Ch6ipj4U0BhJ/gyvG+uKAr1w35DziAW2+682oZEG
         SQMOnKr6l32FNYrzOt6j9gCKr+ZGJCusoe2syGdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/545] hinic: Use the bitmap API when applicable
Date:   Fri, 19 Aug 2022 17:39:44 +0200
Message-Id: <20220819153838.943962413@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index ace949fe6233..2376edf6c263 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -62,8 +62,6 @@ MODULE_PARM_DESC(rx_weight, "Number Rx packets for NAPI budget (default=64)");
 
 #define HINIC_LRO_RX_TIMER_DEFAULT	16
 
-#define VLAN_BITMAP_SIZE(nic_dev)       (ALIGN(VLAN_N_VID, 8) / 8)
-
 #define work_to_rx_mode_work(work)      \
 		container_of(work, struct hinic_rx_mode_work, work)
 
@@ -1248,9 +1246,8 @@ static int nic_dev_init(struct pci_dev *pdev)
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



