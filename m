Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5697B20524
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfEPLl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728167AbfEPLlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 07:41:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A116D20848;
        Thu, 16 May 2019 11:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006884;
        bh=CaOX8HMPFwv8yZnzHXXt2cK0AbeaTHQTOz1dQJgJDJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JxS0y/OwZWXYLTdQtX0iMDzF2FAcalOWWWKs0Ncr8pZkKSP24pXetnqdHBldBAq4x
         j6qiFdusMYv9Pz7f/2gKfFCDluZGLkpPFzj12AeLDIFyxR2HRng1sYwmfPKE/84YJW
         A1/ffi1AYTknbv7cpC0LM3TpUDtSgGxmbSNtl8HY=
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
Subject: [PATCH AUTOSEL 4.14 13/16] sched/cpufreq: Fix kobject memleak
Date:   Thu, 16 May 2019 07:41:04 -0400
Message-Id: <20190516114107.8963-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114107.8963-1-sashal@kernel.org>
References: <20190516114107.8963-1-sashal@kernel.org>
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
index b314c9eaa71d3..f8c45d30ec6d0 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -600,6 +600,7 @@ static int sugov_init(struct cpufreq_policy *policy)
 	return 0;
 
 fail:
+	kobject_put(&tunables->attr_set.kobj);
 	policy->governor_data = NULL;
 	sugov_tunables_free(tunables);
 
-- 
2.20.1

