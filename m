Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8901256F9A9
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiGKJHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiGKJHO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:07:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FF222534;
        Mon, 11 Jul 2022 02:07:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC36FB80E7A;
        Mon, 11 Jul 2022 09:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE9FC341CA;
        Mon, 11 Jul 2022 09:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530423;
        bh=S8GfHA3b6Zbarn8g73Z5/mfjji8h8RDNnKivTthVQsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDnKRZXjolUqS2Qte6wA1MrlslE3M9JCOFicfFSuE14liTX72wtmL3AtQ9umbSfOc
         XCR1aAh1A8CguWAHkJR0tP5qB5/1kSGUbJANc+N9qyvvHpOcwt0cFCoNb63svlgTAb
         B2lJoXG1DcIX3qXo1lpZnfFWrbF5/UuwHCbfcHAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Zhang, Bernice" <bernice.zhang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yian Chen <yian.chen@intel.com>,
        Joerg Roedel <jroedel@suse.de>, Zhang@vger.kernel.org
Subject: [PATCH 4.9 06/14] iommu/vt-d: Fix PCI bus rescan device hot add
Date:   Mon, 11 Jul 2022 11:06:25 +0200
Message-Id: <20220711090535.707526215@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090535.517697227@linuxfoundation.org>
References: <20220711090535.517697227@linuxfoundation.org>
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

From: Yian Chen <yian.chen@intel.com>

commit 316f92a705a4c2bf4712135180d56f3cca09243a upstream.

Notifier calling chain uses priority to determine the execution
order of the notifiers or listeners registered to the chain.
PCI bus device hot add utilizes the notification mechanism.

The current code sets low priority (INT_MIN) to Intel
dmar_pci_bus_notifier and postpones DMAR decoding after adding
new device into IOMMU. The result is that struct device pointer
cannot be found in DRHD search for the new device's DMAR/IOMMU.
Subsequently, the device is put under the "catch-all" IOMMU
instead of the correct one. This could cause system hang when
device TLB invalidation is sent to the wrong IOMMU. Invalidation
timeout error and hard lockup have been observed and data
inconsistency/crush may occur as well.

This patch fixes the issue by setting a positive priority(1) for
dmar_pci_bus_notifier while the priority of IOMMU bus notifier
uses the default value(0), therefore DMAR decoding will be in
advance of DRHD search for a new device to find the correct IOMMU.

Following is a 2-step example that triggers the bug by simulating
PCI device hot add behavior in Intel Sapphire Rapids server.

echo 1 > /sys/bus/pci/devices/0000:6a:01.0/remove
echo 1 > /sys/bus/pci/rescan

Fixes: 59ce0515cdaf ("iommu/vt-d: Update DRHD/RMRR/ATSR device scope")
Cc: stable@vger.kernel.org # v3.15+
Reported-by: Zhang, Bernice <bernice.zhang@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Yian Chen <yian.chen@intel.com>
Link: https://lore.kernel.org/r/20220521002115.1624069-1-yian.chen@intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/dmar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -373,7 +373,7 @@ static int dmar_pci_bus_notifier(struct
 
 static struct notifier_block dmar_pci_bus_nb = {
 	.notifier_call = dmar_pci_bus_notifier,
-	.priority = INT_MIN,
+	.priority = 1,
 };
 
 static struct dmar_drhd_unit *


