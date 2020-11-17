Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74122B63C4
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733087AbgKQNlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732362AbgKQNlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:41:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98F7120888;
        Tue, 17 Nov 2020 13:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620484;
        bh=SqEYFhE6gzRNhglA2IlGwgtNQM9hTjy+6f6SFA4GZ0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPnQw37qujb+ix9j3YHNHoM4xz/Swkcvbg2QKT9XVbccCyhDJq0rOGsc9393i0xTM
         SIFrr3wwlSWKSSzjNdul6gqi9UAgJSbC3QnKZMaZazJce8v8N8w8KYyaPJwVNim8ok
         3ncjqLEXGMKkAbki4xQI5t22YxyO/5waLIlrme/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.9 235/255] cpufreq: Introduce governor flags
Date:   Tue, 17 Nov 2020 14:06:15 +0100
Message-Id: <20201117122150.375972015@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 9a2a9ebc0a758d887ee06e067e9f7f0b36ff7574 upstream.

A new cpufreq governor flag will be added subsequently, so replace
the bool dynamic_switching fleid in struct cpufreq_governor with a
flags field and introduce CPUFREQ_GOV_DYNAMIC_SWITCHING to set for
the "dynamic switching" governors instead of it.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c          |    2 +-
 drivers/cpufreq/cpufreq_governor.h |    2 +-
 include/linux/cpufreq.h            |    9 +++++++--
 kernel/sched/cpufreq_schedutil.c   |    2 +-
 4 files changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2233,7 +2233,7 @@ static int cpufreq_init_governor(struct
 		return -EINVAL;
 
 	/* Platform doesn't want dynamic frequency switching ? */
-	if (policy->governor->dynamic_switching &&
+	if (policy->governor->flags & CPUFREQ_GOV_DYNAMIC_SWITCHING &&
 	    cpufreq_driver->flags & CPUFREQ_NO_AUTO_DYNAMIC_SWITCHING) {
 		struct cpufreq_governor *gov = cpufreq_fallback_governor();
 
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -156,7 +156,7 @@ void cpufreq_dbs_governor_limits(struct
 #define CPUFREQ_DBS_GOVERNOR_INITIALIZER(_name_)			\
 	{								\
 		.name = _name_,						\
-		.dynamic_switching = true,				\
+		.flags = CPUFREQ_GOV_DYNAMIC_SWITCHING,			\
 		.owner = THIS_MODULE,					\
 		.init = cpufreq_dbs_governor_init,			\
 		.exit = cpufreq_dbs_governor_exit,			\
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -565,12 +565,17 @@ struct cpufreq_governor {
 					 char *buf);
 	int	(*store_setspeed)	(struct cpufreq_policy *policy,
 					 unsigned int freq);
-	/* For governors which change frequency dynamically by themselves */
-	bool			dynamic_switching;
 	struct list_head	governor_list;
 	struct module		*owner;
+	u8			flags;
 };
 
+/* Governor flags */
+
+/* For governors which change frequency dynamically by themselves */
+#define CPUFREQ_GOV_DYNAMIC_SWITCHING	BIT(0)
+
+
 /* Pass a target to the cpufreq driver */
 unsigned int cpufreq_driver_fast_switch(struct cpufreq_policy *policy,
 					unsigned int target_freq);
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -896,7 +896,7 @@ static void sugov_limits(struct cpufreq_
 struct cpufreq_governor schedutil_gov = {
 	.name			= "schedutil",
 	.owner			= THIS_MODULE,
-	.dynamic_switching	= true,
+	.flags			= CPUFREQ_GOV_DYNAMIC_SWITCHING,
 	.init			= sugov_init,
 	.exit			= sugov_exit,
 	.start			= sugov_start,


