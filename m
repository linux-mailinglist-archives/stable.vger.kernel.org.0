Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0995290B8
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiEPUHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349688AbiEPUAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575C043EE4;
        Mon, 16 May 2022 12:54:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6C13B81618;
        Mon, 16 May 2022 19:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A02C34100;
        Mon, 16 May 2022 19:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730858;
        bh=p6ago/YST1g5eL3V30HoLhU7ZufykKWvRgnn7qiaM9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuOvTgYk1qBf4/MMEUKI/N4SlHOuxbp607INi+URHpy/MqtQGSg6u8DYyA5prTZNR
         AUq0KGFbCAgK9jlCINJUuHDJtSjkPojhmrQ+hHiMhLivfLSit8rFW6+62kdXAC8y93
         fSb4EuEBFkx/sUQ749PXle1hO3anpi4JwYrqPd8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 027/114] ionic: fix missing pci_release_regions() on error in ionic_probe()
Date:   Mon, 16 May 2022 21:36:01 +0200
Message-Id: <20220516193626.271583393@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
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



