Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259FD55C47E
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbiF0Lnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbiF0Lmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC86D77;
        Mon, 27 Jun 2022 04:37:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9643CB8111E;
        Mon, 27 Jun 2022 11:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03E6C3411D;
        Mon, 27 Jun 2022 11:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329820;
        bh=/yUr5kOLGptxvdwwPg9SpLafIzbLfy8B2/nwoGPtK9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWpSiz4FUa4Xd6RG/T49O0jcH/4WL3FEIAsn4nuGX8xvITjbda2pZZPt85XjUX/4K
         PDEict92ThG1NSaXzGekcBalZU42SCMIpQl/EmtlTkpWY0dMjEaTHvkx+K1qVXK4zu
         5HaZ6ySFFFv+6W+DwNuwlJ93zHvS8OU9gmbHmxhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Utkarsh Patel <utkarsh.h.patel@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 086/135] xhci-pci: Allow host runtime PM as default for Intel Meteor Lake xHCI
Date:   Mon, 27 Jun 2022 13:21:33 +0200
Message-Id: <20220627111940.655568542@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Utkarsh Patel <utkarsh.h.patel@intel.com>

commit 8ffdc53a60049f3930afe161dc51c67959c8d83d upstream.

Meteor Lake TCSS(Type-C Subsystem) xHCI needs to be runtime suspended
whenever possible to allow the TCSS hardware block to enter D3cold and
thus save energy.

Cc: stable@kernel.org
Signed-off-by: Utkarsh Patel <utkarsh.h.patel@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220623111945.1557702-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -62,6 +62,7 @@
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_XHCI		0x464e
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI	0x51ed
 #define PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_XHCI		0xa71e
+#define PCI_DEVICE_ID_INTEL_METEOR_LAKE_XHCI		0x7ec0
 
 #define PCI_DEVICE_ID_AMD_RENOIR_XHCI			0x1639
 #define PCI_DEVICE_ID_AMD_PROMONTORYA_4			0x43b9
@@ -272,7 +273,8 @@ static void xhci_pci_quirks(struct devic
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_N_XHCI ||
 	     pdev->device == PCI_DEVICE_ID_INTEL_ALDER_LAKE_PCH_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_XHCI))
+	     pdev->device == PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_METEOR_LAKE_XHCI))
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&


