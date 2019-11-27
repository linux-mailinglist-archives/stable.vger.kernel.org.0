Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19ACB10B8C0
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbfK0UqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:46:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728211AbfK0UqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:46:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66014217AB;
        Wed, 27 Nov 2019 20:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887580;
        bh=gb11hL3cHx2OLB5oT98ih2DOYxYDCXBIe9RCDvGAhnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSNir+mRpdKbt1dMHqRebtOVWPHub4rVDuzU2T2scMlxDve/Xy/XF8YX5/bOqkfUx
         jkiqr5bm4Fv/QtBwapPiJCFtczltYmWP/Lo0hyYtnn3SZRlonDBsmNYUy1BeLf/4rB
         bzw37JnJUUPIgqyPaibMuon8+BwWwPZ5YtJMD3UY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiernan Hager <kah.listaddress@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 015/211] platform/x86: asus-nb-wmi: Support ALS on the Zenbook UX430UQ
Date:   Wed, 27 Nov 2019 21:29:08 +0100
Message-Id: <20191127203052.001387647@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kiernan Hager <kah.listaddress@gmail.com>

[ Upstream commit db2582afa7444a0ce6bb1ebf1431715969a10b06 ]

This patch adds support for ALS on the Zenbook UX430UQ to the asus_nb_wmi
driver. It also renames "quirk_asus_ux330uak" to "quirk_asus_forceals"
because it is now used for more than one model of computer, and should
thus have a more general name.

Signed-off-by: Kiernan Hager <kah.listaddress@gmail.com>
[andy: massaged commit message, fixed indentation and commas in the code]
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 9c4b0d7f15c3b..b6f2ff95c3ed9 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -111,7 +111,7 @@ static struct quirk_entry quirk_asus_x550lb = {
 	.xusb2pr = 0x01D9,
 };
 
-static struct quirk_entry quirk_asus_ux330uak = {
+static struct quirk_entry quirk_asus_forceals = {
 	.wmi_force_als_set = true,
 };
 
@@ -387,7 +387,7 @@ static const struct dmi_system_id asus_quirks[] = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "UX330UAK"),
 		},
-		.driver_data = &quirk_asus_ux330uak,
+		.driver_data = &quirk_asus_forceals,
 	},
 	{
 		.callback = dmi_matched,
@@ -398,6 +398,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_x550lb,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK COMPUTER INC. UX430UQ",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "UX430UQ"),
+		},
+		.driver_data = &quirk_asus_forceals,
+	},
 	{},
 };
 
-- 
2.20.1



