Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF11166C4B1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbjAPP5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjAPP5W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFAF234E6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:57:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77633B81059
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63F2C433D2;
        Mon, 16 Jan 2023 15:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884626;
        bh=p4Sbr1+I9ttFCLR0Tb168e7EZbLr0+yL75HP8U+Uh+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lAG0a5TMp86EYFee17b2T089iOFOS2JYWYCVxGq052P3RWRJBWIsPyYuqTpGvBkOL
         8H+/E5nqURTBbLesLZ5q3YbBVFjll63BqEc42YKcpzaq1wJqfAO/J+HiOKwh6kfleB
         KT4blVEzwo2lWuuciapBfCDrCrLjni2K+8cnu45A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 6.1 070/183] ixgbe: fix pci device refcount leak
Date:   Mon, 16 Jan 2023 16:49:53 +0100
Message-Id: <20230116154806.321733141@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit b93fb4405fcb5112c5739c5349afb52ec7f15c07 upstream.

As the comment of pci_get_domain_bus_and_slot() says, it
returns a PCI device with refcount incremented, when finish
using it, the caller must decrement the reference count by
calling pci_dev_put().

In ixgbe_get_first_secondary_devfn() and ixgbe_x550em_a_has_mii(),
pci_dev_put() is called to avoid leak.

Fixes: 8fa10ef01260 ("ixgbe: register a mdiobus")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -855,9 +855,11 @@ static struct pci_dev *ixgbe_get_first_s
 	rp_pdev = pci_get_domain_bus_and_slot(0, 0, devfn);
 	if (rp_pdev && rp_pdev->subordinate) {
 		bus = rp_pdev->subordinate->number;
+		pci_dev_put(rp_pdev);
 		return pci_get_domain_bus_and_slot(0, bus, 0);
 	}
 
+	pci_dev_put(rp_pdev);
 	return NULL;
 }
 
@@ -874,6 +876,7 @@ static bool ixgbe_x550em_a_has_mii(struc
 	struct ixgbe_adapter *adapter = hw->back;
 	struct pci_dev *pdev = adapter->pdev;
 	struct pci_dev *func0_pdev;
+	bool has_mii = false;
 
 	/* For the C3000 family of SoCs (x550em_a) the internal ixgbe devices
 	 * are always downstream of root ports @ 0000:00:16.0 & 0000:00:17.0
@@ -884,15 +887,16 @@ static bool ixgbe_x550em_a_has_mii(struc
 	func0_pdev = ixgbe_get_first_secondary_devfn(PCI_DEVFN(0x16, 0));
 	if (func0_pdev) {
 		if (func0_pdev == pdev)
-			return true;
-		else
-			return false;
+			has_mii = true;
+		goto out;
 	}
 	func0_pdev = ixgbe_get_first_secondary_devfn(PCI_DEVFN(0x17, 0));
 	if (func0_pdev == pdev)
-		return true;
+		has_mii = true;
 
-	return false;
+out:
+	pci_dev_put(func0_pdev);
+	return has_mii;
 }
 
 /**


