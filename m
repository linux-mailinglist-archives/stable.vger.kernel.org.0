Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 176E9A7004
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbfICQgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730894AbfICQ1i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CA2D23789;
        Tue,  3 Sep 2019 16:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528057;
        bh=e8P5DWWIAZiS0ZzSbwx32L4ztDWWO7xTmu6X0xz7n6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yu+Be4StFAcXzBY2MjUV7I0hRzF1wbf2PlRPFyYAv4lXcxXFZ7BjnBX2FWBfYeaUJ
         R8y6iIfqtsYCILhhWNiEw6MErsv0IHn1JB3l2MIB37XItK/6WnOges2jzIGzdB14k3
         MzNsHHUfsiX3IO/eyBcV8pC7bOoOJvfSqz+YhEZY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Tatashin <pasha.tatashin@soleen.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 073/167] x86/kvmclock: set offset for kvm unstable clock
Date:   Tue,  3 Sep 2019 12:23:45 -0400
Message-Id: <20190903162519.7136-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Tatashin <pasha.tatashin@soleen.com>

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

