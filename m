Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA01AB932D
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392935AbfITOiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:38:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35682 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728998AbfITOY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:24:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqC-0004wd-Rz; Fri, 20 Sep 2019 15:24:56 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqC-0007q0-HM; Fri, 20 Sep 2019 15:24:56 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        "Wolfram Sang" <wsa+renesas@sang-engineering.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.762338474@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 018/132] rtc: don't reference bogus function pointer
 in kdoc
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit c48cadf5bf4becefcd0751b97995d2350aa9bb57 upstream.

The mentioned function pointer is long gone since early 2011. Remove the
reference in the comment and reword it slightly.

Fixes: 51ba60c5bb3b ("RTC: Cleanup rtc_class_ops->update_irq_enable()")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rtc/interface.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -492,10 +492,9 @@ out:
 	mutex_unlock(&rtc->ops_lock);
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	/*
-	 * Enable emulation if the driver did not provide
-	 * the update_irq_enable function pointer or if returned
-	 * -EINVAL to signal that it has been configured without
-	 * interrupts or that are not available at the moment.
+	 * Enable emulation if the driver returned -EINVAL to signal that it has
+	 * been configured without interrupts or they are not available at the
+	 * moment.
 	 */
 	if (err == -EINVAL)
 		err = rtc_dev_update_irq_enable_emul(rtc, enabled);

