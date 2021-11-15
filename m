Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21CE452242
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345388AbhKPBKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245110AbhKOTTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E6F163448;
        Mon, 15 Nov 2021 18:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000925;
        bh=9oBQyjHEGmZtjDJR+Jj0l4acaldIHuG2OhS+4/trfJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2RbYOWXJyp511O9mtaakhxnKHbU1OGx3ZslRs3V6sXdeVZM5jJjLd0KcT4Vjlqh6j
         Eyqv/pA8cBEc/PN7H9uNIiX3BiJfGygWicoQmUBJJN8qXIDyA4705vNIjUgx0ki9/x
         q9jbPEhx+CcvaWZZqhyVZCJ5HEYCIWML3DrtbfqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.14 817/849] s390/cpumf: cpum_cf PMU displays invalid value after hotplug remove
Date:   Mon, 15 Nov 2021 18:05:00 +0100
Message-Id: <20211115165447.876809608@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

commit 9d48c7afedf91a02d03295837ec76b2fb5e7d3fe upstream.

When a CPU is hotplugged while the perf stat -e cycles command is
running, a wrong (very large) value is displayed immediately after the
CPU removal:

  Check the values, shouldn't be too high as in
            time             counts unit events
     1.001101919           29261846      cycles
     2.002454499           17523405      cycles
     3.003659292           24361161      cycles
     4.004816983 18446744073638406144      cycles
     5.005671647      <not counted>      cycles
     ...

The CPU hotplug off took place after 3 seconds.
The issue is the read of the event count value after 4 seconds when
the CPU is not available and the read of the counter returns an
error. This is treated as a counter value of zero. This results
in a very large value (0 - previous_value).

Fix this by detecting the hotplugged off CPU and report 0 instead
of a very large number.

Cc: stable@vger.kernel.org
Fixes: a029a4eab39e ("s390/cpumf: Allow concurrent access for CPU Measurement Counter Facility")
Reported-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/perf_cpum_cf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -679,8 +679,10 @@ static void cpumf_pmu_stop(struct perf_e
 						      false);
 			if (cfdiag_diffctr(cpuhw, event->hw.config_base))
 				cfdiag_push_sample(event, cpuhw);
-		} else
+		} else if (cpuhw->flags & PMU_F_RESERVED) {
+			/* Only update when PMU not hotplugged off */
 			hw_perf_event_update(event);
+		}
 		hwc->state |= PERF_HES_UPTODATE;
 	}
 }


