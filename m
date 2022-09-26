Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143735E9FDF
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbiIZKah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235871AbiIZK31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:29:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FE1A4;
        Mon, 26 Sep 2022 03:19:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E39D9B80918;
        Mon, 26 Sep 2022 10:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F93C433C1;
        Mon, 26 Sep 2022 10:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187571;
        bh=cunuopUqk2Evaz2JERyZfUP05fYhKKKEXN2E3X1JHFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kr4Ns4v2SLnWI6Umz2tlWuV6NhxULkIuUHgmiSyHgdTsL/fjQfC8wLvUyD7rb6mtT
         it+rVRFVzqcjloV125aS04jlpiYNnrWtf17hQ3aSIKvZ0hhXtv/7gDntkesstqjA77
         kgT+B8pc91pwTjdB8Lv9rw9Y3IC3kegak+HkWbls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/58] usb: dwc3: pci: Add Support for Intel Elkhart Lake Devices
Date:   Mon, 26 Sep 2022 12:11:38 +0200
Message-Id: <20220926100742.142523645@linuxfoundation.org>
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

From: Felipe Balbi <felipe.balbi@linux.intel.com>

[ Upstream commit dbb0569de852fb4576d6f62078d515f989a181ca ]

This patch simply adds a new PCI Device ID

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Stable-dep-of: bad0d1d726ac ("usb: dwc3: pci: Add support for Intel Raptor Lake")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 527938eee846..5d5166373aa1 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -36,6 +36,7 @@
 #define PCI_DEVICE_ID_INTEL_CNPH		0xa36e
 #define PCI_DEVICE_ID_INTEL_CNPV		0xa3b0
 #define PCI_DEVICE_ID_INTEL_ICLLP		0x34ee
+#define PCI_DEVICE_ID_INTEL_EHLLP		0x4b7e
 
 #define PCI_INTEL_BXT_DSM_GUID		"732b85d5-b7a7-4a1b-9ba0-4bbd00ffd511"
 #define PCI_INTEL_BXT_FUNC_PMU_PWR	4
@@ -351,6 +352,9 @@ static const struct pci_device_id dwc3_pci_id_table[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICLLP),
 	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_EHLLP),
+	  (kernel_ulong_t) &dwc3_pci_intel_properties, },
+
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_NL_USB),
 	  (kernel_ulong_t) &dwc3_pci_amd_properties, },
 	{  }	/* Terminating Entry */
-- 
2.35.1



