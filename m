Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBF6B8E34
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 12:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405903AbfITKCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 06:02:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:58443 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405850AbfITKCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Sep 2019 06:02:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Sep 2019 03:02:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,528,1559545200"; 
   d="scan'208";a="202476935"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 20 Sep 2019 03:02:35 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy@infradead.org>
Cc:     Darren Hart <dvhart@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] platform/x86: i2c-multi-instantiate: Derive the device name from parent
Date:   Fri, 20 Sep 2019 13:02:33 +0300
Message-Id: <20190920100233.12829-1-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When naming the new devices, instead of using the ACPI ID in
the name as base, using the parent device's name. That makes
it possible to support multiple multi-instance i2c devices
of the same type in the same system.

This fixes an issue seen on some Intel Kaby Lake based
boards:

sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-0/i2c-INT3515-tps6598x.0'

Fixes: 2336dfadfb1e ("platform/x86: i2c-multi-instantiate: Allow to have same slaves")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/platform/x86/i2c-multi-instantiate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/i2c-multi-instantiate.c b/drivers/platform/x86/i2c-multi-instantiate.c
index 61fe341a85aa..ea68f6ed66ae 100644
--- a/drivers/platform/x86/i2c-multi-instantiate.c
+++ b/drivers/platform/x86/i2c-multi-instantiate.c
@@ -90,7 +90,7 @@ static int i2c_multi_inst_probe(struct platform_device *pdev)
 	for (i = 0; i < multi->num_clients && inst_data[i].type; i++) {
 		memset(&board_info, 0, sizeof(board_info));
 		strlcpy(board_info.type, inst_data[i].type, I2C_NAME_SIZE);
-		snprintf(name, sizeof(name), "%s-%s.%d", match->id,
+		snprintf(name, sizeof(name), "%s-%s.%d", dev_name(dev),
 			 inst_data[i].type, i);
 		board_info.dev_name = name;
 		switch (inst_data[i].flags & IRQ_RESOURCE_TYPE) {
-- 
2.23.0

