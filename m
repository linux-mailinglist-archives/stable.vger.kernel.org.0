Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6A61F2863
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbgFHXwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:52:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731689AbgFHXYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:24:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FF8A214F1;
        Mon,  8 Jun 2020 23:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658694;
        bh=W3ZhRUwNiWudInO1qOqNzl8fJ3VzFMEDoRHUiQYNBKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBc2W5NpD91m/WNtP1m/l/GGyWDP54l/egjaMwgiEeMSkeKFqQzzXZmJpItLsWvsd
         XErWHQdh/poPTRGee8UYqEGKamHkHCSks03TKUue5jTkW42w9sHXaoY1iysBTtVAI7
         M/+Ev0E+ecQrTa+dXNeZ154KhnO8am7U6i8KK2ys=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nickolai Kozachenko <daemongloom@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 102/106] platform/x86: intel-hid: Add a quirk to support HP Spectre X2 (2015)
Date:   Mon,  8 Jun 2020 19:22:34 -0400
Message-Id: <20200608232238.3368589-102-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nickolai Kozachenko <daemongloom@gmail.com>

[ Upstream commit 8fe63eb757ac6e661a384cc760792080bdc738dc ]

HEBC method reports capabilities of 5 button array but HP Spectre X2 (2015)
does not have this control method (the same was for Wacom MobileStudio Pro).
Expand previous DMI quirk by Alex Hung to also enable 5 button array
for this system.

Signed-off-by: Nickolai Kozachenko <daemongloom@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-hid.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/intel-hid.c b/drivers/platform/x86/intel-hid.c
index 3201a83073b5..c514cb73bb50 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -87,6 +87,13 @@ static const struct dmi_system_id button_array_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Wacom MobileStudio Pro 16"),
 		},
 	},
+	{
+		.ident = "HP Spectre x2 (2015)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Spectre x2 Detachable"),
+		},
+	},
 	{ }
 };
 
-- 
2.25.1

