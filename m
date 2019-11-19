Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB78B1017BD
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbfKSFj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:39:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:33970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729029AbfKSFjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:39:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15284208C3;
        Tue, 19 Nov 2019 05:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141994;
        bh=AaJ/mLERXI2BGShxQaRJWcyC7zaq2lLv8vFC69G+pfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKzYOh//kxh9GSnW1xCYcpIeUsu2EzSyVNttwyK2G1R3XoPOTx+tF1qtE6JntH2xq
         ylvygpXODpkqNa/S+yJhn4M5ONx37Lt6SSRYHvb1hMqa0jo4cU0cEK0TF4BdieqlIE
         9gKUdXpSLSv4M3/GZ3/qObS2+uAx48nTVefp4wMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <keith.busch@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 314/422] PCI/AER: Dont read upstream ports below fatal errors
Date:   Tue, 19 Nov 2019 06:18:31 +0100
Message-Id: <20191119051419.342944237@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



