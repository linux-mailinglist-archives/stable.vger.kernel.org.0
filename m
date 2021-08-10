Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246FA3E808C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhHJRuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235539AbhHJRs2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:48:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06D9E610CB;
        Tue, 10 Aug 2021 17:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617274;
        bh=MAHoygpLlLfY3HIeSAJW9XpLd4F/lbg16/4FUEcB4XI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0xbUtGPMO+AE3G4X0I2VWfM9cbq4QRP2C1/7aLlg3Pe+R9rg69zLyJ+BZjr2qVvj
         wNuhkrbNrsw7p+YDsOZ/JsWoNzFGnSStPOz7VHI/oBgHMspPIDL8Cmb07D2KTBkmu0
         fRbtqxoUUe2swGayuXqAJ4Ib0fNNiM9MW+VT9g2I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <likexu@tencent.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH 5.10 123/135] perf/x86/amd: Dont touch the AMD64_EVENTSEL_HOSTONLY bit inside the guest
Date:   Tue, 10 Aug 2021 19:30:57 +0200
Message-Id: <20210810172959.982346545@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <likexu@tencent.com>

commit df51fe7ea1c1c2c3bfdb81279712fdd2e4ea6c27 upstream.

If we use "perf record" in an AMD Milan guest, dmesg reports a #GP
warning from an unchecked MSR access error on MSR_F15H_PERF_CTLx:

  [] unchecked MSR access error: WRMSR to 0xc0010200 (tried to write 0x0000020000110076) at rIP: 0xffffffff8106ddb4 (native_write_msr+0x4/0x20)
  [] Call Trace:
  []  amd_pmu_disable_event+0x22/0x90
  []  x86_pmu_stop+0x4c/0xa0
  []  x86_pmu_del+0x3a/0x140

The AMD64_EVENTSEL_HOSTONLY bit is defined and used on the host,
while the guest perf driver should avoid such use.

Fixes: 1018faa6cf23 ("perf/x86/kvm: Fix Host-Only/Guest-Only counting with SVM disabled")
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Tested-by: Liam Merwick <liam.merwick@oracle.com>
Link: https://lkml.kernel.org/r/20210802070850.35295-1-likexu@tencent.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/perf_event.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1009,9 +1009,10 @@ void x86_pmu_stop(struct perf_event *eve
 
 static inline void x86_pmu_disable_event(struct perf_event *event)
 {
+	u64 disable_mask = __this_cpu_read(cpu_hw_events.perf_ctr_virt_mask);
 	struct hw_perf_event *hwc = &event->hw;
 
-	wrmsrl(hwc->config_base, hwc->config);
+	wrmsrl(hwc->config_base, hwc->config & ~disable_mask);
 
 	if (is_counter_pair(hwc))
 		wrmsrl(x86_pmu_config_addr(hwc->idx + 1), 0);


