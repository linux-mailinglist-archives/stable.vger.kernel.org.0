Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1503B285C
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 09:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhFXHMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 03:12:07 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42612 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbhFXHMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 03:12:06 -0400
Date:   Thu, 24 Jun 2021 07:09:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1624518587;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nZb8bZcnTLvfByHJSritDmBT54k4IXWQmBfw9c44BjA=;
        b=xdOQ7qxo97ku2fddubh7a1A7mqpGsEKgwg08BZACPCa3354Fsn+B52Ka9iv79RA5iIhPIO
        Sjcum0Pp3HgoEhmRxwsvFpJych40gNIlATedUAKcJo/VDtJsIq/Fj8WFGx+XzBEvg8dpOH
        Q/MIaPaTI8GI3nIRcu8ZvqhxTh/ah9sTru0cc0TXvhHhINnVTBNHt0x2psv7YTrOJfwK7a
        5GtycJQFCgoH0OEGN31VC6KfR4/cT9vwySJEh9rF9sJ6Q7kjUalY9FNgA9fufn+xfQom7h
        aYwlgyYon0p3eRWfev5GoVjv/9fDVl3rU/vvBN+3BZYS3SWmW/YJVpaURkelcg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1624518587;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nZb8bZcnTLvfByHJSritDmBT54k4IXWQmBfw9c44BjA=;
        b=/bvx6h+1d0PdABwBx8SS9FgEYTDYHLZb9YuQQCJyz4xUymQvlpjKi+sS8+0fb2zdPcuI1K
        4z2KaivtV9IVc+BQ==
From:   "tip-bot2 for Kan Liang" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] perf/x86/intel: Add more events requires FRONTEND
 MSR on Sapphire Rapids
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1624029174-122219-3-git-send-email-kan.liang@linux.intel.com>
References: <1624029174-122219-3-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Message-ID: <162451858648.395.18261838774067039831.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     d18216fafecf2a3a7c2b97086892269d6ab3cd5e
Gitweb:        https://git.kernel.org/tip/d18216fafecf2a3a7c2b97086892269d6ab3cd5e
Author:        Kan Liang <kan.liang@linux.intel.com>
AuthorDate:    Fri, 18 Jun 2021 08:12:53 -07:00
Committer:     Peter Zijlstra <peterz@infradead.org>
CommitterDate: Wed, 23 Jun 2021 18:30:55 +02:00

perf/x86/intel: Add more events requires FRONTEND MSR on Sapphire Rapids

On Sapphire Rapids, there are two more events 0x40ad and 0x04c2 which
rely on the FRONTEND MSR. If the FRONTEND MSR is not set correctly, the
count value is not correct.

Update intel_spr_extra_regs[] to support them.

Fixes: 61b985e3e775 ("perf/x86/intel: Add perf core PMU support for Sapphire Rapids")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1624029174-122219-3-git-send-email-kan.liang@linux.intel.com
---
 arch/x86/events/intel/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index d39991b..e442b55 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -280,6 +280,8 @@ static struct extra_reg intel_spr_extra_regs[] __read_mostly = {
 	INTEL_UEVENT_EXTRA_REG(0x012b, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
 	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
 	INTEL_UEVENT_EXTRA_REG(0x01c6, MSR_PEBS_FRONTEND, 0x7fff17, FE),
+	INTEL_UEVENT_EXTRA_REG(0x40ad, MSR_PEBS_FRONTEND, 0x7, FE),
+	INTEL_UEVENT_EXTRA_REG(0x04c2, MSR_PEBS_FRONTEND, 0x8, FE),
 	EVENT_EXTRA_END
 };
 
