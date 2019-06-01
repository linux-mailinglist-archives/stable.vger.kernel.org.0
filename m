Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D760931C08
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfFANSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:18:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727721AbfFANSN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:18:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 192932725E;
        Sat,  1 Jun 2019 13:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395093;
        bh=r7Rkp6drW7YvC8pyR7a7+/B2PEGns/wxV56cYM3pWR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daNnsERJXUB2/zlBFJ8IiVblpNou7WgotIUDAq00MgoM35mQI76eCV6xvs+x+sm+s
         knGouN/WRJYxK/3hTFUba+4mWtU8pdcSNPXKBXGb9U9nzOdXFZ1+/zKyxQtLF09rvI
         9UQhd6pgIJfDO0vSMeKM8mjqhHzW0dw62Yvmoxhs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, jolsa@redhat.com,
        kan.liang@intel.com, vincent.weaver@maine.edu,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 030/186] perf/x86/intel: Allow PEBS multi-entry in watermark mode
Date:   Sat,  1 Jun 2019 09:14:06 -0400
Message-Id: <20190601131653.24205-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

[ Upstream commit c7a286577d7592720c2f179aadfb325a1ff48c95 ]

This patch fixes a restriction/bug introduced by:

   583feb08e7f7 ("perf/x86/intel: Fix handling of wakeup_events for multi-entry PEBS")

The original patch prevented using multi-entry PEBS when wakeup_events != 0.
However given that wakeup_events is part of a union with wakeup_watermark, it
means that in watermark mode, PEBS multi-entry is also disabled which is not the
intent. This patch fixes this by checking is watermark mode is enabled.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: jolsa@redhat.com
Cc: kan.liang@intel.com
Cc: vincent.weaver@maine.edu
Fixes: 583feb08e7f7 ("perf/x86/intel: Fix handling of wakeup_events for multi-entry PEBS")
Link: http://lkml.kernel.org/r/20190514003400.224340-1-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index d35f4775d5f10..82dad001d1ea1 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3189,7 +3189,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 		return ret;
 
 	if (event->attr.precise_ip) {
-		if (!(event->attr.freq || event->attr.wakeup_events)) {
+		if (!(event->attr.freq || (event->attr.wakeup_events && !event->attr.watermark))) {
 			event->hw.flags |= PERF_X86_EVENT_AUTO_RELOAD;
 			if (!(event->attr.sample_type &
 			      ~intel_pmu_large_pebs_flags(event)))
-- 
2.20.1

