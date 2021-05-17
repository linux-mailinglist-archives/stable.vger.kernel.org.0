Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B589038323B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240857AbhEQOqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240360AbhEQOnj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:43:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49FE961952;
        Mon, 17 May 2021 14:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261229;
        bh=mSJUEB90YnJUWJ8lpzoiOGZB0zh1GB/zCSArtgyYiQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HYWy2q4SHLvR4XrPq9IqUF72wmGwGYbWE//opsIInu8wLHlTGkNoGCWqtZ9iDpIMi
         HXMndkR3SIAsX5tPJpTo1rPJVpUeyu36ttjJYfGEZ8vs3MrHaa9nz/FiFCwoC6nhgO
         u0FDkqxcaqy5Hamkv7vIvX1S/0ihk42O32+B4rWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandeep Singh <sandeep.singh@amd.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.12 322/363] xhci: Add reset resume quirk for AMD xhci controller.
Date:   Mon, 17 May 2021 16:03:08 +0200
Message-Id: <20210517140313.485243999@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandeep Singh <sandeep.singh@amd.com>

commit 3c128781d8da463761495aaf8898c9ecb4e71528 upstream.

One of AMD xhci controller require reset on resume.
Occasionally AMD xhci controller does not respond to
Stop endpoint command.
Once the issue happens controller goes into bad state
and in that case controller needs to be reset.

Cc: <stable@vger.kernel.org>
Signed-off-by: Sandeep Singh <sandeep.singh@amd.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210512080816.866037-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -167,8 +167,10 @@ static void xhci_pci_quirks(struct devic
 	    (pdev->device == 0x15e0 || pdev->device == 0x15e1))
 		xhci->quirks |= XHCI_SNPS_BROKEN_SUSPEND;
 
-	if (pdev->vendor == PCI_VENDOR_ID_AMD && pdev->device == 0x15e5)
+	if (pdev->vendor == PCI_VENDOR_ID_AMD && pdev->device == 0x15e5) {
 		xhci->quirks |= XHCI_DISABLE_SPARSE;
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
+	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_AMD)
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;


