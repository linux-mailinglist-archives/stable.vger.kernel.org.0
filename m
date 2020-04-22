Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E501B4093
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731314AbgDVKqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729779AbgDVKQs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:16:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3D912070B;
        Wed, 22 Apr 2020 10:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550608;
        bh=U0NUd3gy3ySqpienrLyPfpjtmoETJLPXg4P1CAUJP0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOtir2cyHzQs/VwZ34ipYisNTC9+8tBGjpQFWpRWpSJ5VzUGhmJUPBY1JCHGj67X0
         L2BZdddlBObdTuVqmch7erR/W8kLJENRZMGBPWXAnRLkROXb89VnlvYhG6cp0X3BTg
         vr2fguCHHa6JFf4nf8savj4oVJq6P+ihK39buVjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.4 020/118] x86/Hyper-V: Trigger crash enlightenment only once during system crash.
Date:   Wed, 22 Apr 2020 11:56:21 +0200
Message-Id: <20200422095034.923801965@linuxfoundation.org>
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

commit 73f26e526f19afb3a06b76b970a76bcac2cafd05 upstream.

When a guest VM panics, Hyper-V should be notified only once via the
crash synthetic MSRs.  Current Linux code might write these crash MSRs
twice during a system panic:
1) hyperv_panic/die_event() calling hyperv_report_panic()
2) hv_kmsg_dump() calling hyperv_report_panic_msg()

Fix this by not calling hyperv_report_panic() if a kmsg dump has been
successfully registered.  The notification will happen later via
hyperv_report_panic_msg().

Fixes: 7ed4325a44ea ("Drivers: hv: vmbus: Make panic reporting to be more useful")
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Link: https://lore.kernel.org/r/20200406155331.2105-4-Tianyu.Lan@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/vmbus_drv.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -55,7 +55,13 @@ static int hyperv_panic_event(struct not
 
 	vmbus_initiate_unload(true);
 
-	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
+	/*
+	 * Hyper-V should be notified only once about a panic.  If we will be
+	 * doing hyperv_report_panic_msg() later with kmsg data, don't do
+	 * the notification here.
+	 */
+	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE
+	    && !hv_panic_page) {
 		regs = current_pt_regs();
 		hyperv_report_panic(regs, val);
 	}
@@ -68,7 +74,13 @@ static int hyperv_die_event(struct notif
 	struct die_args *die = (struct die_args *)args;
 	struct pt_regs *regs = die->regs;
 
-	hyperv_report_panic(regs, val);
+	/*
+	 * Hyper-V should be notified only once about a panic.  If we will be
+	 * doing hyperv_report_panic_msg() later with kmsg data, don't do
+	 * the notification here.
+	 */
+	if (!hv_panic_page)
+		hyperv_report_panic(regs, val);
 	return NOTIFY_DONE;
 }
 


