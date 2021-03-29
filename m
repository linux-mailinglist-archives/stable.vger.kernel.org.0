Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF96C34CADC
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbhC2Ik2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:40:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232963AbhC2Ija (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:39:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B50C619F7;
        Mon, 29 Mar 2021 08:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007169;
        bh=UYBfAvLHZ6oaDniR+wxi9O2WFwa8Cs5fhp3Mu5rRikQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fl+EEAK6SshhJoF/sHgUACtxoR9pPrSVIuWVP8qg4SQGG7ZB3mWw1aSbOasKFiaN7
         AfQsG/0yQPJkIqmjE1bJKQlF18uJgk1fv4yt2lvhxI9/3Nn3NlkuhbhJQgMB1MhBic
         Af9LAUWDOv5xWgCQsCNvZchg+DMbPeL7UR26BIK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Blazejowski <paulb@blazebox.homeip.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 246/254] r8169: fix DMA being used after buffer free if WoL is enabled
Date:   Mon, 29 Mar 2021 09:59:22 +0200
Message-Id: <20210329075641.160001852@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

commit f658b90977d2e79822a558e48116e059a7e75dec upstream.

IOMMU errors have been reported if WoL is enabled and interface is
brought down. It turned out that the network chip triggers DMA
transfers after the DMA buffers have been freed. For WoL to work we
need to leave rx enabled, therefore simply stop the chip from being
a DMA busmaster.

Fixes: 567ca57faa62 ("r8169: add rtl8169_up")
Tested-by: Paul Blazejowski <paulb@blazebox.homeip.net>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4677,6 +4677,9 @@ static void rtl8169_down(struct rtl8169_
 
 	rtl8169_update_counters(tp);
 
+	pci_clear_master(tp->pci_dev);
+	rtl_pci_commit(tp);
+
 	rtl8169_cleanup(tp, true);
 
 	rtl_pll_power_down(tp);
@@ -4684,6 +4687,7 @@ static void rtl8169_down(struct rtl8169_
 
 static void rtl8169_up(struct rtl8169_private *tp)
 {
+	pci_set_master(tp->pci_dev);
 	rtl_pll_power_up(tp);
 	rtl8169_init_phy(tp);
 	napi_enable(&tp->napi);
@@ -5348,8 +5352,6 @@ static int rtl_init_one(struct pci_dev *
 
 	rtl_hw_reset(tp);
 
-	pci_set_master(pdev);
-
 	rc = rtl_alloc_irq(tp);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Can't allocate interrupt\n");


