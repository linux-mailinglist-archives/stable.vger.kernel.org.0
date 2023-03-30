Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437A76D0A56
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 17:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbjC3PuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 11:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbjC3PuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 11:50:00 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0688ECA07
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 08:49:35 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id bz27so18878068qtb.1
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 08:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1680191368;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Vil2eKpiNnTMX9jA+HvlVZIvmGd1fQxhTcUQOW8Puig=;
        b=e8Mih22wrNYCfAXGBK0vuNlm8UKe2HkzjWtxH7CV/4rx1Q4AibeFr4Xjfur15O4YmW
         IMBHepmG+q913Bx4QnLZoUBIeClqEdkjLwYwbuWYb4HoJob09uNFDDyUbGW1PXzSgnaF
         copoSVW03mRQqk12K5e6fSYri+EF723APIZRs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680191368;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vil2eKpiNnTMX9jA+HvlVZIvmGd1fQxhTcUQOW8Puig=;
        b=tQq6fELbNIC8GcNrFSV1gmHVfEVjxkKxGNpOw50uoSjKWR9zBgVMRo5lSPYqFb+NdN
         owzKDBSJIWHJnaU7CvuQqkaPS4T6sUIHk2bUa7TPe1aBih3y2VbYYxbhEDQENpFlVs6e
         PTKy8afJoOiENTvm/lN0qe3K+EhkJR1QtafcMprFARJ1NWG1cL7qBUmF1JJk4EI8d4EK
         35LN2mFdfZhVT5nn4fwJbavjkD1GBcnI6kX6rW9A5oRDfeyeLTdQiWp70MPECXqDCGFk
         euh+PZXvFFU7vUrJQmDavNiNywfNDKa7cQt5u0UyuwFrf6H+ZTPjAfE27rxograpPfrU
         S54w==
X-Gm-Message-State: AO0yUKXIIlUNtqjVtaSsCCtQ9P7Vhu3c5wYia9XJjDtChAlILErVDN9p
        uiBf2URd5+xAG8mObcus+t0ujQ==
X-Google-Smtp-Source: AK7set9bulSBIubZM96NEfSd6rzIkSdshjJcrQkRFjuAatfnDeaSj2RhFiEPOJRm8OkE4MvfvHDfcA==
X-Received: by 2002:ac8:5b96:0:b0:3bf:c9d1:4276 with SMTP id a22-20020ac85b96000000b003bfc9d14276mr38021954qta.5.1680191368416;
        Thu, 30 Mar 2023 08:49:28 -0700 (PDT)
Received: from localhost (129.239.188.35.bc.googleusercontent.com. [35.188.239.129])
        by smtp.gmail.com with ESMTPSA id s80-20020a37a953000000b00741a984943fsm11736875qke.40.2023.03.30.08.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 08:49:27 -0700 (PDT)
Date:   Thu, 30 Mar 2023 15:49:27 +0000
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        rcu <rcu@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 04/13] tick/nohz: Fix cpu_is_hotpluggable() by
 checking with nohz subsystem
Message-ID: <20230330154927.GJ2114899@google.com>
References: <20230325173316.3118674-1-joel@joelfernandes.org>
 <20230325173316.3118674-5-joel@joelfernandes.org>
 <ZCCeS/VeGthUNgIY@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZCCeS/VeGthUNgIY@localhost.localdomain>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 26, 2023 at 09:34:35PM +0200, Frederic Weisbecker wrote:
> Le Sat, Mar 25, 2023 at 05:33:07PM +0000, Joel Fernandes (Google) a écrit :
> > For CONFIG_NO_HZ_FULL systems, the tick_do_timer_cpu cannot be offlined.
> > However, cpu_is_hotpluggable() still returns true for those CPUs. This causes
> > torture tests that do offlining to end up trying to offline this CPU causing
> > test failures. Such failure happens on all architectures.
> 
> It might be worth noting that hotplug failure is fine on hotplug testing.
> The issue here is the repetitive error message in the logs.
> 
> Other than that:
> 
> Acked-by: Frederic Weisbecker <frederic@kernel.org>

