Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A074EF4E9
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348344AbiDAPG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349916AbiDAO6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:58:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D04E16CE6F;
        Fri,  1 Apr 2022 07:45:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A28DEB823EB;
        Fri,  1 Apr 2022 14:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C29C34114;
        Fri,  1 Apr 2022 14:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824325;
        bh=Z0RYCsS8nt4/+zW13jfmCso5zRjttb6hNY1XXbjACOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRzX6rNAl0er2M1mSA23ByLi3i/VV1MY9b825qjT/ruWA+fYhb2M/rEPyjAIG5XfJ
         t2UExYul0QaDBz1ZkaDa73TwBEkWPDEV89hG/frCAS0kc6H53xxnjXGpJ3fznygrze
         wtyAWVITY+Bfgix68CVUTZ9X5Ob9e5rUVbLu3L1UgOl1wZNeYU5qynUaRRcIXs2FSJ
         1sFiBCs/ax1BMhTFZ2paUIqd6W6/gUQsMv4ud8zMzG3koZEbIt9q5sIY51DaXBPmlC
         5iOdciPBwrdKoNDXeNjc3vBZlie+iUBPzvTif+b1b7PtyT/icGQ48expc16wzFoVcx
         uIDVv8fYWQDIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neal Liu <neal_liu@aspeedtech.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/37] usb: ehci: add pci device support for Aspeed platforms
Date:   Fri,  1 Apr 2022 10:44:24 -0400
Message-Id: <20220401144446.1954694-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144446.1954694-1-sashal@kernel.org>
References: <20220401144446.1954694-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neal Liu <neal_liu@aspeedtech.com>

[ Upstream commit c3c9cee592828528fd228b01d312c7526c584a42 ]

Enable Aspeed quirks in commit 7f2d73788d90 ("usb: ehci:
handshake CMD_RUN instead of STS_HALT") to support Aspeed
ehci-pci device.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
Link: https://lore.kernel.org/r/20220208101657.76459-1-neal_liu@aspeedtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 774ccaa5acee..1962140a59f2 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -21,6 +21,9 @@ static const char hcd_name[] = "ehci-pci";
 /* defined here to avoid adding to pci_ids.h for single instance use */
 #define PCI_DEVICE_ID_INTEL_CE4100_USB	0x2e70
 
+#define PCI_VENDOR_ID_ASPEED		0x1a03
+#define PCI_DEVICE_ID_ASPEED_EHCI	0x2603
+
 /*-------------------------------------------------------------------------*/
 #define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
 static inline bool is_intel_quark_x1000(struct pci_dev *pdev)
@@ -223,6 +226,12 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 			ehci->has_synopsys_hc_bug = 1;
 		}
 		break;
+	case PCI_VENDOR_ID_ASPEED:
+		if (pdev->device == PCI_DEVICE_ID_ASPEED_EHCI) {
+			ehci_info(ehci, "applying Aspeed HC workaround\n");
+			ehci->is_aspeed = 1;
+		}
+		break;
 	}
 
 	/* optional debug port, normally in the first BAR */
-- 
2.34.1

