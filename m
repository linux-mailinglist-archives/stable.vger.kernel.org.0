Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A472A58AC
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbgKCVyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:54:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730545AbgKCUps (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:45:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEF6A223EA;
        Tue,  3 Nov 2020 20:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436348;
        bh=F9KyQzzFjYFhBZZuYcyudtFio37efGi/cjpx029hPiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZtTICR4DJvR1mH3s3M6dWNDV5kAOP15H5Lw3nSUDWFk1ENJT9Vpjm4XISVB3Cz9C
         kp5XG7JcACmcU9hxuEBP0XxGBe2Vk7ywYYpeGnAkjea30qv7yO8aRhpemHdbL4L5N5
         VfstdbzMmtJz890bz4DLN0X7dj+K1LJ24zitI63E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raymond Tan <raymond.tan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.9 210/391] ACPI: EC: PM: Flush EC work unconditionally after wakeup
Date:   Tue,  3 Nov 2020 21:34:21 +0100
Message-Id: <20201103203401.080699524@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 5e92442bb4121562231e6daf8a2d1306cb5f8805 upstream.

Commit 607b9df63057 ("ACPI: EC: PM: Avoid flushing EC work when EC
GPE is inactive") has been reported to cause some power button wakeup
events to be missed on some systems, so modify acpi_ec_dispatch_gpe()
to call acpi_ec_flush_work() unconditionally to effectively reverse
the changes made by that commit.

Also note that the problem which prompted commit 607b9df63057 is not
reproducible any more on the affected machine.

Fixes: 607b9df63057 ("ACPI: EC: PM: Avoid flushing EC work when EC GPE is inactive")
Reported-by: Raymond Tan <raymond.tan@intel.com>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2019,12 +2019,11 @@ bool acpi_ec_dispatch_gpe(void)
 	 * to allow the caller to process events properly after that.
 	 */
 	ret = acpi_dispatch_gpe(NULL, first_ec->gpe);
-	if (ret == ACPI_INTERRUPT_HANDLED) {
+	if (ret == ACPI_INTERRUPT_HANDLED)
 		pm_pr_dbg("ACPI EC GPE dispatched\n");
 
-		/* Flush the event and query workqueues. */
-		acpi_ec_flush_work();
-	}
+	/* Flush the event and query workqueues. */
+	acpi_ec_flush_work();
 
 	return false;
 }


