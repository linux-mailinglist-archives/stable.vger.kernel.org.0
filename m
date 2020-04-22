Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5141B408C
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731787AbgDVKqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729785AbgDVKQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:16:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D02062076E;
        Wed, 22 Apr 2020 10:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550613;
        bh=CZgZG+rKEREoHAtxAe5bzj7Vxs8nuKcRagnJnrkCH1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7VKlygtfp7BoEfObNaX3dY/mwZIJCzyqlM8LE/bZnjM6R4eXqJ4B8fC4SdJ1Fcfq
         nvTumntxGkrSb909LUlkeZwogOTDbk2uLQODax+cmLzzZdN4B4Q4VFQR5WJ6n7eZkz
         fGPYUsOUX1KT6KD3izPd8JAhPJ0xMoEv0xz+rhJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.4 022/118] x86/Hyper-V: Report crash register data when sysctl_record_panic_msg is not set
Date:   Wed, 22 Apr 2020 11:56:23 +0200
Message-Id: <20200422095035.366179385@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

commit 040026df7088c56ccbad28f7042308f67bde63df upstream.

When sysctl_record_panic_msg is not set, the panic will
not be reported to Hyper-V via hyperv_report_panic_msg().
So the crash should be reported via hyperv_report_panic().

Fixes: 81b18bce48af ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Link: https://lore.kernel.org/r/20200406155331.2105-6-Tianyu.Lan@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/vmbus_drv.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -48,6 +48,18 @@ static int hyperv_cpuhp_online;
 
 static void *hv_panic_page;
 
+/*
+ * Boolean to control whether to report panic messages over Hyper-V.
+ *
+ * It can be set via /proc/sys/kernel/hyperv/record_panic_msg
+ */
+static int sysctl_record_panic_msg = 1;
+
+static int hyperv_report_reg(void)
+{
+	return !sysctl_record_panic_msg || !hv_panic_page;
+}
+
 static int hyperv_panic_event(struct notifier_block *nb, unsigned long val,
 			      void *args)
 {
@@ -61,7 +73,7 @@ static int hyperv_panic_event(struct not
 	 * the notification here.
 	 */
 	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE
-	    && !hv_panic_page) {
+	    && hyperv_report_reg()) {
 		regs = current_pt_regs();
 		hyperv_report_panic(regs, val);
 	}
@@ -79,7 +91,7 @@ static int hyperv_die_event(struct notif
 	 * doing hyperv_report_panic_msg() later with kmsg data, don't do
 	 * the notification here.
 	 */
-	if (!hv_panic_page)
+	if (hyperv_report_reg())
 		hyperv_report_panic(regs, val);
 	return NOTIFY_DONE;
 }
@@ -1262,13 +1274,6 @@ static void vmbus_isr(void)
 }
 
 /*
- * Boolean to control whether to report panic messages over Hyper-V.
- *
- * It can be set via /proc/sys/kernel/hyperv/record_panic_msg
- */
-static int sysctl_record_panic_msg = 1;
-
-/*
  * Callback from kmsg_dump. Grab as much as possible from the end of the kmsg
  * buffer and call into Hyper-V to transfer the data.
  */


