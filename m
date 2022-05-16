Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680BD5290A9
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346473AbiEPTyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348563AbiEPTwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:52:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C21246148;
        Mon, 16 May 2022 12:48:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1904F60BAD;
        Mon, 16 May 2022 19:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C62C385AA;
        Mon, 16 May 2022 19:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730519;
        bh=p6ago/YST1g5eL3V30HoLhU7ZufykKWvRgnn7qiaM9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cq9INTqZGJ8J5Zoit1Y1dL8NAbC+vHfYMBgXzT28RsQjbGw7yEC8m9usCM58XTwNy
         RRcIZDKQDCOLlGh31XU/Czci4bjSjL/2h6ged7CaV7IqNgiRL3j0oyOa29Ktogxl9v
         /019QXkJ8f+leNaiEGhfeX4XEB3whior189uXVs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/102] ionic: fix missing pci_release_regions() on error in ionic_probe()
Date:   Mon, 16 May 2022 21:35:59 +0200
Message-Id: <20220516193624.722496486@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e4b1045bf9cfec6f70ac6d3783be06c3a88dcb25 ]

If ionic_map_bars() fails, pci_release_regions() need be called.

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220506034040.2614129-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 40fa5bce2ac2..d324c292318b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -255,7 +255,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = ionic_map_bars(ionic);
 	if (err)
-		goto err_out_pci_disable_device;
+		goto err_out_pci_release_regions;
 
 	/* Configure the device */
 	err = ionic_setup(ionic);
@@ -359,6 +359,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 err_out_unmap_bars:
 	ionic_unmap_bars(ionic);
+err_out_pci_release_regions:
 	pci_release_regions(pdev);
 err_out_pci_disable_device:
 	pci_disable_device(pdev);
-- 
2.35.1



