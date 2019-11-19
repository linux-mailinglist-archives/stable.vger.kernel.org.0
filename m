Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99897101833
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbfKSFe2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:34:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729665AbfKSFe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:34:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC52320862;
        Tue, 19 Nov 2019 05:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141667;
        bh=Qm0LlYR6QOexdgjcFK6pfnyQ30ddksaltJsl7gtvWFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfWVEgGJ3pzefJKGkRZU95QgwCwkp0nnaPsPFaT3nQm6HPKAMQ6++LMtSwtWraAOU
         gi+LQwZ4cfhCAaRGggn4YOe70tykuemaJC/J8uOj24PGT10Kd5Yxl8YZ4JH72xc7Iv
         7cq4BFuBuJwY1XufpRkIV4s4Obn97q8iEEuYvwJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Sinan Kaya <okaya@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 240/422] PCI/ACPI: Correct error message for ASPM disabling
Date:   Tue, 19 Nov 2019 06:17:17 +0100
Message-Id: <20191119051414.585379292@linuxfoundation.org>
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
index 7433035ded955..e465e720eab20 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -455,8 +455,9 @@ static void negotiate_os_control(struct acpi_pci_root *root, int *no_aspm)
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



