Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD052594E5
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731729AbgIAPoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731738AbgIAPoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:44:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AF01208CA;
        Tue,  1 Sep 2020 15:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975052;
        bh=lAj3qZgHlA9VpgwQn7Vfkt8qFHZHHDRIsHCNYvGNVeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUUWJHHX0C9tZn4neLNFG8y4kgedE30f/GoEl4xw8Ig2AOgrD+KiWpopvvrx7zMB8
         Qtd0pv2I7Kw4xNkHFmjfLAllRf4SkbBch3e+sERyyAN+NLTV48IkFsxQENUD6/OxZR
         g1gNvvZ7Zsjf0W0ZhzVPR2yEl7bAalJMjzANbeVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.8 191/255] usb: renesas-xhci: remove version check
Date:   Tue,  1 Sep 2020 17:10:47 +0200
Message-Id: <20200901151009.842792325@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

commit d66a57be2f9a315fc10d0f524f670fec903e0fb4 upstream.

Some devices in wild are reporting bunch of firmware versions, so remove
the check for versions in driver

Reported by: Anastasios Vacharakis <vacharakis@gmail.com>
Reported by: Glen Journeay <journeay@gmail.com>
Fixes: 2478be82de44 ("usb: renesas-xhci: Add ROM loader for uPD720201")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=208911
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200818071739.789720-1-vkoul@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci-renesas.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- a/drivers/usb/host/xhci-pci-renesas.c
+++ b/drivers/usb/host/xhci-pci-renesas.c
@@ -50,20 +50,6 @@
 #define RENESAS_RETRY	10000
 #define RENESAS_DELAY	10
 
-#define ROM_VALID_01 0x2013
-#define ROM_VALID_02 0x2026
-
-static int renesas_verify_fw_version(struct pci_dev *pdev, u32 version)
-{
-	switch (version) {
-	case ROM_VALID_01:
-	case ROM_VALID_02:
-		return 0;
-	}
-	dev_err(&pdev->dev, "FW has invalid version :%d\n", version);
-	return -EINVAL;
-}
-
 static int renesas_fw_download_image(struct pci_dev *dev,
 				     const u32 *fw, size_t step, bool rom)
 {
@@ -202,10 +188,7 @@ static int renesas_check_rom_state(struc
 
 	version &= RENESAS_FW_VERSION_FIELD;
 	version = version >> RENESAS_FW_VERSION_OFFSET;
-
-	err = renesas_verify_fw_version(pdev, version);
-	if (err)
-		return err;
+	dev_dbg(&pdev->dev, "Found ROM version: %x\n", version);
 
 	/*
 	 * Test if ROM is present and loaded, if so we can skip everything


