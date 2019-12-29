Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 093FE12CA1F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfL2RXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:23:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727566AbfL2RXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:23:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43F1220722;
        Sun, 29 Dec 2019 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640216;
        bh=ABkLrZKoElGRtWFppwkvdptsazTThG4UmudwIkKFSsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZcZj2dwce1c2CdnjHf0pO4UxwdM8CurNiN2EInWS0zDGuGf7m9B7r6iXbkdr1QaH4
         HBGpyhAPtpfdZQjKWGfx26mxbhSdvvJzcm9G7kDpTwbD63VsDMRvXpDhQGmwcn/2zB
         hWbZJSwNDr2ym6ywZssvzXhfJn/z2Vs5pSBzyPKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Berg <bberg@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Christian Kellner <ckellner@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        linux-edac <linux-edac@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 066/161] x86/mce: Lower throttling MCE messages priority to warning
Date:   Sun, 29 Dec 2019 18:18:34 +0100
Message-Id: <20191229162419.667121768@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Berg <bberg@redhat.com>

[ Upstream commit 9c3bafaa1fd88e4dd2dba3735a1f1abb0f2c7bb7 ]

On modern CPUs it is quite normal that the temperature limits are
reached and the CPU is throttled. In fact, often the thermal design is
not sufficient to cool the CPU at full load and limits can quickly be
reached when a burst in load happens. This will even happen with
technologies like RAPL limitting the long term power consumption of
the package.

Also, these limits are "softer", as Srinivas explains:

"CPU temperature doesn't have to hit max(TjMax) to get these warnings.
OEMs ha[ve] an ability to program a threshold where a thermal interrupt
can be generated. In some systems the offset is 20C+ (Read only value).

In recent systems, there is another offset on top of it which can be
programmed by OS, once some agent can adjust power limits dynamically.
By default this is set to low by the firmware, which I guess the
prime motivation of Benjamin to submit the patch."

So these messages do not usually indicate a hardware issue (e.g.
insufficient cooling). Log them as warnings to avoid confusion about
their severity.

 [ bp: Massage commit mesage. ]

Signed-off-by: Benjamin Berg <bberg@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Christian Kellner <ckellner@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20191009155424.249277-1-bberg@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index ee229ceee745..ec6a07b04fdb 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -185,7 +185,7 @@ static void therm_throt_process(bool new_event, int event, int level)
 	/* if we just entered the thermal event */
 	if (new_event) {
 		if (event == THERMAL_THROTTLING_EVENT)
-			pr_crit("CPU%d: %s temperature above threshold, cpu clock throttled (total events = %lu)\n",
+			pr_warn("CPU%d: %s temperature above threshold, cpu clock throttled (total events = %lu)\n",
 				this_cpu,
 				level == CORE_LEVEL ? "Core" : "Package",
 				state->count);
-- 
2.20.1



