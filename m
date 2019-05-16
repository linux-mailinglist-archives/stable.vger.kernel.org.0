Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDBE5205C6
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfEPLkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727623AbfEPLkK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 07:40:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22E822166E;
        Thu, 16 May 2019 11:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006809;
        bh=l+F/wCaVQwtNPXQ5GJJyzT3CrQGWxxyIwZ5VERIBQE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y92i/Lo/L0ES+yj6L+BPRokmkrhBiw3iRXIY8teKMO3JPLrhoaFngOWWd0J0k4Iug
         bLLB9uFeXQpx7cYig8IY6Tqnx9kUtfUu/UgI88aDR+AMWHug9X8JC9neTmKM2NEXfF
         dZ4I/VE+B1apPto7SLiyoa2iyHTB+jn91fbLZ/Hw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 26/34] sched/cpufreq: Fix kobject memleak
Date:   Thu, 16 May 2019 07:39:23 -0400
Message-Id: <20190516113932.8348-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516113932.8348-1-sashal@kernel.org>
References: <20190516113932.8348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Tobin C. Harding" <tobin@kernel.org>

[ Upstream commit 9a4f26cc98d81b67ecc23b890c28e2df324e29f3 ]

Currently the error return path from kobject_init_and_add() is not
followed by a call to kobject_put() - which means we are leaking
the kobject.

Fix it by adding a call to kobject_put() in the error path of
kobject_init_and_add().

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Link: http://lkml.kernel.org/r/20190430001144.24890-1-tobin@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/cpufreq_schedutil.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index 1ccf77f6d346d..d4ab9245e016c 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -771,6 +771,7 @@ static int sugov_init(struct cpufreq_policy *policy)
 	return 0;
 
 fail:
+	kobject_put(&tunables->attr_set.kobj);
 	policy->governor_data = NULL;
 	sugov_tunables_free(tunables);
 
-- 
2.20.1

