Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 257EFE68AD
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbfJ0VQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:16:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730947AbfJ0VQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:16:58 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4A90208C0;
        Sun, 27 Oct 2019 21:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211018;
        bh=l5Ap4qy6IDx+F2UEHsXA9RX/S0oe9K0oBuAI3v//3JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHHoOtrzDHODCDGgHPQle4Aj2fcaXhgx8fzlWOHYc02Be7LRWrQcNNocDe7eJR5BJ
         4Ybj0HJU8/CFcgAZx84ymCEcCr1pDEnMqa6LmYBagIhhFMRPojFYcLzKkjoc/um3xD
         Xh2CqGt208zOvacmWXpvumC3NA1/LZKSGh8R/V5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Levin <levinale@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4.19 81/93] pinctrl: cherryview: restore Strago DMI workaround for all versions
Date:   Sun, 27 Oct 2019 22:01:33 +0100
Message-Id: <20191027203313.219460624@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 260996c30f4f3a732f45045e3e0efe27017615e4 upstream.

This is essentially a revert of:

e3f72b749da2 pinctrl: cherryview: fix Strago DMI workaround
86c5dd6860a6 pinctrl: cherryview: limit Strago DMI workarounds to version 1.0

because even with 1.1 versions of BIOS there are some pins that are
configured as interrupts but not claimed by any driver, and they
sometimes fire up and result in interrupt storms that cause touchpad
stop functioning and other issues.

Given that we are unlikely to qualify another firmware version for a
while it is better to keep the workaround active on all Strago boards.

Reported-by: Alex Levin <levinale@chromium.org>
Fixes: 86c5dd6860a6 ("pinctrl: cherryview: limit Strago DMI workarounds to version 1.0")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Alex Levin <levinale@chromium.org>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/intel/pinctrl-cherryview.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/pinctrl/intel/pinctrl-cherryview.c
+++ b/drivers/pinctrl/intel/pinctrl-cherryview.c
@@ -1524,7 +1524,6 @@ static const struct dmi_system_id chv_no
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "Intel_Strago"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1.0"),
 		},
 	},
 	{
@@ -1532,7 +1531,6 @@ static const struct dmi_system_id chv_no
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Setzer"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1.0"),
 		},
 	},
 	{
@@ -1540,7 +1538,6 @@ static const struct dmi_system_id chv_no
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Cyan"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1.0"),
 		},
 	},
 	{
@@ -1548,7 +1545,6 @@ static const struct dmi_system_id chv_no
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Celes"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1.0"),
 		},
 	},
 	{}


