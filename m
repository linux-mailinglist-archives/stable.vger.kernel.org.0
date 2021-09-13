Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9054090CE
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244886AbhIMNzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243611AbhIMNxh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:53:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EA0361994;
        Mon, 13 Sep 2021 13:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540091;
        bh=eDgv26IYjTek4tHtjF1IaMYKXOB7/58/E6cQPlvcs4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0XGEVMs1uU+ewzlBXf71zwpX2CV9zuf/e3Ji/D7Uia26cWpiyHD+TFw7iEAT19fz
         Yg0NDfq84EB2soWGMEVu+H23j8buD+nXI1kQBwwz+czCzOsQze4SngFYkS+NFXCA8Z
         Q8JlCnzu2+Oz7oQgtSxVksEiskE6jDeBLS1rsuIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 047/300] sched/debug: Dont update sched_domain debug directories before sched_debug_init()
Date:   Mon, 13 Sep 2021 15:11:48 +0200
Message-Id: <20210913131110.929879978@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit 459b09b5a3254008b63382bf41a9b36d0b590f57 ]

Since CPU capacity asymmetry can stem purely from maximum frequency
differences (e.g. Pixel 1), a rebuild of the scheduler topology can be
issued upon loading cpufreq, see:

  arch_topology.c::init_cpu_capacity_callback()

Turns out that if this rebuild happens *before* sched_debug_init() is
run (which is a late initcall), we end up messing up the sched_domain debug
directory: passing a NULL parent to debugfs_create_dir() ends up creating
the directory at the debugfs root, which in this case creates
/sys/kernel/debug/domains (instead of /sys/kernel/debug/sched/domains).

This currently doesn't happen on asymmetric systems which use cpufreq-scpi
or cpufreq-dt drivers, as those are loaded via
deferred_probe_initcall() (it is also a late initcall, but appears to be
ordered *after* sched_debug_init()).

Ionela has been working on detecting maximum frequency asymmetry via ACPI,
and that actually happens via a *device* initcall, thus before
sched_debug_init(), and causes the aforementionned debugfs mayhem.

One option would be to punt sched_debug_init() down to
fs_initcall_sync(). Preventing update_sched_domain_debugfs() from running
before sched_debug_init() appears to be the safer option.

Fixes: 3b87f136f8fc ("sched,debug: Convert sysctl sched_domains to debugfs")
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lore.kernel.org/r/20210514095339.12979-1-ionela.voinescu@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/debug.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index c5aacbd492a1..f8c94bebd17d 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -388,6 +388,13 @@ void update_sched_domain_debugfs(void)
 {
 	int cpu, i;
 
+	/*
+	 * This can unfortunately be invoked before sched_debug_init() creates
+	 * the debug directory. Don't touch sd_sysctl_cpus until then.
+	 */
+	if (!debugfs_sched)
+		return;
+
 	if (!cpumask_available(sd_sysctl_cpus)) {
 		if (!alloc_cpumask_var(&sd_sysctl_cpus, GFP_KERNEL))
 			return;
-- 
2.30.2



