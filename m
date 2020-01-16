Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA9213E6DE
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391494AbgAPRVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:21:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391200AbgAPRR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:17:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C71E21582;
        Thu, 16 Jan 2020 17:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195045;
        bh=sUEmpbvttt0S4MWyiKJbNj8b+VkU2b5Kh+cieFdT378=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z30zkRLj1VVOTkOOT8Lko9JuuA+kD9FEAMZlLISnv6iGM+jd5OXVqvLPHe8+dbjRA
         iqINVjF/+xa9AUkJwlu7zlipNfXuYnhi5DfRF2Xh68hjopnzTU1J7NJ/nnI1LS5eAs
         DYRs8pq67j7olWgtMthvvD7HTHf4x0u/aTKBdJq0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 004/371] apparmor: don't try to replace stale label in ptrace access check
Date:   Thu, 16 Jan 2020 12:11:12 -0500
Message-Id: <20200116171719.16965-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116171719.16965-1-sashal@kernel.org>
References: <20200116171719.16965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit 1f8266ff58840d698a1e96d2274189de1bdf7969 ]

As a comment above begin_current_label_crit_section() explains,
begin_current_label_crit_section() must run in sleepable context because
when label_is_stale() is true, aa_replace_current_label() runs, which uses
prepare_creds(), which can sleep.
Until now, the ptrace access check (which runs with a task lock held)
violated this rule.

Also add a might_sleep() assertion to begin_current_label_crit_section(),
because asserts are less likely to be ignored than comments.

Fixes: b2d09ae449ced ("apparmor: move ptrace checks to using labels")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/context.h | 2 ++
 security/apparmor/lsm.c             | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/include/context.h b/security/apparmor/include/context.h
index 6ae07e9aaa17..812cdec9dd3b 100644
--- a/security/apparmor/include/context.h
+++ b/security/apparmor/include/context.h
@@ -191,6 +191,8 @@ static inline struct aa_label *begin_current_label_crit_section(void)
 {
 	struct aa_label *label = aa_current_raw_label();
 
+	might_sleep();
+
 	if (label_is_stale(label)) {
 		label = aa_get_newest_label(label);
 		if (aa_replace_current_label(label) == 0)
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 1346ee5be04f..4f08023101f3 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -108,12 +108,12 @@ static int apparmor_ptrace_access_check(struct task_struct *child,
 	struct aa_label *tracer, *tracee;
 	int error;
 
-	tracer = begin_current_label_crit_section();
+	tracer = __begin_current_label_crit_section();
 	tracee = aa_get_task_label(child);
 	error = aa_may_ptrace(tracer, tracee,
 		  mode == PTRACE_MODE_READ ? AA_PTRACE_READ : AA_PTRACE_TRACE);
 	aa_put_label(tracee);
-	end_current_label_crit_section(tracer);
+	__end_current_label_crit_section(tracer);
 
 	return error;
 }
-- 
2.20.1

