Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB5D5948C7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354354AbiHOXt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354359AbiHOXr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:47:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5275CC2FB1;
        Mon, 15 Aug 2022 13:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B29B8B8115B;
        Mon, 15 Aug 2022 20:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD05C433D6;
        Mon, 15 Aug 2022 20:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594536;
        bh=VAXuy6qTweqSeZ0LUKOMiZxh54lrf8iikegCxcOJiFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBw4de+v5ruLwIVYaLOo7iEmapHooNI8a/57t9fBaEa2A6lq0VJsgasf6znnF35jD
         3Y72H/tTwAXg/7fzfTotzdo8+Tx2kAz6TqANO4Xw5M9Ffjim0NLs18vxC0lpRfVi1w
         Tb24DM8/9iQjvVnNwmKppFMBqBdhRE78P/LUg3qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0444/1157] hinic: Use the bitmap API when applicable
Date:   Mon, 15 Aug 2022 19:56:40 +0200
Message-Id: <20220815180457.360943676@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 05329292d940..56a89793f47d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -62,8 +62,6 @@ MODULE_PARM_DESC(rx_weight, "Number Rx packets for NAPI budget (default=64)");
 
 #define HINIC_LRO_RX_TIMER_DEFAULT	16
 
-#define VLAN_BITMAP_SIZE(nic_dev)       (ALIGN(VLAN_N_VID, 8) / 8)
-
 #define work_to_rx_mode_work(work)      \
 		container_of(work, struct hinic_rx_mode_work, work)
 
@@ -1242,9 +1240,8 @@ static int nic_dev_init(struct pci_dev *pdev)
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



