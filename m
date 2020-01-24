Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13353147B75
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731098AbgAXJnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:43:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:41892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730816AbgAXJnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:43:46 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0262F21569;
        Fri, 24 Jan 2020 09:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859025;
        bh=FNG82X2hRIlfsjMiNepaYBnQbHxKmTNGKSIjw1rnnc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iP5+sTA6GMRUG4qyLN24APS34gjiK+f3enfbqzPEmGcnktRuuWsE10GXUij0kYsi2
         F6N7ISl8/mO5qJVtYxnK0fowtPHmnw/OnsNquoJFLomUV8nDoNzvG12ms9ird3v+Po
         ziVXd1zmDrXmkb5LKw6Xm8o8iz74u9H60A/LtMUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 011/343] apparmor: dont try to replace stale label in ptrace access check
Date:   Fri, 24 Jan 2020 10:27:09 +0100
Message-Id: <20200124092921.117289827@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6ae07e9aaa172..812cdec9dd3be 100644
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
index 1346ee5be04f1..4f08023101f3c 100644
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



