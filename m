Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA1C4A6E5C
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 11:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245714AbiBBKFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 05:05:47 -0500
Received: from mail.acc.umu.se ([130.239.18.156]:40316 "EHLO mail.acc.umu.se"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245713AbiBBKFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Feb 2022 05:05:44 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by amavisd-new (Postfix) with ESMTP id EB3D644B90;
        Wed,  2 Feb 2022 11:05:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=acc.umu.se; s=mail1;
        t=1643796341; bh=VR855Mb+4xjFEI82EM+qCO2fkELbxbvKwY6+wNTtvuc=;
        h=From:To:Cc:Subject:Date:From;
        b=wwkjIrQwvDGw9W5G7teXaD3zTH7hLX43BZOFk6aQ8yLnwtadsYrMUtvT3O9KfnZCx
         uePqfakNSvlUoEUgUMlCOjVMeZDeSw3TvHXnevLxKXIXXOYAzvJffyDGbSw31i6mMS
         ZWoCVF8ddq9tPhxMLO4+V+hQUlrkagRkXead/GHKSs8YBalb2/i+uFz2c5javdx3LM
         7Wukx2zFgczywhCyU18jBubZ2SZqULG4uyJYaODZD5TBp2UyV8xK8DnN5I8X5eoX6E
         +8t8Y7/U+2wIEBNgO7K/GCnG+Oi2+WTuuna4EePbzkc83F7bENAR+ZEbYSBwcSvGwU
         WktKmD2fE8UYQ==
Received: by mail.acc.umu.se (Postfix, from userid 24471)
        id 78C8544B92; Wed,  2 Feb 2022 11:05:41 +0100 (CET)
From:   Anton Lundin <glance@acc.umu.se>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-ide@vger.kernel.org
Cc:     Anton Lundin <glance@acc.umu.se>, stable@vger.kernel.org
Subject: [PATCH] libata: Don't issue ATA_LOG_DIRECTORY to SATADOM-ML 3ME
Date:   Wed,  2 Feb 2022 11:05:36 +0100
Message-Id: <20220202100536.1909665-1-glance@acc.umu.se>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Back in 06f6c4c6c3e8 ("ata: libata: add missing ata_identify_page_supported() calls")
a read of ATA_LOG_DIRECTORY page was added. This caused the
SATADOM-ML 3ME to lock up.

In 636f6e2af4fb ("libata: add horkage for missing Identify Device log")
a flag was added to cache if a device supports this or not.

This adds a blacklist entry which flags that these devices doesn't
support that call and shouldn't be issued that call.

Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Anton Lundin <glance@acc.umu.se>
Depends-on: 636f6e2af4fb ("libata: add horkage for missing Identify Device log")
---
 drivers/ata/libata-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 87d36b29ca5f..e024af9f33d0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4070,6 +4070,13 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "WDC WD3000JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
 	{ "WDC WD3200JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
 
+	/*
+	 * This sata dom goes on a walkabout when it sees the
+	 * ATA_LOG_DIRECTORY read request so ensure we don't issue such a
+	 * request to these devices.
+	 */
+	{ "SATADOM-ML 3ME",		NULL,	ATA_HORKAGE_NO_ID_DEV_LOG },
+
 	/* End Marker */
 	{ }
 };
-- 
2.30.2

