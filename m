Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38418CA9F2
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388265AbfJCQRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:17:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389143AbfJCQRG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:17:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F9E92133F;
        Thu,  3 Oct 2019 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119425;
        bh=2ZDyCA/W82QMIcVj4QKv0dW3+M4TLs0nbEMoSYY3yjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoQU3yfyu5tFfWIJPo/W1V9yItdrZfPnzli2g2kuXZHs0DHy+i/5I9CoG2bZsYLZB
         8bF+lk+p5ixUlQjN6ufR6Io9HylbfNv2QHv1m/49CDn0WaX3RWgYl5MjZZJjWtydKD
         YHrFxpaJsh1kQzQsYAObVwmuNi412w+ABowF5FPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/211] ACPI / processor: dont print errors for processorIDs == 0xff
Date:   Thu,  3 Oct 2019 17:52:05 +0200
Message-Id: <20191003154501.897612747@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 2c2b005f549544c13ef4cfb0e4842949066889bc ]

Some platforms define their processors in this manner:
    Device (SCK0)
    {
	Name (_HID, "ACPI0004" /* Module Device */)  // _HID: Hardware ID
	Name (_UID, "CPUSCK0")  // _UID: Unique ID
	Processor (CP00, 0x00, 0x00000410, 0x06){}
	Processor (CP01, 0x02, 0x00000410, 0x06){}
	Processor (CP02, 0x04, 0x00000410, 0x06){}
	Processor (CP03, 0x06, 0x00000410, 0x06){}
	Processor (CP04, 0x01, 0x00000410, 0x06){}
	Processor (CP05, 0x03, 0x00000410, 0x06){}
	Processor (CP06, 0x05, 0x00000410, 0x06){}
	Processor (CP07, 0x07, 0x00000410, 0x06){}
	Processor (CP08, 0xFF, 0x00000410, 0x06){}
	Processor (CP09, 0xFF, 0x00000410, 0x06){}
	Processor (CP0A, 0xFF, 0x00000410, 0x06){}
	Processor (CP0B, 0xFF, 0x00000410, 0x06){}
...

The processors marked as 0xff are invalid, there are only 8 of them in
this case.

So do not print an error on ids == 0xff, just print an info message.
Actually, we could return ENODEV even on the first CPU with ID 0xff, but
ACPI spec does not forbid the 0xff value to be a processor ID. Given
0xff could be a correct one, we would break working systems if we
returned ENODEV.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_processor.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index fc447410ae4d1..a448cdf567188 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -282,9 +282,13 @@ static int acpi_processor_get_info(struct acpi_device *device)
 	}
 
 	if (acpi_duplicate_processor_id(pr->acpi_id)) {
-		dev_err(&device->dev,
-			"Failed to get unique processor _UID (0x%x)\n",
-			pr->acpi_id);
+		if (pr->acpi_id == 0xff)
+			dev_info_once(&device->dev,
+				"Entry not well-defined, consider updating BIOS\n");
+		else
+			dev_err(&device->dev,
+				"Failed to get unique processor _UID (0x%x)\n",
+				pr->acpi_id);
 		return -ENODEV;
 	}
 
-- 
2.20.1



