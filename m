Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D333C5E9FF0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235604AbiIZKbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235523AbiIZK3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:29:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818CD1CFD3;
        Mon, 26 Sep 2022 03:19:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91CA760B5E;
        Mon, 26 Sep 2022 10:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5350FC433C1;
        Mon, 26 Sep 2022 10:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187578;
        bh=YXoY+8Ekv8pDLCFBht7bLPBMrzFnxeNVRxc1tuAOeUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOGNyrO4m91mqAgtQk1nO5SVhc4NJzrp1XI5soSq3rRJ45XtZNavDejp2ne4fCiXr
         QGN9e9mv8H4H++og200DsCCG+ScyWIetP9s2pQzYCBNt3/qZLsnMXVYyni645MmkkP
         i/6JYCs0/TsDZuA/m1j4Vw+2tCWwf7GrpK5qL03E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/58] usb: dwc3: pci: add support for the Intel Tiger Lake PCH -H variant
Date:   Mon, 26 Sep 2022 12:11:40 +0200
Message-Id: <20220926100742.209837549@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit c3f595a8119207cc0f82b3dc6ec5bbf6f3e6b135 ]

This patch adds the necessary PCI ID for TGP-H devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Stable-dep-of: bad0d1d726ac ("usb: dwc3: pci: Add support for Intel Raptor Lake")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 3ca582127f94..cddf02add6f1 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -38,6 +38,7 @@
 #define PCI_DEVICE_ID_INTEL_ICLLP		0x34ee
 #define PCI_DEVICE_ID_INTEL_EHLLP		0x4b7e
 #define PCI_DEVICE_ID_INTEL_TGPLP		0xa0ee
+#define PCI_DEVICE_ID_INTEL_TGPH		0x43ee
 
 #define PCI_INTEL_BXT_DSM_GUID		"732b85d5-b7a7-4a1b-9ba0-4bbd00ffd511"
 #define PCI_INTEL_BXT_FUNC_PMU_PWR	4
@@ -359,6 +360,9 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_TGPLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_TGPH),
+	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
+
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_NL_USB),
 	  (kernel_ulong_t) &dwc3_pci_amd_properties, },
 	{  }	/* Terminating Entry */
-- 
2.35.1



