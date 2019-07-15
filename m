Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B831C694B1
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392033AbfGOOxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731218AbfGOO3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:29:41 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 487CF20868;
        Mon, 15 Jul 2019 14:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200980;
        bh=drgLR4zB1/qQLoUjERC8AKlBaH9Az/5UxfkYH1IcjG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uj4PPTpPoFQs7ZL32dbMLrcTlUUOVKq4DnsVTrpia+j6cumH2q4DftrDriQOpKZDp
         lunMmtTAd0AXEuX/sgNcNra31IjzybyO2pfqdnZWFfC4r5GiqINiNNgRYaVbu98a18
         MuJXWldXGge9KQGU1HE3r/b0fzUSC1pk33a4+JB4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Serge Hallyn <serge@hallyn.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 017/105] signal/pid_namespace: Fix reboot_pid_ns to use send_sig not force_sig
Date:   Mon, 15 Jul 2019 10:27:11 -0400
Message-Id: <20190715142839.9896-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715142839.9896-1-sashal@kernel.org>
References: <20190715142839.9896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit f9070dc94542093fd516ae4ccea17ef46a4362c5 ]

The locking in force_sig_info is not prepared to deal with a task that
exits or execs (as sighand may change).  The is not a locking problem
in force_sig as force_sig is only built to handle synchronous
exceptions.

Further the function force_sig_info changes the signal state if the
signal is ignored, or blocked or if SIGNAL_UNKILLABLE will prevent the
delivery of the signal.  The signal SIGKILL can not be ignored and can
not be blocked and SIGNAL_UNKILLABLE won't prevent it from being
delivered.

So using force_sig rather than send_sig for SIGKILL is confusing
and pointless.

Because it won't impact the sending of the signal and and because
using force_sig is wrong, replace force_sig with send_sig.

Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Fixes: cf3f89214ef6 ("pidns: add reboot_pid_ns() to handle the reboot syscall")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/pid_namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 4918314893bc..22091c88b3bb 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -351,7 +351,7 @@ int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
 	}
 
 	read_lock(&tasklist_lock);
-	force_sig(SIGKILL, pid_ns->child_reaper);
+	send_sig(SIGKILL, pid_ns->child_reaper, 1);
 	read_unlock(&tasklist_lock);
 
 	do_exit(0);
-- 
2.20.1

