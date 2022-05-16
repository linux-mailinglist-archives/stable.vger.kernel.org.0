Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44ADE528E8B
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345884AbiEPTtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346336AbiEPTsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:48:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B894338F;
        Mon, 16 May 2022 12:44:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19FB3B8160D;
        Mon, 16 May 2022 19:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD87C385AA;
        Mon, 16 May 2022 19:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730288;
        bh=g8ECtb8mX5kvHNcnRq6EhYmCLsHNLI4ewBkgO6oyvR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zs9x1rvAGPEifx9BdXYfPTpZ/ARjnO9sDUy1X8XI6RFe+9pLQpzVMvmHemS1zwe8w
         dbNmomAnN6Cyexw6qg4fujmM7QkpIUJ1lKdkLDXjOlTSGnJzI4moI8OWHnIArfflvA
         YaVYi4KuiPa9kaLr62S9rUxJcTjXXni4XBmlGu5I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/66] ionic: fix missing pci_release_regions() on error in ionic_probe()
Date:   Mon, 16 May 2022 21:36:17 +0200
Message-Id: <20220516193619.915321519@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
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
index b0d8499d373b..31fbe8904222 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -251,7 +251,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = ionic_map_bars(ionic);
 	if (err)
-		goto err_out_pci_disable_device;
+		goto err_out_pci_release_regions;
 
 	/* Configure the device */
 	err = ionic_setup(ionic);
@@ -353,6 +353,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 err_out_unmap_bars:
 	ionic_unmap_bars(ionic);
+err_out_pci_release_regions:
 	pci_release_regions(pdev);
 err_out_pci_disable_device:
 	pci_disable_device(pdev);
-- 
2.35.1



