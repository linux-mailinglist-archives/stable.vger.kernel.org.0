Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503105EA00B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbiIZKc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235712AbiIZKb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:31:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D280311834;
        Mon, 26 Sep 2022 03:20:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFCF3B80918;
        Mon, 26 Sep 2022 10:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E2AC433D6;
        Mon, 26 Sep 2022 10:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187593;
        bh=tlvUgMkU11HBDwNbeCOwRwnKt9TSsz61+tOrT9iIo/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFcl2wG3oak5DYqEM0eHSaSt03/QuvgonV5AMapjnRalRDsY0KMkETXidvoG7C8Ye
         p2y6acdxzVfi7IjUVlqgSQlDcRhRPLXgCew/bmI+Rfvtim44PqnXJrCsLUSMdofFXi
         T8nBXd51tXShDCmoqJhtIBLFfsl6ldtSr7ndzpdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raymond Tan <raymond.tan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.19 58/58] usb: dwc3: pci: Allow Elkhart Lake to utilize DSM method for PM functionality
Date:   Mon, 26 Sep 2022 12:12:17 +0200
Message-Id: <20220926100743.599371856@linuxfoundation.org>
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

From: Raymond Tan <raymond.tan@intel.com>

commit a609ce2a13360d639b384b6ca783b38c1247f2db upstream.

Similar to some other IA platforms, Elkhart Lake too depends on the
PMU register write to request transition of Dx power state.

Thus, we add the PCI_DEVICE_ID_INTEL_EHLLP to the list of devices that
shall execute the ACPI _DSM method during D0/D3 sequence.

[heikki.krogerus@linux.intel.com: included Fixes tag]

Fixes: dbb0569de852 ("usb: dwc3: pci: Add Support for Intel Elkhart Lake Devices")
Cc: stable@vger.kernel.org
Signed-off-by: Raymond Tan <raymond.tan@intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -149,7 +149,8 @@ static int dwc3_pci_quirks(struct dwc3_p
 
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
 		if (pdev->device == PCI_DEVICE_ID_INTEL_BXT ||
-				pdev->device == PCI_DEVICE_ID_INTEL_BXT_M) {
+		    pdev->device == PCI_DEVICE_ID_INTEL_BXT_M ||
+		    pdev->device == PCI_DEVICE_ID_INTEL_EHLLP) {
 			guid_parse(PCI_INTEL_BXT_DSM_GUID, &dwc->guid);
 			dwc->has_dsm_for_pm = true;
 		}


