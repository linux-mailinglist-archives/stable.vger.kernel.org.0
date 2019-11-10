Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89689F6657
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfKJDNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:13:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbfKJCmt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:42:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B5DF21655;
        Sun, 10 Nov 2019 02:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353769;
        bh=AaJ/mLERXI2BGShxQaRJWcyC7zaq2lLv8vFC69G+pfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6I/M2HCzhECfnvb54W8gn3qSm8JtGPXKY2Ma6XPbmHaau5ndejYWVvgv1V1oH3tF
         JoAal4m1aw5OqsHvva/pP5UsbAlkOF2kILwTZeVrYjpiq57wJpW2QlcgpAVQft3ytU
         ZoIPx9xZtFq7t0oxOykdD2RzLTOkEuHUdVIZbgdc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <keith.busch@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 080/191] PCI/AER: Don't read upstream ports below fatal errors
Date:   Sat,  9 Nov 2019 21:38:22 -0500
Message-Id: <20191110024013.29782-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <keith.busch@intel.com>

[ Upstream commit 9d938ea53b265ed6df6cdd1715d971f0235fdbfc ]

The AER driver has never read the config space of an endpoint that reported
a fatal error because the link to that device is considered unreliable.

An ERR_FATAL from an upstream port almost certainly indicates an error on
its upstream link, so we can't expect to reliably read its config space for
the same reason.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Sinan Kaya <okaya@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index ffbbd759683c5..5c3ea7254c6ae 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1116,8 +1116,9 @@ int aer_get_device_error_info(struct pci_dev *dev, struct aer_err_info *info)
 			&info->mask);
 		if (!(info->status & ~info->mask))
 			return 0;
-	} else if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
-		info->severity == AER_NONFATAL) {
+	} else if (pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT ||
+	           pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM ||
+		   info->severity == AER_NONFATAL) {
 
 		/* Link is still healthy for IO reads */
 		pci_read_config_dword(dev, pos + PCI_ERR_UNCOR_STATUS,
-- 
2.20.1

