Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5152D4228C8
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236148AbhJENyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235196AbhJENxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1121615E6;
        Tue,  5 Oct 2021 13:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441892;
        bh=eUeU9bo79CwZcny0+JKZ8QpzagefINlaXNsT2xL8B8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3w/tF8ogOcKqFKt+P/EkHOjrdiKs8fyhIkFdPnBOyiNvjbK278PbxeRu8txHaQRZ
         wLc+v9Z/jHS2dkVrEM8foAoS3vKNWrv8iOCUWpd2T9jnDFHXfkDWKkC69FvdtGjE2J
         cs7bxvCnHAF2oMTouNktDU8gmP8+Dy/Yki5aa28Y9RHhd24TvPpzpFMHQJTY6yELH3
         Yvk05lw/6qBjpGxSdkNuQU6YvgONizzUb2B1u2oRofygeTO1L9JWVzSiBT8kcsx/gJ
         GJA29FAxoTgleWbgAwulct6LuVmMumXJizc2i1Ybv/H0bViXZdqGP3yfolBKkiJdMD
         rH2UpLTO4NatA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anand K Mistry <amistry@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, tglx@linutronix.de, bp@alien8.de, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 36/40] perf/x86: Reset destroy callback on event init failure
Date:   Tue,  5 Oct 2021 09:50:15 -0400
Message-Id: <20211005135020.214291-36-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand K Mistry <amistry@google.com>

[ Upstream commit 02d029a41dc986e2d5a77ecca45803857b346829 ]

perf_init_event tries multiple init callbacks and does not reset the
event state between tries. When x86_pmu_event_init runs, it
unconditionally sets the destroy callback to hw_perf_event_destroy. On
the next init attempt after x86_pmu_event_init, in perf_try_init_event,
if the pmu's capabilities includes PERF_PMU_CAP_NO_EXCLUDE, the destroy
callback will be run. However, if the next init didn't set the destroy
callback, hw_perf_event_destroy will be run (since the callback wasn't
reset).

Looking at other pmu init functions, the common pattern is to only set
the destroy callback on a successful init. Resetting the callback on
failure tries to replicate that pattern.

This was discovered after commit f11dd0d80555 ("perf/x86/amd/ibs: Extend
PERF_PMU_CAP_NO_EXCLUDE to IBS Op") when the second (and only second)
run of the perf tool after a reboot results in 0 samples being
generated. The extra run of hw_perf_event_destroy results in
active_events having an extra decrement on each perf run. The second run
has active_events == 0 and every subsequent run has active_events < 0.
When active_events == 0, the NMI handler will early-out and not record
any samples.

Signed-off-by: Anand K Mistry <amistry@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210929170405.1.I078b98ee7727f9ae9d6df8262bad7e325e40faf0@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 3092fbf9dbe4..98729ce89917 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2467,6 +2467,7 @@ static int x86_pmu_event_init(struct perf_event *event)
 	if (err) {
 		if (event->destroy)
 			event->destroy(event);
+		event->destroy = NULL;
 	}
 
 	if (READ_ONCE(x86_pmu.attr_rdpmc) &&
-- 
2.33.0

