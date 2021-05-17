Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46977383803
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245305AbhEQPsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345037AbhEQPqO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:46:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 130BC61D28;
        Mon, 17 May 2021 14:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262661;
        bh=mSJUEB90YnJUWJ8lpzoiOGZB0zh1GB/zCSArtgyYiQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYH2t1gIBsA3z82Df+GSOfrsSBBXRz+n9y/prTuDICp0rLB/Kx9diaRr7twa60SOS
         OkO4xYggRM+LTdZNcPPP0ZJH1b85D/WDOg6zp+psiuRRqiAJYQQbNGuOhf8Xe1w0oN
         BUD1V2A+RosEYuGPCxd+cRvQPS/ULHgfifOa44hU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandeep Singh <sandeep.singh@amd.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 251/289] xhci: Add reset resume quirk for AMD xhci controller.
Date:   Mon, 17 May 2021 16:02:56 +0200
Message-Id: <20210517140313.594670412@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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


