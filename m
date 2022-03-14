Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14234D8285
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240432AbiCNMFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240429AbiCNMEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:04:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956EA4BFF1;
        Mon, 14 Mar 2022 05:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41CB3B80DF0;
        Mon, 14 Mar 2022 12:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9B0C36AE2;
        Mon, 14 Mar 2022 12:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259294;
        bh=+E5woosn/ZbFLikndWdbKLVKptItEm0e3E0i3Z+4g/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVWMPz/LoFeSi8LSKac2lEBk8VyoVI+HTOaYy8B4bOS9XmrFIDjMK1qNtctOhImBY
         WFIJsOyxThrHBJujIB4LWryGyr9JwOmFeZSa02idztYtLsyAm2bp7By0GiHlKG1zO3
         GmIfQHG70DbVeWlxU1YuvcPrH05cAxSa510z1aFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/71] isdn: hfcpci: check the return value of dma_set_mask() in setup_hw()
Date:   Mon, 14 Mar 2022 12:53:02 +0100
Message-Id: <20220314112738.194878919@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit d0aeb0d4a3f7d2a0df7e9545892bbeede8f2ac7e ]

The function dma_set_mask() in setup_hw() can fail, so its return value
should be checked.

Fixes: 1700fe1a10dc ("Add mISDN HFC PCI driver")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index bd087cca1c1d..af17459c1a5c 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2005,7 +2005,11 @@ setup_hw(struct hfc_pci *hc)
 	}
 	/* Allocate memory for FIFOS */
 	/* the memory needs to be on a 32k boundary within the first 4G */
-	dma_set_mask(&hc->pdev->dev, 0xFFFF8000);
+	if (dma_set_mask(&hc->pdev->dev, 0xFFFF8000)) {
+		printk(KERN_WARNING
+		       "HFC-PCI: No usable DMA configuration!\n");
+		return -EIO;
+	}
 	buffer = dma_alloc_coherent(&hc->pdev->dev, 0x8000, &hc->hw.dmahandle,
 				    GFP_KERNEL);
 	/* We silently assume the address is okay if nonzero */
-- 
2.34.1



