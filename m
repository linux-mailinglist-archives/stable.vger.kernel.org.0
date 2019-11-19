Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6C3101424
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbfKSFan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:30:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728480AbfKSFan (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:30:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1A0E21783;
        Tue, 19 Nov 2019 05:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141442;
        bh=Qtskj+vuAMOs2JuDmB5bu6/B3Bz7VEjtpal4WMBxMQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddRPgniXCnPzfRqBVZeJKh5ewuX3vpL9XpLcNl5U9/D47biSosRhfIy87Xlk6PLVC
         /Ec1r613qwqmq8Nh4voFVe58Sxnw6Z94qfqvZpKR6QkyjNEC6ytA3l6sviudTXiS9Z
         4G8JPCKhaN9TcO1s6KSH5Q6LfcctAMlZzBmy+S/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 162/422] signal: Always ignore SIGKILL and SIGSTOP sent to the global init
Date:   Tue, 19 Nov 2019 06:15:59 +0100
Message-Id: <20191119051408.975730226@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 86989c41b5ea08776c450cb759592532314a4ed6 ]

If the first process started (aka /sbin/init) receives a SIGKILL it
will panic the system if it is delivered.  Making the system unusable
and undebugable.  It isn't much better if the first process started
receives SIGSTOP.

So always ignore SIGSTOP and SIGKILL sent to init.

This is done in a separate clause in sig_task_ignored as force_sig_info
can clear SIG_UNKILLABLE and this protection should work even then.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index 0e6bc3049427e..7278302e34850 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -78,6 +78,10 @@ static bool sig_task_ignored(struct task_struct *t, int sig, bool force)
 
 	handler = sig_handler(t, sig);
 
+	/* SIGKILL and SIGSTOP may not be sent to the global init */
+	if (unlikely(is_global_init(t) && sig_kernel_only(sig)))
+		return true;
+
 	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
 	    handler == SIG_DFL && !(force && sig_kernel_only(sig)))
 		return true;
-- 
2.20.1