Thank you, below is the reworded update. Let me know if any other comment.

-------8<-------

From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH] tick/nohz: Fix cpu_is_hotpluggable() by checking with nohz
 subsystem

For CONFIG_NO_HZ_FULL systems, the tick_do_timer_cpu cannot be offlined.
However, cpu_is_hotpluggable() still returns true for those CPUs. This causes
torture tests that do offlining to end up trying to offline this CPU causing
test failures. Such failure happens on all architectures.

Fix the repeated error messages thrown as a result (even if the hotplug
errors are harmless), by asking the opinion of the nohz subsystem on whether
the CPU can be hotplugged.

[ Apply Frederic Weisbecker feedback on refactoring tick_nohz_cpu_down(). ]

For drivers/base/ portion:
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: rcu <rcu@vger.kernel.org>
Cc: stable@vger.kernel.org
Fixes: 2987557f52b9 ("driver-core/cpu: Expose hotpluggability to the rest of the kernel")
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 drivers/base/cpu.c       |  3 ++-
 include/linux/tick.h     |  2 ++
 kernel/time/tick-sched.c | 11 ++++++++---
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 182c6122f815..c1815b9dae68 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -487,7 +487,8 @@ static const struct attribute_group *cpu_root_attr_groups[] = {
 bool cpu_is_hotpluggable(unsigned int cpu)
 {
 	struct device *dev = get_cpu_device(cpu);
-	return dev && container_of(dev, struct cpu, dev)->hotpluggable;
+	return dev && container_of(dev, struct cpu, dev)->hotpluggable
+		&& tick_nohz_cpu_hotpluggable(cpu);
 }
 EXPORT_SYMBOL_GPL(cpu_is_hotpluggable);
 
diff --git a/include/linux/tick.h b/include/linux/tick.h
index bfd571f18cfd..9459fef5b857 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -216,6 +216,7 @@ extern void tick_nohz_dep_set_signal(struct task_struct *tsk,
 				     enum tick_dep_bits bit);
 extern void tick_nohz_dep_clear_signal(struct signal_struct *signal,
 				       enum tick_dep_bits bit);
+extern bool tick_nohz_cpu_hotpluggable(unsigned int cpu);
 
 /*
  * The below are tick_nohz_[set,clear]_dep() wrappers that optimize off-cases
@@ -280,6 +281,7 @@ static inline void tick_nohz_full_add_cpus_to(struct cpumask *mask) { }
 
 static inline void tick_nohz_dep_set_cpu(int cpu, enum tick_dep_bits bit) { }
 static inline void tick_nohz_dep_clear_cpu(int cpu, enum tick_dep_bits bit) { }
+static inline bool tick_nohz_cpu_hotpluggable(unsigned int cpu) { return true; }
 
 static inline void tick_dep_set(enum tick_dep_bits bit) { }
 static inline void tick_dep_clear(enum tick_dep_bits bit) { }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index ba2ac1469d47..a46506f7ec6d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -532,7 +532,7 @@ void __init tick_nohz_full_setup(cpumask_var_t cpumask)
 	tick_nohz_full_running = true;
 }
 
-static int tick_nohz_cpu_down(unsigned int cpu)
+bool tick_nohz_cpu_hotpluggable(unsigned int cpu)
 {
 	/*
 	 * The tick_do_timer_cpu CPU handles housekeeping duty (unbound
@@ -540,8 +540,13 @@ static int tick_nohz_cpu_down(unsigned int cpu)
 	 * CPUs. It must remain online when nohz full is enabled.
 	 */
 	if (tick_nohz_full_running && tick_do_timer_cpu == cpu)
-		return -EBUSY;
-	return 0;
+		return false;
+	return true;
+}
+
+static int tick_nohz_cpu_down(unsigned int cpu)
+{
+	return tick_nohz_cpu_hotpluggable(cpu) ? 0 : -EBUSY;
 }
 
 void __init tick_nohz_init(void)
-- 
2.40.0.rc1.284.g88254d51c5-goog

