Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94E6462351
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 22:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhK2Vbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 16:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbhK2V3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 16:29:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7060DC041F7C;
        Mon, 29 Nov 2021 10:24:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11694B815D1;
        Mon, 29 Nov 2021 18:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375C5C53FC7;
        Mon, 29 Nov 2021 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210254;
        bh=p8gIsxhzM9pJlhgn9D8b9aLiGH4BxwbsifAsWtCRpHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puicAR2HtBPbRjmt5bXkWULO7yIC9XqY+CYpz4dmq7Q7Of2phQVe52uJ7Dfz7zSO9
         RqPXs0OW6CQ+kjB4CNxalOzbqqAS8Ip/Pt+8wxeJlQYS4DNaQRjQhMT9FDqU1mw+Ow
         6rdMC/saz6UvkIf6WM3MFM42lPDCcu5xvDOfuFeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 23/92] PCI: aardvark: Deduplicate code in advk_pcie_rd_conf()
Date:   Mon, 29 Nov 2021 19:17:52 +0100
Message-Id: <20211129181708.184405459@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit 67cb2a4c93499c2c22704998fd1fd2bc35194d8e upstream.

Avoid code repetition in advk_pcie_rd_conf() by handling errors with
goto jump, as is customary in kernel.

Link: https://lore.kernel.org/r/20211005180952.6812-9-kabel@kernel.org
Fixes: 43f5c77bcbd2 ("PCI: aardvark: Fix reporting CRS value")
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |   48 ++++++++++++++--------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -773,18 +773,8 @@ static int advk_pcie_rd_conf(struct pci_
 		    (le16_to_cpu(pcie->bridge.pcie_conf.rootctl) &
 		     PCI_EXP_RTCTL_CRSSVE);
 
-	if (advk_pcie_pio_is_running(pcie)) {
-		/*
-		 * If it is possible return Completion Retry Status so caller
-		 * tries to issue the request again instead of failing.
-		 */
-		if (allow_crs) {
-			*val = CFG_RD_CRS_VAL;
-			return PCIBIOS_SUCCESSFUL;
-		}
-		*val = 0xffffffff;
-		return PCIBIOS_SET_FAILED;
-	}
+	if (advk_pcie_pio_is_running(pcie))
+		goto try_crs;
 
 	/* Program the control register */
 	reg = advk_readl(pcie, PIO_CTRL);
@@ -808,25 +798,13 @@ static int advk_pcie_rd_conf(struct pci_
 	advk_writel(pcie, 1, PIO_START);
 
 	ret = advk_pcie_wait_pio(pcie);
-	if (ret < 0) {
-		/*
-		 * If it is possible return Completion Retry Status so caller
-		 * tries to issue the request again instead of failing.
-		 */
-		if (allow_crs) {
-			*val = CFG_RD_CRS_VAL;
-			return PCIBIOS_SUCCESSFUL;
-		}
-		*val = 0xffffffff;
-		return PCIBIOS_SET_FAILED;
-	}
+	if (ret < 0)
+		goto try_crs;
 
 	/* Check PIO status and get the read result */
 	ret = advk_pcie_check_pio_status(pcie, allow_crs, val);
-	if (ret < 0) {
-		*val = 0xffffffff;
-		return PCIBIOS_SET_FAILED;
-	}
+	if (ret < 0)
+		goto fail;
 
 	if (size == 1)
 		*val = (*val >> (8 * (where & 3))) & 0xff;
@@ -834,6 +812,20 @@ static int advk_pcie_rd_conf(struct pci_
 		*val = (*val >> (8 * (where & 3))) & 0xffff;
 
 	return PCIBIOS_SUCCESSFUL;
+
+try_crs:
+	/*
+	 * If it is possible, return Completion Retry Status so that caller
+	 * tries to issue the request again instead of failing.
+	 */
+	if (allow_crs) {
+		*val = CFG_RD_CRS_VAL;
+		return PCIBIOS_SUCCESSFUL;
+	}
+
+fail:
+	*val = 0xffffffff;
+	return PCIBIOS_SET_FAILED;
 }
 
 static int advk_pcie_wr_conf(struct pci_bus *bus, u32 devfn,


