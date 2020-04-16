Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F05B1ACB8A
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbgDPPsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896712AbgDPNd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:33:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 567AE21D91;
        Thu, 16 Apr 2020 13:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044005;
        bh=Gs1eguIB+STlCGpdeVeI2MCI/YDexRL4AJkRKfer9Ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PeeKLvCM1D7qsEeOVkprgOV5qaZzJuVT+vrBRUkU18E8OMVS+lFeRhjk8mTVcVkdw
         K5cNyCFFLpVYzqy5gDqBqY5dpueR+uKA5bbX1fi/kTrTBlwCb728u+Mfz32ExLjvrJ
         UFbScpuuPrF21MPk7Fr4FUImCDB8NG7aoS9tttrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 043/257] ACPI: EC: Do not clear boot_ec_is_ecdt in acpi_ec_add()
Date:   Thu, 16 Apr 2020 15:21:34 +0200
Message-Id: <20200416131331.318536376@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 65a691f5f8f0bb63d6a82eec7b0ffd193d8d8a5f ]

The reason for clearing boot_ec_is_ecdt in acpi_ec_add() (if a
PNP0C09 device object matching the ECDT boot EC had been found in
the namespace) was to cause acpi_ec_ecdt_start() to return early,
but since the latter does not look at boot_ec_is_ecdt any more,
acpi_ec_add() need not clear it.

Moreover, doing that may be confusing as it may cause "DSDT" to be
printed instead of "ECDT" in the EC initialization completion
message, so stop doing it.

While at it, split the EC initialization completion message into
two messages, one regarding the boot EC and another one printed
regardless of whether or not the EC at hand is the boot one.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index bd74c78366759..f351d0711e495 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1649,7 +1649,6 @@ static int acpi_ec_add(struct acpi_device *device)
 
 		if (boot_ec && ec->command_addr == boot_ec->command_addr &&
 		    ec->data_addr == boot_ec->data_addr) {
-			boot_ec_is_ecdt = false;
 			/*
 			 * Trust PNP0C09 namespace location rather than
 			 * ECDT ID. But trust ECDT GPE rather than _GPE
@@ -1669,9 +1668,12 @@ static int acpi_ec_add(struct acpi_device *device)
 
 	if (ec == boot_ec)
 		acpi_handle_info(boot_ec->handle,
-				 "Boot %s EC used to handle transactions and events\n",
+				 "Boot %s EC initialization complete\n",
 				 boot_ec_is_ecdt ? "ECDT" : "DSDT");
 
+	acpi_handle_info(ec->handle,
+			 "EC: Used to handle transactions and events\n");
+
 	device->driver_data = ec;
 
 	ret = !!request_region(ec->data_addr, 1, "EC data");
-- 
2.20.1



