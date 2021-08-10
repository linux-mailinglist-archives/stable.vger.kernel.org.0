Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7313E7EA2
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhHJReg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232498AbhHJRd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:33:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB6C160F94;
        Tue, 10 Aug 2021 17:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616814;
        bh=ihAvkDK7uaKrqIGBsVrJT2bcZ8CGQmp7iO0hrwSPxCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Asf5BRfO55dIBxJRSRxqo1SuML9UakDP+d3bzcd29lHofD32nRZf9dUB+yedSPysQ
         3P11obWpmbZGXvi3XPbJLwk7DNjyTMhDHnUlO+hn8UphcdRE0Qh13YpYOwQAmk03I2
         sxEwrcAwEBGDNrXuW2odQdAf8xaHXD0MVYjUOBH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <likexu@tencent.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH 4.19 47/54] perf/x86/amd: Dont touch the AMD64_EVENTSEL_HOSTONLY bit inside the guest
Date:   Tue, 10 Aug 2021 19:30:41 +0200
Message-Id: <20210810172945.744299691@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
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
@@ -799,9 +799,10 @@ void x86_pmu_stop(struct perf_event *eve
 
 static inline void x86_pmu_disable_event(struct perf_event *event)
 {
+	u64 disable_mask = __this_cpu_read(cpu_hw_events.perf_ctr_virt_mask);
 	struct hw_perf_event *hwc = &event->hw;
 
-	wrmsrl(hwc->config_base, hwc->config);
+	wrmsrl(hwc->config_base, hwc->config & ~disable_mask);
 }
 
 void x86_pmu_enable_event(struct perf_event *event);


