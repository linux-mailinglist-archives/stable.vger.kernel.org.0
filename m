Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36AC4B4822
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244514AbiBNJl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:41:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245063AbiBNJlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:41:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C69A196;
        Mon, 14 Feb 2022 01:37:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A019660DFD;
        Mon, 14 Feb 2022 09:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C992C340E9;
        Mon, 14 Feb 2022 09:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831421;
        bh=qlTXMgDZRk4SlT/fqVq8NbjrNQm0Jg7jri67W8G3os0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P479Zq2bL3cjEU2N4cHCy00QVF2wULOnu7wiFu+bnTRkE8F8rguC0Ictq0i4Tyguy
         NtbKF0VLX6i6xXbw/ezlZgPqMxM8XX2U/7JzVhNGl1yqhE8Og0Yy2wr7aheLgr8Ult
         Yh5SW2a2MbzhYjD946/r81N4Ws/OwXS+yNXCY9Kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Selwin Sebastian <Selwin.Sebastian@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 49/71] net: amd-xgbe: disable interrupts during pci removal
Date:   Mon, 14 Feb 2022 10:26:17 +0100
Message-Id: <20220214092453.698935832@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
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
index 7b86240ecd5fe..c4f1fc97987ae 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-pci.c
@@ -418,6 +418,9 @@ static void xgbe_pci_remove(struct pci_dev *pdev)
 
 	pci_free_irq_vectors(pdata->pcidev);
 
+	/* Disable all interrupts in the hardware */
+	XP_IOWRITE(pdata, XP_INT_EN, 0x0);
+
 	xgbe_free_pdata(pdata);
 }
 
-- 
2.34.1



