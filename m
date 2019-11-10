Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027CAF6261
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfKJCms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:42:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727974AbfKJCms (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:42:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA54F21848;
        Sun, 10 Nov 2019 02:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353767;
        bh=8GO4XkRygHmVTWKvH9SbwPX3T6ChRn2RDaOvhj0FWc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IgFSrB+yh4W0GvXVRhb3f2yzSKXf7Yt61ofrKRC57OCrhkQjoOUwrIjaebs5nekhC
         fdsQsXOkTlQ4W2eBU2yastYGtG0osWFlJuWYDxquWZR9450hKxaWqWVwRD67Cq8/gD
         d88eo51RF2n3Q/b/ZP6Sw4korhj7n9pfpdxO1U7E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <keith.busch@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 079/191] PCI/AER: Take reference on error devices
Date:   Sat,  9 Nov 2019 21:38:21 -0500
Message-Id: <20191110024013.29782-79-sashal@kernel.org>
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

[ Upstream commit 60271ab044a53edb9dcbe76bebea2221c4ff04d9 ]

Error handling may be running in parallel with a hot removal.  Reference
count the device during AER handling so the device can not be freed while
AER wants to reference it.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Sinan Kaya <okaya@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 637d638f73da5..ffbbd759683c5 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -866,7 +866,7 @@ void cper_print_aer(struct pci_dev *dev, int aer_severity,
 static int add_error_device(struct aer_err_info *e_info, struct pci_dev *dev)
 {
 	if (e_info->error_dev_num < AER_MAX_MULTI_ERR_DEVICES) {
-		e_info->dev[e_info->error_dev_num] = dev;
+		e_info->dev[e_info->error_dev_num] = pci_dev_get(dev);
 		e_info->error_dev_num++;
 		return 0;
 	}
@@ -1013,6 +1013,7 @@ static void handle_error_source(struct pci_dev *dev, struct aer_err_info *info)
 		pcie_do_nonfatal_recovery(dev);
 	else if (info->severity == AER_FATAL)
 		pcie_do_fatal_recovery(dev, PCIE_PORT_SERVICE_AER);
+	pci_dev_put(dev);
 }
 
 #ifdef CONFIG_ACPI_APEI_PCIEAER
-- 
2.20.1

