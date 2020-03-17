Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A33D6188233
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgCQL2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:28:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbgCQL2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:28:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CCC220658;
        Tue, 17 Mar 2020 11:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584444521;
        bh=ejZrq+F/lKEfO3Yj3IeUxgVu9TpeCSHvgQhm0SrXQNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGCcj+MF1Wyxc28slHUPFTccGeRP4pffXEJ3SLQxXrCOZirsNXBhjUEeHb66S7Ssg
         JoYauMqKCAdyhTxC76V9Usx40hrya+OOPH7lkaEPY+OEWMXx/7pJD+gx5mZHAaTnLK
         asNZXtvCJupOzk0aZYmiVcj24b8ARQtPTPiCfKfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        "Pandruvada, Srinivas" <srinivas.pandruvada@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.5 129/151] x86/mce/therm_throt: Undo thermal polling properly on CPU offline
Date:   Tue, 17 Mar 2020 11:55:39 +0100
Message-Id: <20200317103335.605735505@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit d364847eed890211444ad74496bb549f838c6018 upstream.

Chris Wilson reported splats from running the thermal throttling
workqueue callback on offlined CPUs. The problem is that that callback
should not even run on offlined CPUs but it happens nevertheless because
the offlining callback thermal_throttle_offline() does not symmetrically
undo the setup work done in its onlining counterpart. IOW,

 1. The thermal interrupt vector should be masked out before ...

 2. ... cancelling any pending work synchronously so that no new work is
 enqueued anymore.

Do those things and fix the issue properly.

 [ bp: Write commit message. ]

Fixes: f6656208f04e ("x86/mce/therm_throt: Optimize notifications of thermal throttle")
Reported-by: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: Pandruvada, Srinivas <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/158120068234.18291.7938335950259651295@skylake-alporthouse-com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mce/therm_throt.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/mce/therm_throt.c
+++ b/arch/x86/kernel/cpu/mce/therm_throt.c
@@ -486,9 +486,14 @@ static int thermal_throttle_offline(unsi
 {
 	struct thermal_state *state = &per_cpu(thermal_state, cpu);
 	struct device *dev = get_cpu_device(cpu);
+	u32 l;
 
-	cancel_delayed_work(&state->package_throttle.therm_work);
-	cancel_delayed_work(&state->core_throttle.therm_work);
+	/* Mask the thermal vector before draining evtl. pending work */
+	l = apic_read(APIC_LVTTHMR);
+	apic_write(APIC_LVTTHMR, l | APIC_LVT_MASKED);
+
+	cancel_delayed_work_sync(&state->package_throttle.therm_work);
+	cancel_delayed_work_sync(&state->core_throttle.therm_work);
 
 	state->package_throttle.rate_control_active = false;
 	state->core_throttle.rate_control_active = false;


