Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF8606DBD7
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732164AbfGSELl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388492AbfGSELk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:11:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 837A62189D;
        Fri, 19 Jul 2019 04:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509499;
        bh=nK2jycfVWp/0ZD4MufIVjgtftS4Ozwdm8QErvRgIeAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TI8X6VtrYRHFyX74/ilAxtQwSjXISnuvFA4M8vFqPEU3MJfHQOfSZiCkUMrf515GC
         D9sch88MrxK5a556yvxBc3mWxKBdErHr0g9VkTaR6tNu8JoX6TMnZPNktcCKtopPBA
         ZJCNJlTQ7sUz9FAqAv4NYrkdlj1TEYsVj4q36Nzc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Lynch <nathanl@linux.ibm.com>,
        "Gautham R . Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 17/60] powerpc/pseries/mobility: prevent cpu hotplug during DT update
Date:   Fri, 19 Jul 2019 00:10:26 -0400
Message-Id: <20190719041109.18262-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041109.18262-1-sashal@kernel.org>
References: <20190719041109.18262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit e59a175faa8df9d674247946f2a5a9c29c835725 ]

CPU online/offline code paths are sensitive to parts of the device
tree (various cpu node properties, cache nodes) that can be changed as
a result of a migration.

Prevent CPU hotplug while the device tree potentially is inconsistent.

Fixes: 410bccf97881 ("powerpc/pseries: Partition migration in the kernel")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/mobility.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
index fbea7db043fa..4addc552eb33 100644
--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -9,6 +9,7 @@
  * 2 as published by the Free Software Foundation.
  */
 
+#include <linux/cpu.h>
 #include <linux/kernel.h>
 #include <linux/kobject.h>
 #include <linux/smp.h>
@@ -343,11 +344,19 @@ void post_mobility_fixup(void)
 	if (rc)
 		printk(KERN_ERR "Post-mobility activate-fw failed: %d\n", rc);
 
+	/*
+	 * We don't want CPUs to go online/offline while the device
+	 * tree is being updated.
+	 */
+	cpus_read_lock();
+
 	rc = pseries_devicetree_update(MIGRATION_SCOPE);
 	if (rc)
 		printk(KERN_ERR "Post-mobility device tree update "
 			"failed: %d\n", rc);
 
+	cpus_read_unlock();
+
 	/* Possibly switch to a new RFI flush type */
 	pseries_setup_rfi_flush();
 
-- 
2.20.1

