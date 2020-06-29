Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC9C20DB2E
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730801AbgF2UEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:04:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732995AbgF2Tac (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6326252D0;
        Mon, 29 Jun 2020 15:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445096;
        bh=nlWEtgoIaJ49QS6lXuyyuMLbym1Vx8sa5bAILlZk6Tc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLF+A536CYYIxjRdn1QaLCB8Uk/+bUoet8Pu0Da6yQYwS4UAcogs2f8GNhRNVf9D0
         2kmj5QVTw0yzDox/LmH8a/QdiM0TEQZ6WWCMT3JijjgqVUpThxXFft2FvLL5lwekAt
         KqRPWYstMoU8OHicgZWS6Vi9JgnboXAe+mXGKA5M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jann Horn <jannh@google.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        kernel test robot <rong.a.chen@intel.com>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/78] apparmor: don't try to replace stale label in ptraceme check
Date:   Mon, 29 Jun 2020 11:36:54 -0400
Message-Id: <20200629153806.2494953-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit ca3fde5214e1d24f78269b337d3f22afd6bf445e ]

begin_current_label_crit_section() must run in sleepable context because
when label_is_stale() is true, aa_replace_current_label() runs, which uses
prepare_creds(), which can sleep.

Until now, the ptraceme access check (which runs with tasklist_lock held)
violated this rule.

Fixes: b2d09ae449ced ("apparmor: move ptrace checks to using labels")
Reported-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 4f08023101f3c..1c6b389ad8f94 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -123,11 +123,11 @@ static int apparmor_ptrace_traceme(struct task_struct *parent)
 	struct aa_label *tracer, *tracee;
 	int error;
 
-	tracee = begin_current_label_crit_section();
+	tracee = __begin_current_label_crit_section();
 	tracer = aa_get_task_label(parent);
 	error = aa_may_ptrace(tracer, tracee, AA_PTRACE_TRACE);
 	aa_put_label(tracer);
-	end_current_label_crit_section(tracee);
+	__end_current_label_crit_section(tracee);
 
 	return error;
 }
-- 
2.25.1

