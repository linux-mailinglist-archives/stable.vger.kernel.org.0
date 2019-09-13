Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09434B1F92
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389666AbfIMNUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389469AbfIMNUi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:20:38 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8421206BB;
        Fri, 13 Sep 2019 13:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380836;
        bh=w9rMOSJJjyio0AAEDtCnA2QRY8NZqeOX69wnXBT1yE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhGUfW7g8FCAKQGhwWOBEG7oWeUYLfkNQnJqAXlwRa40YjsbASLsdVcKTZGv6lyV+
         kIUddXs5jqc9nziA8v/oGBJSekUUWjMSMRN+MHu8yCrhMjRO9fABk9t9VtemrdXCjl
         MYVD9n0vSeXewtyzzq2eANUVAG7KwhuzLay9HpTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Lukas Wunner <lukas@wunner.de>,
        Daniel Drake <drake@endlessm.com>,
        Aaron Plattner <aplattner@nvidia.com>,
        Peter Wu <peter@lekensteyn.nl>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Karol Herbst <kherbst@redhat.com>,
        Maik Freudenberg <hhfeuer@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 186/190] PCI: Reset both NVIDIA GPU and HDA in ThinkPad P50 workaround
Date:   Fri, 13 Sep 2019 14:07:21 +0100
Message-Id: <20190913130614.757255328@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ad54567ad5d8e938ee6cf02e4f3867f18835ae6e ]

quirk_reset_lenovo_thinkpad_50_nvgpu() resets NVIDIA GPUs to work around
an apparent BIOS defect.  It previously used pci_reset_function(), and
the available method was a bus reset, which was fine because there was
only one function on the bus.  After b516ea586d71 ("PCI: Enable NVIDIA
HDA controllers"), there are now two functions (the HDA controller and
the GPU itself) on the bus, so the reset fails.

Use pci_reset_bus() explicitly instead of pci_reset_function() since it's
OK to reset both devices.

[bhelgaas: commit log, add e0547c81bfcf]
Fixes: b516ea586d71 ("PCI: Enable NVIDIA HDA controllers")
Fixes: e0547c81bfcf ("PCI: Reset Lenovo ThinkPad P50 nvgpu at boot if necessary")
Link: https://lore.kernel.org/r/20190801220117.14952-1-lyude@redhat.com
Signed-off-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Daniel Drake <drake@endlessm.com>
Cc: Aaron Plattner <aplattner@nvidia.com>
Cc: Peter Wu <peter@lekensteyn.nl>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Maik Freudenberg <hhfeuer@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 311f8a33e62ff..06be52912dcdb 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5162,7 +5162,7 @@ static void quirk_reset_lenovo_thinkpad_p50_nvgpu(struct pci_dev *pdev)
 	 */
 	if (ioread32(map + 0x2240c) & 0x2) {
 		pci_info(pdev, FW_BUG "GPU left initialized by EFI, resetting\n");
-		ret = pci_reset_function(pdev);
+		ret = pci_reset_bus(pdev);
 		if (ret < 0)
 			pci_err(pdev, "Failed to reset GPU: %d\n", ret);
 	}
-- 
2.20.1



