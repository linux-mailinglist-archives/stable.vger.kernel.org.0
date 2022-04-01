Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8081C4EF4D4
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbiDAPDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349344AbiDAOzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:55:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD56296D09;
        Fri,  1 Apr 2022 07:43:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B2BFB8240F;
        Fri,  1 Apr 2022 14:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAE7C3410F;
        Fri,  1 Apr 2022 14:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824194;
        bh=DhyRSmYkqVp0mD9tp8xB/iWyiPaIGIOPXQyeKGIgjq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0gEXG/5Pm8jd3itDCXie8uFubHocODTihS+sAK53stC6mLHspS7quAnRnk8HxNAa
         eUcChCt8+T0fC6tskwVbu4SivBklhJcdJvulX6++hLFznxkvX6cd3B7QqbjwbgpojY
         MLYdlhe8k85Y4Zsn7HQYQ59oMyXS4ern0OUBOoW0bs+5aZi8a7Erov0hnRk7qPWgqv
         aFA7M9tz2Y7qRj/qchPtx3vSUo1C2crmR/QSj4P5WQTXWTeioeqCx0m6J/70LUsDdp
         mzgBKEdb0Od4tqGNTtjqxAXGyw5BqYlJ6boJ0/4y8MQVrYR5prB2vBqpTaaboJDUrr
         gHxjrIh0wVOSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neal Liu <neal_liu@aspeedtech.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 23/65] usb: ehci: add pci device support for Aspeed platforms
Date:   Fri,  1 Apr 2022 10:41:24 -0400
Message-Id: <20220401144206.1953700-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
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
index e87cf3a00fa4..638f03b89739 100644
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
@@ -222,6 +225,12 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
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

