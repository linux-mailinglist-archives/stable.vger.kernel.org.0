Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A942D9E85
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408603AbgLNRjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:39:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502383AbgLNRjS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:39:18 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Green <evgreen@chromium.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.9 085/105] pinctrl: jasperlake: Fix HOSTSW_OWN offset
Date:   Mon, 14 Dec 2020 18:28:59 +0100
Message-Id: <20201214172559.373622846@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Green <evgreen@chromium.org>

commit cdd8fc2dd64e3f1b22a6636e242d0eff49c4ba22 upstream.

GPIOs that attempt to use interrupts get thwarted with a message like:
"pin 161 cannot be used as IRQ" (for instance with SD_CD). This is because
the HOSTSW_OWN offset is incorrect, so every GPIO looks like it's
owned by ACPI.

Fixes: e278dcb7048b1 ("pinctrl: intel: Add Intel Jasper Lake pin controller support")
Cc: stable@vger.kernel.org
Signed-off-by: Evan Green <evgreen@chromium.org>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/intel/pinctrl-jasperlake.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/intel/pinctrl-jasperlake.c
+++ b/drivers/pinctrl/intel/pinctrl-jasperlake.c
@@ -16,7 +16,7 @@
 
 #define JSL_PAD_OWN	0x020
 #define JSL_PADCFGLOCK	0x080
-#define JSL_HOSTSW_OWN	0x0b0
+#define JSL_HOSTSW_OWN	0x0c0
 #define JSL_GPI_IS	0x100
 #define JSL_GPI_IE	0x120
 


