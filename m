Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756324B4615
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243607AbiBNJcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:32:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243613AbiBNJcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:32:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CCA1ADB1;
        Mon, 14 Feb 2022 01:30:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1F09B80DC6;
        Mon, 14 Feb 2022 09:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CB9C340E9;
        Mon, 14 Feb 2022 09:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831054;
        bh=LGnMrv8zyFJ9Jznd8mvnS6QMJ59LaXA+jxgRSmNbVW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0/gZ2xoSvi0VG1Tv4qhtEM7cyMsrGQYTHVRJpnpTsOxSH9bHfzXd7geu0BKsUvww
         CCLFtgsbgwAZ13RnZrI1EnKAn8PGbM3PjURb9J74a2GMDg+QMmFz3JA8DdwYEaOhb8
         rUqb7REla9MlohPjup7YSo0kCOBqOtajqCuvJkwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Selwin Sebastian <Selwin.Sebastian@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 28/44] net: amd-xgbe: disable interrupts during pci removal
Date:   Mon, 14 Feb 2022 10:25:51 +0100
Message-Id: <20220214092448.821089086@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
References: <20220214092447.897544753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 68c2d6af1f1e469544d6cbe9a601d96fb9c00e7f ]

Hardware interrupts are enabled during the pci probe, however,
they are not disabled during pci removal.

Disable all hardware interrupts during pci removal to avoid any
issues.

Fixes: e75377404726 ("amd-xgbe: Update PCI support to use new IRQ functions")
Suggested-by: Selwin Sebastian <Selwin.Sebastian@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
index 82d1f416ee2ac..569e6d3d066bf 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -400,6 +400,9 @@ static void xgbe_pci_remove(struct pci_dev *pdev)
 
 	pci_free_irq_vectors(pdata->pcidev);
 
+	/* Disable all interrupts in the hardware */
+	XP_IOWRITE(pdata, XP_INT_EN, 0x0);
+
 	xgbe_free_pdata(pdata);
 }
 
-- 
2.34.1



