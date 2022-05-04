Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECE351A6AB
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354340AbiEDQ5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354368AbiEDQ5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:57:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786DC49F2F;
        Wed,  4 May 2022 09:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9E83B827A2;
        Wed,  4 May 2022 16:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4818CC385AF;
        Wed,  4 May 2022 16:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682993;
        bh=+5sO8A4SCcVNYHESQuZJ1neYMuO5NHBNZuzxle12Owg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2Dv46GYthw7zt++gIo+jYqh98JNrfDb4ukycJiZrJKU9+9I/I/WQUGl9kmsGDAsM
         SGxZwsBm0UThn27kVDfbmM7az/ZqNREwHJUlGGN8b7ApPkxnKuNfXh8vs1vRXnlWgj
         KWTYfu+j94bg0s3OXobivhlPKkVrO3G2W8x9F23g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        stable <stable@kernel.org>
Subject: [PATCH 5.10 010/129] xhci: Enable runtime PM on second Alderlake controller
Date:   Wed,  4 May 2022 18:43:22 +0200
Message-Id: <20220504153022.161471590@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Green <evgreen@chromium.org>

commit d8bfe5091d6cc4b8b8395e4666979ae72a6069ca upstream.

Alderlake has two XHCI controllers with PCI IDs 0x461e and 0x51ed. We
had previously added the quirk to default enable runtime PM for 0x461e,
now add it for 0x51ed as well.

Signed-off-by: Evan Green <evgreen@chromium.org>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220408114225.1.Ibcff6b86ed4eacfe4c4bc89c90e18416f3900a3e@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -59,6 +59,7 @@
 #define PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI		0x9a13
 #define PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI		0x1138
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI		0x461e
+#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI	0x51ed
 
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_3			0x43ba
@@ -261,7 +262,8 @@ static void xhci_pci_quirks(struct devic
 	     pdev->device == PCI_DEVICE_ID_INTEL_ICE_LAKE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_TIGER_LAKE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_MAPLE_RIDGE_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI))
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI))
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&


