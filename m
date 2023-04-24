Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0826ECE9B
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjDXNdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbjDXNde (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:33:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A714869F
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1A1561E0A
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7935C433D2;
        Mon, 24 Apr 2023 13:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343196;
        bh=IdxEnrIfq9hTKrt+8mXNMRtQp5DEACW2U8+nFUreq70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cL/dQcWbHSjrlMz4mam8+t81O42MYVGaJxdWFdkskZZl2LTZlD8aDNUIh2dvP3zxr
         0jzbWmXcBfBrAIIE4MDn0jvDo+IhkQHa70TWOxDrWptviYpplVbbjihl6aaD6/9UPw
         qTigsfVqoB6CKDI6nnvhWSbrIjgtScrL8EQncxe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Laight <David.Laight@aculab.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.2 100/110] PCI/MSI: Remove over-zealous hardware size check in pci_msix_validate_entries()
Date:   Mon, 24 Apr 2023 15:18:02 +0200
Message-Id: <20230424131140.316756595@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit e3c026be4d3ca046799fde55ccbae9d0f059fb93 upstream.

pci_msix_validate_entries() validates the entries array which is handed in
by the caller for a MSI-X interrupt allocation. Aside of consistency
failures it also detects a failure when the size of the MSI-X hardware table
in the device is smaller than the size of the entries array.

That's wrong for the case of range allocations where the caller provides
the minimum and the maximum number of vectors to allocate, when the
hardware size is greater or equal than the mininum, but smaller than the
maximum.

Remove the hardware size check completely from that function and just
ensure that the entires array up to the maximum size is consistent.

The limitation and range checking versus the hardware size happens
independently of that afterwards anyway because the entries array is
optional.

Fixes: 4644d22eb673 ("PCI/MSI: Validate MSI-X contiguous restriction early")
Reported-by: David Laight <David.Laight@aculab.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87v8i3sg62.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi/msi.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/msi/msi.c b/drivers/pci/msi/msi.c
index 1f716624ca56..ef1d8857a51b 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -750,8 +750,7 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 	return ret;
 }
 
-static bool pci_msix_validate_entries(struct pci_dev *dev, struct msix_entry *entries,
-				      int nvec, int hwsize)
+static bool pci_msix_validate_entries(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 {
 	bool nogap;
 	int i, j;
@@ -762,10 +761,6 @@ static bool pci_msix_validate_entries(struct pci_dev *dev, struct msix_entry *en
 	nogap = pci_msi_domain_supports(dev, MSI_FLAG_MSIX_CONTIGUOUS, DENY_LEGACY);
 
 	for (i = 0; i < nvec; i++) {
-		/* Entry within hardware limit? */
-		if (entries[i].entry >= hwsize)
-			return false;
-
 		/* Check for duplicate entries */
 		for (j = i + 1; j < nvec; j++) {
 			if (entries[i].entry == entries[j].entry)
@@ -805,7 +800,7 @@ int __pci_enable_msix_range(struct pci_dev *dev, struct msix_entry *entries, int
 	if (hwsize < 0)
 		return hwsize;
 
-	if (!pci_msix_validate_entries(dev, entries, nvec, hwsize))
+	if (!pci_msix_validate_entries(dev, entries, nvec))
 		return -EINVAL;
 
 	if (hwsize < nvec) {
-- 
2.40.0



