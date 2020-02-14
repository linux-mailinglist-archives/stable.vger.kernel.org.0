Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1554A15F0DB
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387730AbgBNR5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:57:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388174AbgBNP5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19B6F222C4;
        Fri, 14 Feb 2020 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695837;
        bh=gSWMBptURQOv6a2L0gBtCD6ZnyHnluDS87v6Rf/xuQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1JfQqo6U9BD2vSSlRLBsLw40q6ubCjZIzJ1/kYF7GFAATWd/nTzVYGke0gbOTFbU
         2nOk7fL9qYKl9yo/AeI9wtEs8YXC4iwKrDGrVWNxM52tRT+kIJk/3npoYmKMue517f
         u5W0wog3cDJxeQEaNc9y8MKIFSEzppC3Nt6UOQrI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boqun Feng <boqun.feng@gmail.com>, linux-hyperv@vger.kernel.org,
        Michael Kelley <mikelley@microsoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 389/542] clocksource/drivers/hyper-v: Reserve PAGE_SIZE space for tsc page
Date:   Fri, 14 Feb 2020 10:46:21 -0500
Message-Id: <20200214154854.6746-389-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com>

[ Upstream commit ddc61bbc45017726a2b450350d476b4dc5ae25ce ]

Currently, the reserved size for a tsc page is 4K, which is enough for
communicating with hypervisor. However, in the case where we want to
export the tsc page to userspace (e.g. for vDSO to read the
clocksource), the tsc page should be at least PAGE_SIZE, otherwise, when
PAGE_SIZE is larger than 4K, extra kernel data will be mapped into
userspace, which means leaking kernel information.

Therefore reserve PAGE_SIZE space for tsc_pg as a preparation for the
vDSO support of ARM64 in the future. Also, while at it, replace all
reference to tsc_pg with hv_get_tsc_page() since it should be the only
interface to access tsc page.

Signed-off-by: Boqun Feng (Microsoft) <boqun.feng@gmail.com>
Cc: linux-hyperv@vger.kernel.org
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20191126021723.4710-1-boqun.feng@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/hyperv_timer.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
index 287d8d58c21ac..b6ea3a2093c56 100644
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -307,17 +307,20 @@ EXPORT_SYMBOL_GPL(hv_stimer_global_cleanup);
 struct clocksource *hyperv_cs;
 EXPORT_SYMBOL_GPL(hyperv_cs);
 
-static struct ms_hyperv_tsc_page tsc_pg __aligned(PAGE_SIZE);
+static union {
+	struct ms_hyperv_tsc_page page;
+	u8 reserved[PAGE_SIZE];
+} tsc_pg __aligned(PAGE_SIZE);
 
 struct ms_hyperv_tsc_page *hv_get_tsc_page(void)
 {
-	return &tsc_pg;
+	return &tsc_pg.page;
 }
 EXPORT_SYMBOL_GPL(hv_get_tsc_page);
 
 static u64 notrace read_hv_clock_tsc(struct clocksource *arg)
 {
-	u64 current_tick = hv_read_tsc_page(&tsc_pg);
+	u64 current_tick = hv_read_tsc_page(hv_get_tsc_page());
 
 	if (current_tick == U64_MAX)
 		hv_get_time_ref_count(current_tick);
@@ -372,7 +375,7 @@ static bool __init hv_init_tsc_clocksource(void)
 		return false;
 
 	hyperv_cs = &hyperv_cs_tsc;
-	phys_addr = virt_to_phys(&tsc_pg);
+	phys_addr = virt_to_phys(hv_get_tsc_page());
 
 	/*
 	 * The Hyper-V TLFS specifies to preserve the value of reserved
-- 
2.20.1

