Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A4829BCB8
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811029AbgJ0Qgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763574AbgJ0PsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:48:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E98322264;
        Tue, 27 Oct 2020 15:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813691;
        bh=AlSTechtl9/ofX2jnWK7w8USo9W8Au2oyD86C0+T6Xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jivsPAhEvGBRw1DI4SvwNVMF1u+w4Pnej077/TLy767ku/fDqk3RN6g7PIxHyANiV
         XRm6F5i1q8T8ea1JctiuKcgGgZa9bVLWMBi/WyvgJ8LV/pp7AMllH0V32E0cYpUWah
         Q8XqVDO0fiW6csrVoDy2x5kBdVOX4A5Y5s0SjKH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Patrick Bellasi <patrick.bellasi@matbug.net>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 637/757] sched/features: Fix !CONFIG_JUMP_LABEL case
Date:   Tue, 27 Oct 2020 14:54:47 +0100
Message-Id: <20201027135520.437967378@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit a73f863af4ce9730795eab7097fb2102e6854365 ]

Commit:

  765cc3a4b224e ("sched/core: Optimize sched_feat() for !CONFIG_SCHED_DEBUG builds")

made sched features static for !CONFIG_SCHED_DEBUG configurations, but
overlooked the CONFIG_SCHED_DEBUG=y and !CONFIG_JUMP_LABEL cases.

For the latter echoing changes to /sys/kernel/debug/sched_features has
the nasty effect of effectively changing what sched_features reports,
but without actually changing the scheduler behaviour (since different
translation units get different sysctl_sched_features).

Fix CONFIG_SCHED_DEBUG=y and !CONFIG_JUMP_LABEL configurations by properly
restructuring ifdefs.

Fixes: 765cc3a4b224e ("sched/core: Optimize sched_feat() for !CONFIG_SCHED_DEBUG builds")
Co-developed-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Patrick Bellasi <patrick.bellasi@matbug.net>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lore.kernel.org/r/20201013053114.160628-1-juri.lelli@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c  |  2 +-
 kernel/sched/sched.h | 13 ++++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d95dc3f46444..b1e0da56abcac 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -43,7 +43,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(sched_update_nr_running_tp);
 
 DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
-#if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_JUMP_LABEL)
+#ifdef CONFIG_SCHED_DEBUG
 /*
  * Debugging: various feature bits
  *
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 28709f6b0975c..8d1ca65db3b0d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1629,7 +1629,7 @@ enum {
 
 #undef SCHED_FEAT
 
-#if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_JUMP_LABEL)
+#ifdef CONFIG_SCHED_DEBUG
 
 /*
  * To support run-time toggling of sched features, all the translation units
@@ -1637,6 +1637,7 @@ enum {
  */
 extern const_debug unsigned int sysctl_sched_features;
 
+#ifdef CONFIG_JUMP_LABEL
 #define SCHED_FEAT(name, enabled)					\
 static __always_inline bool static_branch_##name(struct static_key *key) \
 {									\
@@ -1649,7 +1650,13 @@ static __always_inline bool static_branch_##name(struct static_key *key) \
 extern struct static_key sched_feat_keys[__SCHED_FEAT_NR];
 #define sched_feat(x) (static_branch_##x(&sched_feat_keys[__SCHED_FEAT_##x]))
 
-#else /* !(SCHED_DEBUG && CONFIG_JUMP_LABEL) */
+#else /* !CONFIG_JUMP_LABEL */
+
+#define sched_feat(x) (sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
+
+#endif /* CONFIG_JUMP_LABEL */
+
+#else /* !SCHED_DEBUG */
 
 /*
  * Each translation unit has its own copy of sysctl_sched_features to allow
@@ -1665,7 +1672,7 @@ static const_debug __maybe_unused unsigned int sysctl_sched_features =
 
 #define sched_feat(x) !!(sysctl_sched_features & (1UL << __SCHED_FEAT_##x))
 
-#endif /* SCHED_DEBUG && CONFIG_JUMP_LABEL */
+#endif /* SCHED_DEBUG */
 
 extern struct static_key_false sched_numa_balancing;
 extern struct static_key_false sched_schedstats;
-- 
2.25.1



