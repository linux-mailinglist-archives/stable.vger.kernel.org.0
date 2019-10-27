Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2DAE67E5
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732099AbfJ0VZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732715AbfJ0VZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:25:21 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BE9621D80;
        Sun, 27 Oct 2019 21:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211520;
        bh=fpFNoSccBHLbv0vrydrZEkMT1fnZ0IAWrJKSOGe1NeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTcNy0aTJ6qWElLUdfVZdO5xx84gCjyln9hmAaAjB/qeGDRFiSJWD+5ayMsW/Lgzu
         zr2cEr0milKgJfmqOozuaZG/toW5SfxErV5heOJY3S8rXKkXXpUC6e9tu0Zu+BUYxH
         AJ14Ev2NLXr/F3UJG53oUecWjkL43PfLKfh7tqBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Levin <levinale@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.3 178/197] pinctrl: cherryview: restore Strago DMI workaround for all versions
Date:   Sun, 27 Oct 2019 22:01:36 +0100
Message-Id: <20191027203405.334728832@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
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
@@ -1513,7 +1513,6 @@ static const struct dmi_system_id chv_no
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
 			DMI_MATCH(DMI_PRODUCT_FAMILY, "Intel_Strago"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1.0"),
 		},
 	},
 	{
@@ -1521,7 +1520,6 @@ static const struct dmi_system_id chv_no
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Setzer"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1.0"),
 		},
 	},
 	{
@@ -1529,7 +1527,6 @@ static const struct dmi_system_id chv_no
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Cyan"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1.0"),
 		},
 	},
 	{
@@ -1537,7 +1534,6 @@ static const struct dmi_system_id chv_no
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Celes"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1.0"),
 		},
 	},
 	{}


