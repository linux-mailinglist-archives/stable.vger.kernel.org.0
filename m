Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A3ECA929
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404698AbfJCQiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733111AbfJCQiU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:38:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3782221783;
        Thu,  3 Oct 2019 16:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120699;
        bh=AVrR9+tsKYdOfYBrPs/yN9cRUzxjuwMAG5sQEM8OOFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fhz1XJ/9MNv4CoE6k3DwV7ZPmCi0FYU9T0EU9oiYBdICUbiKJGePCYpOzoxJMLDvp
         0/O3nvUgBgsfUiUJYASXK0kVP6pk0d0+mCbaGT938FeZWMW44ZwX0PSpweqMoZeNH/
         bXCIGE4ujJQDYFPk13GUW55gj8RE4ZLBsKcBV1uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Curtis Malainey <cujomalainey@chromium.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.2 291/313] ACPI / LPSS: Save/restore LPSS private registers also on Lynxpoint
Date:   Thu,  3 Oct 2019 17:54:29 +0200
Message-Id: <20191003154601.784501883@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

commit 57b3006492a4c11b2d4a772b5b2905d544a32037 upstream.

My assumption in commit b53548f9d9e4 ("spi: pxa2xx: Remove LPSS private
register restoring during resume") that Intel Lynxpoint and compatible
based chipsets may not need LPSS private registers saving and restoring
over suspend/resume cycle turned out to be false on Intel Broadwell.

Curtis Malainey sent a patch bringing above change back and reported the
LPSS SPI Chip Select control was lost over suspend/resume cycle on
Broadwell machine.

Instead of reverting above commit lets add LPSS private register
saving/restoring also for all LPSS SPI, I2C and UART controllers on
Lynxpoint and compatible chipset to make sure context is not lost in
case nothing else preserves it like firmware or if LPSS is always on.

Fixes: b53548f9d9e4 ("spi: pxa2xx: Remove LPSS private register restoring during resume")
Reported-by: Curtis Malainey <cujomalainey@chromium.org>
Tested-by: Curtis Malainey <cujomalainey@chromium.org>
Cc: 5.0+ <stable@vger.kernel.org> # 5.0+
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_lpss.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -219,12 +219,13 @@ static void bsw_pwm_setup(struct lpss_pr
 }
 
 static const struct lpss_device_desc lpt_dev_desc = {
-	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR,
+	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR
+			| LPSS_SAVE_CTX,
 	.prv_offset = 0x800,
 };
 
 static const struct lpss_device_desc lpt_i2c_dev_desc = {
-	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_LTR,
+	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_LTR | LPSS_SAVE_CTX,
 	.prv_offset = 0x800,
 };
 
@@ -236,7 +237,8 @@ static struct property_entry uart_proper
 };
 
 static const struct lpss_device_desc lpt_uart_dev_desc = {
-	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR,
+	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR
+			| LPSS_SAVE_CTX,
 	.clk_con_id = "baudclk",
 	.prv_offset = 0x800,
 	.setup = lpss_uart_setup,


