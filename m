Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601066DEF88
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjDLIvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjDLIve (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:51:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7A0977C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:51:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDD046313B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B03C433D2;
        Wed, 12 Apr 2023 08:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289418;
        bh=v2l6FyqJs0CT+7YwnPNBkgEa65om6F4b14Az2PuqUSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=On1HQGTjvWefWu01YNs3sFHyAR8wOV/Ea+y5t43TVFlHWu8ejjnVbpd4abMpnD1F+
         HnKwYgWi4npuXq1DVtEqcWADvwkKzj4JJDZtFaN2JsyHgzxItHWp7dwc3YBbIm8V2B
         pugOP0B8xPzeYx3gGeqq8/mGXmy8yfdpW39C8gh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.2 061/173] Revert "usb: xhci-pci: Set PROBE_PREFER_ASYNCHRONOUS"
Date:   Wed, 12 Apr 2023 10:33:07 +0200
Message-Id: <20230412082840.562843769@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 8e77d3d59d7b5da13deda1d832c51b8bbdbe2037 upstream.

This reverts commit 4c2604a9a6899bab195edbee35fc8d64ce1444aa.

Asynch probe caused regression in a setup with both Renesas and Intel xHC
controllers. Devices connected to the Renesas disconnected shortly after
boot. With Asynch probe the busnumbers got interleaved.

xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 2
xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 4

Reason why this commit causes regression is still unknown, but revert it
while debugging the issue.

Fixes: 4c2604a9a689 ("usb: xhci-pci: Set PROBE_PREFER_ASYNCHRONOUS")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/linux-usb/20230307132120.5897c5af@deangelis.fenrir.org.uk
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20230330143056.1390020-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index fb988e4ea924..6db07ca419c3 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -771,12 +771,11 @@ static struct pci_driver xhci_pci_driver = {
 	/* suspend and resume implemented later */
 
 	.shutdown = 	usb_hcd_pci_shutdown,
-	.driver = {
 #ifdef CONFIG_PM
-		.pm = &usb_hcd_pci_pm_ops,
-#endif
-		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
+	.driver = {
+		.pm = &usb_hcd_pci_pm_ops
 	},
+#endif
 };
 
 static int __init xhci_pci_init(void)
-- 
2.40.0



