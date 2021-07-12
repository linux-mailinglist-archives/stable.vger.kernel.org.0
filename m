Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A841F3C4969
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhGLGoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236149AbhGLGmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51668610E5;
        Mon, 12 Jul 2021 06:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071948;
        bh=bX0vvbNRP0Tct8NSoWZg+tEOYZPdUGxvgH5JjqQzHXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bamjTuWvONod8h6HR0DAzK11JyVACw3wc8PtnZqq1+eiksmnavkyQcAesxQroj3FR
         wAtPiQCPUkpOeMUZZdsVCtmW0k4BjhYZXLtT15n9UeNeAGMATokN8eBhx8fgUI8LLL
         iIvSIX8mppRtaJRtJ22LtbNBLcLvjnAA7p2Occpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 287/593] cpufreq: Make cpufreq_online() call driver->offline() on errors
Date:   Mon, 12 Jul 2021 08:07:27 +0200
Message-Id: <20210712060915.890759400@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 3b7180573c250eb6e2a7eec54ae91f27472332ea ]

In the CPU removal path the ->offline() callback provided by the
driver is always invoked before ->exit(), but in the cpufreq_online()
error path it is not, so ->exit() is expected to somehow know the
context in which it has been called and act accordingly.

That is less than straightforward, so make cpufreq_online() invoke
the driver's ->offline() callback, if present, on errors before
->exit() too.

This only potentially affects intel_pstate.

Fixes: 91a12e91dc39 ("cpufreq: Allow light-weight tear down and bring up of CPUs")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1e7e3f2ff09f..ebee0ad559fa 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1368,9 +1368,14 @@ static int cpufreq_online(unsigned int cpu)
 			goto out_free_policy;
 		}
 
+		/*
+		 * The initialization has succeeded and the policy is online.
+		 * If there is a problem with its frequency table, take it
+		 * offline and drop it.
+		 */
 		ret = cpufreq_table_validate_and_sort(policy);
 		if (ret)
-			goto out_exit_policy;
+			goto out_offline_policy;
 
 		/* related_cpus should at least include policy->cpus. */
 		cpumask_copy(policy->related_cpus, policy->cpus);
@@ -1513,6 +1518,10 @@ out_destroy_policy:
 
 	up_write(&policy->rwsem);
 
+out_offline_policy:
+	if (cpufreq_driver->offline)
+		cpufreq_driver->offline(policy);
+
 out_exit_policy:
 	if (cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
-- 
2.30.2



