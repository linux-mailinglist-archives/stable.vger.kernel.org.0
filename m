Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43202615994
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiKBDOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiKBDNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:13:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AB9D66
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:13:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00E3061799
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8990AC433D6;
        Wed,  2 Nov 2022 03:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358804;
        bh=iml2isc0vHufbEf7bmvep1T2WGSOKOuuBi9kTP4YA68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vVjFqbClE2rHQ84n9EuEo5Ha/J1tKP4YGSwPzr01gyjDTUKdO4CQN7S3jQ+YzQ+iB
         WqIyzh6tX9TATM/MaTtKXYzAKh8akHuic+XeiYYVYUafurFR+iCticJgKEUrDX03yI
         G9q/gOHFzAtZejDud/450EPL59zwmWwkyVlZwmKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jens Glathe <jens.glathe@oldschoolsolutions.biz>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 10/91] usb: xhci: add XHCI_SPURIOUS_SUCCESS to ASM1042 despite being a V0.96 controller
Date:   Wed,  2 Nov 2022 03:32:53 +0100
Message-Id: <20221102022055.338110532@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Glathe <jens.glathe@oldschoolsolutions.biz>

commit 4f547472380136718b56064ea5689a61e135f904 upstream.

This appears to fix the error:
"xhci_hcd <address>; ERROR Transfer event TRB DMA ptr not part of
current TD ep_index 2 comp_code 13" that appear spuriously (or pretty
often) when using a r8152 USB3 ethernet adapter with integrated hub.

ASM1042 reports as a 0.96 controller, but appears to behave more like 1.0

Inspired by this email thread: https://markmail.org/thread/7vzqbe7t6du6qsw3

Cc: stable@vger.kernel.org
Signed-off-by: Jens Glathe <jens.glathe@oldschoolsolutions.biz>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20221024142720.4122053-2-mathias.nyman@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -302,8 +302,14 @@ static void xhci_pci_quirks(struct devic
 	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
-		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI)
+		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI) {
+		/*
+		 * try to tame the ASMedia 1042 controller which reports 0.96
+		 * but appears to behave more like 1.0
+		 */
+		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
+	}
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042A_XHCI) {
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;


