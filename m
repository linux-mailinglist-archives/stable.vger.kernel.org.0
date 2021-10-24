Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5687E438896
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 13:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhJXLav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 07:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhJXLav (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Oct 2021 07:30:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 881B160F22;
        Sun, 24 Oct 2021 11:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635074911;
        bh=JG6TxMu4cJ8CYrFQ2t70EryKoewRtp3HSTVAHJCcHlM=;
        h=Subject:To:Cc:From:Date:From;
        b=0IlNAwek9MB/gUOFPSHHmQmseLdnKIcBYxwqW+7nWknsGW+QxAqSLL8Z56yuFkndl
         y22LQGEHtLXJdXqJNLwnGe3zCsLI2pfwdopVeBZj1ecxiGBNJOjVdR1IfJ6pRwfRPZ
         XlnyyH8Nogn4WR2ylXHLne6+Bnq4jf6QIrOLtPYw=
Subject: FAILED: patch "[PATCH] ACPI: PM: Do not turn off power resources in unknown state" failed to apply to 5.14-stable tree
To:     rafael.j.wysocki@intel.com, andreas.huettel@ur.de,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Oct 2021 13:28:28 +0200
Message-ID: <1635074908144216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bc28368596436e6e81ffc48c815b8225d96121c0 Mon Sep 17 00:00:00 2001
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Fri, 15 Oct 2021 19:12:21 +0200
Subject: [PATCH] ACPI: PM: Do not turn off power resources in unknown state

Commit 6381195ad7d0 ("ACPI: power: Rework turning off unused power
resources") caused power resources in unknown state with reference
counters equal to zero to be turned off too, but that caused issues
to appear in the field, so modify the code to only turn off power
resources that are known to be "on".

Link: https://lore.kernel.org/linux-acpi/6faf4b92-78d5-47a4-63df-cc2bab7769d0@molgen.mpg.de/
Fixes: 6381195ad7d0 ("ACPI: power: Rework turning off unused power resources")
Reported-by: Andreas K. Huettel <andreas.huettel@ur.de>
Tested-by: Andreas K. Huettel <andreas.huettel@ur.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 5.14+ <stable@vger.kernel.org> # 5.14+

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index b9863e22b952..f0ed4414edb1 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -1035,13 +1035,8 @@ void acpi_turn_off_unused_power_resources(void)
 	list_for_each_entry_reverse(resource, &acpi_power_resource_list, list_node) {
 		mutex_lock(&resource->resource_lock);
 
-		/*
-		 * Turn off power resources in an unknown state too, because the
-		 * platform firmware on some system expects the OS to turn off
-		 * power resources without any users unconditionally.
-		 */
 		if (!resource->ref_count &&
-		    resource->state != ACPI_POWER_RESOURCE_STATE_OFF) {
+		    resource->state == ACPI_POWER_RESOURCE_STATE_ON) {
 			acpi_handle_debug(resource->device.handle, "Turning OFF\n");
 			__acpi_power_off(resource);
 		}

