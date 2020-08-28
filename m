Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9E1255AAC
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 14:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbgH1M43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 08:56:29 -0400
Received: from foss.arm.com ([217.140.110.172]:48490 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729317AbgH1M42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Aug 2020 08:56:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA2A31FB;
        Fri, 28 Aug 2020 05:56:25 -0700 (PDT)
Received: from e107158-lin.cambridge.arm.com (e107158-lin.cambridge.arm.com [10.1.195.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF2343F66B;
        Fri, 28 Aug 2020 05:56:24 -0700 (PDT)
From:   Qais Yousef <qais.yousef@arm.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH 0/2] Backport uclamp static key to 5.4.y stable
Date:   Fri, 28 Aug 2020 13:56:08 +0100
Message-Id: <20200828125610.30943-1-qais.yousef@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg/Sasha

The following 2 patches are backports of

	46609ce22703: ("sched/uclamp: Protect uclamp fast path code with static key")
	e65855a52b47: ("sched/uclamp: Fix a deadlock when enabling uclamp static key")

into 5.4.y stable tree. The conflict was trivial and due to:

	1. uclamp_rq_util_with() was renamed from util_util_with()
	2. 2 local variables were converted to unsigned long from unsigned int.

I did do compile test on aarch64 and x86_64 and both looked fine. Beside I ran
a quick and short mmtest to verify the functionality and got the following
results which is inline with what's expected.

                        5.4.y                  5.4.y-static-keys
Hmean     send-64       188.46 (   0.00%)      189.95 *   0.79%*
Hmean     send-128      375.65 (   0.00%)      379.75 *   1.09%*

7.32%     -0.33%  [kernel.kallsyms]        [k] try_to_wake_up
0.58%     -0.55%  [kernel.kallsyms]        [k] deactivate_task
0.50%     -0.45%  [kernel.kallsyms]        [k] activate_task


That said, it's Friday afternoon and I am off next week. If I did something
stupid and didn't find me, please accept my apologies in advance and will fix
it as soon as I am back online.

Thanks

--
Qais Yousef


Qais Yousef (2):
  sched/uclamp: Protect uclamp fast path code with static key
  sched/uclamp: Fix a deadlock when enabling uclamp static key

 kernel/sched/core.c              | 81 +++++++++++++++++++++++++++++++-
 kernel/sched/cpufreq_schedutil.c |  2 +-
 kernel/sched/sched.h             | 47 +++++++++++++++++-
 3 files changed, 126 insertions(+), 4 deletions(-)

-- 
2.17.1

