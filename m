Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B4214F4F
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbfEFOfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:35:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbfEFOfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:35:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C970F2087F;
        Mon,  6 May 2019 14:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153314;
        bh=DytcGrl3mGpbEuLxTjKHLaMmoB5X9NoU6eNM5+cV+XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sksalBO8JrVcLYzwThGhfQxLQ8wvYyw7rGD+MPbQ/pRS1D7JFWZqiwrtMctCJKq97
         31Bv03QdjBHzkGX3RrEi1ozZHe+J1p8fN6DfoIs58JVM5sLj02LQeHdptbdGu7M8s8
         k8bsgwCVkIz9lRCflwI0RWqqAMbPVolk4RY6YH7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.0 021/122] KVM: x86: Consider LAPIC TSC-Deadline timer expired if deadline too short
Date:   Mon,  6 May 2019 16:31:19 +0200
Message-Id: <20190506143056.649682511@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

commit c09d65d9eab69985c75f98ed64541229f6fa9aa6 upstream.

If guest sets MSR_IA32_TSCDEADLINE to value such that in host
time-domain it's shorter than lapic_timer_advance_ns, we can
reach a case that we call hrtimer_start() with expiration time set at
the past.

Because lapic_timer.timer is init with HRTIMER_MODE_ABS_PINNED, it
is not allowed to run in softirq and therefore will never expire.

To avoid such a scenario, verify that deadline expiration time is set on
host time-domain further than (now + lapic_timer_advance_ns).

A future patch can also consider adding a min_timer_deadline_ns module parameter,
similar to min_timer_period_us to avoid races that amount of ns it takes
to run logic could still call hrtimer_start() with expiration timer set
at the past.

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/lapic.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1543,9 +1543,12 @@ static void start_sw_tscdeadline(struct
 
 	now = ktime_get();
 	guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
-	if (likely(tscdeadline > guest_tsc)) {
-		ns = (tscdeadline - guest_tsc) * 1000000ULL;
-		do_div(ns, this_tsc_khz);
+
+	ns = (tscdeadline - guest_tsc) * 1000000ULL;
+	do_div(ns, this_tsc_khz);
+
+	if (likely(tscdeadline > guest_tsc) &&
+	    likely(ns > lapic_timer_advance_ns)) {
 		expire = ktime_add_ns(now, ns);
 		expire = ktime_sub_ns(expire, lapic_timer_advance_ns);
 		hrtimer_start(&apic->lapic_timer.timer,


