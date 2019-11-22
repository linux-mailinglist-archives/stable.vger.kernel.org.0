Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5739107129
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfKVL07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:26:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbfKVKd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:33:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7DDD20708;
        Fri, 22 Nov 2019 10:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418807;
        bh=iuc+CW/MwNh7Z3Nj4jlGrhbfNy6HZQZso3XrQC80OqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPW46oR1Zbqv0eiSMc85mzF4ch7f5aFlz97oZ5NRQZ7SBC187xMU+A7WGBWvt7IO2
         vM50OTUKcNaTgdMQwZBE1QEY9sVsQRh0TV5N+NuwK4yVOF2Aua7r1uVUzoGFIqC0u6
         YPut7fXd2O9pZb9MgzPRwtvrt/TRLzd5ZXtXU9A8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Sinan Kaya <okaya@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 057/159] PCI/ACPI: Correct error message for ASPM disabling
Date:   Fri, 22 Nov 2019 11:27:28 +0100
Message-Id: <20191122100749.437814451@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sinan Kaya <okaya@kernel.org>

[ Upstream commit 1ad61b612b95980a4d970c52022aa01dfc0f6068 ]

If _OSC execution fails today for platforms without an _OSC entry, code is
printing a misleading message saying disabling ASPM as follows:

  acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM

We need to ensure that platform supports ASPM to begin with.

Reported-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Sinan Kaya <okaya@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_root.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 3b0b4bd67b71b..4031ec8024cee 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -454,8 +454,9 @@ static void negotiate_os_control(struct acpi_pci_root *root, int *no_aspm)
 	decode_osc_support(root, "OS supports", support);
 	status = acpi_pci_osc_support(root, support);
 	if (ACPI_FAILURE(status)) {
-		dev_info(&device->dev, "_OSC failed (%s); disabling ASPM\n",
-			 acpi_format_exception(status));
+		dev_info(&device->dev, "_OSC failed (%s)%s\n",
+			 acpi_format_exception(status),
+			 pcie_aspm_support_enabled() ? "; disabling ASPM" : "");
 		*no_aspm = 1;
 		return;
 	}
-- 
2.20.1



