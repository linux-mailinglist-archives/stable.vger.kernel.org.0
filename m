Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B9CBAA8A
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbfIVT1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404708AbfIVSvB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:51:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8443D21D81;
        Sun, 22 Sep 2019 18:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178260;
        bh=1yjOP+y2VDBuHbUnkJ0x7XMZLigsvLv6f6vVBFKWGfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ux6Os3oUyh1zzUKzG/eU7+4a/+e8B2/4qNXy8lP2XHb3K/AqdGpk+7j6U4lw9dMLq
         dw/sBItXMkfLXrA8x0jyW+9xVLvZ3hB9NBPCOlWtUoeUvMfHAYnNzWYGPgii4QZDwI
         ad0OAmWHxVMZZ5QhRXxDz5ws7US/fzlUIBrHYHuI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Slaby <jslaby@suse.cz>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 049/185] ACPI / processor: don't print errors for processorIDs == 0xff
Date:   Sun, 22 Sep 2019 14:47:07 -0400
Message-Id: <20190922184924.32534-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 24f065114d424..2c4dda0787e84 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -279,9 +279,13 @@ static int acpi_processor_get_info(struct acpi_device *device)
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

