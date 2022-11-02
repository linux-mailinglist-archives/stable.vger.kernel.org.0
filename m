Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFAA615968
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiKBDKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiKBDKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:10:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7256D183A0
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C1B90CE1E2F
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4FDC433D6;
        Wed,  2 Nov 2022 03:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358620;
        bh=4KZZYevzx2CQ/IWWV3Ac3ItqjxZ9Q2n3KTyqmsxFaKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFgXWF/k4OFUD0wlvcpl/bNWbiuBVRBPgGanUqgUHyixfg/JVTM7vuum9m+/nsgF8
         YaPpukr03BEHJ0GYLwbYItJpf+Y8wrcR1PtE7f1ueZiqjQRSB1B74ghk2fe51lfmJ5
         kXwn1OFSVK1dW7MmHUc/wt4GkPaydjqE36uzkFXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/132] net: ksz884x: fix missing pci_disable_device() on error in pcidev_init()
Date:   Wed,  2 Nov 2022 03:33:29 +0100
Message-Id: <20221102022102.357336593@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5da6d65590a0698199df44d095e54b0ed1708178 ]

pci_disable_device() need be called while module exiting, switch to use
pcim_enable(), pci_disable_device() will be called in pcim_release()
while unbinding device.

Fixes: 8ca86fd83eae ("net: Micrel KSZ8841/2 PCI Ethernet driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221024131338.2848959-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ksz884x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index a0ee155f9f51..f56bcd3e36d2 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6848,7 +6848,7 @@ static int pcidev_init(struct pci_dev *pdev, const struct pci_device_id *id)
 	char banner[sizeof(version)];
 	struct ksz_switch *sw = NULL;
 
-	result = pci_enable_device(pdev);
+	result = pcim_enable_device(pdev);
 	if (result)
 		return result;
 
-- 
2.35.1



