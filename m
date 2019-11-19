Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1AAD1017C6
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbfKSFjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:39:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730261AbfKSFjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:39:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F31A0208C3;
        Tue, 19 Nov 2019 05:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141962;
        bh=8GO4XkRygHmVTWKvH9SbwPX3T6ChRn2RDaOvhj0FWc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOG8xJVyYoAq25TWT9qpI5xTIvXIH+JdQRgIrjOpZ0Sm7PK+zZV6EdGIa8PHj1Cjw
         rY36gSWuKZ6q7pxCIsNRmmMXG84QxSUkYKhfKxsnuxNT7Zu8Oa8cX8m8GcgaKhdUBV
         0TUUQvVrw0hlZcY7/mp9FdmM0rZ+Jb5nJPmwAvo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <keith.busch@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 313/422] PCI/AER: Take reference on error devices
Date:   Tue, 19 Nov 2019 06:18:30 +0100
Message-Id: <20191119051419.277615903@linuxfoundation.org>
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



