Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095A940C5DF
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 15:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhIONG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 09:06:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229670AbhIONG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 09:06:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C91836135E;
        Wed, 15 Sep 2021 13:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631711138;
        bh=SDvQl/XkyK/rM/6yTtMPy3p+fT1yHtG/5kfOEx24EOA=;
        h=Subject:To:Cc:From:Date:From;
        b=H5HLctltv5k6vPLMhyDIFCJy3Z+0LF+sUN8jlDfyTftaAsj9k57kyYR8Fz9EnM9tV
         ZOOclFMOoGAjQdQzTVB0q/jejmToMrFLbE4grYYaWhp0Gmg4grDqkh88o27LooNiik
         iBfTc67olU10FjM87jSU5k3T5ip3M2igZoVJQlvc=
Subject: FAILED: patch "[PATCH] watchdog: iTCO_wdt: Fix detection of SMI-off case" failed to apply to 5.10-stable tree
To:     jan.kiszka@siemens.com, grawity@gmail.com, linux@roeck-us.net,
        pbonzini@redhat.com, wim@linux-watchdog.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Sep 2021 15:05:25 +0200
Message-ID: <163171112514212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aec42642d91fc86ddc03e97f0139c6c34ee6b6b1 Mon Sep 17 00:00:00 2001
From: Jan Kiszka <jan.kiszka@siemens.com>
Date: Mon, 26 Jul 2021 13:46:13 +0200
Subject: [PATCH] watchdog: iTCO_wdt: Fix detection of SMI-off case
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Obviously, the test needs to run against the register content, not its
address.

Fixes: cb011044e34c ("watchdog: iTCO_wdt: Account for rebooting on second timeout")
Cc: stable@vger.kernel.org
Reported-by: Mantas Mikulėnas <grawity@gmail.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Mantas Mikulėnas <grawity@gmail.com>
Link: https://lore.kernel.org/r/d84f8e06-f646-8b43-d063-fb11f4827044@siemens.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index b3f604669e2c..643c6c2d0b72 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -362,7 +362,7 @@ static int iTCO_wdt_set_timeout(struct watchdog_device *wd_dev, unsigned int t)
 	 * Otherwise, the BIOS generally reboots when the SMI triggers.
 	 */
 	if (p->smi_res &&
-	    (SMI_EN(p) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN | GBL_SMI_EN))
+	    (inl(SMI_EN(p)) & (TCO_EN | GBL_SMI_EN)) != (TCO_EN | GBL_SMI_EN))
 		tmrval /= 2;
 
 	/* from the specs: */

