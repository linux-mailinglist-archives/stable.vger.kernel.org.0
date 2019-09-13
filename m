Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6657B2020
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389304AbfIMNQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389872AbfIMNQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:16:37 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E07C20CC7;
        Fri, 13 Sep 2019 13:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380596;
        bh=0z52JgTNdpmxBLeWd/Lzx1felvZI1R8Y+zcyaJqAtc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkSzHBy+cCMxIO9kLDAVkRGnC7sm7h88nwU55mKasVoWy/7o6gBrfLKI/v+snavYI
         JD6goSyZRWU46L3XgFwOG3JP49E7VIUNXP3nnemH/u6I+9blDuVH7qAfufw76O/dry
         nx9cCCysndEWfv3XIhdsBGy3xozzz4+CipVQuXtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/190] x86/kvmclock: set offset for kvm unstable clock
Date:   Fri, 13 Sep 2019 14:05:50 +0100
Message-Id: <20190913130607.198895854@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b5179ec4187251a751832193693d6e474d3445ac ]

VMs may show incorrect uptime and dmesg printk offsets on hypervisors with
unstable clock. The problem is produced when VM is rebooted without exiting
from qemu.

The fix is to calculate clock offset not only for stable clock but for
unstable clock as well, and use kvm_sched_clock_read() which substracts
the offset for both clocks.

This is safe, because pvclock_clocksource_read() does the right thing and
makes sure that clock always goes forward, so once offset is calculated
with unstable clock, we won't get new reads that are smaller than offset,
and thus won't get negative results.

Thank you Jon DeVree for helping to reproduce this issue.

Fixes: 857baa87b642 ("sched/clock: Enable sched clock early")
Cc: stable@vger.kernel.org
Reported-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kvmclock.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 013fe3d21dbb3..2ec202cb9dfd4 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -117,12 +117,8 @@ static u64 kvm_sched_clock_read(void)
 
 static inline void kvm_sched_clock_init(bool stable)
 {
-	if (!stable) {
-		pv_time_ops.sched_clock = kvm_clock_read;
+	if (!stable)
 		clear_sched_clock_stable();
-		return;
-	}
-
 	kvm_sched_clock_offset = kvm_clock_read();
 	pv_time_ops.sched_clock = kvm_sched_clock_read;
 
-- 
2.20.1



